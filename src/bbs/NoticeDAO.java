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

public class NoticeDAO {
	private Connection conn;
	private ResultSet rs;
	
	// connect to DB
	public NoticeDAO() {
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
	
	// get next order by noticeID number
	public int getNext() {
		String SQL = "SELECT noticeID FROM notice ORDER BY noticeID DESC";
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
	
	// insert notice into DB
	public int write(String noticeTitle, String userID, String noticeContent) {
		String SQL = "INSERT INTO notice VALUES(?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, noticeTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, noticeContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	// get all notice data by ArrayList
	public ArrayList<Notice> getList(int pageNumber) {
		String SQL = "SELECT * FROM notice WHERE noticeAvailable = 1 ORDER BY noticeID DESC LIMIT ?,10";
		ArrayList<Notice> list = new ArrayList<Notice>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Notice notice = new Notice();
				notice.setNoticeID(rs.getInt(1));
				notice.setNoticeTitle(rs.getString(2));
				notice.setUserID(rs.getString(3));
				notice.setNoticeDate(rs.getString(4));
				notice.setNoticeContent(rs.getString(5));
				notice.setNoticeAvailable(rs.getInt(6));
				list.add(notice);
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/*
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM notice WHERE noticeID < ? AND noticeAvailable = 1";
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
	// get one notice data by bbsID
	public Notice getNotice(int noticeID) {
		String SQL = "SELECT * FROM notice WHERE noticeID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, noticeID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Notice notice = new Notice();
				notice.setNoticeID(rs.getInt(1));
				notice.setNoticeTitle(rs.getString(2));
				notice.setUserID(rs.getString(3));
				notice.setNoticeDate(rs.getString(4));
				notice.setNoticeContent(rs.getString(5));
				notice.setNoticeAvailable(rs.getInt(6));
				return notice;
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	// update(modify) one notice data
	public int update(int noticeID, String noticeTitle, String noticeContent) {
		String SQL = "UPDATE notice SET noticeTitle = ?, noticeContent = ? WHERE noticeID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, noticeTitle);
			pstmt.setString(2, noticeContent);
			pstmt.setInt(3, noticeID);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	// delete one notice by bbsID
	public int delete(int noticeID) {
		String SQL = "UPDATE notice SET noticeAvailable = 0 WHERE noticeID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, noticeID);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	// delete all notice data by userID
	public void deleteUser(String userID) {
		String SQL = "DELETE FROM notice WHERE userID = ?";
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
		String SQL = "SELECT COUNT(*) FROM notice WHERE noticeAvailable=1";
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
