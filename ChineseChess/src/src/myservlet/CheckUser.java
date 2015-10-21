package src.myservlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import src.com.tools.UseSQL;
import src.com.tools.UserBean;

/**
 * Servlet implementation class CheckUser
 */
public class CheckUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
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
		HttpSession session=request.getSession(true);//默认在服务器的存储时间是30min
		String username=request.getParameter("username");
		String password=request.getParameter("password");
		session.setAttribute("username", username);
//		System.out.println("username："+username);
//		System.out.println("password："+password);
		UseSQL sql=new UseSQL();
		int choose=sql.checkuser(username, password);
//		System.out.println("choose："+choose);
		if(choose==1){//管理员
			//获得用户数据
			int pagecount=sql.PageCount();
			ArrayList<UserBean> list=sql.GetArrayList(1);//因为是第一页所以当前页就是1加载用户列表
			request.setAttribute("user_list", list);
			request.setAttribute("pagecount", pagecount+"");
			request.setAttribute("pagenow", "1");
			request.setAttribute("username", username);
			request.getRequestDispatcher("admin_succeed.jsp").forward(request, response);
		}else if(choose ==-1){//没有这个用户
			request.setAttribute("name", username);
			request.setAttribute("password",password);
			request.setAttribute("error", "1");
			request.getRequestDispatcher("First.jsp").forward(request, response);
		}else if(choose==-2){//密码错误
			request.setAttribute("name", username);
			request.setAttribute("password",password);
			request.setAttribute("error", "0");
			request.getRequestDispatcher("First.jsp").forward(request, response);
		}else{//普通用户
			//加载好友列表
			sql.changestate(choose,1);
			ArrayList<String> list=sql.GetFriendList(choose);
			request.setAttribute("friend_list", list);
			request.setAttribute("user_id", choose+"");
			session.setAttribute("user_id", choose+"");
			request.getRequestDispatcher("login_game.jsp").forward(request, response);
		}
	}

}
