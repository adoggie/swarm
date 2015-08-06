//
//  PublicMethods.h
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PublicMethods : NSObject

+ (NSString *)getPinYinFrom:(NSString *)chinese;
+(UIColor*) getAlphaColor: (NSString *) stringToConvert alpha:(float)a;
+(NSString *)getFormatTime:(long long)time;
+(NSTimeInterval)getIntervalTime:(NSString *)time;
+(NSString *)getFormatDate:(long long)time Type:(NSString *)str;
+(long long )getCurrentIntervalTime;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL) isEisooEmail:(NSString *)email;
+(BOOL) isValidateMobile:(NSString *)mobile;
+(BOOL)isValidateWebSite:(NSString *)website;
+(NSString *)returnFormatString:(NSString *)str;
+(NSString *)getFormatHourTime:(long long)time;
+(UIImage *)createImageWithColor:(UIColor *)color;
+(long long)getIntervalTimeSince:(NSTimeInterval)time Day:(int)day;

@end
