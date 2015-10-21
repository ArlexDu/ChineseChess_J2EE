package src.com.tools;
import java.sql.Connection;
import java.sql.DriverManager;


public class ConnectMysql {

	public Connection ConSQL( ){
		  String driver="com.mysql.jdbc.Driver";
		  String url="jdbc:mysql://127.0.0.1:3306/My_test";
		  String user="root";
		  String pw="dsy228850169dfq";
		  Connection sql=null;
		  //加载驱动
		  try {
			 Class.forName(driver);
			 //得到链接
			 sql=DriverManager.getConnection(url,user,pw);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		  return sql;
	}
}
