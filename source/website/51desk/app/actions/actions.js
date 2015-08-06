var Reflux=require("reflux");
var req=require("../mixins/reqs");
var systemval=require("../data/SystemValue");

var actions=Reflux.createActions({
	'getAllUsers':{children:['success']},
	'login':{},
	'updateProfile':{},
	'loginError':{},
	'logout':{},
	'updateAside':{},
	'register':{},
	'getAllDepts':{children:['success']},
});
//获取所有用户信息
actions.getAllUsers.listen(function(){
	var  self=this;
	req({
		url:'/app/data/users.json',
		method:'get',
		success:function(resp){
			if(resp.results){
				self.success(resp.arr);
			}
		}
	});
});
actions.login.listen(function(data){
	req({
		url:'/desk/login/check.do',
		data:data,
		type:'POST',
		success:function(resp){
			if(resp.status == systemval.successcode){
				actions.updateProfile(data,resp.result);
			}else{
				actions.loginError(resp.errmsg);
			}
		}
	});
})
actions.register.listen(function(data){

});
actions.getAllDepts.listen(function(){
	var self=this;
	req({
		url:'/app/data/depts.json',
		method:'get',
		success:function(resp){
			if(resp.results){
				self.success(resp.arr);
			}
		}
	})
})
module.exports=actions;