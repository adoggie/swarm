var React=require('react');
var pagerData=require("../data/PagerData");
var sysvalue=require("../data/SystemValue");

module.exports={
	pageSize:sysvalue.pageSize,
	pageCounts:null,
	getPagerData:function(index,count){
		var pagesize=sysvalue.pageSize,pagedata=pagerData,pagecount=sysvalue.pageCount;
		if(count > 0){
			var pages=count%pagesize ? (parseInt(count / pagesize)+1) : parseInt(count / pagesize);
			this.pageCounts=pages;
			if(pages <= pagecount){
				for(var i=0;i<pages;i++){
					var title=i+1;
					var page={
						title:title,
						link:"#"+title,
					};
					if(index == title)
						page.active=true;
					pagedata.pages[i]=page;
				}
			}else{
				if(index >3){
					pagedata.firstDisabled=false;
				}else{
					pagedata.firstDisabled=true;
				}
				if(index >1){
					pagedata.prevDisabled=false;
				}else{
					pagedata.prevDisabled=true;
				}
				for(var i=0;i<pagecount;i++){
					var page={
						title:null,
						link:"#",
					};
					if(index < 3){
						page.title=(i+1);
					}else{
						if(index == pages || index == (pages-1)){
							page.title=pages-4+i;
						}else{
							page.title=index-2+i;
						}
					}	
					page.link="#"+page.title;
					if(index == page.title)
						page.active=true;
					pagedata.pages[i]=page;
				}
				if(index < pages){
					pagedata.nextDisabled=false;
				}else{
					pagedata.nextDisabled=true;
				}
				if(index <= (pages-3)){
					pagedata.lastDisabled=false;
				}else{
					pagedata.lastDisabled=true;
				}
			}
			return pagedata;
		}else{
			return null;
		}
	}
};