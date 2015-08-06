//
//  CloseDataSelectController.h
//  DESK
//
//  Created by 51desk on 15/6/17.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "BaseViewController.h"
#import "DeskActionSheetPickerView.h"
#import "CalendarView.h"
#import "DeskPickerView.h"
#import "SelectMiddleView.h"
#import "DeskLabelEX.h"
#import "FilterDataModel.h"

@interface CloseDataSelectController : BaseViewController<CalendarDataSource, CalendarDelegate,SelectMiddleDelegate,DeskPickerViewDelegate>

@property (nonatomic,strong) CalendarView * calendarview;
@property (nonatomic,strong) SelectMiddleView * selectMiddleView;
@property (nonatomic,strong) DeskPickerView*  pickerView;
@property (nonatomic,strong) DeskLabelEX  * desklabelEX1;
@property  (nonatomic,strong) UILabel * selectlabel;
@property (nonatomic ,strong)  NSDictionary *dict;
@property (nonatomic,strong) NSArray * monthArray;
@property (nonatomic,strong) NSArray * YearArray;
@property (nonatomic,strong) NSArray * QArray;


@end
