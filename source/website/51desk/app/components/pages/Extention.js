'use strict'

var React=require("react");
var systemval=require("../../data/SystemValue");

var Extention=React.createClass({
	propTypes:{
		menu:React.PropTypes.string,
		hasConnected:React.PropTypes.bool,
	},
	getInitialState:function(){
		return {
			hasConnected:false,
		}
	},
	render:function(){
		var menuname=this.props.menu,title=null,connectdesc=null,connecthref=null;
		switch(menuname){
			case 'Salesforce.com':
				title="Salesforce";
				connecthref=systemval.sfurl+systemval.uid;
			break;
			case 'Desk.com':
				title="Desk";
				connecthref=systemval.deskurl;
			break;
		}
		if(this.state.hasConnected){
			connectdesc="Re-Connect";
		}else{
			connectdesc="Connect";
		}
		return (
				<div>
					<h3>{title}</h3>
					<p>Shows related information about contacts,accounts and more</p>
					<div>
						<ul className="extendUl">
							<li>1.{connectdesc} to <a href={connecthref} target="_blank">{title}</a></li>
							<li>2.Enable {title} data on user profiles</li>
							<li>&nbsp;&nbsp;&nbsp;<input type="checkbox" id="extendckid" /><label htmlFor="extendckid">&nbsp;Enable {title} data to display on a user profiles page in 51desk.</label></li>
						</ul>
					</div>
				</div>
			)
	}
});
module.exports=Extention;