<!--
김영원: 전체적인 코딩
서동학: category
-->


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.NoticeDAO" %>
<%@ page import="bbs.StudyboardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/>
<jsp:setProperty name="bbs" property="bbsTitle"/>
<jsp:setProperty name="bbs" property="bbsContent"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
   <%
      String userID = null;
      String category = request.getParameter("category");
   	  // if user logged-in
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
      else {
    	 // if not fill every text
         if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
               PrintWriter script = response.getWriter();
               script.println("<script>");
               script.println("alert('입력이 안 된 사항이 있습니다.')");
               script.println("history.back()");
               script.println("</script>");
            }
            else {
               int result = 0;
               PrintWriter script = response.getWriter();
               // write post by category
               if(category.equals("notice")){
                  BbsDAO bbsDAO = new BbsDAO();
                  result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
               }
               else if(category.equals("noticeAdmin")){
                  NoticeDAO noticeDAO = new NoticeDAO();
                  result = noticeDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
               }
               else if(category.equals("studyboard")){
                  StudyboardDAO studyboardDAO = new StudyboardDAO();
                  result = studyboardDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
               }
               if(result == -1) {
                  script = response.getWriter();
                  script.println("<script>");
                  script.println("alert('글쓰기에 실패했습니다.')");
                  script.println("history.back()");
                  script.println("</script>");
               }
               else if(result == -2) {
                  script = response.getWriter();
                  script.println("<script>");
                  script.println("alert('테스트')");
                  script.println("history.back()");
                  script.println("</script>");
               }
               else {
                  script = response.getWriter();
                  script.println("<script>");
                  script.println("location.href = '" + category + ".jsp'");
                  script.println("</script>");
               }
            }
      }
   %>
</body>
</html>