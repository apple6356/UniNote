<!--
서동학: 전체적인 코딩
-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="map.Counts"%>
<%@ page import="map.CountsDAO"%>
<%@ page import="map.Publicmap"%>
<%@ page import="map.PublicmapDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>회원가입</title>
</head>

<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
		System.out.println(userID);
	}
	if (userID != null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 로그인되어 있습니다.')");
		script.println("location.href = 'home.jsp'");
		script.println("</script>");
	}
	if (user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null || user.getUserEmail() == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('항목을 모두 입력해주세요.')");
		script.println("history.back()");
		script.println("</script>");
	} else {
		UserDAO userDAO = new UserDAO();
		CountsDAO countsDAO = new CountsDAO();
		PublicmapDAO publicmapDAO = new PublicmapDAO();

		int result = userDAO.join(user);

		if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 존재하는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
			session.setAttribute("userID", user.getUserID());
			if (session.getAttribute("userID") != null) {
				userID = (String) session.getAttribute("userID");
		
				// 회원가입 시 쿠키 생성
				Cookie cookie = new Cookie(userID, userID);
				cookie.setMaxAge(60 * 60 * 24);
				response.addCookie(cookie);
				System.out.println("create cookiename : " + cookie.getName() + " create cookievalue : " + cookie.getValue());
			}
			userDAO.isLogin(userID);
			countsDAO.createCounts(user.getUserID()); // counts db에 초기값 insert
			publicmapDAO.createPublicmap(user.getUserID()); // publicmap db에 초기값 insert
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'home.jsp'");
			script.println("</script>");
		}

	}
	%>
</body>

</html>