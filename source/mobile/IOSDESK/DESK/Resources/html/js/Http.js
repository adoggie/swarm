(function ($,http){
	http.getData=function(parame, callback)
	{
	
		var urlstr="http://172.20.0.189:16001/WEBAPI/appserver/data/analyses/satisfaction/?biz_model=1&subtype=5&time_granule=day&start_time=1435483035&end_time=1438075035";
		$.ajax({
			   type:"get",
			   url:urlstr,
			    dataType:"json",  
			    headers:{  
			    	"IF-VERSION":"1",
			    	"SESSION-TOKEN":"eyJ1c2VyX25hbWUiOiAid2FuZ2RhemhpIiwgImRvbWFpbiI6ICJ5bG0iLCAidXNlcl9pZCI6IDEsICJ1c2VyX3R5cGUiOiAxfQ=="
			    },
			    success:function(respose)
			    {
                   return callback(respose);
			    },
			    error:function(respose)
			    {
			      	return callback(respose);
			    }

		})

		
		
		
	}
	
}(jQuery,window.http={}))
