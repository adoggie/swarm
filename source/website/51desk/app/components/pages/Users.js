var React=require('react');
var Tabs=require("../../bsComponents/Navs/Tabs");
var Icon=require("../../bsComponents/Icon");
var UserOption=require("../modules/UserOption");
var UserList=require("../modules/UserList");

var Users=React.createClass({
	mixins:[],
	propTypes:{
		othertabs:React.PropTypes.array,
	},
	getInitialState:function(){
		return {
			defaultkey:"-2",
			othertabs:[],
			othertabsid:[],
		}
	},
	editUserHandle:function(id,user,e){
		e.preventDefault();
		e.stopPropagation();
		var curdata=user;
		var addTab=(
			<Tabs.item title={curdata.lastname} eventkey={id+''}>
				<UserOption data={curdata} />
			</Tabs.item>
			);
		var curtabs=this.state.othertabs;
		var curtabsid=this.state.othertabsid;
		if(curtabsid.indexOf(id) > -1){
			this.setState({
				defaultkey:id+'',
			})
		}else{
			curtabs.push(addTab);
			curtabsid.push(id);
			this.setState({
				defaultkey:id+'',
				othertabs:curtabs,
				othertabsid:curtabsid,
			})
		}
	},
	render:function(){
		var firstTitle=(
				<Icon icon="home" />
			);
		return (
				<div>
					<h4>Manager your system users</h4>
					<Tabs defaultkey={this.state.defaultkey}>
						<Tabs.item title={firstTitle} eventkey="-2">
							<UserList itemClick={this.editUserHandle} />
						</Tabs.item>
						<Tabs.item title="add users" eventkey="-1">
							<UserOption />
						</Tabs.item>
						{this.state.othertabs}
					</Tabs>
				</div>
			)
	}
});
module.exports=Users;