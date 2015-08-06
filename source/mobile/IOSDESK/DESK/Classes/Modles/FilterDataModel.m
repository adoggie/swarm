//
//  FilterDataModel.m
//  DESK
//
//  Created by 51desk on 15/6/30.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "FilterDataModel.h"

@implementation FilterDataModel


static FilterDataModel *pFilterDataInst = nil;

+(FilterDataModel*)shareFilterData
{
    @synchronized(self)
    {
        if(pFilterDataInst == nil)
        {
            pFilterDataInst = [[FilterDataModel alloc] init];
        }
    }
    return pFilterDataInst;
}


+ (void)destroyFilterData
{
     pFilterDataInst=nil;
}


@end
