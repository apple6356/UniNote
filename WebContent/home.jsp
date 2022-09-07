<!--
김영원: HTML, CSS
서동학: 로그인, 로그아웃, 회원가입, 회원탈퇴, category
-->


<%@page import="map.CountsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@page import="java.util.ArrayList"%>
<%@page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@page import="bbs.NoticeDAO"%>
<%@page import="bbs.Notice"%>
<%@page import="bbs.StudyboardDAO"%>
<%@page import="bbs.Studyboard"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>home</title>

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
}

body {
	margin: 0;
	height: 100%;
}

.main_box {
	width: 1400px;
	margin: 0px auto 0px auto;
}

.top_box {
	display: flex;
}

.home {
	width: 40%;
	margin: 0px 0px 10px 10%;
}

.home a {
	font-size: 50px;
	color: #93c9eb;
	text-decoration: none;
	font-weight: 1000;
	font-family: uninote;
}

.login_box {
	float: right;
	margin: 10px 0px 10px auto;
}

#id {
	margin-left: auto;
}

.row_box {
	display: flex;
}

.row_box>div {
	width: 40%;
	margin: 10px 0px 10px auto;
	padding: 5px 0px 5px 5px;
	border: solid #828282;
	background-color: white;
	border-radius: 15px;
}

.row_box>div h2 {
	text-align: center;
	margin: 2px 0px;
	font-family: aTitleGothic3;
}

.row_box>div h2 a {
	text-decoration: none;
	color: #464646;
}

.row_box>div ul {
	margin-top: 10px;
	margin-bottom: 10px;
	padding-left: 30px;
}

.row_box>div li {
	list-style-position: inside;
	list-style: circle;
	padding: 5px 0px 5px 5px;
	margin: 0px;
	font-family: aTitleGothic2;
}

.row_box>div ul a {
	display: block;
	text-decoration: none;
	color: inherit;
}

.row_box>div ul a:hover {
	text-decoration: underline;
}

.notice_box, .community_box, .mymap_box, .goodmap_box, .job_box, .none_box {
	min-height: 178px;
}

hr {
	border: 2px solid #93c9eb;
	margin-bottom: 0px;
}

#background {
	background-color: #f9f9f9;
	padding-top: 15px;
	height: 100%;
}

.underline {
   width: auto; 
   text-overflow: ellipsis; 
   white-space: nowrap;
   overflow: hidden;
}
</style>
</head>

<body>
	<%
	String userID = null;
	int pageNumber = 1;
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
					<input type="hidden" name="href" value="home"> 
					<input type="button" value="회원가입" onClick="location.href='join.jsp'">
				</form>
			</div>
			<%
			// if user logged-in
			} else {
			%>
			<div class="login_box">
				<input type="button" value="로그아웃" onClick="location.replace('logoutAction.jsp?href=home')"> 
				<input type="button" value="회원탈퇴" onClick="deleteUser()">
			</div>
			<%
			}
			%>
		</div>
	</div>

	<hr>

	<div id="background">
		<div class="main_box">
			<div class="row_box">
				<div class="notice_box">
					<h2>
						<!-- goto noticeAdmin -->
						<a href="noticeAdmin.jsp">공지사항</a>
					</h2>
					<ul>
						<%
						pageNumber = 1;
						NoticeDAO noticeDAO = new NoticeDAO();
						ArrayList<Notice> noticeList = noticeDAO.getList(pageNumber);
						// if noticeAdmin posts are over 4
						// show by recently
						if (3 < noticeList.size()) {
							for (int i = 0; i < 4; i++) {
						%>
						<li>
							<a class="underline" href='post.jsp?category=noticeAdmin&bbsID=<%=noticeList.get(i).getNoticeID()%>'>
							<%=noticeList.get(i).getNoticeTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
							</a>
						</li>
						<%
						}
						// if noticeAdmin posts are under 4
						// show by recently
						} else {
						int blank = 4 - noticeList.size();
						for (int i = 0; i < noticeList.size(); i++) {
						%>
						<li>
							<a class="underline" href='post.jsp?category=noticeAdmin&bbsID=<%=noticeList.get(i).getNoticeID()%>'>
							<%=noticeList.get(i).getNoticeTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
							</a>
						</li>
						<%
						}
						}
						%>
					</ul>
				</div>


				<div class="mymap_box">
					<h2>
						<!-- goto myMap -->
						<a href="javascript:checkLogin();">My 로드맵</a>
					</h2>
					<ul>
						<li><a href="javascript:checkLogin();">My 로드맵</a></li>
					</ul>
				</div>
			</div>

			<div class="row_box">
				<div class="community_box">
					<h2>
						<!-- goto notice -->
						<a href="notice.jsp">자유게시판</a>
					</h2>
					<ul>
						<%
						pageNumber = 1;
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> bbsList = bbsDAO.getList(pageNumber);
						// if notice(bbs) posts are over 4
						// show by recently
						if (3 < bbsList.size()) {
							for (int i = 0; i < 4; i++) {
						%>
						<li>
							<a class="underline" href='post.jsp?category=notice&bbsID=<%=bbsList.get(i).getBbsID()%>'>
							<%=bbsList.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
							</a>
						</li>
						<%
						}
						// if notice(bbs) posts are under 4
						// show by recently
						} else {
						int blank = 4 - bbsList.size();
						for (int i = 0; i < bbsList.size(); i++) {
						%>
						<li>
							<a class="underline" href='post.jsp?category=notice&bbsID=<%=bbsList.get(i).getBbsID()%>'>
							<%=bbsList.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
							</a>
						</li>
						<%
						}
						}
						%>
					</ul>
				</div>

				<div class="goodmap_box">
					<h2>
						<!-- goto recommendMap -->
						<a href="recommendmap.jsp?pageNumber=1&selected=public">추천 로드맵</a>
					</h2>
					<ul>
						<%
						CountsDAO countsDAO = new CountsDAO();
						ArrayList<String> mapList = countsDAO.getHomeList();
						// show by most likely
						for (int i = 0; i < mapList.size(); i++) {
						%>
						<li><a href="map.jsp?userID=<%=mapList.get(i)%>"><%=mapList.get(i)%>의로드맵</a></li>
						<%
						}
						%>
					</ul>
				</div>
			</div>


			<div class="row_box">
				<div class="job_box">
					<h2>
						<!-- goto studyboard -->
						<a href="studyboard.jsp">공부게시판</a>
					</h2>
					<ul>
						<%
						pageNumber = 1;
						StudyboardDAO studyboardDAO = new StudyboardDAO();
						ArrayList<Studyboard> studyboardList = studyboardDAO.getList(pageNumber);
						// if studyboard posts are over 4
						// show by recently
						if (3 < studyboardList.size()) {
							for (int i = 0; i < 4; i++) {
						%>
						<li>
							<a class="underline" href='post.jsp?category=studyboard&bbsID=<%=studyboardList.get(i).getStudyboardID()%>'>
							<%=studyboardList.get(i).getStudyboardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
							</a>
						</li>
						<%
						}
						// if studyboard posts are under 4
						// show by recently
						} else {
						int blank = 4 - studyboardList.size();
						for (int i = 0; i < studyboardList.size(); i++) {
						%>
						<li>
							<a class="underline" href='post.jsp?category=studyboard&bbsID=<%=studyboardList.get(i).getStudyboardID()%>'>
							<%=studyboardList.get(i).getStudyboardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
							</a>
						</li>
						<%
						}
						}
						%>
					</ul>
				</div>

				<div class="roadmapManual_box">
					<h2>
						<!-- goto roadmapManual -->
						<a href="roadmapManual.jsp">로드맵 사용설명서</a>
					</h2>
					<ul>
						<li><a href="roadmapManual.jsp">로드맵 사용설명서</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<script>
	   // check before delete user, everything
       function deleteUser() {
          if(confirm("정말 탈퇴하시겠습니까?")==true){
             location.href='deleteUserAction.jsp';
          } else{
             return false;
          }
       }
       
	   // check login before go myMap
       function checkLogin() {
           var userID = '<%=userID%>';
			if (userID != 'null') {
				location.href = "map.jsp?userID=" + userID + "&myLink=yes";
			} else {
				alert('로그인을 해주세요.');
			}
		}
	</script>
</body>

</html>