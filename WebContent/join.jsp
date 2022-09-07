<!--
서동학: 전체적인 코딩
-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>회원가입</title>

<!-- emailJS 사이트를 사용하여 이메일을 보낸다 -->
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/emailjs-com@3/dist/email.min.js"></script>

<script type="text/javascript">
   (function() {
      emailjs.init("user_7jWqZksGUyrF8RSOsS3Xu");
   })();
</script>

<style>
body, html {
   margin: 0;
   width: 100%;
   height: 100%;
}

.main_box {
   width: 30%;
   height: 100%;
   margin: 0 auto;
   overflow: hidden;
   background-color: #f9f9f9;
   padding: 0px 15px 0px 15px;
}

.main_box input {
   width: 100%;
   padding: 10px 14px 10px 14px;
   box-sizing: border-box;
}

.authNo {
   margin-top: 10px;
}

.btnJoin {
   width: 100%;
   margin-top: 10px;
   font-weight: bold;
}

#idLabel {
   margin-top: 30px;
}

#getAuthNo {
   margin-left: 25px;
}

#authNo {
   width: 70%;
}

#authck {
   width: 23%;
   margin-left: 25px;
}

#userID {
   width: 70%;
}

#idCheck {
   width: 23%;
   margin-left: 25px;
}

#background {
   background-color: #f9f9f9;
   height: 100%;
}
</style>
</head>

<body>
   <script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
   <div id="background">
      <div class="main_box">
         <form method="post" action="joinAction.jsp" onsubmit="return check()">
            <h3 id="idLabel">
               <label for="id">아이디</label>
            </h3>
            <div class="id_box">
               <input id="userID" type="text" name="userID" maxlength="20" placeholder="최대 20자" onkeyup="characterCheck(this)" onkeydown="characterCheck(this)">
               <button type="button" id="idCheck" onclick="IDCheck()">중복 확인</button><br>
               <span id="id_span"></span>
            </div>

            <h3>
               <label for="pw">비밀번호</label>
            </h3>
            <div class="pw_box">
               <input id="pw" type="password" name="userPassword" maxlength="20" placeholder="최대 20자" onchange="passwordCheck()">
            </div>

            <h3>
               <label for="pwck">비밀번호 확인</label>
            </h3>
            <div class="pwck_box">
               <input id="pwck" type="password" name="pwck" maxlength="20" placeholder="최대 20자" onchange="passwordCheck()">
            </div>

            <div style="height: 15px">
               <span id="same_ck" style="font-size: 14px"></span>
            </div>

            <h3>
               <label for="name">이름</label>
            </h3>
            <div class="name_box">
               <input id="name_id" type="text" name="userName">
            </div>

            <h3>
               <label for="email">이메일</label>
            </h3>
            <div class="email_box">
               <input id="email_id" type="email" name="userEmail" placeholder="이메일">
               <button id="email_btn" type="button" onclick="emailMove()">인증번호받기</button>
               <button style="display: none" id="email_form_btn" type="submit" form="contact-form">인증번호보내기</button>
            </div>

            <div class="authck_box">
               <input type="tel" name="authNo" class="authNo" id="authNo" placeholder="인증번호 입력">
               <button type="button" id="authck" onclick="authCk(getauthNo())">인증번호 확인</button>
            </div>
            <input type="submit" name="btnJoin" class="btnJoin" id="btnJoin" value='가입하기' disabled>
         </form>
      </div>
   </div>

   <!-- 이메일 발송 폼 -->
   <form id="contact-form">
      <input style="display: none" id="name_id_form" type="text" name="name">
      <input style="display: none" id="email_id_form" type="email"
         name="email" placeholder="이메일"> <input type="hidden"
         name="contact_number">
      <textarea style="display: none" id="message" name="message"></textarea>
   </form>


   <script>
      // 비밀번호 확인 변수
      var pwck = false;
      // 아이디 중복 확인을 했는지 확인하는 변수
      var idck = false;
      // 인증번호를 저장하는 변수
      var authcode;
      
      // 특수문자 입력 방지
      function characterCheck(obj){
      var regExp = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi; 
      if( regExp.test(obj.value) ){
         document.getElementById("id_span").innerHTML = "특수문자는 사용할 수 없습니다";
         document.getElementById("id_span").style.color = "red";
         obj.value = obj.value.substring( 0 , obj.value.length - 1 ); // 입력한 특수문자 한자리 지움
         }
      }
      
      function check() {
         if(idck==false){
            alert("아이디를 확인해주세요.");
            return false;
         }
         else if(pwck==false){
            alert("비밀번호를 확인해주세요.");
            return false;
         }
         else if(idck==true&&pwck==true){
            return true;
         }
      }

      function emailMove() {
         emailSend()
         document.getElementById("name_id_form").value = document.getElementById("name_id").value;
         document.getElementById("email_id_form").value = document.getElementById("email_id").value;
         document.getElementById("email_form_btn").click();
         alert("인증번호가 발송되었습니다.");
      }

      //6자리 난수 생성
      function generateRandomCode() {
         let str = '';
         for (let i = 0; i < 6; i++) {
            str += Math.floor(Math.random() * 10);
         }
         return str;
      }

      function emailSend() {
         //인증번호 생성
         authcode = generateRandomCode();
         document.getElementById("message").value = authcode;

         document.getElementById('contact-form').addEventListener('submit', function(event) {
            event.preventDefault();
            this.contact_number.value = Math.random() * 100000 | 0;
            emailjs.sendForm('service_5gv5vso', 'template_xsxf4tb', this).then(function() {
               console.log('SUCCESS!');
            }, function(error) {
               console.log('FAILED...', error);
            });
         });
      }

      // 인증번호 체크
      function authCk(code) {
         const btn = document.getElementById("authck");
         if (code == authcode) {
            document.getElementById('authNo').disabled = true;
            document.getElementById('authck').disabled = true;
            document.getElementById('btnJoin').disabled = false;
            document.getElementById('btnJoin').style.backgroundColor = "#93c9eb";
            document.getElementById('btnJoin').style.borderColor = "gray";
            alert("인증되었습니다.");
         } else {
            alert("인증번호가 일치하지 않습니다.");
         }
      }

      function getauthNo() {
         var authno = document.getElementById("authNo").value;
         return authno;
      }

      // 비밀번호 확인
      function passwordCheck() {
         if (document.getElementById("pw").value != "" && document.getElementById("pwck").value != "") {
            if (document.getElementById("pw").value == document.getElementById("pwck").value) {
               pwck = true;
               document.getElementById('same_ck').innerHTML = "비밀번호가 일치합니다.";
               document.getElementById('same_ck').style.color = 'blue';
            } else {
               pwck = false;
               document.getElementById('same_ck').innerHTML = "비밀번호가 일치하지 않습니다.";
               document.getElementById('same_ck').style.color = 'red';
            }
         }
      }

      // id 중복 확인 관련
      var request = new XMLHttpRequest();

      function IDCheck() {
         var userID = document.getElementById("userID").value;
         var data_rtn;
         if (userID == "" || userID==null || userID=="null") {
            alert("아이디를 입력해주세요.");
         }

         request.open("Post", "./UserIDServlet?userID=" + encodeURIComponent(userID), true);
         request.onreadystatechange = checkProcess;
         request.send(null);
      }

      // 아이디 체크 결과에 따라 id_span의 내용을 변경
      function checkProcess() {
         var userID = document.getElementById("userID").value;
         if (request.readyState == 4 && request.status == 200) {
            var object = eval('(' + request.responseText + ')');
            if (object == -1 && userID!=null && userID!="" && userID!="null") {
               document.getElementById("id_span").innerHTML = "사용 가능한 아이디입니다";
               document.getElementById("id_span").style.color = "blue";
               idck = true;
            } else if (object == 1) {
               document.getElementById("id_span").innerHTML = "이미 사용중인 아이디입니다";
               document.getElementById("id_span").style.color = "red";
               idck = false;
            }
         }
      }
   </script>
</body>

</html>