/*
서동학: 전체적인 코딩
*/


package user;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class sessionListener implements HttpSessionListener {
	
	// 세션이 생성될 때 실행, 세션이 생성되었는지 확인하기 위해
	public void sessionCreated(HttpSessionEvent se) {
		HttpSession session = se.getSession();
		System.out.println("Create session : " + session.getId());
		System.out.println("Create session : " + session.getAttribute("userID"));
	}

	// 세션이 삭제될 때 실행
	public void sessionDestroyed(HttpSessionEvent se) {
		HttpSession session = se.getSession();
		System.out.println("Close session : " + session.getId());
		System.out.println("Close session : " + session.getAttribute("userID"));
		String userID = (String) session.getAttribute("userID");
		System.out.println("s1: " + userID);
		session.setAttribute("userID", null);
		System.out.println("s2: " + session.getAttribute("userID"));
		// isLogout으로 앱에서 로드인할 수 있게 설정
		UserDAO userDAO = new UserDAO();
		userDAO.isLogout(userID);
	}
}