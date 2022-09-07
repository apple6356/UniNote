<!--
서동학: 전체적인 코딩
-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>로그아웃</title>
</head>

<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
		
		// 로그아웃 시 해당 아이디와 같은 쿠키 삭제
		Cookie cookie = new Cookie(userID, userID);
		cookie.setMaxAge(0);
		response.addCookie(cookie);
		System.out.println("delete cookiename : " + cookie.getName() + " delete cookievalue : " + cookie.getValue());
	}
	UserDAO userDAO = new UserDAO();
	userDAO.isLogout(userID);

	// 세션 삭제
	session.invalidate();
	String href = request.getParameter("href");
	String category = request.getParameter("category");
	String bbsID = request.getParameter("bbsID");
	%>

	<script>
      var bbsID = <%=bbsID%>;
      if(bbsID != null) {
         location.href = '<%=href%>.jsp?category=<%=category%>&bbsID=<%=bbsID%>';
      }
      else {
         location.href = '<%=href%>.jsp';
	  }
	</script>
</body>

</html>