'use strict';

var React=require("react");
var classnames=require("classnames");
var ClassNameMixin=require("./mixins/ClassNameMixin");

var ButtonToolbar=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		classPrefix:React.PropTypes.string.isRequired
	},
	getDefaultProps:function(){
		return {
			classPrefix:'btn-toolbar'
		}
	},
	render:function () {
		var classSet=this.getClassSet();
		return (
				<div {...this.props} 
					className={classnames(this.props.className,classSet)}>
					{this.props.children}
				</div>
			)
	}
})