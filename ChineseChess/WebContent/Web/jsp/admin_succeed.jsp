<%@page import="src.com.tools.UserBean"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>楚河汉界</title>
<style type="text/css">
center {
	margin-top: 5%;
}
</style>
</head>
<body>
<center>
<h1>用户管理界面</h1>
<table>
<tr>
<td>id</td><td>&nbsp;</td><td>用户名</td><td>&nbsp;</td><td>密码</td>
</tr>
<%
      int pagenow=Integer.parseInt((String) request.getAttribute("pagenow"));
      ArrayList<UserBean> list= (ArrayList<UserBean>)request.getAttribute("user_list");
      for(int i=0;i<list.size();i++){
    	  UserBean user=new UserBean();
    	  user=list.get(i);
    	  %>
<tr>
<td><%=user.getUser_id() %></td>
<td>&nbsp;</td><td><%=user.getUser_name() %></td>
<td>&nbsp;</td><td><%=user.getPassword() %></td>
<td>&nbsp;<%=user.getState() %></td>
</tr>  
    	  <%
      }
%>
</table>
<%
		int pagecount=Integer.parseInt((String) request.getAttribute("pagecount"));
		if(pagenow>1){
			%>
			<a href="Page_Servlet?pagenow=<%=pagenow-1%>">上一页</a>
			<%
		}
		for(int i=1;i<=pagecount;i++){
			%>
			<a href="Page_Servlet?pagenow=<%=i%>">[<%=i%>]</a>
			<%
		}
		if(pagenow<pagecount){
			%>
			<a href="Page_Servlet?pagenow=<%=pagenow+1%>">下一页</a>
			<%
		}
%>
</center>
</body>
</html>