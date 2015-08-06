//
//  SalesAnalyticsViewCtr.m
//  DESK
//
//  Created by 51desk on 15/6/10.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "SalesAnalyticsViewCtr.h"
#import "FunnelViewController.h"
#import "CloseDataSelectController.h"

#define middle_Y (isRetina?135:155)
@interface SalesAnalyticsViewCtr ()

@end

@implementation SalesAnalyticsViewCtr


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
       [self initbackBarItem];
    
    _leftStatus=4;
    [FilterDataModel shareFilterData].DateType=0;
    [FilterDataModel shareFilterData].StartTime=[PublicMethods getCurrentIntervalTime];
    self. leftArrayData=[[NSArray alloc]initWithObjects:@"Service Times",@"Service Satisfication",@"Problem Processing Time", nil];
    self. dateArray=[[NSArray alloc]initWithObjects:@"day",@"week",@"month", @"quarter",nil];
    

    
    self.chartData = [NSMutableArray array];
    

    self.chartData2 = [NSMutableArray array];
    
    
   self. chartKeyData= [NSMutableArray array];
    

    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.ContentScrollView];
    [self.view addSubview:self.deskbottomview];
    [self.view addSubview:self.selectMiddleView];
    [self.view addSubview:self.lineview];
    [self.view addSubview:self.Leftdatalabel];
    [self.view addSubview:self.servicetimesbtn];
    [self.view addSubview:self.Leftamountlabel];
    [self.view addSubview:self.LeftamountNblabel];
    [self.view addSubview:self.Rightamountlabel];
    [self.view addSubview:self.RightamountNblabel];
    [self.view addSubview:self.Rightlabel];
    [self.view addSubview:self.bottomChart];
    [self.view addSubview:self.rightChart];
    [self.view addSubview:self.leftChart];
    [self.view addSubview:self.desklabelEX1];
    [self.view addSubview:self.desklabelEX2];
    
    [self.view addSubview:self.NoAnalyticsControl];
    
    // Do any additional setup after loading the view.
    
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_selectMiddleView  selectAtIndex:[FilterDataModel shareFilterData].DateType];
  
    _ContentScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, VIEW_SCREEN_HEIGHT-44);
    

    _lineview.frame=CGRectMake(SCREEN_WIDTH/2, 30, 1, middle_Y-60);
    DLog(@"%d",middle_Y);
    _Leftdatalabel.frame=CGRectMake(0, 5, SCREEN_WIDTH/2, 15);
    _servicetimesbtn.frame=CGRectMake(20, 20, SCREEN_WIDTH/2-40, 25);
    _Leftamountlabel.frame=CGRectMake(20, 45, SCREEN_WIDTH/2-40, 15);
    _LeftamountNblabel.frame=CGRectMake(0, 60, SCREEN_WIDTH/2, 30);
    _Rightamountlabel.frame=CGRectMake(SCREEN_WIDTH/2+20, 45, SCREEN_WIDTH/2-40, 15);
    _RightamountNblabel.frame=CGRectMake(SCREEN_WIDTH/2, 60, SCREEN_WIDTH/2, 30);
    _Rightlabel.frame=CGRectMake(SCREEN_WIDTH/2, 25, SCREEN_WIDTH/2, 15);
    _desklabelEX1.frame=CGRectMake(0, middle_Y+44, SCREEN_WIDTH,15);
    [ _desklabelEX1 setLeftLabelText:@"Service Times" color:DESKCOLOR(0xea4c87)];
    [ _desklabelEX1 setRightLabelText:@"0" color:DESKCOLOR(0xea4c87)];
    
    _desklabelEX2.frame=CGRectMake(0, _desklabelEX1.frame.origin.y+_desklabelEX1.frame.size.height, SCREEN_WIDTH,15);
    [ _desklabelEX2 setLeftLabelText:@"Sales Performanage" color:DESKCOLOR(0x0fc2e8)];
    [ _desklabelEX2 setRightLabelText:@"0" color:DESKCOLOR(0x0fc2e8)];
    
    _bottomChart.frame=CGRectMake(30, _desklabelEX2.frame.origin.y+_desklabelEX2.frame.size.height, SCREEN_WIDTH-60, VIEW_SCREEN_HEIGHT-_desklabelEX2.frame.origin.y-_desklabelEX2.frame.size.height-44);
    

    _NoAnalyticsControl.frame=CGRectMake(0,0, self.view.frame.size.width, VIEW_SCREEN_HEIGHT-44);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
       [FilterDataModel destroyFilterData];
   
}


-(void)DeskBottomClickAtIndext:(NSInteger)index
{
    if (index==1) {
        
        CloseDataSelectController * ctr=[[CloseDataSelectController alloc]init];
        ctr.title=@"Use Funnel";
        [self.navigationController pushViewController:ctr animated:YES];
        
    }else
    {
    
 
    
    }
    
}

-(void)SelectMiddleClickAtIndext:(int)index
{
    
    [FilterDataModel shareFilterData].DateType=index;
    [_chartData2 removeAllObjects];
    [_chartData removeAllObjects];
    
    [self getsecondsales];
    
    
}



- (void)lineChartView:(FSLineChart *)lineChartView didSelectChartAtIndex:(NSInteger)index
{
    
    
    [ _desklabelEX1 setRightLabelText: [NSString stringWithFormat:@"%.2f",[_chartData[index] floatValue]] color:DESKCOLOR(0xea4c87)];
    [ _desklabelEX2 setRightLabelText:  [NSString stringWithFormat:@"%.2f",[_chartData2[index] floatValue]]color:DESKCOLOR(0x0fc2e8)];
    
    
}

-(void)SelectServiceBtnClick
{
    
    
    NSArray *arraytemp=[[NSArray alloc]initWithObjects:self.leftArrayData, nil];
    
    DeskActionSheetPickerView *picker = [[DeskActionSheetPickerView alloc] initWithTitle:@"Select Data Contrast" delegate:self];
    [picker setTag:1];
    [picker setTitlesForComponenets:arraytemp];
    [picker show];

    
    
}

#pragma mark - delegate



- (void)actionSheetPickerView:(DeskActionSheetPickerView *)pickerView didSelectRows:(NSArray*)rows
{
    int type=0;
    
   
    
    type= pow(2, [[rows objectAtIndex:0]intValue]+2 );

    if(type!=_leftStatus)  {
        
        [_servicetimesbtn setTitle:[_leftArrayData objectAtIndex:[[rows objectAtIndex:0]intValue]] forState:UIControlStateNormal];
        _desklabelEX1.LeftLabel.text=[_leftArrayData objectAtIndex:[[rows objectAtIndex:0]intValue]];
        _leftStatus=type;
        
        [self getsecondsales];
    }

}
#pragma http service

-(void)getsecondsales
{
    
    int index=[FilterDataModel shareFilterData].DateType;
    int date=365;
    NSString * str=[_dateArray objectAtIndex:index];
    if (index==0)
    {
        date=30;
    }

     [self waitViewShow];
    DeskHttpRequest *deskhttp=[[DeskHttpRequest alloc]initWithDelegate:self];
    
    [deskhttp addHeaderKey:@"SESSION-TOKEN" Value:[UserManager shareMainUser].session_token];
    DLog(@"aF%@",[UserManager shareMainUser].session_token);
    NSString *STR=  URL_GET_SECOND_SALES(1,1|_leftStatus,str,[PublicMethods getIntervalTimeSince: [FilterDataModel shareFilterData].StartTime Day:date],[FilterDataModel shareFilterData].StartTime);
    DLog(STR);
    [deskhttp startGet: STR tag:@"sales"];

    
}


-(void)UnshowChart:(BOOL)show
{

    _rightChart.hidden=show;
    _leftChart.hidden=show;
    _bottomChart.hidden=show;

}

-(void)getFinished:(NSDictionary *)msg tag:(NSString*)tag;
{
    
    DLog(@"%@",[msg objectForKey:@"errmsg"]);
    [self waitViewHidden];
    if ([[msg objectForKey:@"status"]intValue]==0) {

        [_chartData2 removeAllObjects];
        [_chartData removeAllObjects];
        [_chartKeyData removeAllObjects];
        
           [self UnshowChart:NO];
        
        if (![[[msg objectForKey:[NSString stringWithFormat:@"%d",_leftStatus]]objectForKey:@"value"] isKindOfClass:[NSArray class]]||![[[msg objectForKey:[NSString stringWithFormat:@"%d",_leftStatus]]objectForKey:@"value"] isKindOfClass:[NSArray class]]) {
             [AlertMessageCenter showWaittingView:@"数据出错" during:0.7];
            [self UnshowChart:YES];
            return ;
        }
  
        if ([[[msg objectForKey:[NSString stringWithFormat:@"%d",_leftStatus]]objectForKey:@"key"] isKindOfClass:[NSArray class]]) {
            [_chartKeyData addObjectsFromArray:[[msg objectForKey:[NSString stringWithFormat:@"%d",_leftStatus]]objectForKey:@"key"]];
        }
        
        NSMutableArray* ch = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray* lch = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray* rch = [NSMutableArray arrayWithCapacity:1];
        
        [_chartData addObjectsFromArray:[[msg objectForKey:[NSString stringWithFormat:@"%d",_leftStatus]]objectForKey:@"value"]];
        [ch addObject:_chartData];
        [lch addObject:_chartData];
        
        [_chartData2 addObjectsFromArray:[[msg objectForKey:@"1"]objectForKey:@"value"]];
        [ch addObject:_chartData2];
        [rch addObject:_chartData2];
        
        
        if (_chartData.count!=_chartData2.count) {
            [AlertMessageCenter showWaittingView:@"数据出错" during:0.7];
            return ;
        }
        
        _bottomChart.labelForIndex = ^(NSUInteger item) {
            if (item>=_chartKeyData.count) {
                return @"";
            }
            
            if ([FilterDataModel shareFilterData].DateType==0) {
                return [PublicMethods getFormatTime:[[_chartKeyData objectAtIndex:item] longLongValue]];
            }else  if ([FilterDataModel shareFilterData].DateType==1) {
                return
                [NSString stringWithFormat:@"%@ (W%@)",[PublicMethods getFormatDate:[[_chartKeyData objectAtIndex:item] longLongValue] Type:@"yy/MM"],[PublicMethods getFormatDate:[[_chartKeyData objectAtIndex:item] longLongValue] Type:@"ww"]]
                ;
            }
            else  if ([FilterDataModel shareFilterData].DateType==2) {
               return [PublicMethods getFormatDate:[[_chartKeyData objectAtIndex:item] longLongValue] Type:@"yy/MM"];
            }    else  if ([FilterDataModel shareFilterData].DateType==3) {
             return   [NSString stringWithFormat:@"%@/(Q%@)",[PublicMethods getFormatDate:[[_chartKeyData objectAtIndex:item] longLongValue] Type:@"yy"],[PublicMethods getFormatDate:[[_chartKeyData objectAtIndex:item] longLongValue] Type:@"qq"]]
                ;
            }
            
            return @"";
            
        };
        
        _bottomChart.labelForValue = ^(CGFloat value) {
            return [NSString stringWithFormat:@"%.f", value];
        };
        
        [_bottomChart setChartData:ch ];
        
        
        
       [_rightChart setChartData: rch  ];
       [_leftChart setChartData: lch ];
//
       _LeftamountNblabel.text= [NSString stringWithFormat:@"%@",[[msg objectForKey:[NSString stringWithFormat:@"%d",_leftStatus]]objectForKey:@"total"]]  ;
       _RightamountNblabel.text= [NSString stringWithFormat:@"%@",[[msg objectForKey:@"1"]objectForKey:@"total"]];
          _NoAnalyticsControl.hidden=YES;
    }

    else if ([[msg objectForKey:@"status"]intValue]==1)
    {
        _NoAnalyticsControl.hidden=NO;
           [self UnshowChart:YES];
        if ([[msg objectForKey:@"errcode"]intValue]==5002) {
             [_NoAnalyticsControl  DataTryingError];
        } else if ([[msg objectForKey:@"errcode"]intValue]==5001)
        {
               [_NoAnalyticsControl  DataOuthError];
        }

    }
    
    
}
-(void)getError:(NSDictionary *)msg tag:(NSString*)tag;
{
    [self waitViewHidden];
    [AlertMessageCenter showWaittingView:@"网络失败,稍后再试" during:0.7];
}


#pragma get view


-(UIScrollView *)ContentScrollView
{
    
    if (_ContentScrollView==nil) {
        _ContentScrollView=[[UIScrollView alloc]init];
        _ContentScrollView.backgroundColor=[UIColor clearColor];
    }
    return _ContentScrollView;
}

-(DeskBottomView *)deskbottomview
{
    
    if (_deskbottomview==nil) {
        _deskbottomview=[[DeskBottomView alloc]init];
        _deskbottomview.delegate=self;
        _deskbottomview.backgroundColor=DESKCOLOR(0xfaf8f8);
        
        _deskbottomview.frame=CGRectMake(0, VIEW_SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
        
          NSArray * bottomarray=[NSArray arrayWithObjects:@"home",@"funnel", nil];
        [_deskbottomview setCounts:[bottomarray count]];
        [_deskbottomview setTitles: nil Images:bottomarray];
    }
    return _deskbottomview;
}

-(SelectMiddleView *)selectMiddleView
{
    
    if (_selectMiddleView==nil) {
        _selectMiddleView=[[SelectMiddleView alloc]init];
        _selectMiddleView.selectmiddledelegate=self;
        _selectMiddleView.backgroundColor=[UIColor whiteColor];
        _selectMiddleView.frame=CGRectMake(0, middle_Y, SCREEN_WIDTH, 44);
        NSArray * selectarray=[NSArray arrayWithObjects:@"Day",@"Week",@"Month",@"Quarter", nil];
        [_selectMiddleView setCounts:[selectarray count] ];
        [_selectMiddleView setTitles: selectarray Images:nil selectColor:DESKCOLOR(0x93ec69)];
    }
    return _selectMiddleView;
}


-(UIView *)lineview
{
    
    if (_lineview==nil) {
        _lineview=[[UIView alloc]init];
        _lineview.backgroundColor=[UIColor grayColor];
        
    }
    return _lineview;
}

-(UILabel *)Leftdatalabel
{
    
    if (_Leftdatalabel==nil) {
        _Leftdatalabel=[[UILabel alloc]init];
        _Leftdatalabel.textColor=[UIColor grayColor];
        _Leftdatalabel.text=@"Select Data Contrast";
        _Leftdatalabel.font=[UIFont systemFontOfSize:10];
        _Leftdatalabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return _Leftdatalabel;
}


-(UIButton *)servicetimesbtn
{
    
    if (_servicetimesbtn==nil) {
        _servicetimesbtn=[UIButton  buttonWithType:UIButtonTypeRoundedRect];
        [_servicetimesbtn.layer setMasksToBounds:YES];
        [_servicetimesbtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        [_servicetimesbtn.layer setBorderWidth:1.0]; //边框宽度
        [_servicetimesbtn setTitle:@"Service Times" forState:UIControlStateNormal];
        [_servicetimesbtn setTitleColor:DESKCOLOR(0x4d4c4c) forState:UIControlStateNormal];
        [_servicetimesbtn setFont:[UIFont systemFontOfSize:10]];
        [_servicetimesbtn addTarget:self action:@selector(SelectServiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_servicetimesbtn.layer setBorderColor:[UIColor grayColor].CGColor];//边框颜色
        
    }
    return _servicetimesbtn;
}

-(UILabel *)Leftamountlabel
{
    
    if (_Leftamountlabel==nil) {
        _Leftamountlabel=[[UILabel alloc]init];
        _Leftamountlabel.textColor=[UIColor grayColor];
        _Leftamountlabel.text=@"amount";
        _Leftamountlabel.font=[UIFont systemFontOfSize:10];
        _Leftamountlabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return _Leftamountlabel;
}

-(UILabel *)LeftamountNblabel
{
    
    if (_LeftamountNblabel==nil) {
        _LeftamountNblabel=[[UILabel alloc]init];
        _LeftamountNblabel.textColor=DESKCOLOR(0x333232);
        
        _LeftamountNblabel.font=[UIFont systemFontOfSize:20];
        _LeftamountNblabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return _LeftamountNblabel;
}


-(UILabel *)Rightamountlabel
{
    
    if (_Rightamountlabel==nil) {
        _Rightamountlabel=[[UILabel alloc]init];
        _Rightamountlabel.textColor=[UIColor grayColor];
        _Rightamountlabel.text=@"amount";
        _Rightamountlabel.font=[UIFont systemFontOfSize:10];
        _Rightamountlabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return _Rightamountlabel;
}

-(UILabel *)RightamountNblabel
{
    
    if (_RightamountNblabel==nil) {
        _RightamountNblabel=[[UILabel alloc]init];
        _RightamountNblabel.textColor=DESKCOLOR(0x333232);
        _RightamountNblabel.font=[UIFont systemFontOfSize:20];
        _RightamountNblabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return _RightamountNblabel;
}
-(UILabel *)Rightlabel
{
    
    if (_Rightlabel==nil) {
        _Rightlabel=[[UILabel alloc]init];
        _Rightlabel.textColor=DESKCOLOR(0x4d4c4c);
        _Rightlabel.text=@"Sales Performance";
        _Rightlabel.font=[UIFont systemFontOfSize:12];
        _Rightlabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return _Rightlabel;
}

-( FSLineChart  *)bottomChart
{
    if (_bottomChart==nil) {
        _bottomChart=[[FSLineChart alloc]initWithFrame:CGRectMake(30, middle_Y+54+20, SCREEN_WIDTH-60, VIEW_SCREEN_HEIGHT-middle_Y-138)];
        _bottomChart.drawGrid=YES;
        _bottomChart.delegate=self;
        _bottomChart.selectionVisible=YES;
        _bottomChart.labelForIndex = ^(NSUInteger item) {
            return [NSString stringWithFormat:@"%lu",(unsigned long)item];
        };
        _bottomChart.labelForValue = ^(CGFloat value) {
            return [NSString stringWithFormat:@"%.f", value];
        };
        NSMutableArray* colorData = [NSMutableArray arrayWithCapacity:1];
        [colorData addObject:DESKCOLOR(0xea4c87)];
        [colorData addObject:DESKCOLOR(0x0fc2e8)];
        [_bottomChart setCharColor:colorData];
    }
    return _bottomChart;
    
}

-( FSLineChart  *)leftChart
{
    if (_leftChart==nil) {
        NSMutableArray* ch = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray* colorData = [NSMutableArray arrayWithCapacity:2];
        [colorData addObject:DESKCOLOR(0xea4c87)];
        [ch addObject:_chartData];
        _leftChart=[[FSLineChart alloc]initWithFrame:CGRectMake(30, 85 ,SCREEN_WIDTH/2-60, isRetina?50:60)];
        _leftChart.gridStep = 4;
        [_leftChart setCharColor:colorData];
    }
    return _leftChart;
    
}


-( FSLineChart  *)rightChart
{
    if (_rightChart==nil) {
        NSMutableArray* ch = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray* colorData = [NSMutableArray arrayWithCapacity:1];
        [colorData addObject:DESKCOLOR(0x0fc2e8)];
        [ch addObject:_chartData2];
        _rightChart=[[FSLineChart alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 85 ,SCREEN_WIDTH/2-60, isRetina?50:60)];
        _rightChart.gridStep = 4;
        [_rightChart setCharColor:colorData];
    }
    return _rightChart;
    
}


-( DeskLabelEX  *)desklabelEX1
{
    if (_desklabelEX1==nil) {
        _desklabelEX1=[[DeskLabelEX alloc]init];
        [_desklabelEX1 setLeftLabelTextFont:12];
        [_desklabelEX1 setRightLabelTextFont:12];
        _desklabelEX1.RightLabel.textAlignment=NSTextAlignmentRight;
        _desklabelEX1.backgroundColor=[UIColor clearColor];
    }
    return _desklabelEX1;
}


-( DeskLabelEX  *)desklabelEX2
{
    if (_desklabelEX2==nil) {
        _desklabelEX2=[[DeskLabelEX alloc]init];
        [_desklabelEX2 setLeftLabelTextFont:12];
        [_desklabelEX2 setRightLabelTextFont:12];
        _desklabelEX2.RightLabel.textAlignment=NSTextAlignmentRight;
        _desklabelEX2.backgroundColor=[UIColor clearColor];
    }
    return _desklabelEX2;
}

-(ModuleDataErrorControl *)NoAnalyticsControl
{
    if (_NoAnalyticsControl==nil) {
        _NoAnalyticsControl=[[ModuleDataErrorControl alloc]init];
        _NoAnalyticsControl.backgroundColor=[UIColor whiteColor];

    }
    return _NoAnalyticsControl;
   
}

@end
