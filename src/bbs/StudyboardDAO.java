/*
김영원: 전체적인 코딩
서동학: 게시글 필요한 함수 정의
*/


package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class StudyboardDAO {
	private Connection conn;
	private ResultSet rs;
	
	// connect to DB
	public StudyboardDAO() {
		try {
			/*
			String dbURL = "jdbc:mysql://localhost:3307/BBS";
			String dbID = "root";
			String dbPassword = "tiger";
			*/
			///*
			String dbURL = "jdbc:mysql://183.111.138.172:3306/hjk709914";
			String dbID = "hjk709914";
			String dbPassword = "tiger123*";
			//*/
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// get current date
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	// get next order by studyboardID number
	public int getNext() {
		String SQL = "SELECT studyboardID FROM studyboard ORDER BY studyboardID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; //첫 번째 게시글인 경우
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	// insert studyboard into DB
	public int write(String studyboardTitle, String userID, String studyboardContent) {
		String SQL = "INSERT INTO studyboard VALUES(?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, studyboardTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, studyboardContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	// get all studyboard data by ArrayList
	public ArrayList<Studyboard> getList(int pageNumber) {
		String SQL = "SELECT * FROM studyboard WHERE studyboardAvailable = 1 ORDER BY studyboardID DESC LIMIT ?,10";
		ArrayList<Studyboard> list = new ArrayList<Studyboard>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Studyboard studyboard = new Studyboard();
				studyboard.setStudyboardID(rs.getInt(1));
				studyboard.setStudyboardTitle(rs.getString(2));
				studyboard.setUserID(rs.getString(3));
				studyboard.setStudyboardDate(rs.getString(4));
				studyboard.setStudyboardContent(rs.getString(5));
				studyboard.setStudyboardAvailable(rs.getInt(6));
				list.add(studyboard);
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/*
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM studyboard WHERE studyboardID < ? AND studyboardAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return true;
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	*/
	// get one studyboard data by bbsID
	public Studyboard getStudyboard(int studyboardID) {
		String SQL = "SELECT * FROM studyboard WHERE studyboardID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, studyboardID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Studyboard studyboard = new Studyboard();
				studyboard.setStudyboardID(rs.getInt(1));
				studyboard.setStudyboardTitle(rs.getString(2));
				studyboard.setUserID(rs.getString(3));
				studyboard.setStudyboardDate(rs.getString(4));
				studyboard.setStudyboardContent(rs.getString(5));
				studyboard.setStudyboardAvailable(rs.getInt(6));
				return studyboard;
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	// update(modify) one studyboard data
	public int update(int studyboardID, String studyboardTitle, String studyboardContent) {
		String SQL = "UPDATE studyboard SET studyboardTitle = ?, studyboardContent = ? WHERE studyboardID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, studyboardTitle);
			pstmt.setString(2, studyboardContent);
			pstmt.setInt(3, studyboardID);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	// delete one studyboard by bbsID
	public int delete(int studyboardID) {
		String SQL = "UPDATE studyboard SET studyboardAvailable = 0 WHERE studyboardID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, studyboardID);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	// delete one studyboard by bbsID
	public void deleteUser(String userID) {
		String SQL = "DELETE FROM studyboard WHERE userID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// 전체 게시글을 가져와서 10으로 나눠서 페이지를 나누는데 사용
	public int count() {
		String SQL = "SELECT COUNT(*) FROM studyboard WHERE studyboardAvailable=1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				System.out.println("rs.getInt(1): "+ (rs.getInt(1)));
				return rs.getInt(1);
			}
			return 1; //첫 번째 게시글인 경우
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}
