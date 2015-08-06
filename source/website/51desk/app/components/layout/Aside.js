'use strict'

var React=require("react");
var Reflux=require("reflux");
var Button=require("../../bsComponents/Form/Button");
var Icon=require("../../bsComponents/Icon");
var Sidebaritem=require("./Sidebaritem");
var actions=require("../../actions/actions");
var asideDataStore=require("../../stores/asideDataStore");

var Aside=React.createClass({
	mixins: [
	    require('react-router').Navigation, // needed for transitionto
	    Reflux.listenTo(asideDataStore,"update")
	  ],
	propTypes:{
	},
	getInitialState:function(){
		return {
			asidedata:asideDataStore.getData(this.props.menutitle,this.props.submenutitle),
		};
	},
	sideToggle:function(){
		this.props.onToggle();
	},
	redirectTo:function(item,subitem,e){ // 事件冒泡！！！！ --子菜单 事件
		e.preventDefault();
		e.stopPropagation();
		if(!subitem.active){
			this.transitionTo(subitem.to); // render 了两次 ！！！！
			actions.updateAside({title:item.title,active:true},{title:subitem.title,active:true});
		}
	},
	update:function(data){
		this.setState({
			asidedata:data,
		})
	},
	// componentWillReceiveProps:function(nextProps){
	// 	if(nextProps.menutitle != this.props.menutitle || nextProps.submenutitle !=this.props.submenutitle){
	// 		if(nextProps.submenutitle)
	// 			actions.updateAside({title:nextProps.menutitle,active:true},{title:nextProps.submenutitle,active:true});
	// 		else
	// 			actions.updateAside({title:nextProps.menutitle,active:true});
	// 	}
	// },
	menuClick:function(curMenu,e){ //主菜单事件
		e.stopPropagation();
		if(!curMenu.collapsable){ // 没有子菜单
			this.transitionTo(curMenu.to);  // render 了两次 ！！！！
			actions.updateAside({title:curMenu.title,active:true});
		}else{
			var subitemactive={title:'',active:false};
			curMenu.subMenus.forEach(function(subitem,i){
				if(subitem.active)
					subitemactive=subitem;
			});
			actions.updateAside({title:curMenu.title,active:!curMenu.active},{title:subitemactive.title,active:subitemactive.active});
		}  
	},
	renderSidebars:function(){
		return this.state.asidedata.map(function(item,i){
			var submenus=null;
			if(item.collapsable){
				submenus=item.subMenus.map(function(subitem,j){
					var imgitem=null;
					if(subitem.imgsrc){
						imgitem=(
							<img src={subitem.imgsrc} style={{marginRight:4}} height="24" width="40" />
							);
					}
					return (
						<li key={"submenus_"+j} className={subitem.active ? "active" : ""} onClick={this.redirectTo.bind(this,item,subitem)}>
							<a>
								{imgitem}<span>{subitem.title}</span>
							</a>
						</li>
						);
				}.bind(this));
			}
			return (
					<Sidebaritem key={"sidebaritem_"+i} icon={item.icon} menutitle={item.title} 
					collapsable={item.collapsable} active={item.active}
					onSelect={this.menuClick} curmenu={item}>
						{submenus}
					</Sidebaritem>
				)
		}.bind(this));
	},
	render:function(){
		console.log("aside render");
		this.state.olddata=this.state.asidedata;
		return (
				<div className="main-sidebar">
					<div className="sidebar" style={{height:"auto"}}>
						<div className="sidebar-toggle-wrapper">
							<Button onClick={this.sideToggle}  isABtn>
								<Icon icon="menu-hamburger" />
							</Button>
						</div>
						<div className="input-group">
							<input className="form-control" type="text" placeholder="Search..." name="q" />
							<Button onClick={this.sideToggle} style={{position:"absolute",right:"0"}}  isABtn>
								<Icon icon="search" />
							</Button>
						</div>
						<ul className="sidebar-menu">
							{this.renderSidebars()}
						</ul>
					</div>
				</div>
			)
	}
});
module.exports=Aside;