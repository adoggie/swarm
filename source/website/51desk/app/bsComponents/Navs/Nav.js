'use strict'
var React=require("react");
var classNames=require("classnames");
var ClassNameMixin=require("../mixins/ClassNameMixin");

var Nav=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		classPrefix:React.PropTypes.string.isRequired,
		pills:React.PropTypes.bool,
		tabs:React.PropTypes.bool,
		justify:React.PropTypes.bool,
		componentTag:React.PropTypes.node,
		stacked:React.PropTypes.bool, // 在 pills 模式下，进行垂直堆叠
	},
	getDefaultProps:function(){
		return {
			classPrefix:"nav",
			componentTag:'ul',
		}
	},
	render:function(){
		var classSet=this.getClassSet();
		var Component=this.props.componentTag;
		classSet[this.prefixClass("tabs")]=this.props.tabs;
		classSet[this.prefixClass("pills")]=this.props.pills;
		classSet[this.prefixClass("stacked")]=this.props.pills && this.props.stacked;
		classSet[this.prefixClass("justified")]=this.props.justify;
		return (
				<Component {...this.props}
					className={classNames(this.props.className,classSet)}>
					{this.props.children}
				</Component>
			)
	}
});
module.exports=Nav;

