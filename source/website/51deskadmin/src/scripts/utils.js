$.setCookie=function(name,value,iDay){
	var expires=null,oDate=new Date();
	if(iDay){
		oDate.setDate(oDate.getDate()+iDay);
		expires="expires="+oDate;
	}else{
		oDate.setDate(oDate.getDate()+1000);
		expires="expires="+oDate;
	}
	document.cookie=name+"="+value+";"+expires;
}
$.getCookie=function(name){
	var cookievalue=document.cookie;
	var strArr=cookievalue.split("; "),retuval="";
	for(var i=0;i<strArr.length;i++){
		var subarr=strArr[i].split("=");
		if(subarr[0] == name){
			retuval= subarr[1];
		}
	}
	return retuval;
}
$.removeCookie=function(name){
	this.setCookie(name,'',-1);
}
$.getContentHeight=function(){
	var winHeight=null;
	if (window.innerHeight)
		winHeight = window.innerHeight;
	else if ((document.body) && (document.body.clientHeight))
		winHeight = document.body.clientHeight;
	return (winHeight);
}