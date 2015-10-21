<%@page import="src.com.tools.Qizi"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="renderer" content="ie-comp"><!--兼容模式打开  -->
<title>楚河汉界</title>
<% 
HttpSession s=request.getSession(true);
String r=(String)session.getAttribute("first");
String user_name=(String)session.getAttribute("username");
String player_name=(String)session.getAttribute("playername");
String user_id=(String)session.getAttribute("user_id");
String red;
String green;
if(r.equals("1")){
	red=user_name;
	green=player_name;
}else{
	red=player_name;
	green=user_name;
}
%>
<link href="../css/play.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
 var height;//当前body的高度
 var width;//当前body的宽度
 var qipan_h;//棋盘的高度 
 var qipan_w;//棋盘的宽度
 var single_qipan;//一个棋盘格的大小
 var qizi;//一个棋子的大小
 var x0;//最初的棋盘的初始位置（0,0）
 var y0;
 var x1;//左上角
 var y1;
 var xn;//右下角
 var yn;
 var xmlhttp;
 var step2=false;//是否执行到了第二步
 var t_id=-1;//当前获得的棋子id
 var which=0;//用于控制当前的dialog的状态
 var currentx;//第二步方框的位置
 var currenty;
 //所有的棋子的坐标位置
 var array_x=[0,1,2,3,4,5,6,7,8,1,7,0,2,4,6,8,0,2,4,6,8,1,7,0,1,2,3,4,5,6,7,8];
 var array_y=[0,0,0,0,0,0,0,0,0,2,2,3,3,3,3,3,6,6,6,6,6,7,7,9,9,9,9,9,9,9,9,9];
 
 var red;//判断是否是红色方也就是先走
 
 var move_start;
 var move_end;
 var eat_start;
 var eat_end;
 var moveto_x;
 var moveto_y;
 var move=false;
 var eat=false;//用于判断是否吃子，主要用于炮的逻辑判断
 //窗口变化对应界面的刷新
 
 var shuai_x=4;
 var shuai_y=9;
 var jiang_x=4;
 var jiang_y=0;
 var _id=0;
 var people_w=0;//头像的大小
 var loop=true;
 var see=false;//用于控制输入框是否可见
 var timer_liu=10;
 var timer_xiang=10;
 var lastsaying="0,fuck";//禁止使用这个字
 var friend_flag=true;
 var friend_step=1;//好友邀请的servlet的服务
 window.onresize=function(){
	 init();
 }
 //检测窗口是否关闭,切断servlet,删除游戏数据库
 function leave(){
	 xmlhttp.open("POST","GameServlet?method=3",false);
	 xmlhttp.send();
	 return("你确定要退出？");
 }
 //开始进入界面的载入
 function start(){
	 array_x=[0,1,2,3,4,5,6,7,8,1,7,0,2,4,6,8,0,2,4,6,8,1,7,0,1,2,3,4,5,6,7,8];
	 array_y=[0,0,0,0,0,0,0,0,0,2,2,3,3,3,3,3,6,6,6,6,6,7,7,9,9,9,9,9,9,9,9,9];
     initjs();
	 init();
	 getdata();
	 getchat();
	 getfriends();
	 hidedialog();
 }
 //js与后台操作的部分
 function initjs(){
	 if (window.XMLHttpRequest)
	   {// code for IE7+, Firefox, Chrome, Opera, Safari
	   xmlhttp=new XMLHttpRequest();
	   }
	 else
	   {// code for IE6, IE5
	   xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	   }
	 red=<%=r%>;//xmlhttp.responseText;
	 _id=<%=user_id%>
	 if(red=="1"){
		 move=true;
	 }
	 move_start=1+16*red;
     move_end=16+16*red;
     eat_start=(17+16*red)%32;
     eat_end=(32+17*red)%33;
 }
//每隔一秒获取数据
 function getdata(){
	 if(loop){
		   xmlhttp.onreadystatechange=data;
		   // console.log("GameServlet?method=2&id="+t_id+"&x="+currentx+"&y="+currenty);
		   xmlhttp.open("POST","GameServlet?method=1",false);
		   xmlhttp.send();
	       setTimeout(getdata,1000);
	 }
 }
//每隔一秒获取数据
 function getchat(){
	 if(loop){
		   xmlhttp.onreadystatechange=saying;
		   // console.log("GameServlet?method=2&id="+t_id+"&x="+currentx+"&y="+currenty);
		   xmlhttp.open("POST","ChatServlet?method=1",false);
		   xmlhttp.send();
	       setTimeout(getchat,1000);
	 }
 }
//每隔一秒获取数据
 function getfriends(){
	 if(friend_flag){
		   xmlhttp.onreadystatechange=q_friends;
		   // console.log("GameServlet?method=2&id="+t_id+"&x="+currentx+"&y="+currenty);
		   if(friend_step==1){
			   xmlhttp.open("POST","NewFriend?method=1",false);
		   }else{
			   xmlhttp.open("POST","NewFriend?method=3",false);
		   }
		   xmlhttp.send();
	       setTimeout(getfriends,5000);
	 }
 }
 function friends(step){
		   xmlhttp.onreadystatechange=r_friends;
		   // console.log("GameServlet?method=2&id="+t_id+"&x="+currentx+"&y="+currenty);
		   if(step==2){//加好友
			   xmlhttp.open("POST","NewFriend?method=2",false);
		   }else if(step==4){//同意
			   xmlhttp.open("POST","NewFriend?method=4",false);
		       step=3;
		   }else if(step==5){//拒绝
			   xmlhttp.open("POST","NewFriend?method=5",false);
		   }
		   xmlhttp.send();
 }
 function r_friends(){
	 if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
		 
	    }
 }
 function q_friends(){
	 if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
		 var new_p=xmlhttp.responseText;
		 console.log("new_friend is "+new_p);
		 if(new_p=="0"){//没有新的信息
			 
		 }else if(new_p=="refused"){//拒绝
			 which=5;
			 friend_step=1;
			 friend_flag=true;
			 showdialog(new_p);
		 }else if(new_p=="ok"){//同意
			 object=document.getElementById("add");
			 object.disabled="true";
			 which=6;
			 friend_flag=false;
			 showdialog(new_p);
		 }else if(new_p=="2333"){//已经是好友
			 which=7;
			 friend_flag=false;
			 showdialog(new_p);
		 }else if(new_p=="404"){//数据库不存在
			 loop=false;
			 which=2;
			 friend_flag=false;
			 showdialog(new_p);
		 }else{//新的好友邀请
			 which=1;
			 friend_flag=false;
			 showdialog(new_p);
		 }
	    }
 }
 function saying(){
	 if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
		 var new_p=xmlhttp.responseText;
		// console.log("newsaying is "+new_p);
		 if(new_p!=lastsaying){//保证是新的数据才处理
			 lastsaying=new_p;
			 var a=new_p.split(",");
			 //判断是聊天信息还是好友邀请信息
			 if(_id==-100){
				 
			 }else{
				 if(_id==a[0]&&red==1){//项羽
			    	 timer_xiang=10;
			    	 showxiangchat(a[1]);
			     }else if(_id==a[0]&&red==0){//刘邦
			    	 timer_liu=10;
			    	 showliuchat(a[1]);
			     }else if(_id!=a[0]&&red==1){//刘邦
			    	 timer_liu=10;
			    	 showliuchat(a[1]);
			     }else if(_id!=a[0]&&red==0){//项羽
			    	 timer_xiang=10;
			    	 showxiangchat(a[1]);
			     }
			 }
		 }else{
			 timer_liu--;
			 timer_xiang--;
		 }
		 if(timer_liu==0){
			 hideliuchat();
		 }
		 if(timer_xiang==0){
			 hidexiangchat();
		 }
	    }
 }
 function data(){//用于获得新的棋子的变化
	 if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
		 var new_p=xmlhttp.responseText;
		 if(new_p=="none"){
			 loop=false;
			 which=2;
			 showdialog("hehe");//用于展示你赢了
		 }else{
			 var a=new_p.split(",")
			 var id=a[0];
			 if(id!=-1){
				 moveQizi(a[0],a[1],a[2]);
			 }
		 }
	    }
 }
 function getservlet(){//用于上传当前的棋子的变化
	   xmlhttp.onreadystatechange=getpoisitionchange;
	   console.log("t_id is "+t_id);
	   console.log("x is "+currentx);
	   console.log("y is "+currenty);
	   xmlhttp.open("POST","GameServlet?method=2&id="+t_id+"&x="+currentx+"&y="+currenty,true);
	   xmlhttp.send();
 }
 function sendchat(s_chat){//用于上传当前的棋子的变化
	   xmlhttp.onreadystatechange=getpoisitionchange;
	   xmlhttp.open("POST","ChatServlet?method=2&chat="+s_chat,true);
	   xmlhttp.send();
}
 function getpoisitionchange(){
	 if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
		 
	    }
 }

 //改变棋子的位置
 function moveQizi(id,x,y){
	 //alert("change");
	 if(!move){//当前自己走完了，来判断自己走的位置是否已经被数据库获得
		 if(id>=move_start&&id<=move_end){
			 if(id!=t_id){//如果当前获得的变化不是自己的新的变化位置，就重发
				 getservlet();
			 }
		 }
	 }
	 //console.log(id+"change to "+x+","+y);
	 if(array_x[id-1]==x&&array_y[id-1]==y){//判断当前是否已经发生变化
		 
	 }else{
		//用于判断是否吃自己的棋子
		 if(id>=eat_start&&id<=eat_end){//吃子移动的是对方的棋子
		   for(var i=move_start;i<=move_end;i++){
			 if(array_x[i]==x){//找到自己被吃的棋子，用于控制自己的一方获得棋子的位置恰好是自己的棋子走的，而避免隐藏
				 if(array_y[i]==y){
					 if(array_x[id-1]>0){//避免延迟消息而导致的那个子已经被吃掉而又出来吃其他子
						 console.log("receive hide "+(i+1));
						 document.getElementById(i+1+"").style.zIndex=-1;
						 array_x[i]=-10;//把吃掉的棋子从当前列表"去掉"
						 array_y[i]=-10;
					 }
				  }
			 }
		   }
		 }
		//改变第一个框的位置
		 var object=document.getElementById("kuang_1");
		 var kuang=qizi*1.2;
		 object.style.height=kuang+"px";
		 object.style.width=kuang+"px";
		 object.style.left=x0+array_x[id-1]*single_qipan-kuang/2+"px";
		 object.style.top=y0+array_y[id-1]*single_qipan-kuang/2+"px";
		 object.style.position="absolute";
		 object.style.visibility="visible";
		 //改变棋子的位置
		 var qizi_object=document.getElementById(id);
		 qizi_object.style.height=qizi+"px";
		 qizi_object.style.width=qizi+"px";
		 qizi_object.style.left=x0+x*single_qipan-qizi/2+"px";
		 qizi_object.style.top=y0+y*single_qipan-qizi/2+"px";
		 qizi_object.style.position="absolute";
		 array_x[id-1]=x;
	     array_y[id-1]=y;
	     
	     //改变第二个框的位置
	     var object=document.getElementById("kuang_2");
		 object.style.height=kuang+"px";
		 object.style.width=kuang+"px";
		 object.style.left=x0+x*single_qipan-kuang/2+"px";
		 object.style.top=y0+y*single_qipan-kuang/2+"px";
		 object.style.position="absolute";
		 object.style.visibility="visible";
	     //用于记录将和帅的最新位置
	     if(id==5){
			 jiang_x=x;
			 jiang_y=y;
		 }else if(id==28){
			 shuai_x=x;
			 shuai_y=y;
		 }
	    // console.log("check");
	     check(id);
	     move=true;
	 }
 }
 
 //js控制的界面的刷新
 function init(){
	 height=document.documentElement.clientHeight;
	 width=document.documentElement.clientWidth;
	 /* console.log("height is "+height);
	 console.log("width is "+width); */
	 qipan_h=height;
	 qipan_w=height/921*1134;
	/*  console.log("height is "+qipan_h);
	 console.log("width is "+qipan_w); */
	 var object=document.getElementById("background");
	 object.style.height=qipan_h+"px";
	 object.style.width=qipan_w+"px";
	 object.style.left=(width-qipan_w)/2+"px";
	 object.style.position="absolute";
	 people_w=(width-qipan_w)/2*0.5;
	 object=document.getElementById("xiangyu");
	 object.style.height=people_w/363*383+"px";
	 object.style.width=people_w+"px";
	 object.style.left=(width-qipan_w)/2*0.3+"px";
	 object.style.bottom=height*0.01+"px";
	 object.style.position="absolute";
	 object=document.getElementById("liubang");
	 object.style.height=people_w/427*446+"px";
	 object.style.width=people_w+"px";
	 object.style.right=(width-qipan_w)/2*0.3+"px";
	 object.style.top=height*0.01+"px";
	 object.style.position="absolute";
	 
	 object=document.getElementById("xiangyu_name");
	 object.style.width=people_w+"px";
	 object.style.left=(width-qipan_w)/2*0.3+"px";
	 object.style.bottom=height*0.01+people_w/363*383+10+"px";
	 object.style.position="absolute";
	 object=document.getElementById("liubang_name");
	 object.style.width=people_w+"px";
	 object.style.right=(width-qipan_w)/2*0.3+"px";
	 object.style.top=height*0.01+people_w/427*446+10+"px";
	 object.style.position="absolute";
	 
	 //两个选择框的确定
	 object=document.getElementById("kuang_1");
	 object.style.height=people_w/427*446+"px";
	 object.style.width=people_w+"px";
	 object.style.right=(width-qipan_w)/2*0.3+"px";
	 object.style.top=height*0.01+"px";
	 object.style.position="absolute";
	 
	 object=document.getElementById("kuang_2");
	 object.style.height=people_w/427*446+"px";
	 object.style.width=people_w+"px";
	 object.style.right=(width-qipan_w)/2*0.3+"px";
	 object.style.top=height*0.01+"px";
	 object.style.position="absolute";
	 single_qipan=height/13;
	 qizi=single_qipan/1.2;
	 x0=(width-qipan_w)/2+qipan_w/16*4;
	 y0=height/13*2;
	 //右下角的位置
	 xn=(width-qipan_w)/2+qipan_w/16*12.3;
	 yn=height/13*11.3;
	 x1=(width-qipan_w)/2+qipan_w/16*3.7;
	 y1=height/13*1.7;
	 //初始化棋子的位置
     for(var i=0;i<32;i++){
    	 initqizi(i+1, array_x[i], array_y[i]);
		}
	 
	 initflag();
	 
	 object=document.getElementById("chatinput");
	 object.style.left=(width-150)/2+"px";
	 object.style.top=height*0.9+"px";
	 object.style.zIndex=3;
	 object.style.position="absolute";
	 object.style.display="none";
	 if(red==1){//项羽，放到刘邦那里
		 object=document.getElementById("add");
		 object.style.left=(width-100)/2+"px";
		 object.style.top=height*0.05+"px";
		 object.style.zIndex=2;
		 object.style.position="absolute";
	 }else{//刘邦，放到项羽那里
		 object=document.getElementById("add");
		 object.style.left=(width-100)/2+"px";
		 object.style.top=height*0.95+"px";
		 object.style.zIndex=2;
		 object.style.position="absolute";
	 }
	 hidechat();
 }
 function hidechat(){
	    object=document.getElementById("tri_liu");
		object.style.display="none";
		object=document.getElementById("liubang_chat");
		object.style.display="none";
		object=document.getElementById("tri_xiang");
		object.style.display="none";
		object=document.getElementById("xiangyu_chat");
		object.style.display="none";
 }
 function showliuchat(saying){
	    var object=document.getElementById("tri_liu");
	    object.style.right=(width-qipan_w)/2*0.3+15+"px";
		object.style.top=height*0.01+people_w/427*446+25+"px"; 
		object.style.position="absolute";
		object.style.display="block";
		
		object=document.getElementById("liubang_chat");
		object.style.right=(width-qipan_w)/2*0.3+"px";
		object.style.top=height*0.01+people_w/427*446+50+"px"; 
		object.style.position="absolute";
		object.style.display="block";
		object.innerHTML=saying;
 }
 
 function hideliuchat(){
		    console.log("hide liu");
		    var object=document.getElementById("tri_liu");
			object.style.display="none";
			object=document.getElementById("liubang_chat");
			object.style.display="none";
}
 
function showxiangchat(saying){
		var object=document.getElementById("tri_xiang");
		object.style.left=(width-qipan_w)/2*0.3+15+"px";
		object.style.bottom=height*0.01+people_w/363*383+25+"px"; 
		object.style.position="absolute";
		object.style.display="block";
		
		object=document.getElementById("xiangyu_chat");
		object.style.left=(width-qipan_w)/2*0.3+"px";
		object.style.bottom=height*0.01+people_w/363*383+50+"px"; 
		object.style.position="absolute";
		object.style.display="block";
		object.innerHTML=saying;
}
     
function hidexiangchat(){
		    console.log("hide xiang");
		    var object=document.getElementById("tri_xiang");
			object.style.display="none";
			object=document.getElementById("xiangyu_chat");
			object.style.display="none";
}
 //谁走的标志
 function initflag(){
	 var qizi_object=document.getElementById("red_flag");
	 qizi_object.style.height=single_qipan+"px";
	 qizi_object.style.width=2*single_qipan+"px";
	 qizi_object.style.left=x0-2*single_qipan+"px";
	 qizi_object.style.top=y0+8*single_qipan+"px";
	 qizi_object.style.position="absolute";
	 qizi_object.style.zIndex=2;
	 var qizi_object1=document.getElementById("green_flag");
	 qizi_object1.style.height=single_qipan+"px";
	 qizi_object1.style.width=2*single_qipan+"px";
	 qizi_object1.style.left=x0+9*single_qipan+"px";
	 qizi_object1.style.top=y0+0*single_qipan+"px";
	 qizi_object1.style.position="absolute";
	 qizi_object1.style.zIndex=-1;
 }
 //将军的提示
 function initnotice(a){
	 var qizi_object=document.getElementById("notice");
	 qizi_object.style.height=single_qipan+"px";
	 qizi_object.style.width=2*single_qipan+"px";
	 qizi_object.style.left=x0+3*single_qipan+"px";
	 qizi_object.style.top=y0+4*single_qipan+"px";
	 qizi_object.style.position="absolute";
	 var image=document.getElementById("jiangjun");
	 if(a==2){
		 image.src="../picture/jiangjun_green.png";
	 }else{
		 image.src="../picture/jiangjun_red.png";
	 }
	 qizi_object.style.zIndex=2;
	 setTimeout(deletenotice, 1000);
 }
 function deletenotice(){
	 var image=document.getElementById("notice");
	 image.style.zIndex=-1;
	 
 } 
 
 function initqizi(number,x,y){
	 var qizi_object=document.getElementById(number+"");
	 qizi_object.style.height=qizi+"px";
	 qizi_object.style.width=qizi+"px";
	 qizi_object.style.left=x0+x*single_qipan-qizi/2+"px";
	 qizi_object.style.top=y0+y*single_qipan-qizi/2+"px";
	 qizi_object.style.position="absolute";
 }
 function getposition(e){
	 if (!e) var e = window.event;
	 //console.log("pageX: "+e.pageX+" clientX: "+e.clientX+" layerX: "+e.layerX+" offsetX: "+e.offsetX);
	 if(e.clientX){//获取可是界面的绝对坐标
		    var vx=e.clientX; 
		    var vy=e.clientY;
		    /* console.log("x1: "+x1+" y1: "+y1);
		    console.log("xn: "+xn+" yn: "+yn);
		    console.log("x: "+vx+" y: "+vy); */
	    	if(step2){
		        if(vx>x1&&vx<xn&&vy>y1&&vy<yn){//在棋盘格的范围内
		    	     currentx=Math.floor((vx-x1)/single_qipan);//不保留小数
		    	     currenty=Math.floor((vy-y1)/single_qipan);
		    	     //console.log("x: "+currentx+" y: "+currenty);
		    		 var object=document.getElementById("kuang_2");
		    		 var kuang=qizi*1.2;
		    		 object.style.height=kuang+"px";
		    		 object.style.width=kuang+"px";
		    		 object.style.left=x0+currentx*single_qipan-kuang/2+"px";
		    		 object.style.top=y0+currenty*single_qipan-kuang/2+"px";
		    		 object.style.position="absolute";
		    		 object.style.visibility="visible";
		    	}
		    }
	 }
 }
 //获得当前点击的控件的标号
 function whichElement(e)
 {
 var targ
 if (!e) var e = window.event;
 if (e.target) targ = e.target;
 else if (e.srcElement) targ = e.srcElement;
 if (targ.nodeType == 3) // defeat Safari bug
    targ = targ.parentNode;
 var tname;
 tname=targ.parentElement.id;//因为当前的target是img所以要获得它的父物体div的标号
// alert(tname);
 //var move_start=1+16*red;
// var move_end=16+16*red;
 //var eat_start=(17+16*red)%32;
 //var eat_end=(32+17*red)%33;
 if(parseInt(tname)>=move_start&&parseInt(tname)<=move_end&&move){//点击一个棋子也就是第一次点击在选择棋子
	t_id=tname;
	getshape(t_id);
 }else if(tname=="kuang_2"&&move){//不吃子，点击棋盘的某一个位置，也就是选定之后点击
	 console.log("move");
	 eat=false;
	 for(var i=eat_start-1;i<eat_end;i++){//避免第一个方法判断不出当前的是否吃子情况
			if(array_x[i]==currentx&&array_y[i]==currenty){
				document.getElementById((i+1)+"").style.zIndex=-1;
				array_x[i]=-10;//把吃掉的棋子从当前列表"去掉"
				array_y[i]=-10;
				eat=true;
			}
		}
	 if(judge(t_id,currentx,currenty)){
		    step2=false;
			array_x[t_id-1]=currentx;
			array_y[t_id-1]=currenty;
		    changeQizi(); 
		    check(t_id);//检查是否将军
	 }
 }else if(parseInt(tname)>=eat_start&&parseInt(tname)<=eat_end&&step2&&move){//吃子，要改变棋子的层数，是被吃的棋子在最下方
	//console.log("chi is "+tname);
	 console.log("eat");
     eat=true;
	if(judge(t_id,currentx,currenty)){
		console.log("hide "+tname);
		document.getElementById(tname+"").style.zIndex=-1;
	    //console.log("z-index is "+z);
		step2=false;
		array_x[t_id-1]=currentx;
		array_y[t_id-1]=currenty;
		array_x[tname-1]=-10;//把吃掉的棋子从当前列表"去掉"
		array_y[tname-1]=-10;
	    changeQizi(); 
	    check(t_id);
	}	
 }
 }
 //改变棋子的位置
 function changeQizi(){
	 var qizi_object=document.getElementById(t_id+"");
	 //判断当前棋子位置是否合理
	 //象棋逻辑
		 qizi_object.style.height=qizi+"px";
		 qizi_object.style.width=qizi+"px";
		 qizi_object.style.left=x0+currentx*single_qipan-qizi/2+"px";
		 qizi_object.style.top=y0+currenty*single_qipan-qizi/2+"px";
		 qizi_object.style.position="absolute";
		
         move=false;//测试的时候要全部保持可以移动的状态
		 moveto_x=currentx;
		 moveto_y=currenty;
         getservlet();
	 }
 //在当前的棋子位置边上加一个方框
 function getshape(id){
	 var kuang=qizi*1.2;
	 var x=array_x[id-1];
	 var y=array_y[id-1];
	 var object=document.getElementById("kuang_1");
	 object.style.height=kuang+"px";
	 object.style.width=kuang+"px";
	 object.style.left=x0+x*single_qipan-kuang/2+"px";
	 object.style.top=y0+y*single_qipan-kuang/2+"px";
	 object.style.position="absolute";
	 object.style.visibility="visible";
	 step2=true;
 }
 
 //车   1;马2;象3; 士4 ;将5;士6 ;象 7;马 8;车9;炮10，11,卒 12,13,14,15,16;
 //车  32;马31;相30; 仕29 ;帅28;仕27 ;相 26;马 25;车24;炮23，22,卒21,20,19,18,17;
 
 //用于判断当前位置是否合理
 function judge(m_id,x,y){
	 console.log("id is "+m_id);
	 var id=m_id-1;
	 if(array_x[id]<0||array_y[id]<0){//去除被吃掉的子
		 return false;
	 }
	 if(m_id==1||m_id==9||m_id==24||m_id==32){//车
		/*  console.log("currentx is "+currentx);
		 console.log("currenty is "+currenty);
		 console.log("x is "+array_x[id]);
		 console.log("y is "+array_y[id]); */
		 if(x==array_x[id]||y==array_y[id]){
					if(x==array_x[id]){//横走
						var max_y=y>array_y[id]?y:array_y[id];
						var min_y=y<array_y[id]?y:array_y[id];
						for(var i=0;i<32;i++){
							if(array_x[i]==x){//和车在同一条竖线上
								if(array_y[i]>min_y&&array_y[i]<max_y){
									return false;
								}
							}
						}
					}else{//竖走
						var max_x=x>array_x[id]?x:array_x[id];
						var min_x=x<array_x[id]?x:array_x[id];
						for(var i=0;i<32;i++){
							if(array_y[i]==y){//和车在同一条横线上
								if(array_x[i]>min_x&&array_x[i]<max_x){
									return false;
								}
							}
						}
					}
		 }else{
			 return false;
		 }
	 }else if(m_id==2||m_id==8||m_id==25||m_id==31){//马
		 if(Math.abs(x-array_x[id])==1){//希望构成竖日
					 if(Math.abs(y-array_y[id])==2){//判断是否蹩马腿
								 if(y>array_y[id]){//向下跳
									 for(var i=0;i<32;i++){
										 if(array_x[i]==array_x[id]&&id!=i){
											 if(array_y[i]==(array_y[id]+1)){
												 return false;
											 }
										 }
									 }
								 }else{//向上跳
									 for(var i=0;i<32;i++){
										 if(array_x[i]==array_x[id]&&id!=i){
											 if(array_y[i]==(array_y[id]-1)){
												 return false;
											 }
										 }
									 }
								 }
					 }else{//走的不是日
						 return false;
					 }
		 }else if(Math.abs(y-array_y[id])==1){//希望构成横日
		             if(Math.abs(x-array_x[id])==2){//判断是否蹩马腿
				            	 if(x>array_x[id]){//向下跳
									 for(var i=0;i<32;i++){
										 if(array_y[i]==array_y[id]&&id!=i){
											 if(array_x[i]==(array_x[id]+1)){
												 return false;
											 }
										 }
									 }
								 }else{//向上跳
									 for(var i=0;i<32;i++){
										 if(array_y[i]==array_y[id]&&id!=i){
											 if(array_x[i]==(array_x[id]-1)){
												 return false;
											 }
										 }
									 }
								 }
					 }else{//走的不是日
						 return false;
					 }
		 }else{//不能构成日
			 return false;
		 }
	 }else if(m_id==3||m_id==7){//象
		 if(y>=5){//过河
			 return false;
		 }
		 if(Math.abs(x-array_x[id])==2){//看是否是田字
			 if(Math.abs(y-array_y[id])==2){//看是否是蹩象腿
				 if(x>array_x[id]){//向右飞
					 if(y>array_y[id]){//向右下飞
						 for(var i=0;i<32;i++){
							 if(array_y[i]==(array_y[id]+1)){
								 if(array_x[i]==(array_x[id]+1)){
									 return false;
								 }
							 }
						 }
					 }else{//向右上飞
						 for(var i=0;i<32;i++){
							 if(array_y[i]==(array_y[id]-1)){
								 if(array_x[i]==(array_x[id]+1)){
									 return false;
								 }
							 }
						 }
					 }
				 }else{//向左飞
                     if(y>array_y[id]){//向左下飞
                    	 for(var i=0;i<32;i++){
							 if(array_y[i]==(array_y[id]+1)){
								 if(array_x[i]==(array_x[id]-1)){
									 return false;
								 }
							 }
						 }
					 }else{//向左上飞
						 for(var i=0;i<32;i++){
							 if(array_y[i]==(array_y[id]-1)){
								 if(array_x[i]==(array_x[id]-1)){
									 return false;
								 }
							 }
						 }
					 }
				 }
				 
			 }else{//不能构成田
				 return false;
			 }
		 }else{//不能构成田
			 return false;
		 }
	 }else if(m_id==26||m_id==30){//相
	 if(y<=4){//过河
		 return false;
	 }
	 if(Math.abs(x-array_x[id])==2){//看是否是田字
		 if(Math.abs(y-array_y[id])==2){//看是否是蹩象腿
			 if(x>array_x[id]){//向右飞
				 if(y>array_y[id]){//向右下飞
					 for(var i=0;i<32;i++){
						 if(array_y[i]==(array_y[id]+1)){
							 if(array_x[i]==(array_x[id]+1)){
								 return false;
							 }
						 }
					 }
				 }else{//向右上飞
					 for(var i=0;i<32;i++){
						 if(array_y[i]==(array_y[id]-1)){
							 if(array_x[i]==(array_x[id]+1)){
								 return false;
							 }
						 }
					 }
				 }
			 }else{//向左飞
                    if(y>array_y[id]){//向左下飞
                   	 for(var i=0;i<32;i++){
						 if(array_y[i]==(array_y[id]+1)){
							 if(array_x[i]==(array_x[id]-1)){
								 return false;
							 }
						 }
					 }
				 }else{//向左上飞
					 for(var i=0;i<32;i++){
						 if(array_y[i]==(array_y[id]-1)){
							 if(array_x[i]==(array_x[id]-1)){
								 return false;
							 }
						 }
					 }
				 }
			 }
			 
		 }else{//不能构成田
			 return false;
		 }
	 }else{//不能构成田
		 return false;
	 }
		 
	 }else if(m_id==4||m_id==6){//士
		 if(x>=3&&x<=5&&y>=0&&y<=2){//只可以在将框内移动
			 if((Math.abs(x-array_x[id])==1)){
				 if((Math.abs(y-array_y[id])!=1)){
					 return false;
				 }
			 }else{//每次只可以对角线走
				 return false;
			 }
		 }else{
			 return false;
		 }
	 }
	 else if(m_id==27||m_id==29){//仕
		 if(x>=3&&x<=5&&y>=7&&y<=9){//只可以在将框内移动
			 if((Math.abs(x-array_x[id])==1)){
				 if((Math.abs(y-array_y[id])!=1)){
					 return false;
				 }
			 }else{//每次只可以对角线走
				 return false;
			 }
		 }else{
			 return false;
		 }
		 
	 }else if(m_id==5){//将
		 if(x>=3&&x<=5&&y>=0&&y<=2){//只可以在将框内移动
			 if((Math.abs(x-array_x[id])==1)){//横向走只能走一格
				 if(y!=array_y[id]){
					 return false;
				 }
			 }else if((Math.abs(y-array_y[id])==1)){//竖着走只能走一格
				 if(x!=array_x[id]){
					 return false;
				 }
			 }else{
				 return false;
			 }
		 }else{
			 return false;
		 }
		 
	 }else if(m_id==28){//帅
		 if(x>=3&&x<=5&&y>=7&&y<=9){//只可以在将框内移动
			 if((Math.abs(x-array_x[id])==1)){//横向走只能走一格
				 if(y!=array_y[id]){
					 return false;
				 }
			 }else if((Math.abs(y-array_y[id])==1)){//竖着走只能走一格
				 if(x!=array_x[id]){
					 return false;
				 }
			 }else{//没有走一格
				     return false;
			 }
		 }else{
			 return false;
		 }
		 
	 }else if(m_id==10||m_id==11||m_id==22||m_id==23){//炮
		 if(m_id==10||m_id==11){//绿
			 if(x==shuai_x&&y==shuai_y){
				 eat=true;
			 }
		 }else{//红
			 if(x==jiang_x&&y==jiang_y){
				 eat=true;
			 }
		 }
		 if(eat){//吃子
			 console.log("pao eat");
			 if(x==array_x[id]||y==array_y[id]){
					if(x==array_x[id]){//竖走
						var max_y=y>array_y[id]?y:array_y[id];
						var min_y=y<array_y[id]?y:array_y[id];
						var count=0;//用于计算跑走的这段路程中有几个隔着的棋子
						for(var i=0;i<32;i++){
							if(array_x[i]==x){//在同一条竖线上
								if(array_y[i]>min_y&&array_y[i]<max_y){
									count++;
									if(count>1){//已经有了两个或者两个以上的棋子在中间了,这里是为了优化算法，如果发现有两个或者两个以上的炮台就退出，避免每次都遍历一遍数组
										return false;
									}
								}
							}
						}
						if(count!=1){//吃子的炮必须中间要有一个炮台,其实这里也就是检查count是不是0
							return false;
						}
					}else{//横走
						var max_x=x>array_x[id]?x:array_x[id];
						var min_x=x<array_x[id]?x:array_x[id];
						var count=0;
						for(var i=0;i<32;i++){
							if(array_y[i]==y){//在同一条横线上
								if(array_x[i]>min_x&&array_x[i]<max_x){
									count++;
									if(count>1){
										return false;
									}
								}
							}
						}
						if(count!=1){
							return false;
						}
					}
		 }else{
			 return false;
		 }
			 
		 }else{//不吃子，类似于车
			 console.log("pao move");
				 if(x==array_x[id]||y==array_y[id]){
						if(x==array_x[id]){//横走
							var max_y=y>array_y[id]?y:array_y[id];
							var min_y=y<array_y[id]?y:array_y[id];
							for(var i=0;i<32;i++){
								if(array_x[i]==x){//在同一条竖线上
									if(array_y[i]>min_y&&array_y[i]<max_y){
										return false;
									}
								}
							}
						}else{//竖走
							var max_x=x>array_x[id]?x:array_x[id];
							var min_x=x<array_x[id]?x:array_x[id];
							for(var i=0;i<32;i++){
								if(array_y[i]==y){//在同一条横线上
									if(array_x[i]>min_x&&array_x[i]<max_x){
										return false;
									}
								}
							}
						}
			 }else{
				 return false;
			 }
		 }
		 
	 }else if(m_id==12||m_id==13||m_id==14||m_id==15||m_id==16){//卒
		if(Math.abs(x-array_x[id])>1||Math.abs(y-array_y[id])>1){
			return false;
		}
		if(array_y[id]<5){//没过河
			if(y!=(array_y[id]+1)||(x!=array_x[id])){//只可以直走
				return false;
			}
		}else{//过河了
			if((Math.abs(x-array_x[id])==1)){//横向走只能走一格
				if(y!=array_y[id]){//只可以直走
					return false;
				}
			 }else if(y-array_y[id]==1){//竖着走只能走一格
				 if(x!=array_x[id]){
					 return false;
				 }
			 }else{
				 return false;
			 }
		}
		 
	 }else if(m_id==17||m_id==18||m_id==19||m_id==20||m_id==21){//兵
		 if(Math.abs(x-array_x[id])>1||Math.abs(y-array_y[id])>1){
				return false;
			}
		 if(array_y[id]>4){//没过河
				if((y!=(array_y[id]-1))&&(x!=array_x[id])){//只可以直走
					return false;
				}
			}else{//过河了
				if((Math.abs(x-array_x[id])==1)){//横向走只能走一格
					 if(y!=array_y[id]){
						 return false;
					 }
				 }else if(Math.abs(y-array_y[id])==1){//竖着走只能走一格
					 if(x!=array_x[id]){
						 return false;
					 }
				 }else{//没有走一格
					 return false;
				 }
			}
	 }
	 
	 //记录将和帅的最新的位置，便于判断将军
	 if(m_id==5){
		 jiang_x=array_x[4];
		 jiang_y=array_y[4];
	 }else if(m_id==28){
		 shuai_x=array_x[27];
		 shuai_y=array_y[27];
	 }
	 return true;
 }
 
//车   1;马2;象3; 士4 ;将5;士6 ;象 7;马 8;车9;炮10，11,卒 12,13,14,15,16;
 //车  32;马31;相30; 仕29 ;帅28;仕27 ;相 26;马 25;车24;炮23，22,卒21,20,19,18,17;
 
 //用于检查是否将军
 function check(q_id){//其中炮和帅要单独讨论
	if(q_id>=1&&q_id<=16){//绿
		document.getElementById("red_flag").style.zIndex=2;
		document.getElementById("green_flag").style.zIndex=-1;
	}else if(q_id>=17&&q_id<=32){//红
		document.getElementById("red_flag").style.zIndex=-1;
		document.getElementById("green_flag").style.zIndex=2;
	}
	var flag=false;
	if(q_id>=move_start&&q_id<=move_end){//自己走的棋子
		if(red==1){//红方
			for(var i=move_start;i<=move_end;i++){
				if(q_id==28){
					q_id=32;
				}
				flag=judge(i,jiang_x, jiang_y);
				if(flag){
					initnotice(1);
					break;
				}
			}
		}else{
			for(var i=move_start;i<=move_end;i++){
				if(q_id==5){
					q_id=1;
				}
				flag=judge(i,shuai_x, shuai_y);
				if(flag){
					initnotice(2);
					break;
				}
			}
		}
	}else if(q_id>=eat_start&&q_id<=eat_end){//对方走的棋子
		if(red==1){//红方
			for(var i=eat_start;i<=eat_end;i++){
				if(q_id==28){
					q_id=32;
				}
				flag=judge(i,shuai_x, shuai_y);
				if(flag){
					initnotice(2);
					break;
				}
			}
		}else{
			for(var i=eat_start;i<=eat_end;i++){
				if(q_id==5){
					q_id=1;
				}
				flag=judge(i,jiang_x, jiang_y);
				if(flag){
					initnotice(1);
					break;
				}
			}
		}
	}
 }
//聊天事件的创立
 document.onkeydown=function (event) 
	{ 
		var e = event||window.event;
		var keyCode = e.keyCode ? e.keyCode : e.which;//火狐浏览器需要使用e.which
		    if(keyCode==13) //点击空格事件
		             { 
             	if(!see){
             		var object=document.getElementById("chatinput");
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
 
 function agree(){
		if(which==1){//来自加好友邀请
			object=document.getElementById("add");
			object.disabled="true";
			friends(4);
		}else if(which==2){//你赢了
			
		}else if (which==3){//你输了
			
		}else if(which==4){//退出提示
			
		}else if(which==5){
			
		}else if(which==6){
			
		}else if(which==7){
			
		}
		hidedialog();
	}

function cancel(){
		if(which==1){//来自好友邀请
			friend_flag=true;
			friends(5);
		}else if(which==2){//删除好友
			 console.log("giveup delete");
		}
		hidedialog();
	}
	
function add(){
	friend_step=3;
	friends(2);
}	
 function showdialog(player_name){
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
		if(which==1){//加好友邀请
			object.innerHTML=player_name+"请求成为好友~";
		}else if(which==2){//你赢了
			object.innerHTML="恭喜你，你赢啦！";
		}else if(which==3){//你输了
			object.innerHTML="很遗憾，你输了~";
		}else if(which==4){//确定要退出？
			
		}else if(which==5){
			object.innerHTML="很遗憾，他不想加你。。。";
		}else if(which==6){
			object.innerHTML="加好友成功！";
		}else if(which==7){
			object.innerHTML="你们已经是好友~";
		}
		var object=document.getElementById("yes");
		object.style.height=height*0.25*0.2+"px";
		object.style.width=width*0.2*0.3+"px";
		object.style.left=width*0.8/2+width*0.2*0.15+"px";
		object.style.top=height*0.75/2+height*0.25*0.8+"px";
		object.style.display="block";
		if(which==1){//加好友
			object.value="同意";
		}else{
			object.style.left=width*0.8/2+width*0.2*0.4+"px";
			object.value="确认";
		}

		var object=document.getElementById("no");
		object.style.height=height*0.25*0.2+"px";
		object.style.width=width*0.2*0.3+"px";
		object.style.right=width*0.8/2+width*0.2*0.15+"px";
		object.style.top=height*0.75/2+height*0.25*0.8+"px";
		object.style.display="block";
		if(which==1){
			object.value="算了";
		}else if(which==2){//你赢了
			object.style.display="none";
		}else if(which==3){//你输了
			object.style.display="none";
		}else if(which==5){//不加
			object.style.display="none";
		}else if(which==6){//成功
			object.style.display="none";
		}else if(which==7){//是好友
			object.style.display="none";
		}else{
			object.value="取消";
		}
	}

</script>
</head>
<body onload="start();" onmousedown="whichElement(event);" onmousemove="getposition(event);" onbeforeunload="leave();">
<div id="background">
   <img src="../picture/final_qipan.png" height="100%">
</div>
<div id="liubang">
    <img src="../picture/liubang.png" height="100%">
</div>
<div id="xiangyu">
    <img src="../picture/xiangyu.png" height="100%">
</div>
<div id="kuang_1" style="visibility: hidden; z-index: 1">
    <img src="../picture/qizi_kuang.png" height="100%" >
</div>
<div id="kuang_2" style="visibility: hidden; z-index: 1">
    <img src="../picture/qizi_kuang.png" height="100%" >
</div>
<div class="qizi" id="1">
    <img src="../picture/qizi_green_che.png" height="100%" >
</div>
<div class="qizi" id="2">
    <img src="../picture/qizi_green_ma.png" height="100%">
</div>
<div class="qizi" id="3">
    <img src="../picture/qizi_green_xiang.png" height="100%">
</div>
<div class="qizi" id="4">
    <img src="../picture/qizi_green_shi.png" height="100%">
</div>
<div class="qizi" id="5">
    <img src="../picture/qizi_green_jiang.png" height="100%">
</div>
<div class="qizi" id="6">
    <img src="../picture/qizi_green_shi.png" height="100%">
</div>
<div class="qizi" id="7">
    <img src="../picture/qizi_green_xiang.png" height="100%">
</div>
<div class="qizi" id="8">
    <img src="../picture/qizi_green_ma.png" height="100%">
</div>
<div class="qizi" id="9">
    <img src="../picture/qizi_green_che.png" height="100%">
</div>
<div class="qizi" id="10">
    <img src="../picture/qizi_green_pao.png" height="100%">
</div>
<div class="qizi" id="11">
    <img src="../picture/qizi_green_pao.png" height="100%">
</div>
<div class="qizi" id="12">
    <img src="../picture/qizi_green_zu.png" height="100%">
</div>
<div class="qizi" id="13">
    <img src="../picture/qizi_green_zu.png" height="100%">
</div>
<div class="qizi" id="14">
    <img src="../picture/qizi_green_zu.png" height="100%">
</div>
<div class="qizi" id="15">
    <img src="../picture/qizi_green_zu.png" height="100%">
</div>
<div class="qizi" id="16">
    <img src="../picture/qizi_green_zu.png" height="100%">
</div>
<div class="qizi" id="17">
    <img src="../picture/qizi_red_bing.png" height="100%">
</div>
<div class="qizi" id="18">
    <img src="../picture/qizi_red_bing.png" height="100%">
</div>
<div class="qizi" id="19">
    <img src="../picture/qizi_red_bing.png" height="100%">
</div>
<div class="qizi" id="20">
    <img src="../picture/qizi_red_bing.png" height="100%">
</div>
<div class="qizi" id="21">
    <img src="../picture/qizi_red_bing.png" height="100%">
</div>
<div class="qizi" id="22">
    <img src="../picture/qizi_red_pao.png" height="100%">
</div>
<div class="qizi" id="23">
    <img src="../picture/qizi_red_pao.png" height="100%">
</div>
<div class="qizi" id="24">
    <img src="../picture/qizi_red_che.png" height="100%">
</div>
<div class="qizi" id="25">
    <img src="../picture/qizi_red_ma.png" height="100%">
</div>
<div class="qizi" id="26">
    <img src="../picture/qizi_red_xiang.png" height="100%">
</div>
<div class="qizi" id="27">
    <img src="../picture/qizi_red_shi.png" height="100%">
</div>
<div class="qizi" id="28">
    <img src="../picture/qizi_red_shuai.png" height="100%">
</div>
<div class="qizi" id="29">
    <img src="../picture/qizi_red_shi.png" height="100%">
</div>
<div class="qizi" id="30">
    <img src="../picture/qizi_red_xiang.png" height="100%">
</div>
<div class="qizi" id="31">
    <img src="../picture/qizi_red_ma.png" height="100%">
</div>
<div class="qizi" id="32">
    <img src="../picture/qizi_red_che.png" height="100%">
</div>
<div class="qizi" id="notice">
    <img id="jiangjun" height="100%"/>
</div>
<div class="qizi" id="red_flag">
    <img id="red" src="../picture/qizi_red_shuai.png" height="100%"/>
</div>
<div class="qizi" id="green_flag">
    <img id="green" src="../picture/qizi_green_jiang.png"  height="100%"/>
</div>
<div id="xiangyu_name">
<%=red %>
</div>
<div id="liubang_name">
<%=green %>
</div>
<input id="chatinput" type="text" width="150px">

<div class="chat" id="liubang_chat"></div>
<div id="tri_liu"></div>
<div class="chat" id="xiangyu_chat"></div>
<div id="tri_xiang"></div>
<input type="submit" id="add" value="" onclick="add();">
<div id="dialog" class="chat"></div>
<div id="text" class="text"></div>
<div id="black_bg"></div>
<input class="button" type="button" id="yes" value="同意" onclick="agree();">
<input class="button" type="button" id="no" value="忽视" onclick="cancel();">
</body>
</html>