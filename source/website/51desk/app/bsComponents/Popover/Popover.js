'use strict'

var React=require("react");
var classNames=require("classnames");
var ClassNameMixin=require("../mixins/ClassNameMixin.js");

var Popover=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		classPrefix:React.PropTypes.string.isRequired,
		placement:React.PropTypes.oneOf(['top','left','right','bottom']),
		pleft:React.PropTypes.number,
		ptop:React.PropTypes.number,
		noarrow:React.PropTypes.bool,
	},
	getDefaultProps:function(){
		return {
			classPrefix:'popover',
		}
	},
	render:function(){
  		var classSet=this.getClassSet();
  		var style={
  			left:this.props.pleft,
  			top:this.props.ptop,
  			display:"block",
  		}
  		var title=this.props.title ? 
  			<h3 className={this.prefixClass("title")}>{this.props.title}</h3> : "";
  		var arrow=this.props.noarrow ? 
  			"" : <div className={"arrow"}></div>;
  		return (
  				<div  style={style}
  					{...this.props}
  					className={classNames(classSet,this.props.placement,this.props.className)}>
  					{arrow}
  					{title}
  					<div className={this.prefixClass("content")}>
  						{this.props.children}
  					</div>
  				</div>
  			)

	}
});
module.exports=Popover;