/*
서동학: 전체적인 코딩
*/


package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserIDServlet")
public class UserIDServlet extends HttpServlet {
	// ID 중복체크를 위한 클래스
	
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String userID = request.getParameter("userID");
		response.getWriter().write(getJSON(userID));
	}
	
	// 결과가 JSON 형태로 돌아감
	public String getJSON(String userID) {
		if(userID == null) userID ="";
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		UserDAO userDAO = new UserDAO();
		int resultInt = userDAO.select(userID);
		String resultStr = Integer.toString(resultInt);
		result.append("[{\"value\":\"" + resultInt + "\"}]]}");
		return resultStr;
	}

}
