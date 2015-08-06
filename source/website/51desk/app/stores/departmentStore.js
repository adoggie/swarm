var Reflux=require("reflux");
var actions=require("../actions/actions");
var departmentStore=Reflux.createStore({
	listenables:actions,
	onGetAllDeptsSuccess:function(depts){
		this.depts=depts;
		this.trigger(depts);
	}
});
module.exports=departmentStore;