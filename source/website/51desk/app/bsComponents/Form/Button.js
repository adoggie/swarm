'use strict';

var React=require("react");
var classNames=require("classnames");
var ClassNameMixin=require("../mixins/ClassNameMixin");

var Button=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		classPrefix:React.PropTypes.string.isRequired,
		active:React.PropTypes.bool,
		block: React.PropTypes.bool,
	    disabled: React.PropTypes.bool,
	    radius: React.PropTypes.bool,
	    round: React.PropTypes.bool,
	    componentTag: React.PropTypes.node,
	    href: React.PropTypes.string,
	    target: React.PropTypes.string,
	    isABtn:React.PropTypes.bool,
	},
	getDefaultProps:function(){
		return {
			classPrefix:'btn',
			type:'button',
			bsStyle:'default'
		}
	},
	renderAnchor: function(classSet) {
	    var Component = this.props.componentTag || 'a';
	    var href = this.props.href || '#';
	    var classes=classNames(this.props.className, classSet);
	    //var props = omit(this.props, 'type');
	    if(this.props.isABtn){
	    	classes=classNames(this.props.className,this.props.classPrefix);
	    	href="javascript:";
	    }
    	return (
	      <Component
	        {...this.props}
	        href={href}
	        className={classes}
	        role="button">
	        {this.props.children}
	      </Component>
	    );
	  },
	renderButton:function(classSet){
		var Component=this.props.componentTag || "button";
		return (
				<Component 
					{...this.props}
					className={classNames(this.props.className,classSet)}>
					{this.props.children}
				</Component>
			)
	},
	render:function(){
		var classSet=this.getClassSet();
		var renderType=this.props.href || this.props.target || this.props.isABtn ? "renderAnchor" : "renderButton";

		this.props.block && (classSet[this.prefixClass('block')]=true);
		return this[renderType](classSet);
	}
})

module.exports=Button;
