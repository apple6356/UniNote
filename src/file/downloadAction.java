/*
서동학: 전체적인 코딩, FTP
김영원: FTP
*/


package file;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.net.ftp.*;
import java.io.*;

@WebServlet("/downloadAction")
public class downloadAction extends HttpServlet {
	// 파일 다운로드
	// 1. DB 호스팅 서버에서 JSP 호스팅 서버로 파일 다운로드
	// 2. JSP 서버에서 사용자 컴퓨터로 다운로드
	// 3. JSP 호스팅 서버에 남은 다운로드 폴더 삭제
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		FTPClient ftp = null;
		try {
			ftp = new FTPClient();
			ftp.setControlEncoding("UTF-8"); 
			ftp.connect("183.111.138.172");			// 접속할 ip
			ftp.login("hjk709914", "tiger123*"); 	// 접속할 아이디 비밀번호
			ftp.enterLocalPassiveMode();
			System.out.println(request.getParameter("directory"));
			ftp.changeWorkingDirectory("/"+request.getParameter("directory")); // 작업할 디렉토리 설정
			if(ftp.changeWorkingDirectory(request.getParameter("directory"))) {
				System.out.println("FTP diretory set");
			}
			ftp.setFileType(FTP.BINARY_FILE_TYPE);//파일 타입 설정 기본적으로 파일을 전송할떄는 BINARY타입을 사용합니다.
			
			int reply = ftp.getReplyCode();
		    if (!FTPReply.isPositiveCompletion(reply)) {
		    	ftp.disconnect();
		        System.out.println("FTP server refused connection.");    
		    } else {
		    	System.out.println("FTP connected");
		        //System.out.print(ftpClient.getReplyString());
		    }

		    // 디렉토리가 없다면 생성
		    String mapID = request.getParameter("mapID");
		    File mapFile = new File("download/" + request.getParameter("mapID"));
		    if(!mapFile.exists()) {
		    	try{
		    		mapFile.mkdir();
		    	}
		    	catch(Exception e) {
		    		e.printStackTrace();
		    	}
		    }
		    
			File f = new File("download/" + request.getParameter("mapID") + "/" + request.getParameter("file"));//로컬에 다운받아 설정할 이름
			//System.out.println(f.getName());
			FileOutputStream fos = null;
			try {
				fos = new FileOutputStream(f);
				boolean isSuccess = ftp.retrieveFile(request.getParameter("file"), fos);//ftp서버에 존재하는 해당명의 파일을 다운로드 하여 fos에 데이터를 넣습니다.
				if (isSuccess) {
					System.out.println("다운로드를 성공 하였습니다.");
					
					
					// ftp 다운로드 성공시 JSP 서버에서 사용자 컴퓨터로 다운로드
					String fileName = request.getParameter("file");
					System.out.println("fileName : " + fileName);

					// JSP 다운로드 디렉토리 지정
					File file = new File("download/" + mapID + "/" + fileName);

					String mimeType = getServletContext().getMimeType(file.toString());
					if (mimeType == null) {
						response.setContentType("application/octet-stream");
					}

					String downloadName = null;
					// MSIE는 인터넷 익스플로러, 인터넷 익스플로러가 아니라면 URF-8, 8859-1형식으로 인코딩
					if (request.getHeader("user-agent").indexOf("MSIE") == -1) {
						downloadName = java.net.URLEncoder.encode(fileName, "UTF-8");
						// downloadName = new String(fileName.getBytes("UTF-8"), "8859_1");
					} else {
						downloadName = new String(fileName.getBytes("EUC-KR"), "8859_1");
					}

					response.setHeader("Content-Disposition", "attachment;fileName=\"" + downloadName + "\";");

					FileInputStream fileInputStream = new FileInputStream(file);
					ServletOutputStream servletOutputStream = response.getOutputStream();

					byte b[] = new byte[1024];
					int data = 0;

					while ((data = (fileInputStream.read(b, 0, b.length))) != -1) {
						servletOutputStream.write(b, 0, data);
					}

					servletOutputStream.flush();
					servletOutputStream.close();
					fileInputStream.close();

					
					// 다운로드 후 해당 파일 삭제
					file.delete();

				} else {
					System.out.println("다운로드 실패하여습니다.");
				}
			} catch (IOException ex) {
				System.out.println(ex.getMessage());
			} finally {
				if (fos != null)
					try {
						fos.close();
					} catch (IOException ex) {
					}
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

}
