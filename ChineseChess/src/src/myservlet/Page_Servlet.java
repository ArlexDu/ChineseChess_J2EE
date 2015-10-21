package src.myservlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import src.com.tools.UseSQL;
import src.com.tools.UserBean;

/**
 * Servlet implementation class Page_Servlet
 */
public class Page_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Page_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("change page");
		UseSQL sql=new UseSQL();
		String s_pagenow=request.getParameter("pagenow");
		int pagenow=1; 
		if(s_pagenow!=null){
			  pagenow=Integer.parseInt(s_pagenow);
		 }
		int pagecount=sql.PageCount();
		ArrayList<UserBean> list=sql.GetArrayList(pagenow);//因为是第一页所以当前页就是1
		request.setAttribute("user_list", list);
		request.setAttribute("pagecount", pagecount+"");
		request.setAttribute("pagenow", pagenow+"");
		request.getRequestDispatcher("admin_succeed.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
