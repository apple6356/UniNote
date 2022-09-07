<!--
김영원: DB, CSS
서동학: HTML, 로그인 상태확인, category
-->


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Notice" %>
<%@ page import="bbs.NoticeDAO" %>
<%@ page import="bbs.Studyboard" %>
<%@ page import="bbs.StudyboardDAO" %>
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <title>게시글</title>
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
      margin: 0px;
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
      font-family: aTitleGothic2;
      word-break: break-all;
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
      height: 100%;
    }
  </style>
</head>

<body>
    <%
    String category = request.getParameter("category");
    int bbsID = 0;
    // get bbsID (PK)
    if(request.getParameter("bbsID") != null) {
       bbsID = Integer.parseInt(request.getParameter("bbsID"));
    }
    if(bbsID == 0) {
       PrintWriter script = response.getWriter();
       script.println("<script>");
       script.println("alert('유효하지 않은 글입니다.')");
       script.println("location.href = '"+category+".jsp'");
       script.println("</script>");
    }
    
    Bbs bbs = new BbsDAO().getBbs(bbsID);
    Notice notice = new NoticeDAO().getNotice(bbsID);
    Studyboard studyboard = new StudyboardDAO().getStudyboard(bbsID);
    
    String userID = null;
    // if user logged-in
    if(session.getAttribute("userID") != null){
       userID = (String)session.getAttribute("userID");
    }
    %>
 
<div class="main_box">
    <div class="top_box">
      <div class="home">
	  	<p style="margin:0;"><a href='home.jsp'><img src="img/LogoColor.png" alt="no image" height="50" style="vertical-align: middle;"><span style="vertical-align: middle;">UNINOTE</span></a></p>
      </div>
    
       <%
       // if user not logged-in
       if(userID == null){
       %>
	      <div class="login_box">
	         <form method="post" action="loginAction.jsp">
	             <input type="text" name="userID" placeholder="아이디" maxlength="20">
	             <input type="password" name="userPassword" placeholder="비밀번호" maxlength="20">
	             <input type="submit" value="로그인">
	             <input type="hidden" name="href" value="post">
	             <input type="hidden" name="category" value=<%=category %>>
	             <input type="hidden" name="bbsID" value=<%=bbsID %>>
	             <input type="button" value="회원가입" onClick="location.href='join.jsp'">
	         </form>
	      </div>
       <%
       // if user logged-in
       } else {
       %>
      <div class="login_box">
         <input type="button" value="로그아웃" onClick="location.replace('logoutAction.jsp?href=post&category=<%=category %>&bbsID=<%=bbsID%>')">
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
         <%
         // check by category and get Title, writer, writtenDate
         if("notice".equals(category)){ 
         %>
          <li class="post_title"><strong><%= bbs.getBbsTitle() %></strong></li>
          <li class="post_wirter"><%= bbs.getUserID() %></li>
          <li class="post_date"><%= bbs.getBbsDate().substring(0, 11) %></li>
        <%
        } else if("noticeAdmin".equals(category)) {
        %>
          <li class="post_title"><strong><%= notice.getNoticeTitle() %></strong></li>
          <li class="post_wirter"><%= notice.getUserID() %></li>
          <li class="post_date"><%= notice.getNoticeDate().substring(0, 11) %></li>
        <%
        } else if("studyboard".equals(category)) {
        %>
          <li class="post_title"><strong><%= studyboard.getStudyboardTitle() %></strong></li>
          <li class="post_wirter"><%= studyboard.getUserID() %></li>
          <li class="post_date"><%= studyboard.getStudyboardDate().substring(0, 11) %></li>
        <%
        }
        %>
        </div>
      </ul>
      <div class="button_box">
          <%
          String isMyPost = "no";
          if(userID != null) {
        	    // if post is mine set modify button by category and set delete button
                if("notice".equals(category) && userID.equals(bbs.getUserID())) {
                	isMyPost = "yes";
          %>
	            <button type="button" value="수정"><a href="update.jsp?category=<%=category %>&bbsID=<%= bbsID %>">수정</a></button>
	            <button onclick="return confirm('삭제합니까?')" type="button" value="삭제"><a href="deleteAction.jsp?category=<%=category %>&bbsID=<%= bbsID %>">삭제</a></button>
          <%
                } 
                else if("noticeAdmin".equals(category) && userID.equals(notice.getUserID())) {
                	isMyPost = "yes";
          %>
	            <button type="button" value="수정"><a href="update.jsp?category=<%=category %>&bbsID=<%= bbsID %>">수정</a></button>
	            <button onclick="return confirm('삭제합니까?')" type="button" value="삭제"><a href="deleteAction.jsp?category=<%=category %>&bbsID=<%= bbsID %>">삭제</a></button>
          <%
                }
                else if("studyboard".equals(category) && userID.equals(studyboard.getUserID())) {
                	isMyPost = "yes";
          %>
	            <button type="button" value="수정"><a href="update.jsp?category=<%=category %>&bbsID=<%= bbsID %>">수정</a></button>
	            <button onclick="return confirm('삭제합니까?')" type="button" value="삭제"><a href="deleteAction.jsp?category=<%=category %>&bbsID=<%= bbsID %>">삭제</a></button>
          <%
                }
          }
          %>
      </div>
    </div>

    <div class="article_box">
    <%
      // show content by category
      if("notice".equals(category)) {
    %>
      <%= bbs.getBbsContent()%>
    <%
      } else if("noticeAdmin".equals(category)) {
    %>
      <%= notice.getNoticeContent()%>
    <%
      } else if("studyboard".equals(category)) {
    %>
      <%= studyboard.getStudyboardContent()%>
    <%
      }
    %>
    </div>

    <div class="bottom_button_box">
      <button onclick="location.href='<%=category %>.jsp'" value="목록">목록</button>
    </div>

  </div>
  </div>
  
  <script>
  	var isMyPost = '<%=isMyPost %>';
  
  	// make space for modify, delete button
  	if(isMyPost == "yes") {
  		var postList = document.getElementById("postList");
  		postList.style.gridTemplateColumns = "600px 100px 100px";
  	}
  
 	// check before delete user, everything
    function deleteUser() {
        if(confirm("정말 탈퇴하시겠습니까?")==true){
           location.href='deleteUserAction.jsp';
        } else{
           return false;
        }
    }
  </script>
</body>

</html>