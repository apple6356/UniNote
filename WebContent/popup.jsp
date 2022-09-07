<!--
김영원: CSS
서동학: 전체적인 코딩
-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="map.Note"%>
<%@ page import="map.NoteDAO"%>
<!DOCTYPE html>
<html>

<head>
<!-- 아이템에 대한 추가적인 내용을 작성 -->
<meta charset="utf-8">
<title>메모</title>

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
}

.main_box {
	
}

.article_box {
	text-align: center;
}

#noteContent {
	width: 95%;
	height: 90vh;
	resize: none;
	font-family: aTitleGothic2;
}

.bottem_box {
	text-align: right;
	bottom: 3px;
}
</style>

</head>
<body>
	<%
	/* 
	아이템에 추가 내용을 작성하는 페이지
	본인이 아니면 수정이 불가능
	*/
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	String itemID = null;
	itemID = request.getParameter("itemID");

	String mapID = null;
	mapID = request.getParameter("mapID");

	NoteDAO noteDAO = new NoteDAO();
	String noteContent = null;
	if (mapID.equals(userID)) {
		Note note = noteDAO.selectNote(userID, itemID);
		noteContent = note.getNoteContent();
	} else if (!mapID.equals(userID)) {
		Note note = noteDAO.selectNote(mapID, itemID);
		noteContent = note.getNoteContent();
	}
	%>

	<div class="main_box">
		<div class="article_box">
			<%
			if (noteContent == null && mapID.equals(userID)) {
			%>
			<form action="noteAction.jsp" method="post" id="noteForm" method="post">
				<input type="hidden" id="noteItemID" name="noteItemID" value=<%=itemID%>>
				<textarea id="noteContent" name="noteContent" placeholder="내용을 입력해주세요."></textarea>
				<input type="hidden" id="noteType" name="noteType" value="update">
				<button id="save_btn" type="submit">저장</button>
			</form>
			<%
			} else if (!mapID.equals(userID) && noteContent != null) {
			%>
			<input type="hidden" id="noteItemID" name="noteItemID" value=<%=itemID%>>
			<textarea id="noteContent" name="noteContent" readonly><%=noteContent%></textarea>
			<%
			} else if (!mapID.equals(userID) && noteContent == null) {
			%>
			<input type="hidden" id="noteItemID" name="noteItemID" value=<%=itemID%>>
			<textarea id="noteContent" name="noteContent" placeholder="내용을 입력해주세요." readonly></textarea>
			<%
			} else {
			%>
			<form action="noteAction.jsp" method="post" id="noteForm" method="post">
				<input type="hidden" id="noteItemID" name="noteItemID" value=<%=itemID%>>
				<textarea id="noteContent" name="noteContent"><%=noteContent%></textarea>
				<input type="hidden" id="noteType" name="noteType" value="update">
				<button id="save_btn" type="submit">저장</button>
			</form>
			<%
			}
			%>
		</div>
		<div class="bottem_box"></div>
	</div>

	<script>
		
	</script>
</body>

</html>