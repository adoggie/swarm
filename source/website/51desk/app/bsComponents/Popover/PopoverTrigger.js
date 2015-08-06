'use strict'

var React=require("react");
var cloneElement=React.cloneElement;
var dom=require("../utils/domUtils");
var createChainedFunction=require("../utils/createChainedFunction");
var OverlayMixin=require("../mixins/OverlayMixin");

function isOneOf(one,of){
	if(Array.isArray(of)){
		return of.indexOf(one) > -1;
	}
	return one === of;
}

var PopoverTrigger=React.createClass({
	mixins:[OverlayMixin],
	propTypes:{
		trigger:React.PropTypes.oneOfType([
	      React.PropTypes.oneOf(['click', 'hover', 'focus']),
	      React.PropTypes.arrayOf(
	        React.PropTypes.oneOf(['click', 'hover', 'focus'])
	      )
	    ]),
		placement:React.PropTypes.oneOf(['top','left','right','bottom']),
		defaultPopoverActive:React.PropTypes.bool,
		popover:React.PropTypes.node.isRequired,
	},
	getDefaultProps:function(){
		return {
			placement:'left',
			trigger:["hover",'click']
		}
	},
	getInitialState:function(){
		return {
			isPopoverActive:this.props.defaultPopoverActive === null ? 
			false : this.props.defaultPopoverActive,
			pleft:null,
			ptop:null
		}
	},
	componentDidMount:function(){ //挂载完
		if(this.defaultPopoverActive)
			this.updatePopoverPosition();
	},
	updatePopoverPosition:function(){ //确定弹出层 位置
		if(!this.isMounted())
			return
		var position=this.calcPopoverPosition();
		this.setState({
			pleft:position.left,
			ptop:position.top,
		})
	},
	calcPopoverPosition:function(){  //坐标原点
		var childOffset=this.getPosition();
		var popovernode=this.getOverlayDOMNode();
		var popoverHeight=popovernode.offsetHeight;
		var popoverWidth=popovernode.offsetWidth;
		var caretSize=8;
		switch (this.props.placement) {
	      case 'right':
	        return {
	          top: childOffset.top + childOffset.height / 2 - popoverHeight / 2,
	          left: childOffset.left + childOffset.width + caretSize
	        };
	      case 'left':
	        return {
	          top: childOffset.top + childOffset.height / 2 - popoverHeight / 2,
	          left: childOffset.left - popoverWidth - caretSize
	        };
	      case 'top':
	        return {
	          top: childOffset.top - popoverHeight - caretSize,
	          left: childOffset.left + childOffset.width / 2 - popoverWidth / 2
	        };
	      case 'bottom':
	        return {
	          top: childOffset.top + childOffset.height + caretSize,
	          left: childOffset.left + childOffset.width / 2 - popoverWidth / 2
	        };
	      default:
	        throw new Error('calcPopoverPosition(): No such placement of ['
	          + this.props.placement + '] found.');
	    }
	},
	getPosition:function(){
		var node=React.findDOMNode(this);
		var container=this.getContainerDOMNode();
		var offset=container.tagName === 'BODY' ? 
			dom.offset(node) : dom.position(node);
		var returnvalue={
			left:offset.left,
			top:offset.top,
			width:node.offsetWidth,
			height:node.offsetHeight
		};
		return returnvalue;
	},
	renderOverlay:function(){ //渲染 弹出层
		if(!this.state.isPopoverActive)
			return <span />;
		var popover=this.props.popover;
		return cloneElement(popover,{
			placement:this.props.placement,
			pleft:this.state.pleft,
			ptop:this.state.ptop,
		});
	},
	//事件函数
	toggle:function(){
		this.state.isPopoverActive ? this.close() : this.open();
	},
	open:function(){
		this.setState({
			isPopoverActive:true,
		},function(){
			this.updatePopoverPosition();
		})
	},
	close:function(){
		this.setState({
			isPopoverActive:false,
		})
	},
	render:function(){
		var child=React.Children.only(this.props.children);
		var props={};
		props.onClick=createChainedFunction(child.props.onClick,this.props.onClick);
		if(isOneOf("click",this.props.trigger)){
			props.onClick=createChainedFunction(this.toggle,props.onClick);
		}
		if(isOneOf("hover",this.props.trigger)){
			props.onMouseOver=createChainedFunction(this.toggle,props.onMouseOver);
			props.onMouseOut=createChainedFunction(this.toggle,props.onMouseOut);
		}

		return cloneElement(child,props);
	}
});
module.exports=PopoverTrigger;