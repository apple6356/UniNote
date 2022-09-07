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

public class ItemDAO {
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
	
	// get next order by desc item number
	public int getNext(String userID) { // itemID int 아님
		String SQL = "SELECT itemCount FROM item where userID=? ORDER BY itemCount DESC";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
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
	
	// insert one item
	public int write(String itemID, String itemTop, String itemLeft, String userID, String itemContent) {
		String SQL = "INSERT INTO item VALUES(?, ?, ?, ?, ?, ?, ?)";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, itemID);
			pstmt.setString(2, itemTop);
			pstmt.setString(3, itemLeft);
			pstmt.setString(4, userID);
			pstmt.setString(5, itemContent);
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
	
	// get all item data by ArrayList
	public ArrayList<Item> getList(String userID) {
		String SQL = "SELECT * FROM item WHERE userID=?";
		ArrayList<Item> list = new ArrayList<Item>();
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Item item = new Item();
				item.setItemID(rs.getString(1));
				item.setItemTop(rs.getString(2));
				item.setItemLeft(rs.getString(3));
				item.setUserID(rs.getString(4));
				item.setItemContent(rs.getString(5));
				item.setItemCount(rs.getInt(6));
				item.setItemWidth(rs.getString(7));
				item.setItemHeight(rs.getString(8));
				list.add(item);
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
	
	// update one item tuple
	public int update(String itemID, String itemTop, String itemLeft, String itemContent) {
		String SQL = "UPDATE item SET itemTop = ?, itemLeft = ?, itemContent = ? WHERE itemID = ?";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, itemTop);
			pstmt.setString(2, itemLeft);
			pstmt.setString(3, itemContent);
			pstmt.setString(4, itemID);
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
	
	// change parent
	public int insert(String itemID, String insertItemID) {
		String SQL = "UPDATE item SET itemID = ? WHERE itemID = ?";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, insertItemID);
			pstmt.setString(2, itemID);
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
	
	// delete one item tuple
	public int delete(String itemID, String userID) {
		String SQL = "DELETE FROM item WHERE userID = ? AND itemID = ?";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, itemID);
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
	
	// execute sended itemSql
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
	
	// delete all items selected by userID
	public void deleteUser(String userID) {
	      String SQL = "DELETE FROM item WHERE userID = ?";
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
