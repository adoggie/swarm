'use strict'
var React=require("react");
var classNames=require("classnames");
var Nav=require("./Nav");
var NavItem=require("./NavItem");
var ClassNameMixin=require("../mixins/ClassNameMixin");

var Tabs=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		data:React.PropTypes.array,
		onSelect:React.PropTypes.func,
		defaultkey:React.PropTypes.any,
		justify:React.PropTypes.bool,
		wrapperClassName:React.PropTypes.string,
	},
	getDefaultProps:function(){
		return {
			classPrefix:'tab'
		}
	},
	getInitialState:function(){
		var defaultkey=this.props.defaultkey || this.getDefaultActiveKey(this.props.children);
		return {
			activekey:defaultkey
		}
	},
	getDefaultActiveKey:function(children){
		var defaultackey=null;

		React.Children.forEach(children,function(child){
			if(defaultackey == null)
				defaultackey=child.props.eventkey;
		})
		return defaultackey;
	},
	componentWillReceiveProps:function(nextProps){
		if(nextProps.defaultkey != this.state.defaultkey){
			this.setState({
				activekey:nextProps.defaultkey
			})
		}
	},
	handleClick:function(key,disabled,e){ //tab 切换事件
		e.stopPropagation();
		var activekey=this.state.activekey;
		if(!disabled){
			if(this.props.onSelect){
				this.props.onSelect(key);
			}
			if(activekey !=key){
				this.setState({
					activekey:key
				})
			}
		}
	},
	renderWrapper:function(children){
		return (
				<div className={this.props.wrapperClassName}>
					{children}
				</div>
			)
	},
	renderNavWrapper:function(children){
		var TabNav=Nav;
		return (
			<TabNav key="tabsNav" justify={this.props.justify} tabs>
				{children}
			</TabNav>
			);
	},
	renderNav:function(){
		var activekey=this.state.activekey;
		var self=this;
		return React.Children.map(this.props.children,function(child,index){
			if(child){
				var key=child.props.eventkey || index;
				var disabled=child.props.disabled;
				return (
					<NavItem key={'navitem'+key} 
						active={key === activekey}
						disabled={disabled} 
						onClick={self.handleClick.bind(self,key,disabled)}>
						{child.props.title}
					</NavItem>
					);
			}
			})
	},
	renderContentWrapper:function(children){
		return (
				<div className={this.prefixClass("content")}>
					{children}
				</div>
			);
	},
	renderContent:function(){
		var activekey=this.state.activekey;
		return React.Children.map(this.props.children,function(child,index){
			if(child){
				var key=child.props.eventkey ? child.props.eventkey : index;
				return (
					<Tabs.item key={'navcontent'+key} active={key === activekey}>
						{child.props.children}
					</Tabs.item>
				);
			}
		})
	},
	renderData:function(){
	},
	render:function(){
		console.log("tabs render");
		var children=this.props.data ? this.renderData() : {};
		return this.renderWrapper([
				this.renderNavWrapper(children.nav || this.renderNav()),
				this.renderContentWrapper(children.content || this.renderContent())
			]);
	}
});
Tabs.item=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		title:React.PropTypes.any,
		active:React.PropTypes.bool,
		key:React.PropTypes.any,
		disabled:React.PropTypes.bool,
	},
	render:function(){
		var classes={};
		classes[this.setClassNamespace("tab-pane")]=true,
		classes[this.setClassNamespace("active")]=this.props.active;
		classes[this.setClassNamespace("fade")]=true;
		classes[this.setClassNamespace("in")]=this.props.active;
		return (
				<div className={classNames(classes)} {...this.props}>
					{this.props.children}
				</div>
			);
	}
});
module.exports=Tabs;