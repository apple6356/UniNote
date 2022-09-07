/*
김영원: 전체적인 코딩
*/


package map;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PublicmapDAO {
	private Connection conn;
	private ResultSet rs;
	
	// connect to DB
	public PublicmapDAO() {
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
			
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// get state of publicmap by userID
	public int getPublicmap(String userID) {
		String SQL = "SELECT publicmap FROM publicmap WHERE userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	// public -> private
	public void privateMap(String userID, String password) {
		String sql = "update publicmap set publicmap=0, password=? where userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, password);
			pstmt.setString(2, userID);
			pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// private -> public
	public void publicMap(String userID) {
		String sql = "update publicmap set publicmap=1, password='' where userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// insert publicmap tuple when user join
	public void createPublicmap(String userID) {
	      String sql = "INSERT INTO publicmap VALUES(?, 1, '')";
	      try {
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, userID);
	         pstmt.executeUpdate();
	      }
	      catch(Exception e) {
	         e.printStackTrace();
	      }
	}
	
	// delete publicmap tuple when user delete
	public void deleteUser(String userID) {
	      String SQL = "DELETE FROM publicmap WHERE userID = ?";
	      try {
	         PreparedStatement pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.executeUpdate();
	      }
	      catch(Exception e) {
	         e.printStackTrace();
	      }
	}
	
	// get password when user enter private map
	public String getPassword(String userID) {
		String SQL = "SELECT password FROM publicmap WHERE userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
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
}
