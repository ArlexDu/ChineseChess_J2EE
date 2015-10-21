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
 * Servlet implementation class ChatServlet
 */
public class ChatServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChatServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String method=request.getParameter("method");
//		System.out.println("method is "+method);
		UseSQL sql=new UseSQL();
		HttpSession session=request.getSession(true);
		String name=(String)session.getAttribute("table_name");
		String username=(String)session.getAttribute("username");
		switch(method){
		case "1"://获得聊天信息
			String newchat=sql.getnewchat(name);
			PrintWriter out = response.getWriter();
			out.write(newchat);
			out.flush();
			out.close();
			break;
        case "2"://上传聊天信息
        	int u_id=sql.getId(username);
        	String chat=(String)request.getParameter("chat");
			int flag=-1;
			while(flag==-1){
				flag=sql.changechat(name, chat, u_id);
			}
			break;
        case "3"://发出好友邀请信息
			int flag1=-1;
			while(flag1==-1){
				flag1=sql.changechat(name, "invite", -100);
			}
			break;
		}
	}

}
