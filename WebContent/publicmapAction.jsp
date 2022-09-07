<!--
김영원: 전체적인 코딩
-->


<%@page import="java.io.PrintWriter"%>
<%@page import="map.PublicmapDAO"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<body>
<%
	// state public=1, private=0
	// publicAction: publicmap=0, userID='userID'
	// privateAction: publicmap=1, userID='userID', password='password'
	int publicmap = Integer.parseInt(request.getParameter("publicmap"));
	String userID = request.getParameter("userID");
	String password = request.getParameter("password");

	// public -> private
	if(publicmap == 1) { 
		PublicmapDAO publicmapDAO = new PublicmapDAO();
		publicmapDAO.privateMap(userID, password);
		System.out.println("privateAction " + userID);
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'map.jsp?userID=" + userID + "'");
		script.println("</script>");
	}
	// private -> public
	else if(publicmap == 0) { 
		PublicmapDAO publicmapDAO = new PublicmapDAO();
		publicmapDAO.publicMap(userID);
		System.out.println("publicAction " + userID);
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'map.jsp?userID=" + userID + "'");
		script.println("</script>");
	}
%>
</body>
</html>