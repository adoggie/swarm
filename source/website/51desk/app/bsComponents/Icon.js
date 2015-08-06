'use strict'

var React=require("react");
var classNames=require("classnames");
var classNameMixin=require("./mixins/ClassNameMixin.js");

var Icon=React.createClass({
	mixins:[classNameMixin],
	propTypes:{
		icon:React.PropTypes.string.isRequired,
		componentTag:React.PropTypes.string.isRequired
	},
	getDefaultProps:function(){
		return {
			classPrefix:'glyphicon',
			componentTag:"span",
			icon:"search"
		}
	},
	render:function(){
		var classes=this.getClassSet();
		var props=this.props;
		var Component=props.href ? "a":props.componentTag;
		var prefixclass=this.prefixClass;

		classes[prefixclass(props.icon)]=true; //添加icon class
		classes[prefixclass("spin")]=props.spin;

		return (
				<Component
					{...props}
					className={classNames(this.props.className,classes)}>
					{props.children}
				</Component>
			)
	}
});

module.exports=Icon;