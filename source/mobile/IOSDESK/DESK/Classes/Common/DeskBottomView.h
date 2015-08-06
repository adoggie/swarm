//
//  DeskBottomView.h
//  DESK
//
//  Created by 51desk on 15/6/10.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeskUIConstantDefine.h"
@protocol  DeskBottomDelegate<NSObject>
-(void) DeskBottomClickAtIndext:(NSInteger)index;

@end

@interface DeskBottomView : UIView
@property (nonatomic,assign)id<DeskBottomDelegate> delegate;
@property (nonatomic,assign)NSInteger selectedAtIndex;
-(void)setTitles:(NSArray *)source Images:(NSArray*)images ;
-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts;
-(void)setCounts:(NSInteger)counts;
@end