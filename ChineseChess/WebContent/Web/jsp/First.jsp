<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>楚河汉界</title>
<script language="javascript" src="../js/first.js"></script>
<link href="../css/first.css" rel="stylesheet" type="text/css" />
</head>
<body>
<%
 String error=(String)request.getAttribute("error");
 String name=(String)request.getAttribute("name");
 //name= new String(name.getBytes("iso-8859-1"),"UTF-8");
 String password=request.getParameter("password");
 String error1="";
 String error0="";
 if(name==null&&password==null){
	 name="";
	 password="";
 }
 if(error!=null){

	 if(error.equals("1")){//没有用户名
		 error0="*不存在此用户";
	 }else{//密码错误
		 error1="*密码错误";
	 }
 }
%>
<!--背景图片  -->
<div id="background">
   <img src="../picture/background.jpg" height="100%" width="100%"></img>
</div>
<div id="button">
		<!-- 表单的建立 -->
		<form id="form" method="post" >
			<table >
				<tr>
					<td><img src="../picture/user_name.png" height="20px"/></td>
					<td>
					  <input  type="text" name="username" value="<%=name %>" />
					</td>
					<td id="error1"><!-- 错误提示 -->
					<%=error0 %>
					</td>
				</tr>
				<tr>
				<td>&nbsp;</td>
				</tr>
				<tr>
					<td><img src="../picture/password.png" height="20px"/></td>
					<td>
					  <input  type="password" name="password" value="<%=password %>" />
					</td>
					<td id="error2"><!-- 错误提示 -->
					<%=error1 %>
					</td>
				</tr>
				<tr>
				<td>&nbsp;</td>
				</tr>
			</table>
			<div id="click">
			<input id="login_btn"  type="submit" value="" onclick="return checknull()"/>
		    <input id="register_btn" type="submit" value="" onclick="register()"/>
			</div>
			
		</form>
</div>
</body>
</html>