package src.myservlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import src.com.tools.UseSQL;

/**
 * Servlet implementation class NewUser
 */
public class NewUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NewUser() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		  String username=request.getParameter("username");
	      String password=request.getParameter("password");
	      String repassword=request.getParameter("repassword");
	      System.out.println("username is "+username);
	      System.out.println("password is "+password);
	      if(!password.equals(repassword)){//输入的密码不一致
	    	  request.setAttribute("error", "2");
	    	  request.setAttribute("password", password);
	    	  request.setAttribute("username",username);
	    	  request.setAttribute("repassword",repassword);
	    	  request.getRequestDispatcher("Register.jsp").forward(request, response);
//	    	  response.sendRedirect("Register.jsp?error=2&user="+username+"&password="+password+"&repassword="+repassword);
	      }else{
	    	  UseSQL sql=new UseSQL();
	          int flag=sql.newUser(username, password);
	    	  if(flag==0){//添加失败
	    		  
	    	  }else if(flag==-1){//用户名已经存在
	    		  request.setAttribute("error", "1");
		    	  request.setAttribute("password", password);
		    	  request.setAttribute("username",username);
		    	  request.getRequestDispatcher("Register.jsp").forward(request, response);
//	    		  response.sendRedirect("Register.jsp?error=1&user="+username+"&password="+password+"&repassword="+repassword);
	    	  }else{
	    		  response.sendRedirect("login_game.jsp");
	    	  }
	      }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
