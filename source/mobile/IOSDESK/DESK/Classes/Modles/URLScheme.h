//
//  URLScheme.h
//  DESK
//
//  Created by 51desk on 15/6/25.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "JSONKit.h"
#ifndef DESK_URLScheme_h
#define DESK_URLScheme_h


#define debug

#ifdef debug
#define surl @"http://172.20.0.213:16001/WEBAPI"

#else 
#define surl @"http://172.20.0.189:16001/WEBAPI"

#endif


#define URL_GET_DOMAIN(_domain) [NSString stringWithFormat:@"%@/appserver/domain/%@",surl,_domain]
#define URL_POST_LOGIN_IN [NSString stringWithFormat:@"%@/auth/accessToken/",surl]
#define URL_GET_USERINFO [NSString stringWithFormat:@"%@/appserver/me/fetchall/",surl]




#define URL_GET_SECOND_SALES(model,subtype,granule,start_time,end_time) [NSString stringWithFormat:@"%@/appserver/data/analyses/satisfaction/?biz_model=%d&subtype=%d&time_granule=%@&start_time=%lld&end_time=%lld",surl,model,subtype,granule,start_time,end_time]

#endif
