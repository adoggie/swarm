//
//  CloseDataSelectController.m
//  DESK
//
//  Created by 51desk on 15/6/17.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "CloseDataSelectController.h"



@interface CloseDataSelectController ()

@end

@implementation CloseDataSelectController
-(void)viewDidLoad
{
    [super viewDidLoad];
       [self initbackBarItem];
    self.monthArray=[NSArray   arrayWithObjects:@"January", @"February", @"March", @"April", @"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    self.YearArray=[NSArray   arrayWithObjects:@"2000", @"2001", @"2002", @"2003", @"2004", @"2005", @"2006", @"2007", @"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",nil];
    self. QArray=[NSArray   arrayWithObjects:@"Q1", @"Q2", @"Q3", @"Q4",nil];
    [self.view setBackgroundColor:[UIColor whiteColor] ];
    [self.view  addSubview:self.calendarview];
    [self.view  addSubview:self.selectMiddleView];
    [self.view  addSubview:self.pickerView];
    [self.view  addSubview:self.desklabelEX1];
    [self.view  addSubview:self.selectlabel];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    [_selectMiddleView  selectAtIndex: [FilterDataModel shareFilterData].DateType];
    
    _desklabelEX1.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [_desklabelEX1 setLeftLabelWidth:80];
    
    _selectlabel.frame=CGRectMake(0, _calendarview.origin.y+_calendarview.frame.size.height,SCREEN_WIDTH, 44);
    _calendarview.calendarDate   = [NSDate dateWithTimeIntervalSince1970:[FilterDataModel shareFilterData].StartTime];
    
    [_pickerView setDate:[NSDate dateWithTimeIntervalSince1970:[FilterDataModel shareFilterData].StartTime]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)swipeleft:(id)sender
{
    [_calendarview showNextMonth];
}

-(void)swiperight:(id)sender
{
    [_calendarview showPreviousMonth];
}

#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    [FilterDataModel shareFilterData].StartTime=[selectedDate timeIntervalSince1970];
    [self setSelectlabelData];
    //    [_pickerView setDate:[NSDate dateWithTimeIntervalSince1970:[FilterDataModel shareFilterData].StartTime]];
    
}


-(BOOL)isDataForDate:(NSDate *)date
{
    if ([date compare:[NSDate date]] == NSOrderedAscending)
        return YES;
    return NO;
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    
    if ([date compare:[NSDate date]] == NSOrderedAscending)
        return YES;
    return NO;
}

#pragma Middleview delegate

-(void)SelectMiddleClickAtIndext:(int)index
{
    [FilterDataModel shareFilterData].DateType=index;
    long long startdate= [FilterDataModel shareFilterData].StartTime;
    [self setSelectlabelData];
    switch (index) {
        case 0:
            _pickerView.hidden=YES;
            _calendarview.hidden=NO;
            _desklabelEX1.RightLabel .text=@"30Days";
            break;
        case 1:
            _pickerView.hidden=YES;
            _calendarview.hidden=NO;
            _desklabelEX1.RightLabel .text=@"365Days";
            break;
        case 2:
            _calendarview.hidden=YES;
            _pickerView.hidden=NO;
            _desklabelEX1.RightLabel .text=@"365Days";
            [_pickerView setTitlesForComponenets:[NSArray arrayWithObjects: _monthArray,_YearArray, nil]];
            [_pickerView  reloadAllComponents];
            [self  setPickerSelectYear:[[PublicMethods getFormatDate:startdate Type:@"yyyy"]intValue] Month:[[PublicMethods getFormatDate:startdate Type:@"M"]intValue]];
            break;
        case 3:
            _calendarview.hidden=YES;
            _pickerView.hidden=NO;
            _desklabelEX1.RightLabel .text=@"365Days";
            [_pickerView setTitlesForComponenets:[NSArray arrayWithObjects: _QArray,_YearArray, nil]];
            [_pickerView  reloadAllComponents];
            [self  setPickerSelectYear:[[PublicMethods getFormatDate:startdate Type:@"yyyy"]intValue] Month:[[PublicMethods getFormatDate:startdate Type:@"M"]intValue]];
            break;
        default:
            break;
    }
    
}

#pragma DeskPickerView delegate
- (void)DeskPickerView:(DeskPickerView *)pickerView didSelectDate:(NSDate*)date
{
    [FilterDataModel shareFilterData].StartTime=[date timeIntervalSince1970];
    _calendarview.calendarDate   = date;
    [self setSelectlabelData];
    
}

- (void)DeskPickerView:(DeskPickerView *)pickerView didSelectRow:(NSArray*)rowArray
{
    int s_year= [[_YearArray objectAtIndex: [[rowArray objectAtIndex:1]intValue]]intValue];
    int row0= [[rowArray objectAtIndex:0]intValue];
    int c_year=   [[PublicMethods getFormatDate:[PublicMethods getCurrentIntervalTime] Type:@"yyyy"]intValue];
    int c_month=   [[PublicMethods getFormatDate:[PublicMethods getCurrentIntervalTime] Type:@"M"]intValue];
    if ([FilterDataModel shareFilterData].DateType==2) {
      
        if (s_year<c_year||((row0+1<=c_month)&&(s_year==c_year))){
            
            [FilterDataModel shareFilterData].StartTime=[PublicMethods getIntervalTime:[NSString stringWithFormat:@"%d-%d-%d",s_year,row0+1,1]];
            [self setSelectlabelData];
            return;
        }
            [FilterDataModel shareFilterData].StartTime=[PublicMethods getIntervalTime:[NSString stringWithFormat:@"%d-%d-%d",c_year,c_month,1]];
    }else if ([FilterDataModel shareFilterData].DateType==3) {

              int row0= [[rowArray objectAtIndex:0]intValue];
            if (s_year<c_year||((row0*3+1<=c_month)&&(s_year==c_year))){

                [FilterDataModel shareFilterData].StartTime=[PublicMethods getIntervalTime:[NSString stringWithFormat:@"%d-%d-%d",s_year,row0*3+1,1]];
                [self setSelectlabelData];
                return;
            }
              int  rowtemp=(int) (c_month-1)/3;
                [FilterDataModel shareFilterData].StartTime=[PublicMethods getIntervalTime:[NSString stringWithFormat:@"%d-%d-%d",c_year,rowtemp*3+1,1]];
        }
        
     [self setPickerSelectYear:c_year Month:c_month];

    _calendarview.calendarDate   = [NSDate dateWithTimeIntervalSince1970: [FilterDataModel shareFilterData].StartTime];

    [self setSelectlabelData];
}

-(void)setSelectlabelData
{
    
    long long startdate= [FilterDataModel shareFilterData].StartTime;
    if ([FilterDataModel shareFilterData].DateType==0) {
        _selectlabel.text=[NSString stringWithFormat:@"%@ TO %@",[PublicMethods getFormatTime:[PublicMethods getIntervalTimeSince: startdate Day:30]],[PublicMethods getFormatTime:startdate]];
        ;
    }  else if ([FilterDataModel shareFilterData].DateType==1||[FilterDataModel shareFilterData].DateType==2||[FilterDataModel shareFilterData].DateType==3) {
        _selectlabel.text=[NSString stringWithFormat:@"%@ TO %@",[PublicMethods getFormatTime:[PublicMethods getIntervalTimeSince:startdate Day:365]],[PublicMethods getFormatTime:startdate]];
        ;
    }
    
    
    
}

-(void)setPickerSelectYear:(int)year Month:(int)month
{
    int row0=0;
    int row1=0;
    if ([FilterDataModel shareFilterData].DateType==2) {
        row0=month-1;
        
    }else if ([FilterDataModel shareFilterData].DateType==3) {
      
        row0=(int) (month-1)/3;
        
    }
    for (int i=0; i<_YearArray.count; i++) {
        if (year==[[_YearArray objectAtIndex:i]intValue]) {
            row1=i;
            break;
        }
    }
    [_pickerView selectIndexes:@[[NSNumber numberWithInteger:row0],[NSNumber numberWithInteger:row1]] animated:NO];
}

#pragma get view

-(SelectMiddleView *)selectMiddleView
{
    
    if (_selectMiddleView==nil) {
        _selectMiddleView=[[SelectMiddleView alloc]init];
        _selectMiddleView.backgroundColor=[UIColor whiteColor];
        _selectMiddleView.selectmiddledelegate=self;
        _selectMiddleView.frame=CGRectMake(0, VIEW_SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);;
        
        NSArray * selectarray=[NSArray arrayWithObjects:@"Day",@"Week",@"Month",@"Quarter", nil];
        [_selectMiddleView setCounts:[selectarray count] ];
        [_selectMiddleView setTitles: selectarray Images:nil selectColor:DESKCOLOR(0x93ec69)];
        
    }
    return _selectMiddleView;
}

-(DeskPickerView *)pickerView
{
    
    if (_pickerView==nil) {
        _pickerView=[[DeskPickerView alloc]initWithFrame: CGRectMake(20, 60, SCREEN_WIDTH-40, SCREEN_HEIGHT/2) delegate:self];
        [_pickerView setActionSheetPickerStyle:DesktPickerStyleTextPicker];
        _pickerView.backgroundColor=[UIColor clearColor];
        _pickerView.delegate=self;
        
    }
    return _pickerView;
}


-(CalendarView*)calendarview
{
    
    if (_calendarview==nil) {
        _calendarview=[[CalendarView alloc]init];
        _calendarview.delegate=self;
        _calendarview     = [[CalendarView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH-40, SCREEN_HEIGHT/2)];
        _calendarview.delegate                    = self;
        _calendarview.datasource                  = self;
        _calendarview.monthAndDayTextColor       = DESKCOLOR(0x93ce69);
        _calendarview.dayBgColorWithData          = DESKCOLOR(0x93ce69);
        _calendarview.dayBgColorWithoutData       = DESKCOLOR(0xbabeca);
        _calendarview.dayBgColorSelected          =DESKCOLOR(0x497f22);
        _calendarview.dayTxtColorWithoutData      = DESKCOLOR(0xe2e1e7);
        _calendarview.dayTxtColorWithData         = [UIColor whiteColor];
        _calendarview.dayTxtColorSelected         = [UIColor whiteColor];
        _calendarview.borderColor                 = RGBCOLOR(159, 162, 172);
        _calendarview.borderWidth                 = 1;
        _calendarview.allowsChangeMonthByDayTap   = YES;
        _calendarview.allowsChangeMonthByButtons  = YES;
        _calendarview.keepSelDayWhenMonthChange   = YES;
        _calendarview.nextMonthAnimation          = UIViewAnimationOptionTransitionFlipFromRight;
        _calendarview.prevMonthAnimation          = UIViewAnimationOptionTransitionFlipFromLeft;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:_calendarview];
            _calendarview.center = CGPointMake(self.view.center.x, _calendarview.center.y);
        });
        
    }
    return _calendarview;
}


-(DeskLabelEX *)desklabelEX1
{
    
    if (_desklabelEX1==nil) {
        _desklabelEX1=[[DeskLabelEX alloc]init];
        _desklabelEX1.backgroundColor=[UIColor clearColor];
        _desklabelEX1.labelstyle=DeskLabelEXStyleBTLine;
        [_desklabelEX1 setLeftLabelText:@"Scope" color:DESKCOLOR(0xa3a3a3)];
        [_desklabelEX1 setRightLabelText:@"30Days" color:DESKCOLOR(0x191919)];
        
        
    }
    return _desklabelEX1;
}

-(UILabel *)selectlabel
{
    if (_selectlabel==nil) {
        _selectlabel=[[UILabel alloc]init];
        _selectlabel.backgroundColor=[UIColor clearColor];
        _selectlabel.textAlignment=NSTextAlignmentCenter;
        _selectlabel.text=@"ddd";
        _selectlabel.textColor=DESKCOLOR(0x037ff1);
    }
    return _selectlabel;
}



@end
