<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="renderer" content="ie-comp"><!--兼容模式打开  -->
<title>楚河汉界</title>
<link href="../css/play.css" rel="stylesheet" type="text/css" />
<style type="text/css">
html,body{
    margin:0px;
    padding:0px;
    height: 100%;
    width: 100%;
    background-image: url(../picture/play_bg.png);
    background-repeat: repeat;
}
.chat{
 border:1px;
 border-style:solid;
 padding:7px;
 max-width:200px;
 z-index: 3;
 display: block;
 position: absolute;
 line-height: 120%;
 color:#fff;
 -webkit-border-radius:10px;  
 -moz-border-radius:10px;  
 border-radius:10px;
 /*加入渐变色  */
 background:-webkit-gradient(linear, left top, left bottom, from(rgba(249,216,53,0.7)), to(rgba(243,150,28,0.7)));
 background:-moz-linear-gradient(top, rgba(249,216,53,0.7), rgba(243,150,28,0.7));
　background:-o-linear-gradient(top, rgba(249,216,53,0.7), rgba(243,150,28,0.7));
　background:linear-gradient(top, rgba(249,216,53,0.7), rgba(243,150,28,0.7));
 /*加入阴影  */
 -moz-box-shadow:3px 3px 5px rgba(0,0,0,0.7);  
 -webkit-box-shadow:3px 3px 5px rgba(0,0,0,0.7);  
 box-shadow:3px 3px 5px rgba(0,0,0,0.7);  
}
.chat:before{  
    height:0px;  
    width:0px;  
    top:0px;
　　　left:0px; 
    border-width:15px;  
    border-style:solid;  
    border-color:transparent transparent #f3961c transparent;
    position:absolute;
　　　z-index:3;
}  
</style>
<script type="text/javascript">

</script>
</head>
<body>
<input type="submit" id="add" value="" onclick="add();">
</body>
</html>