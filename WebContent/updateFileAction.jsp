<!--
서동학: 전체적인 코딩, FTP
김영원: FTP
-->


<%@ page import="file.FileDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="map.ItemDAO"%>
<%@ page import="map.Item"%>
<%@ page import="map.LineDAO"%>
<%@ page import="map.Line"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.apache.commons.net.ftp.*"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.*" %>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>파일 업데이트 액션</title>
</head>
<body>
	<%
	String userID = request.getParameter("userID"); // 임시 아이디 부여
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}

	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'login.jsp'");
		script.println("</script>");
	} else {
		FileDAO fileDAO = new FileDAO();

		// 폴더 이름 바꾸기, 아이템의 상위요소교체 시 폴더의 이름도 변경된 itemID의 이름을 따라 변경
		String fileChangeStr = request.getParameter("fileData");
		StringTokenizer st = new StringTokenizer(fileChangeStr, "/");
		String oldItemID = st.nextToken();
		String newItemID = st.nextToken();
		String path = "/www/upload/" + userID; // 변경이전 폴더 경로
		
		
		FTPClient ftp = null;
		try {
			ftp = new FTPClient();
			ftp.setControlEncoding("UTF-8"); 
			ftp.connect("183.111.138.172"); // 접속할 ip
			ftp.login("hjk709914", "tiger123*"); // 접속할 아이디, 비밀번호
			ftp.enterLocalPassiveMode();
			
			ftp.changeWorkingDirectory(path); // 작업할 디렉토리 설정
			if(ftp.changeWorkingDirectory(path)) {
				System.out.println("FTP diretory set");
			}
			//ftp.setFileType(FTP.BINARY_FILE_TYPE);//파일 타입 설정 기본적으로 파일을 전송할떄는 BINARY타입을 사용합니다.
			
			int reply = ftp.getReplyCode();
		    if (!FTPReply.isPositiveCompletion(reply)) {
		    	ftp.disconnect();
		        System.out.println("FTP server refused connection.");
		    } else {
		    	System.out.println("FTP connected");
		        //System.out.print(ftpClient.getReplyString());
		    }

			try {
				// 부모 item 교체시 폴더 이름 변경
				ftp.rename(path+"/"+oldItemID, path+"/"+newItemID);
				fileDAO.updateChange(userID, oldItemID, newItemID);
			} catch (Exception e) {
				System.out.println(e.getMessage());
			} finally {
				
			}
			ftp.logout();
		} catch (Exception e) {
			System.out.println("Socket:" + e.getMessage());
		} finally {
			if (ftp != null && ftp.isConnected()) {
				try {
					ftp.disconnect();//ftp연결 끊기
		            PrintWriter script = response.getWriter();
		            script.println("<script>");
		            script.println("history.back()");
		            script.println("</script>");
				} catch (IOException e) {
				}
			}
		}
	}
	%>
</body>
</html>