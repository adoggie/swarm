'use strict'

var React=require("react");
var Reflux=require("reflux");
var Dropdown=require("../../bsComponents/Dropdown/Dropdown");
var Icon=require("../../bsComponents/Icon");
var Util=require("../Util");
var loginStore=require("../../stores/loginStore");
var userStore=require("../../stores/userStore");
var actions=require("../../actions/actions");

var Header=React.createClass({
	mixins: [
		Util,
	    require('react-router').Navigation, // needed for transitionto
	    Reflux.listenTo(loginStore,'logoutCallback')
	  ],
	handleClick:function(type){
		switch(type){
			case "layout":
				actions.logout();
			break;
		}
	},
	logoutCallback:function(){
		this.transitionTo("login");
	},
	render:function(){
		console.log("header render");
		var beforeElement=(
				<span className="userWrapperSpan">
				<img className="user-image" alt="User" src="/app/images/user.png" />
				<span>{userStore.getCurUser().username}</span></span>
			);
		return (
			<div className="main-header">
				<div className="logo">
					<span>
						51Desk
					</span>
				</div>
				<div className="navbar navbar-static-top">
					<div className="navbar-custom-menu">
						<ul className="nav navbar-nav">
							<Dropdown icon="bell" contentClass="dropdown-menu-anchor" labelClassName="label-success" labelTipCount="4">
								<Dropdown.item>test 标题 one</Dropdown.item>
								<Dropdown.item>test 标题 two</Dropdown.item>
							</Dropdown>
							<Dropdown icon="envelope" contentClass="dropdown-menu-anchor" labelClassName="label-warning" labelTipCount="6">
								<Dropdown.item>test 标题 one</Dropdown.item>
								<Dropdown.item>test 标题 two</Dropdown.item>
							</Dropdown>
							<Dropdown icon="calendar" contentClass="dropdown-menu-anchor" 
								labelClassName="label-danger" labelTipCount="2">
								<Dropdown.item>test 标题 one</Dropdown.item>
								<Dropdown.item divider></Dropdown.item>
								<Dropdown.item>test 标题 two</Dropdown.item>
							</Dropdown>
							<Dropdown icon="menu-down" contentClass="dropdown-menu-anchor" beforeElement={beforeElement} className="userWrap">
								<Dropdown.item>
									<Icon icon="user" /><span>Friends</span>
									<span className="label label-danger">2</span>
								</Dropdown.item>
								<Dropdown.item>
									<Icon icon="cog" /><span>Setting</span>
								</Dropdown.item>
								<Dropdown.item center onClick={this.handleClick.bind(this,"layout")}>
									<Icon icon="off" /><span>Layout</span>
								</Dropdown.item>
							</Dropdown>
						</ul>
					</div>
				</div>
			</div>
			)
	}
});
module.exports=Header;