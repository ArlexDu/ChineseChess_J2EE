package src.myservlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import src.com.tools.Gaming;
import src.com.tools.Qizi;
import src.com.tools.UseSQL;

/**
 * Servlet implementation class GameServlet
 */
public class GameServlet extends HttpServlet {
	//�������Ϊ�˸������ݿ�Ĳ���
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
		//System.out.println("get in ");
		String method=request.getParameter("method");
//		System.out.println("method is "+method);
		UseSQL sql=new UseSQL();
		HttpSession session=request.getSession(true);
		String name=(String)session.getAttribute("table_name");
		switch(method){
		case "1"://�������ӵ�λ��
			String n_p=sql.getnewposition(name);
			if(n_p.equals("none")){//���ݿⲻ���ڵ�ʱ��Ҳ���Ƕ������ر�֮��
				String id=(String)session.getAttribute("user_id");
				int u_id=0;
				if(id!=null){
					u_id=Integer.parseInt(id);
				}
				sql.updateplayer_id(u_id, -1);
			}
			PrintWriter out = response.getWriter();
			out.write(n_p);
			out.flush();
			out.close();
			break;
		case "2"://�ı����ӵ�λ��
			int id=Integer.parseInt((String)request.getParameter("id"));
			int x=Integer.parseInt((String)request.getParameter("x"));
			int y=Integer.parseInt((String)request.getParameter("y"));
			int flag=0;
			while(flag==0){
				flag=sql.changeqiziposition(name, id, x, y);
			}
			break;
		case "3"://�������ݿ�
			String s_id=(String)session.getAttribute("user_id");
			int user_id=0;
			if(s_id!=null){
				user_id=Integer.parseInt(s_id);
			}
			sql.changestate(user_id, 1);//������Ϸ������״̬
			sql.updateplayer_id(user_id, -1);
			sql.deletetable(name);
			break;
			}
	}

}
