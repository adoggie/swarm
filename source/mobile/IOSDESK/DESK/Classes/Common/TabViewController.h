//
//  TabViewController.h
//  DESK
//
//  Created by 51desk on 15/6/9.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeskCommonConfig.h"
#import "DeskUIConstantDefine.h"
#import "PublicMethods.h"
#import "BaseViewController.h"


@protocol TabButtonManagerDelegate <NSObject>
-(void)TabButtonManageClickAtIndext:(NSInteger)index;
@end

@protocol TabButtonDelegate <NSObject>
-(void)TabButtonClickAtIndext:(NSInteger)index;
@end

@interface TabViewController : BaseViewController<TabButtonDelegate>

@property (nonatomic,retain)UIColor *color;
@property (nonatomic,retain)NSMutableArray *viewControls;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,assign)id<TabButtonManagerDelegate> delegate;
-(void)setControlsTitles:(NSArray *)titles;
-(void)setControlsImages:(NSArray *)images;
-(void)selectControlViewAtIndex:(NSInteger)index;
-(void)setTabButtonsFrame:(CGRect)frame withColor:(UIColor *)color;
@end



@interface TabButtonsView : UIScrollView
@property (nonatomic,assign)id<TabButtonDelegate> tabviewdelegate;
@property (nonatomic,assign)NSInteger selectedAtIndex;
-(void)setTitles:(NSArray *)source Images:(NSArray*)images selectColor:(UIColor *)color;
-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts;
-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts canShowGratLine:(BOOL)canShow;
-(void)selectAtIndex:(NSInteger)index;
-(void)resetStatus;
@end


@interface ButtonEx : UIButton
{
    BOOL selFlag;
    UIColor *_selectColorLine;
}
-(void)onClick:(BOOL)click;
-(void)selectColor:(UIColor *)color;
@property (nonatomic,assign)BOOL canShowGrayLine;
@end
