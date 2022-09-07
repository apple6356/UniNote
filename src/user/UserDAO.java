/*
서동학: 전체적인 코딩
*/


package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class UserDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	/* public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "hak78523!@";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	} */

	public void getCon() {
		// 커넥션풀을 이용하여 데이터베이스에 접근
		try {
			// 외부에서 데이터를 읽어들여야 하기에
			Context init = new InitialContext();
			// 톰켓 서버에 정보를 담아놓은 곳으로 이동
			Context envctx = (Context) init.lookup("java:comp/env");
			// 데이터 소스 객체를 선언
			DataSource ds = (DataSource) envctx.lookup("jdbc/bbs");
			// 데이터 소스를 기준으로 커넥션을 연결해주시오
			conn = ds.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 로그인 시 아이디와 패스워드를 확인
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM user WHERE userID = ?";
		try {
			getCon();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString(1).equals(userPassword)) {
					return 1;
				} else {
					return 0;
				}
			}
			return -1;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
		return -2;

	}

	// 회원가입 시 사용
	public int join(User user) {
		String SQL = "INSERT INTO user VALUES (?, ?, ?, ?, 0)";
		try {
			getCon();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserEmail());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
		return -1;
	}

	// 회원탈퇴 시 사용
	public int delete(String userID) {
		String SQL = "DELETE FROM user WHERE userID=?;";
		try {
			getCon();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
		return -1;
	}

	// 유저 검색 시 사용
	public int select(String userID) {
		String SQL = "SELECT * FROM user WHERE userID=?;";
		try {
			getCon();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return 1;
			} else {
				return -1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
		return -1;
	}

	// isLogin 값을 1로 변경해 웹과 앱의 동시 접속 막음
	public int isLogin(String userID) {
		String SQL = "UPDATE user SET isLogin=1 WHERE userID=?;";
		try {
			getCon();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
		return -1;
	}

	// isLogin 값을 0으로 변경해 자유롭게 로그인할 수 있게 변경
	public int isLogout(String userID) {
		String SQL = "UPDATE user SET isLogin=0 WHERE userID=?;";
		try {
			getCon();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
		return -1;
	}

	// isLogin값을 체크하여 로그인 여부 확인
	public int loginCk(String userID) {
		String SQL = "SELECT isLogin FROM user WHERE userID=?;";
		try {
			getCon();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getInt(1) == 1) {
					return 1;
				} else {
					return 0;
				}
			} else {
				return -1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
		return -2;
	}
}
