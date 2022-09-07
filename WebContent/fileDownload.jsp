<!--
서동학: 전체적인 코딩
-->


<%@ page import="java.util.ArrayList"%>
<%@ page import="file.FileDTO"%>
<%@ page import="file.FileDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일 관리</title>
<style>
@font-face {
  font-family: "aTitleGothic2";
  src: url('fonts/aTitleGothic2.ttf');
}
@font-face {
  font-family: "aTitleGothic3";
  src: url('fonts/aTitleGothic3.ttf');
}
@font-face {
  font-family: "uninote";
  src: url('fonts/UNINOTE.otf');
}

body {
	margin: 0px;
	background-color: #f9f9f9;
	padding: 10px 0px 0px 20px;
	font-family: aTitleGothic2;
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

	out.write("<span>" + itemID + "의 파일목록</span><br><br>");

	String directory = "upload/" + userID + "/" + itemID; //경로

	if (mapID.equals(userID)) {
		//directory = "D:/JSP/upload/" + userID + "/" + itemID; //경로
		directory = "www/upload/" + userID + "/" + itemID; //경로
		// 유저의 아이디와 아이템의 아이디로 파일을 불러온다
		ArrayList<FileDTO> fileList = new FileDAO().getList(userID, itemID);

		for (FileDTO file : fileList) {
			out.write("<a href=\"" + request.getContextPath() + "/downloadAction?mapID="+userID+"&directory=" + directory + "&file="
			+ java.net.URLEncoder.encode(file.getFileRealName(), "UTF-8") + "\">" + file.getFileName() + "</a>"
			+ "<span>  </span>" + "<form action='deleteFileAction.jsp' method='post' style='display: inline;'>"
			+ "<input type='text' name='itemID' style='display: none;' value='" + itemID + "'>"
			+ "<input type='text' name='fileRealName' style='display: none;' value='" + file.getFileRealName()
			+ "'>" + "<input type='hidden' name='action' value='fileDelete'>"
			+ "<input type='submit' name='delete' value='삭제'>" + "</form>" + "<br>");
		}
	} else if (!mapID.equals(userID)) { // 사용자 본인이 아니라면 다운로드만 가능
		directory = "www/upload/" + mapID + "/" + itemID; //경로
		ArrayList<FileDTO> fileList = new FileDAO().getList(mapID, itemID);

		for (FileDTO file : fileList) {
			out.write("<a href=\"" + request.getContextPath() + "/downloadAction?mapID="+mapID+"&directory=" + directory + "&file="
			+ java.net.URLEncoder.encode(file.getFileRealName(), "UTF-8") + "\">" + file.getFileName() + "</a>"
			+ "<span>  </span>" + "<form action='deleteFileAction.jsp' method='post' style='display: inline;'>"
			+ "<input type='text' name='itemID' style='display: none;' value='" + itemID + "'>"
			+ "<input type='text' name='fileRealName' style='display: none;' value='" + file.getFileRealName()
			+ "'>" + "<input type='hidden' name='action' value='fileDelete'>" + "</form>" + "<br>");
		}
	}
	if (mapID.equals(userID)) {
	%>
	<input type="button" onclick="back()" value="돌아가기">
	<%
	}
	%>
	<script>
		function back() {
			location.href = 'upload_map.jsp?itemID=<%=itemID%>&mapID=<%=mapID%>';
		}
	</script>
</body>
</html>
