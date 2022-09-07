/*
서동학: 전체적인 코딩
*/


package map;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class NoteDAO {
	private Connection conn;
	private ResultSet rs;

	public void getCon() {
		// 커넥션풀을 이용하여 데이터베이스에 접근
		try {
			// 외부에서 데이터를 읽어들여야 하기에
			Context init = new InitialContext();
			// 톰켓 서버에 정보를 담아놓은 곳으로 이동
			Context envctx = (Context) init.lookup("java:comp/env");
			// 데이터 소스 객체를 선언
			DataSource ds = (DataSource) envctx.lookup("jdbc/pool");
			// 데이터 소스를 기준으로 커넥션을 연결해주시오
			conn = ds.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 노트 생성
	public int createNote(String userID, String itemID) {
		String SQL = "INSERT INTO note(userID, itemID) VALUES(?, ?)";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, itemID);
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

	// 조건에 맞는 노트를 리턴
	public Note selectNote(String userID, String itemID) {
		String SQL = "SELECT * FROM note WHERE userID=? AND itemID=?";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, itemID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Note note = new Note();
				note.setUserID(rs.getString(1));
				note.setItemID(rs.getString(2));
				note.setNoteContent(rs.getString(3));
				return note;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
		return null;
	}

	// 노트에 내용 작성 시 업데이트
	public void updateNote(String noteContent, String userID, String itemID) {
		String SQL = "UPDATE note SET noteContent = ? WHERE userID=? AND itemID=?";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, noteContent);
			pstmt.setString(2, userID);
			pstmt.setString(3, itemID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
	}

	// 노트 삭제
	public void deleteNote(String userID, String itemID) {
		String SQL = "DELETE FROM note WHERE userID = ? AND itemID = ?";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, itemID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
	}

	// 아이템의 상위요소교체 시 사용
	public void updateChange(String userID, String itemID, String newItemID) {
		String SQL = "UPDATE note SET itemID=? WHERE userID = ? AND itemID = ?;";
		try {
			getCon();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, newItemID);
			pstmt.setString(2, userID);
			pstmt.setString(3, itemID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (Exception e) {

			}
		}
	}
}
