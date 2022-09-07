<!--
서동학: 전체적인 코딩, FTP
김영원: FTP
-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="file.FileDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="org.apache.commons.net.ftp.*"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>파일 삭제</title>
</head>

<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		String itemID = "";
		String action = request.getParameter("action");
		
		// 파일을 삭제하는 경우, 파일만을 삭제 폴더에 영향 없음
		if(action.equals("fileDelete")){
			itemID = request.getParameter("itemID");
			String fileRealName = request.getParameter("fileRealName");
			
			if(userID==null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('로그인된 상태가 아닙니다.')");
				script.println("location.href = 'home.jsp'");
				script.println("</script>");
			}
			else {
				FileDAO fileDAO = new FileDAO();
				int result = fileDAO.delete(userID, itemID, fileRealName);
				if(result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else {
					String path = "/www/upload/" + userID + "/" + itemID; // 변경이전 폴더 경로
					FTPClient ftp = null;
					try {
						ftp = new FTPClient();
						ftp.setControlEncoding("UTF-8"); 
						ftp.connect("183.111.138.172"); // 접속할 ip
						ftp.login("hjk709914", "tiger123*"); // 접속할 아이디, 비밀번호
						ftp.enterLocalPassiveMode();
						
						ftp.changeWorkingDirectory(path);// 작업할 디렉토리 설정
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
							// item 삭제시 해당 파일 삭제
							ftp.deleteFile(fileRealName);
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
								script.println("location.href = document.referrer;");
								script.println("</script>");
							} catch (IOException e) {
							}
						}
					}
				}
			}
		}
		// 아이템을 삭제하여 아이템에 업로드된 파일과 폴더를 삭제하는 경우
		else if(action.equals("itemDelete")){
			System.out.println("itemDelete");
			itemID = request.getParameter("fileData");
			System.out.println(itemID);
			if(userID==null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('로그인된 상태가 아닙니다.')");
				script.println("location.href = 'home.jsp'");
				script.println("</script>");
			}
			else {
				FileDAO fileDAO = new FileDAO();
				int result = fileDAO.deleteItem(userID, itemID);
				if(result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else {
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
							// 해당 폴더 삭제
							removeDirectory(ftp, path, itemID);
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
								script.println("location.href = document.referrer;");
								script.println("</script>");
							} catch (IOException e) {
							}
						}
					}
				}
			}
		}
	%>
	
	<!-- 탈퇴한 유저가 업로드한 파일과 폴더를 삭제하는 함수 -->
	<%!
		public static void deleteFile(String path) {
			File deleteFolder = new File(path);
	
			if(deleteFolder.exists()){
				File[] deleteFolderList = deleteFolder.listFiles();
				
				for (int i = 0; i < deleteFolderList.length; i++) {
					if(deleteFolderList[i].isFile()) {
						deleteFolderList[i].delete();
					}else {
						deleteFile(deleteFolderList[i].getPath());
					}
					deleteFolderList[i].delete(); 
				}
				deleteFolder.delete();
			}
		}
	
	// 안에 있는 모든 파일, 폴더를 지운후 폴더를 삭제하는 함수
    public static void removeDirectory(FTPClient ftpClient, String parentDir,
            String currentDir) throws IOException {
    	ftpClient.setControlEncoding("euc-kr");
        String dirToList = parentDir;
        if (!currentDir.equals("")) {
            dirToList += "/" + currentDir;
        }
 
        FTPFile[] subFiles = ftpClient.listFiles(dirToList);
 
        if (subFiles != null && subFiles.length > 0) {
            for (FTPFile aFile : subFiles) {
                String currentFileName = aFile.getName();
                if (currentFileName.equals(".") || currentFileName.equals("..")) {
                    // skip parent directory and the directory itself
                    continue;
                }
                String filePath = parentDir + "/" + currentDir + "/"
                        + currentFileName;
                if (currentDir.equals("")) {
                    filePath = parentDir + "/" + currentFileName;
                }
 
                if (aFile.isDirectory()) {
                    // remove the sub directory
                    removeDirectory(ftpClient, dirToList, currentFileName);
                } else {
                    // delete the file
                    boolean deleted = ftpClient.deleteFile(filePath);
                    if (deleted) {
                        System.out.println("DELETED the file: " + filePath);
                    } else {
                        System.out.println("CANNOT delete the file: "
                                + filePath);
                    }
                }
            }
 
            // finally, remove the directory itself
            boolean removed = ftpClient.removeDirectory(dirToList);
            if (removed) {
                System.out.println("REMOVED the directory: " + dirToList);
            } else {
                System.out.println("CANNOT remove the directory: " + dirToList);
            }
        }
    }
	%>
</body>

</html>
