<!--
서동학: 전체적인 코딩
-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>로그인</title>
</head>

<body>
	<%
	String href = request.getParameter("href");
	String category = request.getParameter("category");
	String bbsID = request.getParameter("bbsID");
	String userID = null;

	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID != null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 로그인되어 있습니다.')");
		script.println("location.href = '" + href + ".jsp'");
		script.println("</script>");
	}

	UserDAO userDAO = new UserDAO();

	// 로그인 시 쿠키를 확인 후 쿠키 정보로 로그인
	Cookie[] cookies = request.getCookies();
	for (Cookie c : cookies) {
		if (c.getName().equals(user.getUserID())) {
			String cUserID = c.getValue();
			System.out.println("clogin cookiename : " + c.getName() + " clogin cookievalue : " + cUserID);
			// 입력한 아이디와 비밀번호가 맞는지 확인
			int result = userDAO.login(user.getUserID(), user.getUserPassword());
			if (cUserID.equals(user.getUserID()) && result == 1) {
				userDAO.isLogout(cUserID);
			} else if (result == 0) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('비밀번호가 틀렸습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
		}
	}

	// 앱에 접속되어 있으면 접속하지 못하게 막는다
	int logck = userDAO.loginCk(user.getUserID());

	if (logck == 1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('다른 기기에서 로그인되어 있습니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else if (logck == 0) {

		int result = userDAO.login(user.getUserID(), user.getUserPassword());

		if (result == 1) {
			if (bbsID != null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = '" + href + ".jsp?category=" + category + "&bbsID=" + bbsID + "'");
				script.println("</script>");
				session.setAttribute("userID", user.getUserID());
				if (session.getAttribute("userID") != null) {
					userID = (String) session.getAttribute("userID");
		
					// 로그인 시 쿠키 생성
					Cookie cookie = new Cookie(userID, userID);
					cookie.setMaxAge(60 * 60 * 24);
					response.addCookie(cookie);
					System.out.println("cookiename : " + cookie.getName() + " cookievalue : " + cookie.getValue());
				}
				userDAO.isLogin(userID);
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = '" + href + ".jsp'");
				script.println("</script>");
				session.setAttribute("userID", user.getUserID());
				if (session.getAttribute("userID") != null) {
					userID = (String) session.getAttribute("userID");
		
					// 로그인 시 쿠키 생성
					Cookie cookie = new Cookie(userID, userID);
					cookie.setMaxAge(60 * 60 * 24);
					response.addCookie(cookie);
					System.out.println("create cookiename : " + cookie.getName() + " create cookievalue : " + cookie.getValue());
				}
				userDAO.isLogin(userID);
			}
		} else if (result == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀렸습니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else if (result == -2) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('아이디, 패스워드를 확인해주세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
	} else if (logck == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else if (logck == -2) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('아이디, 패스워드를 확인해주세요.')");
		script.println("history.back()");
		script.println("</script>");
	}
	%>
</body>

</html>