'use strict'

var React=require("react");
var classNames=require('classnames');
var ClassNameMixin=require("../mixins/ClassNameMixin.js");

var GridRow=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		classPrefix:React.PropTypes.string.isRequired,
		componentTag:React.PropTypes.node.isRequired,
	},
	getDefaultProps:function(){
		return {
			classPrefix:"row",
			componentTag:'div'
		}
	},
	render:function(){
		var Component=this.props.componentTag;
		var classSet=this.getClassSet();
		var props=this.props;

		return (
				<Component
					{...props}
					className={classNames(props.className,classSet)}>
					{props.children}
				</Component>
			)
	}
});
module.exports=GridRow;