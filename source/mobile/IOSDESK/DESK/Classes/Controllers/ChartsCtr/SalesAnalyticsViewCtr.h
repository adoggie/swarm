//
//  SalesAnalyticsViewCtr.h
//  DESK
//
//  Created by 51desk on 15/6/10.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "BaseViewController.h"
#import "DeskBottomView.h"
#import "SelectMiddleView.h"
#import "FSLineChart.h"
#import "DeskActionSheetPickerView.h"
#import "DeskLabelEX.h"
#import "FilterDataModel.h"
#import "ModuleDataErrorControl.h"


@interface SalesAnalyticsViewCtr : BaseViewController<DeskBottomDelegate,SelectMiddleDelegate,DeskActionSheetPickerViewDelegate,FSLineChartViewDelegate>
@property (nonatomic, strong) UIScrollView * ContentScrollView;
@property (nonatomic ,strong) DeskBottomView * deskbottomview;
@property (nonatomic,strong)SelectMiddleView * selectMiddleView;
@property (nonatomic,strong) UIView * lineview;
@property  (nonatomic,strong) UILabel * Leftdatalabel;
@property  (nonatomic,strong)UIButton * servicetimesbtn;
@property  (nonatomic,strong)UILabel * Leftamountlabel;
@property  (nonatomic,strong)UILabel * LeftamountNblabel;
@property  (nonatomic,strong)UILabel * RightamountNblabel;
@property  (nonatomic,strong)UILabel * Rightamountlabel;
@property  (nonatomic,strong) UILabel * Rightlabel;
@property (nonatomic,strong) FSLineChart  * bottomChart;
@property (nonatomic,strong) FSLineChart  * leftChart;
@property (nonatomic,strong) FSLineChart  * rightChart;
@property (nonatomic,strong) DeskLabelEX  * desklabelEX1;
@property (nonatomic,strong) DeskLabelEX  *desklabelEX2;
@property (nonatomic,strong) NSMutableArray* chartData;
@property (nonatomic,strong) NSMutableArray* chartData2;
@property (nonatomic,strong) NSMutableArray * chartKeyData;
@property (nonatomic,assign)int leftStatus;
@property (nonatomic ,strong)NSArray * leftArrayData;
@property (nonatomic,strong)NSArray * dateArray;


//@property (nonatomic,strong)UIControl * AnalyticsControl;
@property (nonatomic,strong)ModuleDataErrorControl * NoAnalyticsControl;
@end
