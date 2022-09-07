<!--
서동학: 전체적인 코딩, FTP
김영원: FTP
-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.StudyboardDAO"%>
<%@ page import="file.FileDAO"%>
<%@ page import="map.CountsDAO"%>
<%@ page import="map.ItemDAO"%>
<%@ page import="map.LineDAO"%>
<%@ page import="map.PublicmapDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="org.apache.commons.net.ftp.*"%>
<%@ page import="java.io.*" %>
<%request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>회원탈퇴</title>
</head>

<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
		System.out.println(userID);
	}
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인된 상태가 아닙니다.')");
		script.println("location.href = 'home.jsp'");
		script.println("</script>");
	} else {
		UserDAO userDAO = new UserDAO();
		int result = userDAO.delete(userID);
		if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('실패했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
			// 유저와 관련된 모든 db 삭제
			
			BbsDAO bbsDAO = new BbsDAO();
			bbsDAO.deleteUser(userID);

			StudyboardDAO studyboardDAO = new StudyboardDAO();
			studyboardDAO.deleteUser(userID);

			// 유저가 업로드한 파일들도 모두 삭제
			FileDAO fileDAO = new FileDAO();
			fileDAO.deleteUser(userID);

			
			
			
			
			
			
			
			
			
			
			String path = "/www/upload"; // 변경이전 폴더 경로
			FTPClient ftp = null;
			try {
				ftp = new FTPClient();
				ftp.setControlEncoding("UTF-8"); 
				ftp.connect("183.111.138.172"); //"192.168.0.35"
				ftp.login("hjk709914", "tiger123*"); //"MeongDdi", "1234"
				ftp.enterLocalPassiveMode();
				
				ftp.changeWorkingDirectory(path);//파일 가져올 디렉터리 위치
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

				//File f = new File("C:/Users/" + System.getProperty("user.name") + "/Downloads/" + request.getParameter("file"));//로컬에 다운받아 설정할 이름
				//System.out.println(f.getName());
				//FileOutputStream fos = null;
				try {
					//ftp.removeDirectory(itemID);
					removeDirectory(ftp, path, userID);
					
					//fos = new FileOutputStream(f);
					//boolean isSuccess = ftp.retrieveFile(request.getParameter("file"), fos);//ftp서버에 존재하는 해당명의 파일을 다운로드 하여 fos에 데이터를 넣습니다.
					/*if (isSuccess) {
						System.out.println("다운로드를 성공 하였습니다.");
					} else {
						System.out.println("다운로드 실패하여습니다.");
					}
					*/
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
					} catch (IOException e) {
					}
				}
			}
			
			
			
			
			
			
			
			
			

			CountsDAO countsDAO = new CountsDAO();
			countsDAO.deleteCounts(userID);

			ItemDAO itemDAO = new ItemDAO();
			itemDAO.deleteUser(userID);

			LineDAO lineDAO = new LineDAO();
			lineDAO.deleteUser(userID);

			PublicmapDAO publicmapDAO = new PublicmapDAO();
			publicmapDAO.deleteUser(userID);

			session.invalidate();
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'home.jsp'"); // 이전 화면으로 새로고침된 화면 location.href = document.referrer;
			script.println("</script>");
		}

	}
	%>
	
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
