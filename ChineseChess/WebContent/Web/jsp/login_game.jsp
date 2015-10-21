<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="renderer" content="ie-comp"><!--兼容模式打开  -->
<title>楚河汉界</title>
<link href="../css/play.css" rel="stylesheet" type="text/css" />
<style type="text/css">
html,body {
    margin:0;
	height: 100%;
	width: 100%;
}
#background{							/* 背景的设置 */
	    height: 100%;
		width: 100%;
		z-index: 0;
}
#center{
    width: 54%;
    height: 46%;
    top: 25%;
    left: 23%;
    position: absolute;  
    z-index: 1;
}
#left{
   top:0px;
   left:0px;
   margin-left: 0px;
   height: 100%;
   width: 30%;
   position: absolute;
}
#middle{
   top:0px;
   left:30%;
   margin-left: 0px;
   height: 100%;
   width: 40%;
   position: absolute;
}
#right{
   top:0px;
   left:70%;
   margin-left: 0px;
   height: 100%;
   width: 30%;
   position: absolute;
}
#friend{/* 控制好友列表的位置 */
    margin-left: 30%;
    height: 90%;
    overflow-y: auto;
    scrollbar-arrow-color: #f4ae21; 
	scrollbar-face-color: #333; 
	scrollbar-3dlight-color: #d9c8ac; 
	scrollbar-highlight-color:#d9c8ac; 
	scrollbar-shadow-color: #999; 
	scrollbar-darkshadow-color: #d9c8ac; 
	scrollbar-track-color: #d9c8ac;
}
#each{
  font-size: medium;
  font-weight: bold; 
}
#play_p{
  height:35px;
  width: 70px;
  margin-left: 15px;
  margin-top:20px;  

}
#delete_p{
  height:35px;
  width: 70px;
  margin-left: 15px;
  margin-top:20px; 

}
</style>	
<script language="javascript">
var player_name="";
var loop=true;
var invite=false;
var xmlhttp;
var see=false;
var method=-1;
/* window.onbeforeunload=function(){
	return confirm("你确定要离开？");
} */
function init(){
	if (window.XMLHttpRequest)
	   {// code for IE7+, Firefox, Chrome, Opera, Safari
	   xmlhttp=new XMLHttpRequest();
	   }
	 else
	   {// code for IE6, IE5
	   xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	   }
	hidemenu();
	getdata();
	hidedialog();
}
//每隔一秒获取数据
function getdata(){
	 if(loop){
	   console.log("get new data");
	   xmlhttp.onreadystatechange=data;
	   // console.log("GameServlet?method=2&id="+t_id+"&x="+currentx+"&y="+currenty);
	   xmlhttp.open("POST","BeforeGame",true);
	   xmlhttp.send();
	   setTimeout(getdata,2000);
	   }
}
function data(){//用于获得好友约战
	 if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
		 var player=xmlhttp.responseText;
		 console.log("player is "+player);
		 if(player!="none"){
			 method=1;
			 player_name=player;
			 showdialog(player);
		 }
	    }
}

function agree(){
	if(method==1){//来自好友邀请
		 loop=false;
		 playwithfriend(4);
	}else if(method==2){//删除好友
		 console.log("delete");
		 playwithfriend(3); 
	}else if (method==3){//收到不玩通知
		 console.log("被拒绝了。。。");
		 playwithfriend(6); 
	}
	hidedialog();
}

function cancel(){
	if(method==1){//来自好友邀请
		 playwithfriend(5);
	}else if(method==2){//删除好友
		 console.log("giveup delete");
	}
	hidedialog();
}
function showdialog(player_name){
	var height=document.documentElement.clientHeight;
	var width=document.documentElement.clientWidth;
	//黑色背景
    var object=document.getElementById("black_bg");
	object.style.height=height+"px";
	object.style.width=width+"px"; 
	object.style.left=0+"px";
	object.style.top=0+"px";
	object.style.display="block";
	object.style.position="absolute";
	
	var object=document.getElementById("dialog");
	object.style.height=height*0.25+"px";
	object.style.width=width*0.2+"px";
	object.style.left=width*0.8/2+"px";
	object.style.top=height*0.75/2+"px";
	object.style.maxWidth=width+"px";
	object.style.display="block";
	
	var object=document.getElementById("text");
	object.style.left=width*0.8/2+width*0.2*0.15+"px";
	object.style.top=height*0.75/2+height*0.25*0.3+"px";
	object.style.maxWidth=width*0.2*0.8+"px";
	object.style.display="block";
	if(method==1){//好友邀请
		object.innerHTML=player_name+"邀请您战一组!";
	}else if(method==2){//删除提示
		object.innerHTML="你确定要删除好友"+player_name+"吗？";
	}else{//拒绝邀请
		object.innerHTML=player_name+"不想和你刚!";
	}
	
	var object=document.getElementById("yes");
	object.style.height=height*0.25*0.2+"px";
	object.style.width=width*0.2*0.3+"px";
	object.style.left=width*0.8/2+width*0.2*0.15+"px";
	object.style.top=height*0.75/2+height*0.25*0.8+"px";
	object.style.display="block";
	if(method==1){
		
	}else if(method==2){//删除提示
		object.value="确认";
	
	}else if(method==3){//拒绝邀请
		object.style.width=width*0.2*0.4+"px";
		object.style.left=width*0.8/2+width*0.2*0.3+"px";
		object.value="我知道了";
	}

	var object=document.getElementById("no");
	object.style.height=height*0.25*0.2+"px";
	object.style.width=width*0.2*0.3+"px";
	object.style.right=width*0.8/2+width*0.2*0.15+"px";
	object.style.top=height*0.75/2+height*0.25*0.8+"px";
	object.style.display="block";
	if(method==1){
		
	}else if(method==2){//删除提示
		object.value="取消";
	}else if(method==3){
		object.style.display="none";
	}
}

function hidedialog(){
	//黑色背景
    var object=document.getElementById("black_bg");
	object.style.display="none";
	
	var object=document.getElementById("dialog");
	object.style.display="none";
	
	var object=document.getElementById("text");
	object.style.display="none";
	
	var object=document.getElementById("yes");
	object.style.display="none";

	var object=document.getElementById("no");
	object.style.display="none";
}
function playwithfriend(way){//用于发送邀请
	   if(way==2){//邀请
		   xmlhttp.onreadystatechange=callback;
	   }else if(way==4){//同意
		   xmlhttp.onreadystatechange=dosome;
	   }else if(way==5){//拒绝
		   xmlhttp.onreadystatechange=refuse;
	   }else if(way==6){//被拒绝
		   xmlhttp.onreadystatechange=berefused;
	   }
	   xmlhttp.open("POST","BeforePlay?method="+way+"&player="+player_name,true);
	   xmlhttp.send();
}
function refuse(){
	if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
		 loop=true;
    }
}
function berefused(){
	if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
		 loop=true;
		 invite=false;
    }
}
function callback(){
	if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
		 loop=false;
		 invite=true;
		 waiting();
    }
}
function waiting(){
	if(invite){
		 xmlhttp.onreadystatechange=result;
	     xmlhttp.open("POST","BeforePlay?method="+1+"&player="+player_name,true);
	     xmlhttp.send();
	     setTimeout(waiting,1000);
	}
}
function result(){//用于判断返回邀请的结果
	if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
	 var player=xmlhttp.responseText;
	 console.log("result is "+player);
	 if(player=="okay"){//同意
		 playwithfriend(4);
		 invite=false;
	 }else if(player=="cancel"){//被拒绝
		 method=3;
		 showdialog(player_name);
	 }
    }
}
function dosome(){
	if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
		 var result=xmlhttp.responseText;
		 window.location.href="play.jsp";
    }
}
function lookfor(){                                          //还没有加入取消的操作
	loop=false;
	document.getElementById("click").src="../picture/cancel.png";
	window.location.href = "Friend_Servlet";
	return false;//不加这个的话图片不会发生变化
}

function mouseclick(e){
	 var targ
	 if (!e) var e = window.event;
	 if (e.target) targ = e.target;
	 else if (e.srcElement) targ = e.srcElement;
	 if (targ.nodeType == 3) // defeat Safari bug
	    targ = targ.parentNode;
	 var tname;
	 tname=targ.id;//因为当前的target是img所以要获得它的父物体div的标号
	 t_kuang=targ.parentElement.id;
	 //获得的标号就是好友的名称
	 console.log("click is "+tname);
	 console.log("click parent is "+t_kuang);
	 if(t_kuang=="friend"){//也就是说明当前点击的位置是在好友选择这里
		 var brothers = document.getElementById("friend").children;//获得同一级别下的所有的子物体
		 for(var i=0;i<brothers.length;i++)
		 {
		  document.getElementById(brothers[i].id).style.background=null;
		 }
		document.getElementById(tname).style.background="red";
		player_name=tname;
		showmenu(tname);
	 }else if(t_kuang=="play"){//点击菜单
		 loop=false;
		 playwithfriend(2);
		 hidemenu();
	 }else if(t_kuang=="delete"){
		 method=2;
		 hidemenu();
		 showdialog(player_name);
	 }else{
		 hidemenu();
	 }
}
function showmenu(tname){
	var object=document.getElementById(tname);
	var m_left=object.offsetLeft;	
	var m_top=object.offsetTop;
	var m_width=object.offsetWidth;
	var m_height=object.offsetHeight;
	console.log("width is "+m_width);
	console.log("height is "+m_height);
	while(object=object.offsetParent) //获得当前坐标点的绝对坐标  
	    {    
	       m_left   +=   object.offsetLeft;      
	       m_top   +=   object.offsetTop;   
	    }    
	console.log("left is "+m_left);
	console.log("top is "+m_top);
	var menu=document.getElementById("menu");
	menu.style.left=m_left+m_width+"px";
	menu.style.top=m_top+m_height+"px";
	menu.style.position="absolute";
	menu.style.display="block";
	menu.style.zIndex=2;
  }
  
function hidemenu(){
	var menu=document.getElementById("menu");
	menu.style.left=0;
	menu.style.top=0;
	menu.style.display="none";
	menu.style.zIndex=2;
	menu.style.position="absolute";
}
var see=false;

document.onkeydown=function (event) 
{ 
var e = event||window.event;
var keyCode = e.keyCode ? e.keyCode : e.which;//火狐浏览器需要使用e.which
    if(keyCode==13) //键盘按下enter事件
    { 
    	if(!see){
    		var object=document.getElementById("chatinput");
    		object.style.left=(800-150)/2+"px";
    		object.style.top=500+"px";
    		object.style.zIndex=3;
    		object.style.position="absolute";
        	object.style.display="block";
        	object.value="";
        	object.focus(); 
        	see=true;
    	}else{
    		var object=document.getElementById("chatinput");
    		var chat=object.value;
            if(chat.length>13){
            	alert("输入的字符不得超过13个字~");
            }else{
            	console.log("chat is "+chat);
            	object.style.display="none";
            	see=false;
            	sendchat(chat);
            }
    	}
        return false; 
    }
    
} 
</script>
</head>
<body onload="init();" onmousedown="mouseclick(event);">
<div id="background">
   <img src="../picture/choose_game.jpg" height="100%" width="100%"></img>
</div>
<div id="center">
    <!-- 好友列表 -->
	<div id="left">
	<!-- 获取好友列表 -->
	<img src="../picture/friends.png" height="19px" width="80 px" style="margin-left: 15%;">
	<div id="friend">
		<% 
	 ArrayList<String> list=(ArrayList<String>)request.getAttribute("friend_list");
	 if(list!=null){
	 for(int i=0;i<list.size();i++){ 
			%>
			<div id="<%=list.get(i)%>"><%=list.get(i) %></div>
			<%
		}
	 }
		%>
	</div>
	</div>
	<!-- 中间的介绍 -->
	<div id="middle">
	<img src="../picture/introduce.png" height="100%" width="100%">
    </div>
    <!-- 开始匹配按钮 -->
    <div id="right">
    <img id="click" src="../picture/start.png" height="16%" width="80%" style="margin-top: 42%;margin-left: 10%;position: absolute;" onclick="lookfor();">
    </div> 
</div>
<div id="menu" style="background-image: url(../picture/menu_bg.png); height: 140px ;width: 100px">
	<div id="play">
	<img id="play_p" src="../picture/fight.png">
	</div>
	<div id="delete">
	<img id="delete_p" src="../picture/delete.png">
	</div>
</div>
<input id="chatinput" type="text" width="150px">
<div id="dialog" class="chat"></div>
<div id="text" class="text"></div>
<div id="black_bg"></div>
<input class="button" type="button" id="yes" value="来战" onclick="agree();">
<input class="button" type="button" id="no" value="算了" onclick="cancel();">
</body>
</html>