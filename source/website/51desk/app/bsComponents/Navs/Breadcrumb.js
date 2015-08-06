'use strict'

var React=require("react");
var classNames=require("classnames");
var ClassNameMixin=require("../mixins/ClassNameMixin");

var Breadcrumb=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		componentTag:React.PropTypes.node,
	},
	getDefaultProps:function(){
		return {
			classPrefix:'breadcrumb',
			componentTag:'ol'
		}
	},
	render:function(){
		var classes=this.getClassSet();
		var Component=this.props.componentTag;
		return (
				<Component {...this.props}
					className={classNames(classes,this.props.className)}>
					{this.props.children}
				</Component>
			)
	}
});
Breadcrumb.item=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		active:React.PropTypes.bool,
		href:React.PropTypes.string,
		title:React.PropTypes.string,
		target:React.PropTypes.string,
	},
	renderAnchor:function(classed){
		return (
				<li {...this.props}
					className={classes}>
					<a href={this.props.href} title={this.props.title} target={this.props.target}>
						{this.props.children}
					</a>
				</li>
			)
	},
	render:function(){
		var classes=classNames(this.props.className);
		if(this.props.href){
			return this.renderAnchor(classes);
		}
		return (
				<li {...this.props}
					className={classes}>
					{this.props.children}
				</li>
			)
	}
});
module.exports=Breadcrumb;