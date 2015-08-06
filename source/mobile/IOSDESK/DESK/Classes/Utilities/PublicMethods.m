//
//  PublicMethods.m
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "PublicMethods.h"
@implementation PublicMethods
+ (NSString *)getPinYinFrom:(NSString *)chinese
{
    if (chinese==nil) {
        return nil;
    }
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFMutableStringRef)[NSMutableString stringWithString:chinese]);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    __block NSMutableString *aNSString = (__bridge NSMutableString *)string;
    [aNSString autorelease];

    return [aNSString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 32] withString:@""];
}


+(UIColor *) getAlphaColor: (NSString *) stringToConvert alpha:(float)a
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:a];
}


+(UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+(NSString *)getFormatTime:(long long)time
{
    if (time==0) {
        return @"暂无";
    }
    NSString *temp=[NSString stringWithFormat:@"%lld",time];
    NSRange range=NSMakeRange(0, 10);
    if (temp.length>10) {
        temp = [temp substringWithRange:range];
    }
    time=[temp longLongValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy/MM/dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return destDateString;
}

+(NSString *)getFormatHourTime:(long long)time
{
    if (time==0) {
        return @"暂无";
    }
    NSString *temp=[NSString stringWithFormat:@"%lld",time];
    NSRange range=NSMakeRange(0, 10);
    if (temp.length>10) {
        temp = [temp substringWithRange:range];
    }
    time=[temp longLongValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return destDateString;
}

+(NSString *)getFormatDate:(long long)time Type:(NSString *)str
{
    if (time==0) {
        return @"暂无";
    }
    NSString *temp=[NSString stringWithFormat:@"%lld",time];
    NSRange range=NSMakeRange(0, 10);
    if (temp.length>10) {
        temp = [temp substringWithRange:range];
    }
    time=[temp longLongValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:str];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return destDateString;
}

+(NSTimeInterval)getIntervalTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    NSDate *destDate= [dateFormatter dateFromString:time];
    [dateFormatter release];
    
    return [destDate timeIntervalSince1970];
}
+(long long )getCurrentIntervalTime
{
    NSDate *destDate= [NSDate date];
    return [destDate timeIntervalSince1970];
}

+(long long)getIntervalTimeSince:(NSTimeInterval)time Day:(int)day
{
    return  time-day*24*3600;
}

+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL) isEisooEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[Ee][Ii][Ss][Oo][Oo].[Cc][Oo][Mm]";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL) isValidateMobile:(NSString *)mobile
{
    
    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+(BOOL)isValidateWebSite:(NSString *)website
{

    NSString *phoneRegex = @"^http://([\\w-]+\\.)+[\\w-]+([\\w- ./?%&=]*)?$|([\\w-]+\\.)+[\\w-]+([\\w- ./?%&=]*)?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:website];
}
+(NSString *)returnFormatString:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}



@end
