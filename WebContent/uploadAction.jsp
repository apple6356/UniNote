<!--
서동학: 전체적인 코딩, FTP
김영원: FTP
-->


<%@ page import="java.util.Enumeration"%>
<%@ page import="file.FileDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.net.ftp.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>업로드 액션</title>
</head>
<body>
   <%
   String userID = null;
   if (session.getAttribute("userID") != null) {
      userID = (String) session.getAttribute("userID");
   }
   
   // 1. 사용자 컴퓨터 에서 JSP 호스팅 서버에 업로드
   // 2. JSP 서버에서 DB 호스팅 서버에 업로드
   // 3. JSP 호스팅 서버에 남은 업로드 폴더 삭제
   
   // JSP 호스팅 연결 후 업로드
   String[] fileNameArr = new String[5];
   String[] fileRealNameArr = new String[5];
   String itemID = null;
   itemID = request.getParameter("id");
   
   String directory = "upload/" + userID + "/" + itemID + "/"; //경로

   String savePath = directory.replace('\\', '/'); //구분자 리플레이스

   File targetDir = new File(savePath);
   // 경로에 저장할 폴더가 없으면 생성
   if (!targetDir.exists()) {
       targetDir.mkdirs();
   }

   // 업로드, 다운로드를 루트 폴더가 아니라 외부의 폴더로 지정해 취약점을 막는 방식의 코딩
   // 총 100메가 까지 저장 가능한 용량
   int maxSize = 1024 * 1024 * 100;
   String encoding = "UTF-8";

   MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());
   
   // Enumeration for문처럼 사용한다
   Enumeration fileNames = multipartRequest.getFileNames();
   int i=0;
   while (fileNames.hasMoreElements()) {
      String parameter = (String) fileNames.nextElement();
      String fileName = multipartRequest.getOriginalFileName(parameter);
      String fileRealName = multipartRequest.getFilesystemName(parameter);
      fileNameArr[i] = fileName;
      fileRealNameArr[i] = fileRealName;
      int fileSize = request.getContentLength();
      
      if (fileName == null) continue;
      if(fileSize <= 0 || fileSize>maxSize){
         File file = new File(directory + fileRealName);
         file.delete();
         break;
      }
      // 여기 나오는 확장자는 정상적으로 업로드하고 그게 아니라면 삭제하는 코드
      else if (!fileName.endsWith(".zip") && !fileName.endsWith(".ZIP") 
         && !fileName.endsWith(".hwp") && !fileName.endsWith(".HWP") 
         && !fileName.endsWith(".jpg") && !fileName.endsWith(".JPG")
         && !fileName.endsWith(".png") && !fileName.endsWith(".PNG") 
         && !fileName.endsWith(".ppt") && !fileName.endsWith(".PPT") 
         && !fileName.endsWith(".pptx") && !fileName.endsWith(".PPTX")) {
         // 업로드 실패시
         File file = new File(directory + fileRealName);
         file.delete();
         break;
      } else {
         // 성공적으로 업로드한 경우
		 // ftp 추가하면서 밑으로 내려감
      }
      i++;
      //System.out.println("while: " + fileRealName);
   }
   
   
    // FTP 연결 후 업로드
    FTPClient ftp = null;

	try {
		String FilePath="";
	    itemID = request.getParameter("id");
	    String ftpDirectory = "www/upload/" + userID + "/" + itemID + "/"; //경로
	    
	    savePath = ftpDirectory.replace('\\', '/'); //구분자 리플레이스
	
	    ftp = new FTPClient();
	    ftp.setControlEncoding("UTF-8");
	    ftp.connect("183.111.138.172");			// 접속할 ip
	    ftp.login("hjk709914", "tiger123*");	// 접속할 아이디, 비밀번호
	    ftp.enterLocalPassiveMode();
		
		boolean result = ftp.changeWorkingDirectory(savePath); // 작업할 디렉토리 설정
		// 디렉토리 만드는 부분 
		if(!result) { 
			result = false; 
			String[] FTPdirectory = savePath.split("/"); 

			String newdir = "";
			int l=0;
			for(i=0, l=FTPdirectory.length; i<l; i++) { 
				newdir += ("/" + FTPdirectory[i]); 
				try { 
					result = ftp.changeWorkingDirectory(newdir); 
					if(!result) { 
						ftp.makeDirectory(newdir); 
						ftp.changeWorkingDirectory(newdir); 
					} 
				} catch (IOException e) { 
					throw e; 
				} 
			} 
		}


	    ftp.setFileType(FTPClient.BINARY_FILE_TYPE);	// 파일 깨짐 방지	   

	    // ftp 저장할 장소 (루트의 imgs 폴더)
	    ftp.changeWorkingDirectory(savePath);
	    
	   	// 저장할 파일 선택
	   	for(i=0; i<fileRealNameArr.length; i++) {
	   		if(fileRealNameArr[i] != null) {
	   			//System.out.println("FTP: " + fileRealNameArr[i]);
		   		File uploadFile = new File(directory + fileRealNameArr[i]);
			    FileInputStream fis = null;
				   
			    try {
			        fis = new FileInputStream(uploadFile);
			        
			        // ftp 서버에 파일을 저장한다. (저장한 이름, 파일)
			        // 성공시 DB도 업로드
			        boolean isSuccess = ftp.storeFile(uploadFile.getName(), fis);
			        if (isSuccess) {
			            System.out.println("Upload Success");
			            new FileDAO().upload(fileNameArr[i], fileRealNameArr[i], userID, itemID);
			            out.write("파일명 : " + fileNameArr[i] + "<br>");
			        }
			    } catch (IOException ex) {
			        System.out.println(ex.getMessage());
			    } finally {
			        if (fis != null) {
			            try {
			                fis.close();
			            } catch (IOException ex) {}
			        }
			    }
	   		}
	   	}
	} catch (SocketException e) {
	    System.out.println("Socket:" + e.getMessage());
	} catch (IOException e)	{
	    System.out.println("IO:" + e.getMessage());
	// 마지막으로 ftp 로그아웃, 연결해제
	} finally {
	    if (ftp != null && ftp.isConnected()) {
	        try {
	        	ftp.logout();
	            ftp.disconnect();
	            deleteFile("upload/"+userID);
	        } catch (IOException e) { 
	        	
	        }
	    }
	}
   %>
   <input type="button" onclick="back()" value="돌아가기">
   <script>
      // 뒤로 돌아가는 함수
      function back() {
         location.href = document.referrer;
      }
   </script>
   
   	<!-- 탈퇴한 유저가 업로드한 파일과 폴더를 삭제하는 함수 -->
	<%!
	public static void deleteFile(String path) {
	      File deleteFolder = new File(path);

	      if (deleteFolder.exists()) {
	         File[] deleteFolderList = deleteFolder.listFiles();

	         for (int i = 0; i < deleteFolderList.length; i++) {
	            if (deleteFolderList[i].isFile()) {
	               deleteFolderList[i].delete();
	            } else {
	               deleteFile(deleteFolderList[i].getPath());
	            }
	            deleteFolderList[i].delete();
	         }
	         deleteFolder.delete();
	      }
	   }
	%>
</body>
</html>