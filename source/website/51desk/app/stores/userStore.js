var Reflux=require("reflux");
var actions=require("../actions/actions");

var defaultUser=(function(){
	return {
		username:"",
		savename:false
	}
});
var userStore=Reflux.createStore({
	listenables:actions,
	init:function(){
		this.user=defaultUser();
		var username=localStorage.getItem("username");
		var savename=localStorage.getItem("savename") == 1 ? true : false;
		if(savename){
			this.user.username=username;
			this.user.savename=savename;
		}
	},
	updateProfile:function(data,resp){
		sessionStorage.setItem("username",data.username);
		sessionStorage.setItem("uid",resp.uid);
		sessionStorage.setItem("sid",resp.sid);
		this.trigger(resp);
	},
	getUser:function(){
		return this.user;
	},
	checkUser:function(){
		var username=sessionStorage.getItem("username");
		if(username)
			return true;
		else
			return false;
	},
	getCurUser:function(){
		var username=sessionStorage.getItem("username");
		return {
			username:username
		}
	},
	setUser:function(username){ //save name  --持久化
		if(username){
			localStorage.setItem("username",username);
			localStorage.setItem("savename",1);
		}else{
			localStorage.setItem("savename",0);
		}
	},
	
	onGetAllUsersSuccess:function(data){
		// this.users=data;
		this.trigger(data);
	},

});
module.exports=userStore;