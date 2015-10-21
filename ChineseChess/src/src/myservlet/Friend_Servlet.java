package src.myservlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import src.com.tools.Qizi;
import src.com.tools.UseSQL;

/**
 * Servlet implementation class Friend_Servlet
 */
public class Friend_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		System.out.println("go into game");
		HttpSession session=request.getSession(true);
		String s_id=(String)session.getAttribute("user_id");
		int id=0;
		if(s_id!=null){
			id=Integer.parseInt(s_id);
		}
		UseSQL sql=new UseSQL();
		sql.changestate(id, 2);//进入匹配的状态
		int player_id=sql.searchplayer(id);//进行匹配对手
		int red=0;
		int room;
		if(player_id>id){//id红
			red=1;
			room=player_id;
		}else{//id绿
			red=0;
			room=id;
		}
		if(red==1){//红方建立房间（数据库）
			sql.createnewtable("_"+room);
		}
		String player_name=sql.getName(player_id);
		session.setAttribute("first", red+"");
		session.setAttribute("playername", player_name);
		session.setAttribute("table_name", "_"+room);
		System.out.println("user_id is "+id);
		System.out.println("first is "+red);
		System.out.println("playerid is "+player_id);
		request.getRequestDispatcher("play.jsp").forward(request, response);
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

}
