/*
김영원: 전체적인 코딩
*/


package map;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MapLikeyDAO {
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
	
	// user like map (one user can like one map)
	public int like(String userID, String mapID) {
		String sql = "INSERT INTO maplikey VALUES (?, ?)";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setString(2, mapID);
			return pstmt.executeUpdate();
		}
		catch(Exception e) {
			System.out.println("중복 추천");
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
}
