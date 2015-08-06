var Reflux=require("reflux");
var actions=require("../actions/actions");
var AsideData=require("../data/AsideData");

var asideDataStore=Reflux.createStore({
	listenables:actions,
	init:function(){
		this.data=AsideData; //初始数据
	},
	updateAside:function(menu,submenu){
		this.updateData(menu,submenu);
		this.trigger(this.data);
	},
	updateData:function(menu,submenu){
		submenu= submenu || {title:""};
		this.data.map(function(item,i){
			if(item.title == menu.title){
				if(menu.active)
					item.active=true;
				else
					item.active=false;
			}else{
				item.active=false;
			}
			item.subMenus && item.subMenus.map(function(subitem,j){
				if(subitem.title == submenu.title){
					if(submenu.active)
						subitem.active=true;
					else
						subitem.active=false;
				}else{
					subitem.active=false;
				}
			}.bind(this));
		}.bind(this));
	},
	getData:function(menutitle,submenutitle){
		if(menutitle && submenutitle)
			this.updateData({title:menutitle,active:true},{title:submenutitle,active:true});
		if(menutitle && !submenutitle)
			this.updateData({title:menutitle,active:true});
		return this.data;
	}
});
module.exports=asideDataStore;