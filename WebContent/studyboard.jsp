<!--
김영원: DB, CSS
서동학: HTML, 페이지 나누기
-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.StudyboardDAO"%>
<%@ page import="bbs.Studyboard"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>공부게시판</title>
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
	height: 100%;
	margin: 0px
}

.top_box {
	display: flex;
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

.main_box {
	width: 1000px;
	margin: 0 auto;
}

.home {
	font-size: 40px;
	margin: 0px auto 15px 20px;
}

.home a {
	font-size: 50px;
	color: #93c9eb;
	margin: 10px 10px 10xp auto;
	text-decoration: none;
	font-weight: 1000;
	font-family: uninote;
}

.login_box {
	float: right;
	padding-top: 15px;
}

.menu {
	display: grid;
	grid-template-columns: 140px 140px 140px 140px 140px;
	margin-bottom: 10px;
	margin-top: 10px;
}

.submenu {
	text-align: center;
	border: 1px solid #ccc;
	margin-right: 10px;
	padding: 5px 2px 5px 2px;
	background-color: white;
	border-radius: 5px;
	font-weight: bold;
	font-family: aTitleGothic3;
}

.index {
	background-color: white;
}

.index ul {
	border: 2px solid #93c9eb;
}

.list {
	display: grid;
	grid-template-columns: 100px 1fr 160px 200px;
	font-family: aTitleGothic2;
}

.list_title {
   text-decoration: none;
   padding: 15px;
   font-size: 15px;
   width: 1fr; 
   text-overflow: ellipsis; 
   white-space: nowrap;
   overflow: hidden;
}

.list_wirter {
	text-decoration: none;
	text-align: center;
	vertical-align: middle;
	/* border: 1px solid black; */
	padding: 15px;
}

.list_date {
	text-decoration: none;
	text-align: center;
	vertical-align: middle;
	/* border: 1px solid black; */
	padding: 15px;
}

.bottom_box {
	display: flex;
	justify-content: space-between;
	font-family: aTitleGothic2;
}

.page {
	display: flex;
	margin-right: 460px;
	margin-left: 15px;
}

.page_num {
	padding-right: 5px;
}

.button_box {
	
}

.pageNum {
	display: flex;
	margin-top: 0px;
}

.pageNo {
	margin-left: 3px;
	margin-right: 3px;
}

.active {
	font-weight: bold;
}

hr {
	border: 2px solid #93c9eb;
	margin-bottom: 0px;
}

#background {
	background-color: #f9f9f9;
	padding-top: 10px;
	height: 100%;
}
</style>
</head>

<body>
	<%
	int pageNumber = 1;
	if (request.getParameter("pageNumber") != null) {
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}

	StudyboardDAO studyboardDAO = new StudyboardDAO();
	int listCount = studyboardDAO.count(); // 현재 게시판의 게시글 개수

	int PAGE_LIMIT = 10; // 한번에 보이는 페이지 수
	int BOARD_LIMIT = 10; // 하나의 페이지에 보이는 게시물 수

	int currentPage = pageNumber;
	int maxPage = (int) Math.ceil(listCount / (double) BOARD_LIMIT); // 표현가능한 마지막 페이지
	// currentPage에 -1을 빼고, 마지막 결과에 +1을 하는 것은, 1과 10페이지에서의 문제 때문이다.
	int startPage = (int) ((currentPage - 1) / PAGE_LIMIT) * PAGE_LIMIT + 1; // 처음 페이지를 구한다
	int endPage = startPage + PAGE_LIMIT - 1; // 마지막 페이지
	if (maxPage < endPage) {
		endPage = maxPage;
	}
	%>
	<div class="main_box">
		<div class="top_box">
			<div class="home">
				<p style="margin:0;"><a href='home.jsp'><img src="img/LogoColor.png" alt="no image" height="50" style="vertical-align: middle;"><span style="vertical-align: middle;">UNINOTE</span></a></p>
			</div>

			<%
			if (userID == null) {
			%>
			<div class="login_box">
				<form method="post" action="loginAction.jsp">
					<input type="text" name="userID" placeholder="아이디" maxlength="20">
					<input type="password" name="userPassword" placeholder="비밀번호" maxlength="20"> <input type="submit" value="로그인">
					<input type="hidden" name="href" value="studyboard"> <input type="button" value="회원가입" onClick="location.href='join.jsp'">
				</form>
			</div>
			<%
			} else {
			%>
			<div class="login_box">
				<input type="button" value="로그아웃" onClick="location.replace('logoutAction.jsp?href=studyboard')">
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
			<div class="menu">
				<div class="submenu">
					<a class="underline" href='noticeAdmin.jsp'>공지사항</a>
				</div>
				<div class="submenu">
					<a class="underline" href='notice.jsp'>자유게시판</a>
				</div>
				<div class="submenu">
					<a class="underline" href='recommendmap.jsp'>추천 로드맵</a>
				</div>
				<div class="submenu" style="background-color: #93c9eb;">
					<a class="underline" href='studyboard.jsp' style="color: white;">공부게시판</a>
				</div>
			</div>

			<div class=index>
				<ul>
					<div class="list">
						<li class="list_wirter" style="border-right: 2px solid #93c9eb; border-bottom: 2px solid #93c9eb; font-weight: bold;">번호</li>
						<li class="list_title" style="border-right: 2px solid #93c9eb; border-bottom: 2px solid #93c9eb; font-weight: bold;">제목</li>
						<li class="list_wirter" style="border-right: 2px solid #93c9eb; border-bottom: 2px solid #93c9eb; font-weight: bold;">작성자</li>
						<li class="list_date" style="border-bottom: 2px solid #93c9eb; font-weight: bold;">작성일</li>
					</div>
					<%
					// 공부게시판의 글만 가져온다
					ArrayList<Studyboard> studyboardList = studyboardDAO.getList(pageNumber);
					for (int i = 0; i < studyboardList.size(); i++) {
						if (i < studyboardList.size() - 1) {
					%>
					<div class="list">
						<li class="list_wirter" style="border-right: 2px solid #ccc; border-bottom: 2px solid #ccc;"><%=studyboardList.get(i).getStudyboardID()%></li>
						<li class="list_title" style="border-right: 2px solid #ccc; border-bottom: 2px solid #ccc;">
						<a class="underline" href='post.jsp?category=studyboard&bbsID=<%=studyboardList.get(i).getStudyboardID()%>'><%=studyboardList.get(i).getStudyboardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></a></li>
						<li class="list_wirter" style="border-right: 2px solid #ccc; border-bottom: 2px solid #ccc;"><%=studyboardList.get(i).getUserID()%></li>
						<li class="list_date" style="border-bottom: 2px solid #ccc;"><%=studyboardList.get(i).getStudyboardDate().substring(0, 11)%></li>
					</div>
					<%
						} else {
					%>
					<div class="list">
						<li class="list_wirter" style="border-right: 2px solid #ccc;"><%=studyboardList.get(i).getStudyboardID()%></li>
						<li class="list_title" style="border-right: 2px solid #ccc;">
						<a class="underline" href='post.jsp?category=studyboard&bbsID=<%=studyboardList.get(i).getStudyboardID()%>'><%=studyboardList.get(i).getStudyboardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></a></li>
						<li class="list_wirter" style="border-right: 2px solid #ccc;"><%=studyboardList.get(i).getUserID()%></li>
						<li class="list_date"><%=studyboardList.get(i).getStudyboardDate().substring(0, 11)%></li>
					</div>
					<%
						}
					}
					%>

				</ul>
			</div>

			<div class="bottom_box">
				<div class=page>
					<%
					if (currentPage > 10) { // 현재 페이지가 10보다 클 때 이전 버튼을 활성화, 전 페이지의 가장 마지막 페이지로 이동
						int preNum;
						int x = pageNumber % 10;
						preNum = pageNumber - x;
					%>
					<a class="page_num" href='studyboard.jsp?pageNumber=<%=preNum%>'>이전</a>
					<%
					} else {
					%>
					<span class="page_num">이전</span>
					<%
					}
					%>
					<ul class="pageNum">
						<%
						if (1 != startPage) {
						%>
						<li><a href="studyboard.jsp?pageNumber=<%=startPage - 1%>"></a></li>
						<%
						}
						%>
						<%
						int i = 0;
						for (i = startPage; i <= endPage; i++) {
							if (i == currentPage) {
						%>
						<li class="active pageNo"><a class="active"><%=i%></a></li>
						<%
							} else {
						%>
						<li class="pageNo"><a href="studyboard.jsp?pageNumber=<%=i%>"><%=i%></a></li>
						<%
							}
						}
						if (endPage != maxPage) { // endPage와 maxPage가 다르면 endPage+1이 가장 마지막
						%>
						<li class="pageNo"><a href="studyboard.jsp?pageNumber=<%=endPage + 1%>"></a></li>
						<%
						}
						%>
					</ul>
					<%
					if (maxPage > 10) { // maxPage가 10보다 클 경우만 다음 버튼 활성화, 클릭시 다음의 첫 페이지로 이동
						int postNum;
						int x = pageNumber % 10;
						if (x == 0) x = 10;
						postNum = (pageNumber + 11) - x;
						if ((postNum) <= maxPage) {
					%>
					<a class="page_num" href='studyboard.jsp?pageNumber=<%=postNum%>'>다음</a>
					<%
						} else {
					%>
					<span class="page_num">다음</span>
					<%
						}
					} else {
					%>
					<span class="page_num">다음</span>
					<%
					}
					%>
				</div>

				<%
				if (userID == null) {
				%>
				<div class="button_box">
					<button onClick="alert('로그인 후 시도해주세요.')" value="생성">생성</button>
				</div>
				<%
				} else {
				%>
				<div class="button_box">
					<button onClick="location.href='write.jsp?category=studyboard'" value="생성">생성</button>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</div>
	<script>
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