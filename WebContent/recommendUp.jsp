<!--
김영원: 전체적인 코딩
-->


<%@page import="map.MapLikeyDAO"%>
<%@page import="map.CountsDAO"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<!DOCTYPE html>
<html>
<body>
	<%
		// userID: login ID
		// mapID: whose map (It can be myMap or othersMap)
		String userID = null;
	    String mapID = null;
    	userID = request.getParameter("userID");
    	mapID = request.getParameter("mapID");

    	// mapLikeyDAO makes 1-like for 1-user
    	// countsDAO has all-users hits, likes
    	MapLikeyDAO mapLikeyDAO = new MapLikeyDAO();
    	CountsDAO countsDAO = new CountsDAO();
    	PrintWriter script = response.getWriter();
    	
    	// if user clicked like someones map (It can be myMap)
    	if(mapLikeyDAO.like(userID, mapID) != -1) {
    		countsDAO.recommendUp(mapID);
    		countsDAO.hitsDown(mapID); // likeAction has refresh, need hitsDown
    		
    		script.println("<script>");
    		script.println("location.href = 'map.jsp?userID=" + mapID + "'");
    		script.println("</script>");
    	}
    	// if user already liked someones map
    	else {
    		countsDAO.hitsDown(mapID);
    		
    		script = response.getWriter();
    		script.println("<script>");
    		script.println("location.href = 'map.jsp?userID=" + mapID + "'");
    		script.println("alert('이미 추천했습니다.')");
    		script.println("</script>");
    	}
	%>
	
</body>
</html>