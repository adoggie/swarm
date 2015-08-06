var Reflux=require("reflux");
var actions=require("../actions/actions");

var loginStore=Reflux.createStore({
	listenables:actions,
	loginError:function(msg){
		this.trigger(msg);
	},
	logout:function(){
		sessionStorage.removeItem("username");
		this.trigger();
	}
});
module.exports=loginStore;