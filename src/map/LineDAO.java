/*
김영원: 전체적인 코딩
*/


package map;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class LineDAO {
	private Connection conn;
	private ResultSet rs;
	
	// get connection pool
	public void getCon() {
		//커넥션풀을 이용하여 데이터베이스에 접근
		try {
			//외부에서 데이터를 읽어들여야 하기에
			Context init = new InitialContext();
			//톰켓 서버에 정보를 담아놓은 곳으로 이동
			Context envctx = (Context) init.lookup("java:comp/env");
			//데이터 소스 객체를 선언
			DataSource ds = (DataSource) envctx.lookup("jdbc/pool");
			//데이터 소스를 기준으로 커넥션을 연결해주시오
			conn = ds.getConnection();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// get order by desc item number
	public int getNext() { // itemID int 아님
		String SQL = "SELECT itemID FROM submenu ORDER BY itemID DESC";
		try {
			getCon();
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
		finally {
			try {
				conn.close();
			}
			catch(Exception e) {
					
			}
		}
		return -1;
	}
	
	// insert one line tuple
	public int write(String lineID, String userID) {
		String SQL = "INSERT INTO line VALUES(?, ?)";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, lineID);
			pstmt.setString(2, userID);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				conn.close();
			}
			catch(Exception e) {
					
			}
		}
		return -1;
	}
	
	// get all line data by ArrayList
	public ArrayList<Line> getList(String userID) {
		String SQL = "SELECT lineID FROM line WHERE userID=?";
		ArrayList<Line> list = new ArrayList<Line>();
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Line line = new Line();
				line.setLineID(rs.getString(1));
				list.add(line);
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				conn.close();
			}
			catch(Exception e) {
					
			}
		}
		return list;
	}
	
	// change parent
	public int insert(String DBlineLastID, String insertLineID) {
		String SQL = "UPDATE line SET lineID = ? WHERE lineID = ?";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, insertLineID);
			pstmt.setString(2, DBlineLastID);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				conn.close();
			}
			catch(Exception e) {
					
			}
		}
		return -1;
	}
	
	// delete on line tuple
	public int delete(String lineID, String userID) {
		String SQL = "DELETE FROM line WHERE userID = ? AND lineID = ?";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, lineID);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				conn.close();
			}
			catch(Exception e) {
					
			}
		}
		return -1;
	}
	
	// execute sended lineSql
	public void execute(String sql) {
		String SQL = sql;
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.executeUpdate();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				conn.close();
			}
			catch(Exception e) {
					
			}
		}
	}
	
	// delete all lines selected by userID
	public void deleteUser(String userID) {
	     String SQL = "DELETE FROM line WHERE userID = ?";
	      try {
	    	  getCon();
	          PreparedStatement pstmt = conn.prepareStatement(SQL);
	          pstmt.setString(1, userID);
	          pstmt.executeUpdate();
	     }
	     catch(Exception e) {
	          e.printStackTrace();
	     }
		finally {
			try {
				conn.close();
			}
			catch(Exception e) {
					
			}
		}
	}
}
