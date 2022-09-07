<!--
김영원: CSS
서동학: 전체적인 코딩
-->


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <title>글작성</title>

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
    
    .write_box span {
      font-weight: bold;
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
		script.println("alert('로그인을 해주세요.');");
		script.println("history.back();");
		script.println("</script>");
	}
%>
  <div class="main_box">
    <div class="top_box">
      <div class="home">
		<p style="margin:0;"><a href='home.jsp'><img src="img/LogoColor.png" alt="no image" height="50" style="vertical-align: middle;"><span style="vertical-align: middle;">UNINOTE</span></a></p>
      </div>
    </div>

	<!-- write title, content and submit -->
    <form method="post" action="writeAction.jsp?category=<%=category%>">
      <div class="write_box">
        제목 : <input class="title" type="text" name="bbsTitle" placeholder="제목" size="80" maxlength="50">
        <textarea id="summernote" name="bbsContent"></textarea>
      </div>

      <div class="button_box">
        <input class="submit_button" type="submit" value="작성">
        <input class="cancle_button" type="button" value="취소" onClick="location.href='<%=category %>.jsp'">
      </div>
    </form>


  </div>

  <script>
    //make text-area box
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
