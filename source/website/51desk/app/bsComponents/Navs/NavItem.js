var React=require("react");
var classNames=require("classnames");
var ClassNameMixin=require("../mixins/ClassNameMixin");
var NavItem=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		componentTag:React.PropTypes.node.isRequired,
		active:React.PropTypes.bool,
		disabled:React.PropTypes.bool,
		divider:React.PropTypes.bool,
		dropdown:React.PropTypes.bool,
	},
	getDefaultProps:function(){
		return {
			classPrefix:"nav",
			componentTag:'li'
		}
	},	
	renderAnchor:function(classSet){
		var Component=props.componentTag;
		var linkprops={
			href:this.props.href,
			title:this.props.title,
			target:this.props.target,
		};
		return (
				<Component {...this.props}
					className={classNames(this.props.className,classSet)}>
					<a {...linkprops}>
						{this.props.children}
					</a>
				</Component>
			);
	},
	render:function(){
		var classSet=this.getClassSet(true);
		var props=this.props;
		var Component=props.componentTag;
		classSet[this.setClassNamespace("dropdown")]=props.dropdown;

		if(props.href){
			this.renderAnchor(classSet);
		}
		return (
				<Component {...props}
					className={classNames(props.className,classSet)}>
					<a href="javascript:">
						{this.props.children}
					</a>
				</Component>
			);
	}
});
module.exports=NavItem;