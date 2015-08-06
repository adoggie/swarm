'use strict'

var React=require("react");

var Footer=React.createClass({
	showComponentUpdate:function(){
		return false;
	},
	render:function(){
		return (
			<div className="main-footer">
				<div className="pull-right hidden-xs">
		          <b>Version</b> 1.0
		        </div>
				<strong>Copyright &copy; 2014 51desk.cn</strong>
				All rights reserved.
			</div>
			)
	}
});
module.exports=Footer;