'use strict'

var React=require("react");
var classNames=require("classnames");
var Icon=require("../../bsComponents/Icon");
var Sidebaritem=React.createClass({
	propTypes:{
		collapsable:React.PropTypes.bool, //是否有下级菜单
		icon:React.PropTypes.string,
		menutitle:React.PropTypes.string,
		menuLeftIcon:React.PropTypes.string,
		active:React.PropTypes.bool,//是否处于默认激活状态
	},
	handlerToggle:function(e){
		e.preventDefault();
		this.props.onSelect(this.props.curmenu,e);
	},
	render:function(){
		var collapseitems=null,iconright=null,itemClassName="treeview",
		collapseClassName="collapse",menuLeftIcon="menu-left";
		if(this.props.collapsable && this.props.active){
			collapseClassName="collapse in";
			menuLeftIcon="menu-down";
			itemClassName="treeview active";
			collapseitems=(
					<ul className={classNames("treeview-menu",collapseClassName)}>
						{this.props.children}
					</ul>
				);
		}
		if(this.props.collapsable){
			iconright=(
				<Icon icon={menuLeftIcon} className="pull-right" key="menulefticon" />
				);
		}else{
			if(this.props.active){
				itemClassName="treeview active";
			}
		}
		return (
				<li className={itemClassName} onClick={this.handlerToggle}>
					<a href="javascript:">
						<Icon icon={this.props.icon} />
						<span className="menu-title">{this.props.menutitle}</span>
						{iconright}
					</a>
					{collapseitems}
				</li>
			);
	}
});
module.exports=Sidebaritem;