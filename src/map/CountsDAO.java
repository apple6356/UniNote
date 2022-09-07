/*
김영원: 조회수, 추천수 관련 함수
서동학: 게시글 관련 모든 함수
*/


package map;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import bbs.Bbs;

public class CountsDAO {
	private Connection conn;
	private ResultSet rs;
	
	// connect to DB
	public CountsDAO() {
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
	
	// make tuple when user join
	public void createCounts(String userID) {
		String SQL = "INSERT INTO counts VALUES(?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setInt(2, 0);
			pstmt.setInt(3, 0);
			if(pstmt.executeUpdate() == -1) {
				System.out.println("createCount() 오류 발생");
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// get one counts tuple
	public Counts readCounts(String userID) {
		Counts count = new Counts();
		String sql = "select * from counts where userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count.setUserID(rs.getString(1));
				count.setHits(rs.getInt(2));
				count.setRecommend(rs.getInt(3));
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return count;
	}
	
	// update one counts tuple
	public void updateCounts(Counts count) {
		String sql = "update counts set hits=?, recommend=? where userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, count.getHits());
			pstmt.setInt(2, count.getRecommend());
			pstmt.setString(3, count.getUserID());
			if(pstmt.executeUpdate() == -1) {
				System.out.println("updateCount() 오류 발생");
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// delete one counts tuple
	public void deleteCounts(String userID) {
		String SQL = "delete from counts where userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			if(pstmt.executeUpdate() == -1) {
				System.out.println("deleteCount() 오류 발생");
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// 1 hits up by userID
	public void hitsUp(String userID) {
		Counts count = new Counts();
		count = readCounts(userID);
		String sql = "update counts set hits=? where userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, count.getHits()+1);
			pstmt.setString(2, userID);
			if(pstmt.executeUpdate() == -1) {
				System.out.println("hitsUp() 오류 발생");
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// 1 hits down by userID
	public void hitsDown(String userID) {
		Counts count = new Counts();
		count = readCounts(userID);
		String sql = "update counts set hits=? where userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, count.getHits()-1);
			pstmt.setString(2, userID);
			if(pstmt.executeUpdate() == -1) {
				System.out.println("hitsDown() 오류 발생");
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// 1 recoomendUp by userID (1 user 1 recommend of each map)
	public void recommendUp(String userID) {
		Counts count = new Counts();
		count = readCounts(userID);
		String sql = "update counts set recommend=? where userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, count.getRecommend()+1);
			pstmt.setString(2, userID);
			if(pstmt.executeUpdate() == -1) {
				System.out.println("recommendUp() 오류 발생");
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// get all counts ArrayList data
	public ArrayList<String> getHomeList() {
		String SQL = "select counts.userID from counts natural join publicmap where publicmap.publicmap=1 order by counts.recommend desc limit 4";
		ArrayList<String> list = new ArrayList<String>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				String userID = rs.getString(1);
				list.add(userID);
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// get all counts ArrayList data
	public ArrayList<Counts> getAllList(int pageNumber) {
	    String SQL = "select * from counts natural join publicmap order by counts.recommend desc limit ?,10";
	    ArrayList<Counts> list = new ArrayList<Counts>();
	    try {
	       PreparedStatement pstmt = conn.prepareStatement(SQL);
	       pstmt.setInt(1, (pageNumber-1)*10);
	       rs = pstmt.executeQuery();
	       while(rs.next()) {
	          Counts counts = new Counts();
	          counts.setUserID(rs.getString(1));
	          counts.setHits(rs.getInt(2));
	          counts.setRecommend(rs.getInt(3));
	          list.add(counts);
	       }
	    }
	    catch(Exception e) {
	       e.printStackTrace();
	    }
	    return list;
	 }
	 
	 // get public and order by recommend desc split by 10
	 public ArrayList<Counts> getPublicList(int pageNumber) {
	    String SQL = "select * from counts natural join publicmap where publicmap.publicmap=1 order by counts.recommend desc limit ?,10";
	    ArrayList<Counts> list = new ArrayList<Counts>();
	    try {
	       PreparedStatement pstmt = conn.prepareStatement(SQL);
	       pstmt.setInt(1, (pageNumber-1)*10);
	       rs = pstmt.executeQuery();
	       while(rs.next()) {
	          Counts counts = new Counts();
	          counts.setUserID(rs.getString(1));
	          counts.setHits(rs.getInt(2));
	          counts.setRecommend(rs.getInt(3));
	          list.add(counts);
	       }
	    }
	    catch(Exception e) {
	       e.printStackTrace();
	    }
	    return list;
	 }
	   
	 // get private and order by recommend desc split by 10
	 public ArrayList<Counts> getPrivateList(int pageNumber) {
	    String SQL = "select * from counts natural join publicmap where publicmap.publicmap=0 order by counts.recommend desc limit ?,10";
	    ArrayList<Counts> list = new ArrayList<Counts>();
	    try {
	       PreparedStatement pstmt = conn.prepareStatement(SQL);
	       pstmt.setInt(1, (pageNumber-1)*10);
	       rs = pstmt.executeQuery();
	       while(rs.next()) {
	          Counts counts = new Counts();
	          counts.setUserID(rs.getString(1));
	          counts.setHits(rs.getInt(2));
	          counts.setRecommend(rs.getInt(3));
	          list.add(counts);
	       }
	    }
	    catch(Exception e) {
	       e.printStackTrace();
	    }
	    return list;
	 }
	 
	 // 추천로드맵에서 전체보기시 가져오는 함수
	 public int countAll() {
	     String SQL = "SELECT COUNT(*) FROM counts";
	     try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	        System.out.println("rs.getInt(1): "+ (rs.getInt(1)));
	        return rs.getInt(1);
	        }
	        return 1; //첫 번째 게시글인 경우
	    } catch(Exception e) {
	       e.printStackTrace();
	    }
	    return -1;
	 }
	 
	 // 추천로드맵에서 공개글만 가져오는 함수
	 public int countPublic() {
	     String SQL = "SELECT COUNT(*) FROM counts natural join publicmap where publicmap.publicmap=1";
	     try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	           System.out.println("rs.getInt(1): "+ (rs.getInt(1)));
	        return rs.getInt(1);
	        }
	        return 1; //첫 번째 게시글인 경우
	    } catch(Exception e) {
	         e.printStackTrace();
	    }
	    return -1;
	 }
	 
	 // 추천로드맵에서 비공개글만 가져오는 함수
	 public int countPrivate() {
	     String SQL = "SELECT COUNT(*) FROM counts natural join publicmap where publicmap.publicmap=0";
	     try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	           System.out.println("rs.getInt(1): "+ (rs.getInt(1)));
	           return rs.getInt(1);
	        }
	      return 1; //첫 번째 게시글인 경우
	      } catch(Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	 }

}
