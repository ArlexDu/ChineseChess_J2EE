<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>注册</title>
<script language="javascript" src="../js/first.js"></script>
<style type="text/css">
#main{
  top: 33%;
  left: 40%;
  width:40%;
  height:35%;
  position: absolute;
  z-index: 1;
}
#end{
  height:33px;
  width:73px;
  left:20px;
  border:none;
  background-repeat:no-repeat;
  background-image: url(../picture/end.png);
  background-color: transparent;
  background-position: center;
  position: absolute;
}
#re{
  height:33px;
  width:73px;
  left:113px;
  border:none;
  background-repeat:no-repeat;
  background-image: url(../picture/reset.png);
  background-color: transparent;
  background-position: center;
  position: absolute;
}
html,body { 
    margin:0;
    height:100%;
    width:100%;
    z-index: 0;
}
#error{
     color: red;
}
#part{
    border:3px;
    border-style:solid;
    border-color:blue;
    height: 25%;
    width: 100%;
}
</style>
</head>
<body>
<div>
<img src="../picture/zc_background.jpg" height="100%" width="100%"/>
</div>
<%
        String error1="";
        String error0="";
        String error=(String)request.getAttribute("error");//用户名重复
        String username=(String)request.getAttribute("username");
        String password=(String)request.getAttribute("password");
        String repassword=(String)request.getAttribute("repassword");
        if(username==null){
        	username="";
        }
        if(password==null){
        	password="";
        }
        if(repassword==null){
        	repassword="";
        }
        if(error!=null){
        	if(error.equals("1")){
            	error1="*用户名已经存在";
            }else if(error.equals("2")){//输入的密码不一致
            	error0="*两次输入的密码不一致";
            }
        }
%>
<div id="main">
 <form id="form" method="post">
			<table>
				<tr>
				<td><img src="../picture/user_name.png" height="25px" width="80px"/></td>
				<td><input type="text" name="username" value="<%=username %>" size="15"/></td>
				<td id="error"><%=error1 %></td>
				</tr>
				<tr>
				<td>
				&nbsp;
				</td>
				</tr>
				<tr>
				<td><img src="../picture/password.png" height="25px" width="80px"/></td>
				<td><input type="password" name="password" value="<%=password %>" size="15" /></td>
				</tr>
				<tr>
				<td>
				&nbsp;
				</td>
				</tr>
				<tr>
				<td><img src="../picture/makesure.png" height="25px" width="80px"/></td>
				<td><input type="password" name="repassword" value="<%=repassword %>" size="15" /></td>
				<td id="error"><%=error0 %></td>
				</tr>
				<tr>
				<td>
				&nbsp;
				</td>
				</tr>
			</table>
		<div>
				<input id="end" type="submit" name="register" value="" onclick=" check_register();"/>
				<input id="re" type="submit" name="reset" value="" onclick="reset();"/>
		</div>
   </form>
</div>
</body>
</html>