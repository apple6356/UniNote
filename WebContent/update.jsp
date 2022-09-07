<!--
김영원: CSS
서동학: 전체적인 코딩
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
  <title>글수정</title>

  <link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet">
  <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.js"></script>
  <script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script>

  <link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.1/summernote.css" rel="stylesheet">
  <script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.1/summernote.js"></script>


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
  
    html, body {
      height: 100%;
      margin: 0px;
      background-color: #f9f9f9;
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

    .top_box {
      display: flex;
      justify-content: space-between;
    }

    .home {
      font-size: 40px;
      margin-bottom: 20px;
    }
    
    .home a {
      font-size: 50px;
      color: #93c9eb;
      margin: 10px 10px 10xp auto;
      text-decoration: none;
      font-weight: 700;
      font-family: uninote;
    }

    .text_box {
      resize: none;
      width: 700px;
      height: 300px;
    }

    .title {
      margin-bottom: 10px;
    }

    .button_box {
      display: flex;
      justify-content: center;
    }

    .submit_button {
      margin-right: 20px;
    }
  </style>
</head>

<body>
  <%
    String category = request.getParameter("category");
    String userID = null;
    
    // if user logged-in
    if(session.getAttribute("userID") != null) {
       userID = (String) session.getAttribute("userID");
    }
    // if user not logged-in
    if(userID == null) {
       PrintWriter script = response.getWriter();
       script.println("<script>");
       script.println("alert('로그인을 하세요.')");
       script.println("location.href = 'login.jsp'");
       script.println("</script>");
    }
    
    int bbsID = 0;
    // get bbsID (PK)
    if(request.getParameter("bbsID") != null) {
       bbsID = Integer.parseInt(request.getParameter("bbsID"));
    }
    if(bbsID == 0) {
       PrintWriter script = response.getWriter();
       script.println("<script>");
       script.println("alert('유효하지 않은 글입니다.')");
       script.println("location.href = '"+ category + ".jsp'");
       script.println("</script>");
    }
    
    Bbs bbs = new BbsDAO().getBbs(bbsID);
    Notice notice = new NoticeDAO().getNotice(bbsID);
    Studyboard studyboard = new StudyboardDAO().getStudyboard(bbsID);
    // check if modify and not my post
    if(category.equals("notice")) {
       if(!userID.equals(bbs.getUserID())) {
          PrintWriter script = response.getWriter();
          script.println("<script>");
          script.println("alert('권한이 없습니다.')");
          script.println("location.href = 'notice.jsp'");
          script.println("</script>");
       }
    }
    if(category.equals("noticeAdmin")) {
       if(!userID.equals(notice.getUserID())) {
          PrintWriter script = response.getWriter();
          script.println("<script>");
          script.println("alert('권한이 없습니다.')");
          script.println("location.href = 'noticeAdmin.jsp'");
          script.println("</script>");
       }
    }
    if(category.equals("studyboard")) {
       if(!userID.equals(studyboard.getUserID())) {
          PrintWriter script = response.getWriter();
          script.println("<script>");
          script.println("alert('권한이 없습니다.')");
          script.println("location.href = 'studyboard.jsp'");
          script.println("</script>");
       }
    }
  %>
  <div class="main_box">
    <div class="top_box">
      <div class="home">
		<p style="margin:0;"><a href='home.jsp'><img src="img/LogoColor.png" alt="no image" height="50" style="vertical-align: middle;"><span style="vertical-align: middle;">UNINOTE</span></a></p>
      </div>
    </div>

    <form method="post" action="updateAction.jsp?category=<%=category %>&bbsID=<%= bbsID %>">
      <div class="write_box">
        <%
        // show title box by category
        if(category.equals("notice")){ 
        %>
        제목 : <input class="title" type="text" name="bbsTitle" placeholder=<%= bbs.getBbsTitle() %> size="80" maxlength="50">
        <p><textarea id="summernote" name="bbsContent"><%= bbs.getBbsContent() %></textarea></p>
        <%
        } 
        if(category.equals("noticeAdmin")) {
        %>
        제목 : <input class="title" type="text" name="bbsTitle" placeholder=<%= notice.getNoticeTitle() %> size="80" maxlength="50">
        <p><textarea id="summernote" name="bbsContent"><%= notice.getNoticeContent() %></textarea></p>
        <%
        }
        if(category.equals("studyboard")) {
        %>
        제목 : <input class="title" type="text" name="bbsTitle" placeholder=<%= studyboard.getStudyboardTitle() %> size="80" maxlength="50">
        <p><textarea id="summernote" name="bbsContent"><%=studyboard.getStudyboardContent() %></textarea></p>
        <%
        }
        %>
     </div>
     
      <div class="button_box">
        <input class="submit_button" type="submit" value="수정">
        <input class="cancle_button" type="button" value="취소" onClick="history.go(-1)">
      </div>
    </form>


  </div>

  <script>
  	// make text-area box
    $(document).ready(function() {
      $('#summernote').summernote({
        height: 300,
        minHeight: null,
        maxHeight: null,
        focus: true,
        lang: "ko-KR",
        placeholder: '최대 2048자까지 쓸 수 있습니다',
        toolbar: [
          ['fontname', ['fontname']],
          ['fontsize', ['fontsize']],
          ['style', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
          ['color', ['forecolor', 'color']],
          ['para', ['ul', 'ol', 'paragraph']],
          ['height', ['height']],
          ['view', ['fullscreen', 'help']]
        ],
        fontNames: ['맑은 고딕', '궁서', '굴림체', '굴림', '돋움체', '바탕체'],
        fontSizes: ['8', '9', '10', '11', '12', '14', '16', '18', '20', '22', '24', '28', '30', '36']
      });
      
      $("#summernote").on("summernote.enter", function(we, e) {
        $(this).summernote("pasteHTML", "<br><br>");
        e.preventDefault();
      });
    });
  </script>
</body>

</html>