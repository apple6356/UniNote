<!--
김영원: 전체적인 코딩
-->


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>로드맵 사용설명서</title>
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

html {
	height: 100%;
	overflow: auto;
}

body {
	height: 100%;
	margin: 0px;
	overflow: auto;
}

a {
	color: black;
	text-decoration: none;
}

a.underline:hover {
	text-decoration: underline;
}

ul {
	list-style: none;
	padding-left: 0px;
}

p {
	margin-left: 20px;
}

.main_box {
	width: 1000px;
	margin: 0 auto;
	overflow: auto;
}

.top_box {
	display: flex;
}

.home {
	font-size: 40px;
	margin: 0px auto 15px 20px;
}

.home a {
	font-size: 50px;
	color: #93c9eb;
	font-weight: 1000;
	font-family: uninote;
}

.login_box {
	float: right;
}

.bottom_box {
	width: 1000px;
	margin: 0 auto;
	background-color: white;
	height: 100%;
}

.title_box {
	width: 1000px;
	border-bottom: 2px solid #93c9eb;
	display: flex;
	margin-bottom: 20px;
	font-family: aTitleGothic3;
}

.post_list {
	display: grid;
	grid-template-columns: 750px 100px 100px;
}

.post_title {
	text-decoration: none;
	margin-left: 20px;
	font-size: 20px;
}

.post_wirter {
	text-decoration: none;
	text-align: center;
	vertical-align: middle;
	font-weight: bold;
}

.post_date {
	text-decoration: none;
	text-align: center;
	vertical-align: middle;
	font-weight: bold;
}

.button_box {
	margin-left: auto;
	margin-bottom: auto;
	margin-top: auto;
	margin-right: 10px;
}

.article_box {
	border-bottom: 2px solid #93c9eb;
	min-height: 70%;
	background-color: white;
	font-family: aTitleGothic2;
}

.article_box div {
	margin-bottom: 10px;
	margin-left: 10px;
	display: flex;
}

.article_box div span {
	margin-left: 15px;
}

.bottom_button_box {
	display: flex;
	justify-content: flex-end;
	margin-top: 20px;
}

hr {
	border: 2px solid #93c9eb;
	margin-bottom: 0px;
}

#background {
	background-color: #f9f9f9;
	height: auto;
}
</style>
</head>

<body>
	<%
	String userID = null;
	// if user logged-in
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	%>

	<div class="main_box">
		<div class="top_box">
			<div class="home">
				<p style="margin:0;"><a href='home.jsp'><img src="img/LogoColor.png" alt="no image" height="50" style="vertical-align: middle;"><span style="vertical-align: middle;">UNINOTE</span></a></p>
			</div>

			<%
			// if user not logged-in
			if (userID == null) {
			%>
			<div class="login_box">
				<form method="post" action="loginAction.jsp">
					<input type="text" name="userID" placeholder="아이디" maxlength="20">
					<input type="password" name="userPassword" placeholder="비밀번호" maxlength="20"> <input type="submit" value="로그인">
					<input type="hidden" name="href" value="roadmapManual">
					<input type="button" value="회원가입" onClick="location.href='join.jsp'">
				</form>
			</div>
			<%
			// if user logged-in
			} else {
			%>
			<div class="login_box">
				<input type="button" value="로그아웃" onClick="location.replace('logoutAction.jsp?href=roadmapManual')">
				<input type="button" value="회원탈퇴" onClick="deleteUser()">
			</div>
			<%
			}
			%>
		</div>
	</div>

	<hr>

	<div id="background">
		<div class="bottom_box">
			<div class="title_box">
				<ul>
					<div id="postList" class="post_list">
						<li class="post_title"><strong>로드맵 사용설명서</strong></li>
						<li class="post_wirter">Admin</li>
						<li class="post_date">2022-05-02</li>
					</div>
				</ul>
			</div>

			<!-- roadmapManual: image with short text -->
			<div class="article_box">
				<div>
					<img src="img/2. grade1_right.PNG" alt="no image" width="300">
					<span>
						1. 학년 박스를 우클릭 후 항목 추가를 누르세요. <br>
						&nbsp;&nbsp; (추가, 삭제, 이동, 추가내용, 업로드는 자동으로 저장됩니다.)
					</span>
				</div>
				<div>
					<img src="img/3. grade1_create.PNG" alt="no image" width="300">
					<span>2. 1, 2학년일 경우 왼쪽상단에 새로운 상자가 추가됩니다.</span>
				</div>
				<div>
					<img src="img/4. item_DragDrop.PNG" alt="no image" width="300">
					<span>3. 상자를 드래그해 원하는 위치에 둡니다.</span>
				</div>
				<div>
					<img src="img/4.5 item_content.PNG" alt="no image" width="300">
					<span>4. 상자를 클릭해 활성화한 후 키보드 입력시 내용을 입력할 수 있습니다.</span>
				</div>
				<div>
					<img src="img/4.6 item_width.PNG" alt="no image" width="300">
					<span>5. 상자의 크기를 조절할 수 있습니다.</span>
				</div>
				<div>
					<img src="img/4.7 item_parentDrag.PNG" alt="no image" width="300">
					<span>6. 상자를 드래그해 다른 상자에 둡니다.</span>
				</div>
				<div>
					<img src="img/4.8 item_parentDrop.PNG" alt="no image" width="300">
					<span>7. 상자의 상위상자를 바꿀 수 있습니다.</span>
				</div>
				<div>
					<img src="img/5. item_right.PNG" alt="no image" width="300">
					<span>8. 새로 추가된 상자를 우클릭 후 추가 내용을 누르세요.</span>
				</div>
				<div>
					<img src="img/6. popup.PNG" alt="no image" width="300"> 
					<span>9. 해당 상자에 대한 추가적인 내용을 자세히 설명할 수 있습니다.</span>
				</div>
				<div>
					<img src="img/7. upload.PNG" alt="no image" width="300">
					<span>
						10. 상자를 우클릭 후 업/다운로드를 누르세요. <br> 
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; zip, pptx, hwp, jpg, png 파일을 업로드 할 수 있습니다.
					</span>
				</div>
				<div>
					<img src="img/8. download.PNG" alt="no image" width="300">
					<span>
						11. 파일 관리를 누르면 다운로드 페이지로 이동합니다. <br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 해당 상자에 업로드된 파일을 다운로드 할 수 있습니다.
					</span>
				</div>
			</div>
		</div>
	</div>

	<script>
		// deleteUserAction
		function deleteUser() {
			if (confirm("정말 탈퇴하시겠습니까?") == true) {
				location.href = 'deleteUserAction.jsp';
			} else {
				return false;
			}
		}
	</script>
</body>

</html>