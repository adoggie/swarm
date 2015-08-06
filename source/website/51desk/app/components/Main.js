'use strict'

var React=require("react");
var Router = require('react-router');
var Header=require("./layout/Header");
var Aside=require("./layout/Aside");
var Footer=require("./layout/Footer");
//pages
var Extention=require("./pages/Extention");
var Dashbord=require("./pages/Dashbord");
var Users=require("./pages/Users");
//
var Util=require("./Util");
var userStore=require("../stores/userStore");
var Breadcrumb=require("../bsComponents/Navs/Breadcrumb");
var Icon=require("../bsComponents/Icon");

var Main=React.createClass({
	mixins:[Router.Navigation,Router.State,Util],
	getInitialState:function(){
		return {
			expanded:true,
		}
	},
	handleToggle:function(){
		this.setState({expanded:!this.state.expanded});
	},
	render:function(){
		var sidebarClasses=null,secmenu=this.getParams().secmenu,
		submenu=this.getParams().menu,online=userStore.checkUser();
		if(!online){
			this.transitionTo("login");
		}
		if(!this.state.expanded)
			sidebarClasses="sidebar-collapse";
		else
			sidebarClasses="";
		var content=null;
		switch(secmenu){
			case "Extensions":
				content=(
					<Extention menu={submenu} />
					);
			break;
			case "Dashbord":
				content=(
					<Dashbord menu={secmenu} />
					);
			break;
			case 'Team':
				if(submenu == "Users")
					content=(
							<Users />
						);
			break;
		}
		return (
				<div className={sidebarClasses} key="divwrapper" style={{position:"relative"}}>
					<Header key="headerwrapper" />
					<Aside onToggle={this.handleToggle} key="asidewrpper" menutitle={secmenu} submenutitle={submenu}/>
					<div className="content-wrapper" key="contentwrapper" style={{minHeight:this.getContentMinHeight()}}>
						<Breadcrumb>
							<Breadcrumb.item>
								<Icon icon="home"/>Home
							</Breadcrumb.item>
							<Breadcrumb.item>{secmenu}</Breadcrumb.item>
							{submenu ? (<Breadcrumb.item>{submenu}</Breadcrumb.item>) :  null}
						</Breadcrumb>
						<div className="content">
							{content}
						</div>
					</div>
					<Footer />
				</div>
			)
	}
});
module.exports=Main;