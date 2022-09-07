/*
서동학: 전체적인 코딩
*/


package file;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class FileDAO {

	private Connection conn;
	private PreparedStatement pstmt;

	public FileDAO() {
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
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 파일 업로드 시 사용
	public int upload(String fileName, String fileRealName, String userID, String itemID) {
	   String SQL = "INSERT INTO file VALUE(?, ?, ?, ?)";
	   try {
	      PreparedStatement pstmt = conn.prepareStatement(SQL);
	      pstmt.setString(1, fileName);
	      pstmt.setString(2, fileRealName);
	      pstmt.setString(3, userID);
	      pstmt.setString(4, itemID);
	      return pstmt.executeUpdate();
	   } catch (Exception e) {
	      e.printStackTrace();
	   }
	   return -1;
	}

	// 파일을 리스트 형태로 리턴
	public ArrayList<FileDTO> getList(String userID, String itemID) {
		String SQL = "SELECT * FROM file WHERE userID = ? AND itemID = ?";
		ArrayList<FileDTO> list = new ArrayList<FileDTO>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, itemID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				FileDTO file = new FileDTO(rs.getString(1), rs.getString(2));
				list.add(file);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 파일을 삭제
	public int delete(String userID, String itemID, String fileRealName) {
		String SQL = "DELETE FROM file WHERE userID=? AND itemID=? AND fileRealName=?;";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, itemID);
			pstmt.setString(3, fileRealName);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	// 회원탈퇴 시 삭제
	public void deleteUser(String userID) {
		String SQL = "DELETE FROM file WHERE userID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 아이템 삭제 시 함께 삭제
	public int deleteItem(String userID, String itemID) {
		String SQL = "DELETE FROM file WHERE userID = ? && itemID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, itemID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	// 아이템의 상위요소교체 시 함께 변경
	public void updateChange(String userID, String itemID, String newItemID) {
		String SQL = "UPDATE file SET itemID=? WHERE userID=? && itemID=?;";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, newItemID);
			pstmt.setString(2, userID);
			pstmt.setString(3, itemID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
