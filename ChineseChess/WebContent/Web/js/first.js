function checknull(){
	if(form.username.value==""||form.password.value==""){
		window.alert("输入不能为空！");
		return false;
	}else{
		form.action="CheckUser";
	}
}
function register(){
	form.action="Register.jsp";
}
function check_register(){
	if(form.username.value==""||form.password.value==""||form.repassword.value==""){
		window.alert("输入不能为空！");
		return false;
	}else{
		form.action="NewUser";
	}
}
function reset(){
    form.username.value="";
    form.password.value="";
    form.repassword.value="";
}