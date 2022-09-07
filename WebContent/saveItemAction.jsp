<!--
김영원: 전체적인 코딩
-->


<%@ page import="file.FileDAO"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="map.ItemDAO" %>
<%@ page import="map.Item" %>
<%@ page import="map.LineDAO" %>
<%@ page import="map.Line" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
   <%
      // if user logged-in
      String userID = request.getParameter("userID");
      if(session.getAttribute("userID") != null) {
         userID = (String) session.getAttribute("userID");
      }
      
      // if user not logged-in
      if(userID == null) {
         PrintWriter script = response.getWriter();
         script.println("<script>");
         script.println("alert('로그인을 하세요.')");
         script.println("history.back();");
         script.println("</script>");
      }
      // if checked user logged-in
      else {
    	    // if itemSql exists get and exexcute
    	    // if lineSql exists get and exexcute
    	    String itemSql = "";
    	    String lineSql = "";
    	    if(request.getParameter("itemSql") != "") {
    	    	itemSql = request.getParameter("itemSql");
        		ItemDAO itemDAO = new ItemDAO();
        		itemDAO.execute(itemSql);
    	    }
    	    if(request.getParameter("lineSql") != "") {
        	  	lineSql = request.getParameter("lineSql");
        		LineDAO lineDAO = new LineDAO();
        		lineDAO.execute(lineSql);
    	    }
    		System.out.println("saveAction " + itemSql + "\n           " + lineSql);
    		
    		PrintWriter script = response.getWriter();
    		script.println("<script>");
    		script.println("history.back()");
    		//script.println("location.replace('map.jsp?userID=" + userID + "')");
    		script.println("</script>");
      }
   %>
</body>
</html>