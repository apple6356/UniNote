<!--
서동학: 전체적인 코딩
-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="map.NoteDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>노트 액션</title>
</head>
<body>
	<%
	String userID = request.getParameter("userID");
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'home.jsp'");
		script.println("</script>");
	} else {
		NoteDAO noteDAO = new NoteDAO();
		String noteType = request.getParameter("noteType");
		
		// 아이템이 생성될 때 노트 생성
		if (noteType.equals("insert")) {
			String itemID = request.getParameter("noteItemID");
			int result = noteDAO.createNote(userID, itemID);
			
			if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('실패했습니다.')");
				script.println("</script>");
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("history.back()");
				script.println("</script>");
			}
		}

		// 노트에 내용 작성시 내용 저장
		if (noteType.equals("update")) {
			String itemID = request.getParameter("noteItemID");
			String noteContent = request.getParameter("noteContent");
			noteDAO.updateNote(noteContent, userID, itemID);

			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("history.back()");
			script.println("</script>");
		}

		// 아이템 삭제시 노트도 함께 삭제
		if (noteType.equals("delete")) {
			String itemID = request.getParameter("noteItemID");
			System.out.println("userID : " + userID + ", itemID : " + itemID + ", noteType : " + noteType);
			noteDAO.deleteNote(userID, itemID);
			System.out.println("deleteNote");

			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("history.back()");
			script.println("</script>");
		}

		// 아이템 상위요소 교체 시 노트의 db도 함께 변경
		if (noteType.equals("change")) {
			String noteChangeStr = request.getParameter("noteItemID");
			StringTokenizer st = new StringTokenizer(noteChangeStr, "/");
			String oldItemID = st.nextToken();
			String newItemID = st.nextToken();
			System.out.println("oldItemID : " + oldItemID + ", newItemID : " + newItemID + ", noteType : " + noteType);
			noteDAO.updateChange(userID, oldItemID, newItemID);
			System.out.println("updateChange");

			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("history.back()");
			script.println("</script>");
		}
	}
	%>
</body>
</html>