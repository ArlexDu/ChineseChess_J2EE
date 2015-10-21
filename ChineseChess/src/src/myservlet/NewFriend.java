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
 * Servlet implementation class NewFriend
 */
public class NewFriend extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NewFriend() {
        super();
        // TODO Auto-generated constructor stub
    }

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
		String method=request.getParameter("method");
//		System.out.println("method is "+method);
		UseSQL sql=new UseSQL();
		HttpSession session=request.getSession(true);
		String username=(String)session.getAttribute("username");
		String name=(String)session.getAttribute("table_name");
		switch(method){
		case "1"://获得好友邀请
			int friends=sql.getnewfriends(name);
			PrintWriter out = response.getWriter();
			if(friends==0){//收到新的好友邀请
				out.write("0");
			}else if(friends==404){//数据库不存在
				out.write("404");
			}else{
				String p_name=sql.getName(friends);
				if(!p_name.equals(username)){
					out.write(p_name);
				}else{
					out.write("0");
				}
			}
			out.flush();
			out.close();
			break;
        case "2"://发出好友邀请
        	//判断当前邀请是否是好友
        	int u=sql.getId(username);
        	int player_id=sql.getfriends(u);
        	int c=sql.checkfriends(u,player_id);
        	if(c==1){//已经存在好友
        		sql.exitnewfriends(name);
        	}else{
            	int flag=-1;
    			while(flag==-1){
    				flag=sql.invitenewfriends(name, u);
    			}
        	}
			break;
        case "3"://是否成功
        	int check=sql.checknewfriends(name);
        	PrintWriter o = response.getWriter();
        	System.out.println("check is "+check);
        	if(check==-2){//失败
        		o.write("refused");
			}else if(check==-1){//没有响应
				o.write("0");
			}else if(check==2333){//已经存在好友
				o.write("2333");
			}else{
				//String p_name=sql.getName(check);
				o.write("ok");
			}
			o.flush();
			o.close();
        	break;
        case "4"://同意成为好友
        	int p=sql.getId(username);
        	sql.agreenewfriends(name,p);
        	
        	break;
        case "5"://拒绝同意成为好友
        	int f=-1;
        	while(f==-1){
        		f=sql.refusenewfriends(name);
        	}
        	break;
		}
	}

}
