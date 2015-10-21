package src.myservlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import src.com.tools.UseSQL;

/**
 * Servlet implementation class BeforeGame
 */
public class BeforeGame extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String player_name;
		HttpSession session=request.getSession(true);
		String user_name=(String)session.getAttribute("username");
		UseSQL sql=new UseSQL();
		int player_id=sql.getinvitefriend(user_name);
		if(player_id!=-1){
			player_name=sql.getName(player_id);
		}else{
			player_name="none";
		}
		PrintWriter out=response.getWriter();
		out.write(player_name);
		out.flush();
		out.close();
 }
}
