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
 * Servlet implementation class BeforePlay
 */
public class BeforePlay extends HttpServlet {
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
		String method =request.getParameter("method");
		String player_name=request.getParameter("player");
		HttpSession session=request.getSession(true);
		String user_name=(String)session.getAttribute("username");
		UseSQL sql=new UseSQL();
		System.out.println("��ǰ�������ǣ�"+method);
		System.out.println("player_name�ǣ�"+player_name);
		System.out.println("user_name�ǣ�"+user_name);
		switch(method){
		case "1"://�ȴ�������Ϣ���ж϶Է���player_id�Ƿ����Լ���id
			int r_id=sql.getinvitefriend(user_name);
			int m_id=sql.getId(player_name);
			if(r_id==m_id){//�Է�ͬ��
							int red=0;
							int room;
							int player_id=sql.getId(user_name);
							int id=sql.getId(player_name);
							sql.updateplayer_id(id, player_id);
							if(player_id>id){//id��
								red=1;
								room=player_id;
							}else{//id��
								red=0;
								room=id;
							}
							if(red==1){//�췽�������䣨���ݿ⣩
								sql.createnewtable("_"+room);
							}
							session.setAttribute("first", red+"");
							session.setAttribute("playername", player_name);
							session.setAttribute("table_name", "_"+room);
							System.out.println("user_id is "+id);
							System.out.println("first is "+red);
							PrintWriter out=response.getWriter();
							out.write("okay");
							out.flush();
							out.close();
			}else if(r_id==-2){//�Է���ͬ��
							PrintWriter out=response.getWriter();
							out.write("cancel");
							out.flush();
							out.close();
			}else{
							PrintWriter out=response.getWriter();
							out.write("none");
							out.flush();
							out.close();
			}
			break;
		case "2"://�������
			int u_id=sql.getId(user_name);
			int p_id=sql.getId(player_name);
			sql.updateplayer_id(p_id, u_id);
			break;
		case "3"://ɾ������
			sql.deletefriend(user_name, player_name);
			break;
		case "4"://ͬ�������Ϸ����
			int red=0;
			int room;
			int player_id=sql.getId(user_name);
			int id=sql.getId(player_name);
			sql.updateplayer_id(id, player_id);
			if(player_id>id){//id��
				red=1;
				room=player_id;
			}else{//id��
				red=0;
				room=id;
			}
			if(red==1){//�췽�������䣨���ݿ⣩
				sql.createnewtable("_"+room);
			}
			session.setAttribute("first", red+"");
			session.setAttribute("playername", player_name);
			session.setAttribute("table_name", "_"+room);
			System.out.println("user_id is "+id);
			System.out.println("first is "+red);
			PrintWriter out=response.getWriter();
			out.write("okay");
			out.flush();
			out.close();
			break;
		case "5"://�ܾ�����
			int i_id=sql.getId(user_name);
			int y_id=sql.getId(player_name);
			sql.updateplayer_id(i_id, -1);//���Լ��Ķ���״̬����Ϊ��ʼֵ
			sql.updateplayer_id(y_id, -2);//�������ߵĶ���״̬����Ϊ-2Ҳ�ʹ���ܾ�����
			break;
		case "6"://���ܾ�������Լ��Ķ���״̬
			int _id=sql.getId(user_name);
			sql.updateplayer_id(_id, -1);//���Լ��Ķ���״̬����Ϊ��ʼֵ
			break;
		}
	}

}
