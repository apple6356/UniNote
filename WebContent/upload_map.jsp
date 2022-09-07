<!--
김영원: CSS
서동학: 전체적인 코딩
-->


<%@ page import="java.util.ArrayList"%>
<%@ page import="file.FileDTO"%>
<%@ page import="file.FileDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>업로드/다운로드</title>
<style>
body {
   margin: 0px;
   background-color: #f9f9f9;
   padding: 10px 0px 0px 20px;
}

a {
   color: blue;
   text-decoration: none;
}
</style>
</head>
<body>
   <%
   String userID = null;
   if (session.getAttribute("userID") != null) {
      userID = (String) session.getAttribute("userID");
   }
   String itemID = null;
   itemID = request.getParameter("itemID");
   String mapID = null;
   mapID = request.getParameter("mapID");
   
   // 본인이 아니면 다운로드페이지로 이동
   if (!mapID.equals(userID) || userID == null) {
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("location.href = 'fileDownload.jsp?itemID=" + itemID + "&mapID=" + mapID + "'");
      script.println("</script>");
   }
   %>
   <span>총 업로드 가능 용량은 100mb입니다.</span>
   <hr>
   <button type="button" name="add_btn" id="add_btn" style="margin-bottom: 10px;" onclick="addButton()">추가하기</button>
   <form action="uploadAction.jsp?id=<%=itemID%>" method="post" enctype="multipart/form-data">
      <input type="file" name="file1" id="file1" style="margin-bottom: 10px;"> <br> 
      <input type="file" name="file2" id="file2" style="margin-bottom: 10px; display: none;">
      <input type="file" name="file3" id="file3" style="margin-bottom: 10px; display: none;"> 
      <input type="file" name="file4" id="file4" style="margin-bottom: 10px; display: none;"> 
      <input type="file" name="file5" id="file5" style="margin-bottom: 10px; display: none;"> 
      <input type="submit" value="업로드">
   </form>
   <br>
   <a href="fileDownload.jsp?itemID=<%=itemID%>&mapID=<%=mapID%>">파일 관리</a>
</body>
<script>
   var n = 1;
   // 화면에서 추가하기 버튼을 누르면 파일을 하나더 업로드할 수 있게 변경
   function addButton() {
      var filenum = "file";
      if (n >= 5) {
         document.getElementById("add_btn").disabled = true;
      } else {
         n++;
         if (n >= 5) {
            document.getElementById("add_btn").disabled = true;
         }
         filenum = filenum + n;
         console.log(filenum);
         document.getElementById(filenum).style.display = "block";
      }
   }
</script>
</html>