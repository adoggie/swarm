//
//  FilterDataModel.h
//  DESK
//
//  Created by 51desk on 15/6/30.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterDataModel : NSObject
@property (nonatomic ,assign) int  DateType;
@property (nonatomic,assign) long long StartTime;
+(FilterDataModel*)shareFilterData;
+ (void)destroyFilterData;
@end
