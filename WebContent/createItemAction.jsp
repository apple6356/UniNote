<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="map.ItemDAO" %>
<%@ page import="map.Item" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		String userID = request.getParameter("userID");	// 임시 아이디 부여
		//alert(userID);
		
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		else {
			ItemDAO itemDAO = new ItemDAO();
			
			String itemID = request.getParameter("itemID");
			String itemTop = request.getParameter("itemTop");
			String itemLeft = request.getParameter("itemLeft");
			String itemContent = request.getParameter("itemContent");
			
			int result = itemDAO.write(itemID, itemTop, itemLeft, userID, itemContent);
			if(result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글쓰기에 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'map.jsp'");
				script.println("</script>");
			}	
		}
		
	%>
</body>
</html>