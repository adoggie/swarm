'use strict'

var React=require("react");
var ClassNameMixin=require("../mixins/ClassNameMixin");
var classNames=require("classnames");
var Button=require("../Form/Button");
var Icon=require("../Icon");
var Events=require("../utils/Events");
var isNodeInTree=require("../utils/isNodeInTree");
var constants=require("../constants");

var Dropdown=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		title:React.PropTypes.string,//如果是按钮 title 为必须
		btnStyle:React.PropTypes.string,
		btnInlineStyle:React.PropTypes.object,
		toggleClassName:React.PropTypes.string,
		contentInlineStyle:React.PropTypes.object,
		contentClass:React.PropTypes.string,
		drop:React.PropTypes.bool, // 是否有下拉箭头 true you  默认false
		navItem:React.PropTypes.bool, //是否是导航栏 item ？ li : div 默认true
		onOpen:React.PropTypes.func,//open callback
		onClose:React.PropTypes.func,
		icon:React.PropTypes.string,
		iconclassname:React.PropTypes.string,
		labelClassName:React.PropTypes.string, // 提示tip，根据 改属性判断
		labelTipCount:React.PropTypes.string,
	},
	getDefaultProps:function(){
		return {
			classPrefix:'dropdown',
			contentTag:'ul',
			drop:false,
			navItem:true,
		}
	},
	getInitialState:function(){
		return {
			open:false
		}
	},
	componentWillMount:function(){
		this.unBindOuterHandlers();
	},
	bindOuterHandlers:function(){
		Events.on(document,'click',this.handlerOuterClick);
	},
	unBindOuterHandlers:function(){
		Events.off(document,'click',this.handlerOuterClick);
	},
	handlerOuterClick:function(e){
		if (isNodeInTree(e.target, React.findDOMNode(this))) {
	      return false;
	    }
	    this.setDropdownState(false);
	},
	setDropdownState:function(state,callback){
		if(state)
			this.bindOuterHandlers();
		else
			this.unBindOuterHandlers();
		this.setState({open:state},function(){
			callback && callback();
			state && this.props.onOpen && this.props.onOpen();
			!state && this.props.onClose && this.props.onClose();
		})
	},
	handlerDropdownClick:function(e){
		e.preventDefault();
		this.setDropdownState(!this.state.open);
	},
	render:function(){
		var classSet=this.getClassSet();
		var Component=this.props.navItem ? 'li' :'div';
		if(!this.props.drop){
			var iconcart=(
				<Icon icon={this.props.icon} className={this.props.iconclassname}/>
				);
		}
		else{
			var iconcart=(
				<Icon icon="caret" className={this.props.iconclassname} />
				);
		}
		var animation=this.props.open ? 
			this.setClassNamespace("animation-slide-top-fixed") :
			this.setClassNamespace("dropdown-animation");
		var ContentTag=this.props.contentTag;
		classSet[constants.CLASSES.open] = this.state.open;
		var beforeElement=this.props.beforeElement || null;
		var labelTips=null;
		if(this.props.labelClassName){
			labelTips=(
				<span className={classNames("label",this.props.labelClassName)}>{this.props.labelTipCount}</span>
				);
		}
		if(this.props.title){
			var content=(
				<Button bsStyle={this.props.bsStyle} ref="dropdowntoggle" onClick={this.handlerDropdownClick}
					className={classNames(this.prefixClass("toggle"),this.props.toggleClassName)}
					style={this.props.btnInlineStyle}>
					{this.props.title}
					{" "}
					{iconcart}
				</Button>
				);
		}
		else{
			var content=(
				<a className={classNames(this.prefixClass("toggle"),this.props.toggleClassName)} ref="dropdowntoggle" 
					onClick={this.handlerDropdownClick}>
					{beforeElement}
					{iconcart}
					{labelTips}
				</a>
				);
		}
		return (
			<Component
				className={classNames(this.props.className,classSet)}>
				{content}
				<ContentTag ref="dropdowncontent" 
					style={this.props.contentInlineStyle}
					className={classNames(this.prefixClass("menu"),animation,this.props.contentClass)}>
					{this.props.children}
				</ContentTag>
			</Component>
			)
	}
});
Dropdown.item=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		href:React.PropTypes.string,
		title:React.PropTypes.string,
		target:React.PropTypes.string,
		header:React.PropTypes.bool,
		divider:React.PropTypes.bool,
		center:React.PropTypes.bool,
	},
	getDefaultProps:function(){
		return {
			header:false
		}
	},
	render:function(){
		var classSet=this.getClassSet();
		var children=null,astyle=null;
    	classSet[this.setClassNamespace('dropdown-header')] = this.props.header;
    	if(this.props.center)
    		astyle={textAlign:"center"};
    	if(this.props.header)
    		children=this.props.children;
    	else if(!this.props.divider){
    		children=(
    			// onClick={this.props.onclick} 
    			<a href={this.props.href} title={this.props.title}
    				target={this.props.target} style={astyle}>
    				{this.props.children}
    			</a>
    			);
    	}
    	return (
    		<li {...this.props} 
    			href={null} title={null} className={classNames(this.props.className,classSet)}>
    			{children}
    		</li>
    		)
	}
});
module.exports=Dropdown;