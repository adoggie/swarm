'use strict'

var React=require("react");
var classNames=require("classnames");
var ClassNameMixin=require("../mixins/ClassNameMixin");

var GridCol=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		classPrefix:React.PropTypes.string.isRequired,
		componentTag:React.PropTypes.node.isRequired,
		xs:React.PropTypes.number,
		sm:React.PropTypes.number,
		md:React.PropTypes.number,
		lg:React.PropTypes.number,
		xsOffset:React.PropTypes.number,
		smOffset:React.PropTypes.number,
		mdOffset:React.PropTypes.number,
		lgOffset:React.PropTypes.number,
		xsPull:React.PropTypes.number, //左
		smPull:React.PropTypes.number,
		mdPull:React.PropTypes.number,
		lgPull:React.PropTypes.number,
		xsPush:React.PropTypes.number,//右移
		smPush:React.PropTypes.number,
		mdPush:React.PropTypes.number,
		lgPush:React.PropTypes.number,
	},
	getDefaultProps:function(){
		return {
			classPrefix:"col",
			componentTag:'div'
		}
	},
	render:function(){
		var Component=this.props.componentTag;
		var props=this.props;
		var prefixClass=this.prefixClass;
		var classSet=this.getClassSet(true);

		['xs','sm','md','lg'].forEach(function(size){
			var prop=size;

			if(props[prop])
				classSet[prefixClass(prop+"-"+props[prop])]=true;

			prop = size +"Offset";
			if(props[prop])
				classSet[prefixClass(size + "-offset-"+props[prop])]=true;

			prop = size +"Pull";
			if(props[prop])
				classSet[prefixClass(size + "-pull-"+props[prop])]=true;

			prop = size +"Push";
			if(props[prop])
				classSet[prefixClass(size + "-push-"+props[prop])]=true;

			if(props[size+"Center"])
				classSet[prefixClass(size+"-centerblock")]=true;
		})
		return (
				<Component
					{...props}
					className={classNames(props.className,classSet)}>
					{props.children}
				</Component>
			)
	}
});
module.exports=GridCol;