//
//  DeskCommonConfig.h
//  RongCloud
//

//

#ifndef RongCloud_CommonConfig_h
#define RongCloud_CommonConfig_h


#define DEV_FAKE_SERVER @"http://"
#define PRO_FAKE_SERVER @""




#define CHECK_PASSWORD_ENABLE 0

//当前版本
#define IOS_FSystenVersion            ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS_DSystenVersion            ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define IOS_SSystemVersion            ([[UIDevice currentDevice] systemVersion])

//当前语言
#define CURRENTLANGUAGE           ([[NSLocale preferredLanguages] objectAtIndex:0])


//是否Retina屏
#define isRetina                  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) :NO)
//是否iPhone5
#define ISIPHONE                  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define ISIPHONE5                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define Ipad [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone

/*  88px */
#define def_addHeight [[UIScreen mainScreen] bounds].size.height-480

#define IOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue]-7.0)>=0?YES:NO)


#define Release(obj) [obj release]
#define Dealloc(obj) [obj release],obj=nil
#define SetNil(obj) obj=nil

#endif



