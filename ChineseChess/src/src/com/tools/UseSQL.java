package src.com.tools;
import java.io.Console;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;



public class UseSQL {
	private Connection connection;
	private ResultSet result;
	private Statement statement;
	private int pagesize=5;//每一页的数据量
//	计算需要分的页数
	public int PageCount(){
		  int pagecount=0;//分页的总数
		  int rowcount=0;//数据库的信息总数
		try {
			  ConnectMysql mysql=new ConnectMysql();
			  connection=mysql.ConSQL();
              statement=connection.createStatement();
              String sql="select count(*) from user ";
			  result=statement.executeQuery(sql);
			  if(result.next()){
			    rowcount=result.getInt(1);
			  }
			  //计算一共有多少页
			  if(rowcount%pagesize==0){
				  pagecount=rowcount/pagesize;
			  }else{
				  pagecount=rowcount/pagesize+1;
			  }
			  
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			this.close();
		}
		return pagecount;
	}
//    用于分页的用户管理操作
	public ArrayList<UserBean> GetArrayList (int pagenow){
		ArrayList<UserBean> list=new ArrayList<UserBean>();
		  try {
			  ConnectMysql mysql=new ConnectMysql();
			  connection=mysql.ConSQL();
				  
			  statement =connection.createStatement();
				  
			  String sql="select * from user limit "
				  +pagesize*(pagenow-1)+","+pagesize;
			      
				  result=statement.executeQuery(sql);
		     while(result.next()){
		    	 UserBean bean=new UserBean();
		    	 bean.setUser_id(result.getInt(1));
		    	 bean.setUser_name(result.getString(2));
		    	 bean.setPassword(result.getString(3));
		    	 bean.setState(result.getInt(4));
		    	 
		    	 list.add(bean);
		     }
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
			this.close();
		}
		  
		  return list;
	}
	/*返回的值代表不同的对象
	1：超级用户
	-1：登陆失败，不存在用户
	-2：登陆失败，密码错误
	其它的数字就是返回的当前用户的id*/
	public int checkuser(String username,String password){
		int ok=0;
		ConnectMysql mysql=new ConnectMysql();
		connection=mysql.ConSQL();
		try {
			statement = connection.createStatement();
			int id=0;
			String sql="select password,id from user where name='"+username+"'";
			result=statement.executeQuery(sql);
			  if(result.next()){
				  id=result.getInt(2);
				  if(result.getString(1).equals(password)){
					  if(id==1){
						  ok=1;
					  }else{
						  ok=id;
					  }
				  }else{//密码错误
					      ok=-2;
				  }
			  }else{
				  //不存在用户
				  ok=-1;
			  }
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			this.close();
		}
		return ok;
	}
//	注册新的用户
	public int newUser(String username,String password){
		int flag=0;
		try {
			  connection=new ConnectMysql().ConSQL();
			  statement=connection.createStatement();
			  //判断是否用户名重复
			  String sql="select name from user where name='"+username+"'";
			  result=statement.executeQuery(sql);
			  if(result.next()){
				  flag=-1;
				  return flag;
			  }
			  sql="insert into user (name,password,state,player_id) values(?,?,?,?)";//注册完成就进入游戏，所以当前是在线状态
			  PreparedStatement statement1=connection.prepareStatement(sql);
			  statement1.setString(1, username);
			  statement1.setString(2, password);
			  statement1.setInt(3, 1);
			  statement1.setInt(4, -1);
			  flag=statement1.executeUpdate();  //executeUpdate返回的是更新的条数
			  System.out.println("flag is "+flag);
			  if(statement1!=null){
				  statement1.close();
				  statement1=null;
			  }
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			this.close();
		}
		return flag;
	}
//	根据用户的id获得用户的名字
	public String getName(int id){
		String name="";
		try {
			connection=new ConnectMysql().ConSQL();
			statement=connection.createStatement();
			String sql="select name from user where id ='"+id+"'";
			result=statement.executeQuery(sql);
			if(result.next()){
				name=result.getString(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
			this.close();
		}
		return name;
	}
//	根据用户的名字获得用户的id
	public int getId(String name){
		int id=0;
		try {
			connection=new ConnectMysql().ConSQL();
			statement=connection.createStatement();
			String sql="select id from user where name ='"+name+"'";
			result=statement.executeQuery(sql);
			if(result.next()){
				id=result.getInt(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
			this.close();
		}
		return id;
	}
	
	public ArrayList<String> GetFriendList(int user_id){
		ArrayList<Integer> list_id=new ArrayList<Integer>();
		ArrayList<String> list=new ArrayList<String>();
		try {
			ConnectMysql mysql=new ConnectMysql();
			connection=mysql.ConSQL();
			statement=connection.createStatement();
			String sql="select friend_id from friend where user='"+user_id+"'";
			result=statement.executeQuery(sql);
			while(result.next()){
				int id=result.getInt(1);
				list_id.add(id);
			}
//		   System.out.println(list_id.size());
		   for(int i=0;i<list_id.size();i++){
			   int id=list_id.get(i);
			   String name=getName(id);
//			   System.out.println(name);
			   list.add(name);
		   }
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			this.close();
		}
		return list;
	}
	//改变当前用户的状态
	public void changestate(int id,int state){
		try {
			ConnectMysql mysql=new ConnectMysql();
			connection=mysql.ConSQL();
			statement=connection.createStatement();
			String sql="update user set state="+state+" where id='"+id+"'";
			int flag=statement.executeUpdate(sql);
			if(flag==0){//失败
				
			}else{//成功
				
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			this.close();
		}
	}
	public void friendchangestate(int id,int state){
		try {
			ConnectMysql mysql=new ConnectMysql();
			connection=mysql.ConSQL();
			statement=connection.createStatement();
			String sql="update user set state="+state+" where id='"+id+"'";
			statement.executeUpdate(sql);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
	public int searchplayer(int id){
		int player_id=0;
		try {
			boolean flag=false;//用于表示当前用户是对方的servlet先找到对手
			boolean goon=true;//用于控制循环
			ConnectMysql mysql=new ConnectMysql();
			connection=mysql.ConSQL();
			statement=connection.createStatement();
			String check_user="Select state from user where id= '"+id+"'";
			String search_user="Select id from user where state= '2'";
			result=statement.executeQuery(check_user);
			Statement search=connection.createStatement();
			ResultSet user;
			while(result.next()){
				if(result.getInt(1)==2){//当前用户正在匹配
					user=search.executeQuery(search_user);
					while(user.next()){
						if(user.getInt(1)!=id){//找到匹配用户并且更改信息
							//System.out.println(id+" is first find!");
							player_id=user.getInt(1);
							friendchangestate(id, 3);//改变当前寻找的状态
							friendchangestate(player_id, 3);
							String s_update="update user set player_id=? where id=?";
							PreparedStatement pre=connection.prepareStatement(s_update);
							pre.setInt(1, player_id);
							pre.setInt(2, id);
							pre.executeUpdate();
							pre.close();
							flag=false;
							goon=false;
							user.close();
							user=null;
							break;
//							System.out.println("got it");
						}
					}
				}else if(result.getInt(1)==3){//当前用户完成匹配
					flag=true;
					goon=false;
				}
				if(goon){
					result=statement.executeQuery(check_user);
				}
			}
			search.close();
			search=null;
			if(flag){
				//System.out.println(id+" is second find!");
				search_user="Select id from user where player_id= '"+id+"'";
				result=statement.executeQuery(search_user);
				goon=true;
				while(goon){
						if(result.next()){
							player_id=result.getInt(1);
							//System.out.println("sec_id  is "+player_id);
							//更新数据库信息
							connection=mysql.ConSQL();
							String s_update="update user set player_id=? where id=?";
							PreparedStatement pre=connection.prepareStatement(s_update);
							pre.setInt(1, player_id);
							pre.setInt(2, id);
							pre.executeUpdate();
							pre.close();
							goon=false;
						}else{
							result=statement.executeQuery(search_user);
						}
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			this.close();
		}
		return player_id;
	}
//	关闭当前打开的资源
	private void close(){
        	try {
        		if(result!=null){
				result.close();
				result=null;
        		}
				if(statement!=null){
		        	statement.close();
		        	statement=null;
		        }
		        if(connection!=null){
		        	connection.close();
		        	connection=null;
		        }
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	
	public void createnewtable(String room){
		try {
			ConnectMysql mysql=new ConnectMysql();
			connection=mysql.ConSQL();
			statement=connection.createStatement();
			//新建一个表
			String sql="create table "+room+" ( id  INT NOT NULL AUTO_INCREMENT, qizi_id INT NOT NULL DEFAULT 0,x  INT NOT NULL DEFAULT 0, y  INT NOT NULL DEFAULT 0 ,player_id  INT NOT NULL DEFAULT 0 ,chat  VARCHAR(50) NOT NULL DEFAULT 'fuck',PRIMARY KEY (id))";
			int result=statement.executeUpdate(sql);
			//插入初始化元素
			connection.setAutoCommit(false);
			String insert="insert into "+room+" (qizi_id,x, y) values (?,?,?)";
		    PreparedStatement pre=connection.prepareStatement(insert);
		    //最后一个用于记录那个棋子发生了移动
		    pre.setInt(1,-1);
		    pre.setInt(2,-1);
		    pre.setInt(3, -1);
		    pre.addBatch();
		    //用于处理聊天的信息
		    pre.setInt(1,-1);
		    pre.setInt(2,-1);
		    pre.setInt(3, -1);
		    pre.addBatch();
            //用于处理好友邀请的信息
		    pre.setInt(1,-1);
		    pre.setInt(2,-1);
		    pre.setInt(3, -1);
		    pre.addBatch();
		    pre.executeBatch();
		    connection.commit();
		    pre.close();
		    pre=null;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			this.close();
		}
	}
	//改变棋子的位置
	public int changeqiziposition(String name,int id, int x,int y){
		int flag=0;
		try {
			ConnectMysql mysql=new ConnectMysql();
			connection=mysql.ConSQL();
			String sql="update "+name+" set qizi_id=?,x=?,y=? where id='1'";
			PreparedStatement pre=connection.prepareStatement(sql);
			pre.setInt(1, id);
			pre.setInt(2, x);
			pre.setInt(3, y);
			flag=pre.executeUpdate();
			pre.close();
			pre=null;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			this.close();
		}
		return flag;
	}
	//获得棋子的新位置
		public String getnewposition(String name){
			String newposition="hehe";
			try {
				ConnectMysql mysql=new ConnectMysql();
				connection=mysql.ConSQL();
				String sql="select qizi_id,x,y from "+name+" where id= '1'";
				statement=connection.createStatement();
				result=statement.executeQuery(sql);
				if(result.next()){
					newposition=result.getInt(1)+","+result.getInt(2)+","+result.getInt(3);
				}
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
				newposition="none";
				return newposition;
			}finally{
				this.close();
			}
			return newposition;
		}
		
		//改变新的对话
		public int changechat(String name,String chat,int player_id){
			int flag=0;
			try {
				ConnectMysql mysql=new ConnectMysql();
				connection=mysql.ConSQL();
				String sql="update "+name+" set chat=?,player_id=? where id='2'";
				PreparedStatement pre=connection.prepareStatement(sql);
				pre.setString(1, chat);
				pre.setInt(2,player_id);
				flag=pre.executeUpdate();
				pre.close();
				pre=null;
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
				flag=-1;
				return flag;
			}finally{
				this.close();
			}
			return flag;
		}
		//获得新对话
			public String getnewchat(String name){
				String newchat="";
				try {
					ConnectMysql mysql=new ConnectMysql();
					connection=mysql.ConSQL();
					String sql="select player_id,chat from "+name+" where id = '2'";
					statement=connection.createStatement();
					result=statement.executeQuery(sql);
					if(result.next()){
						newchat=result.getInt(1)+","+result.getString(2);
					} 
				  } catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}finally{
					this.close();
				}
				return newchat;
			}
			
			//获得新的好友邀请
			public int getnewfriends(String name){
				int newchat=-1;
				try {
					ConnectMysql mysql=new ConnectMysql();
					connection=mysql.ConSQL();
					String sql="select player_id from "+name+" where id = '3'";
					statement=connection.createStatement();
					result=statement.executeQuery(sql);
					if(result.next()){
						newchat=result.getInt(1);
					} 
				  } catch (Exception e) {
					// TODO: handle exception
					 e.printStackTrace();
					 return 404;
				}finally{
					this.close();
				}
				return newchat;
			}
			//获得对手的id
			public int getfriends(int user){
				int play=-1;
				try {
					ConnectMysql mysql=new ConnectMysql();
					connection=mysql.ConSQL();
					String sql="select player_id from user where id='"+user+"'";
					statement=connection.createStatement();
					result=statement.executeQuery(sql);
					if(result.next()){
						play=result.getInt(1);
					} 
				  } catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}finally{
					this.close();
				}
				return play;
			}
			//检查当前的好友是否已经是好友
			public int checkfriends(int user,int player){
				int newchat=-1;
				try {
					ConnectMysql mysql=new ConnectMysql();
					connection=mysql.ConSQL();
					String sql="select num_id from friend where user='"+user+"' and friend_id='"+player+"'";
					statement=connection.createStatement();
					result=statement.executeQuery(sql);
					if(result.next()){
						newchat=1;
					} 
				  } catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}finally{
					this.close();
				}
				return newchat;
			}
			//发出新的好友邀请
			public int invitenewfriends(String name,int player_id){
				int flag=0;
				try {
					ConnectMysql mysql=new ConnectMysql();
					connection=mysql.ConSQL();
					String sql="update "+name+" set player_id=? where id='3'";
					PreparedStatement pre=connection.prepareStatement(sql);
					pre.setInt(1, player_id);
					flag=pre.executeUpdate();
					pre.close();
					pre=null;
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
					flag=-1;
					return flag;
				}finally{
					this.close();
				}
				return flag;
			}
			//存在好友
			public int exitnewfriends(String name){
				int flag=0;
				try {
					ConnectMysql mysql=new ConnectMysql();
					connection=mysql.ConSQL();
					String sql="update "+name+" set qizi_id=? where id='3'";
					PreparedStatement pre=connection.prepareStatement(sql);
					pre.setInt(1, 2333);
					flag=pre.executeUpdate();
					pre.close();
					pre=null;
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
					flag=-1;
					return flag;
				}finally{
					this.close();
				}
				return flag;
			}
			//检查新的好友邀请
			public int checknewfriends(String name){
				int newchat=-1;
				try {
					ConnectMysql mysql=new ConnectMysql();
					connection=mysql.ConSQL();
					String sql="select qizi_id from "+name+" where id = '3'";
					statement=connection.createStatement();
					result=statement.executeQuery(sql);
					if(result.next()){
						newchat=result.getInt(1);
					} 
				  } catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}finally{
					this.close();
				}
				return newchat;
			}
			
			//同意新的好友邀请
			public int agreenewfriends(String name,int player_id){
				int flag=0;
				try {
					ConnectMysql mysql=new ConnectMysql();
					connection=mysql.ConSQL();
					String sle="select player_id from "+name+" where id = '3'";
					statement=connection.createStatement();
					result=statement.executeQuery(sle);
					int user=player_id;
					int player=0;
					if(result.next()){
						player=result.getInt(1);
					} 
					String sql="update "+name+" set qizi_id=?,player_id=? where id='3'";
					PreparedStatement pre=connection.prepareStatement(sql);
					pre.setInt(1, player_id);
					pre.setInt(2, -1);
					flag=pre.executeUpdate();
					pre.close();
					pre=null;
					newfriend(user, player);
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
					flag=-1;
					return flag;
				}finally{
					this.close();
				}
				return flag;
			}
			//拒绝同意新的好友邀请
			public int refusenewfriends(String name){
				int flag=0;
				try {
					ConnectMysql mysql=new ConnectMysql();
					connection=mysql.ConSQL();
					String sql="update "+name+" set qizi_id=?,player_id=? where id='3'";
					PreparedStatement pre=connection.prepareStatement(sql);
					pre.setInt(1, -2);
					pre.setInt(2, 0);
					flag=pre.executeUpdate();
					pre.close();
					pre=null;
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
					flag=-1;
					return flag;
				}finally{
					this.close();
				}
				return flag;
			}
			
		public void deletetable(String name){
			try {
				ConnectMysql mysql=new ConnectMysql();
				connection=mysql.ConSQL();
				String sql="drop table if exists "+name;
				statement=connection.createStatement();
				statement.execute(sql);
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}finally{
				this.close();
			}
		}
		public void deletefriend(String user_name,String player_name){
			try {
				ConnectMysql mysql=new ConnectMysql();
				connection=mysql.ConSQL();
				int user_id=getId(user_name);
				int player_id=getId(player_name);
				String sql="delete from friend where user='"+user_id+"'";
				statement=connection.createStatement();
				result=statement.executeQuery(sql);
				sql="delete from friend where user='"+player_id+"'";
				result=statement.executeQuery(sql);
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}finally{
				this.close();
			}
		}
		public void newfriend(int user_id,int player_id){
			try {
				ConnectMysql mysql=new ConnectMysql();
				connection=mysql.ConSQL();
				String insert="insert into friend (user,friend_id) values (?,?)";
			    PreparedStatement pre=connection.prepareStatement(insert);
			    pre.setInt(1,user_id);
			    pre.setInt(2,player_id);
			    pre.addBatch();
			    pre.setInt(1,player_id);
			    pre.setInt(2,user_id);
			    pre.addBatch();
			    pre.executeBatch();
			    pre.close();
			    pre=null;
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}finally{
				this.close();
			}
		}
		public int getinvitefriend(String username){
			int player_id=-1;
			try {
				ConnectMysql mysql=new ConnectMysql();
				connection=mysql.ConSQL();
				String sql="select player_id from user where name='"+username+"'";
				statement=connection.createStatement();
				result=statement.executeQuery(sql);
				if(result.next()){
					player_id=result.getInt(1);
				}
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}finally{
				this.close();
			}
			return player_id;
		}
		
		public void updateplayer_id(int  u_id,int p_id){
			try {
				ConnectMysql mysql=new ConnectMysql();
				connection=mysql.ConSQL();
				System.out.println("uid is "+u_id);
				System.out.println("pid is "+p_id);
				String s_update="update user set player_id=? where id=?";
				PreparedStatement pre=connection.prepareStatement(s_update);
				pre.setInt(1, p_id);
				pre.setInt(2, u_id);
				pre.executeUpdate();
				pre.close();
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}finally{
				this.close();
			}
		}
		
}
