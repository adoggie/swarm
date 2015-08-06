//
//  DeskPickerView.m
//  DESK
//
//  Created by 51desk on 15/6/24.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "DeskPickerView.h"



@interface DeskPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView    *_pickerView;
    UIDatePicker    *_datePicker;

    UILabel         *_titleLabel;
}

@end

@implementation DeskPickerView

@synthesize actionSheetPickerStyle  = _actionSheetPickerStyle;
@synthesize titlesForComponenets    = _titlesForComponenets;
@synthesize widthsForComponents     = _widthsForComponents;
@synthesize isRangePickerView       = _isRangePickerView;
@synthesize delegate                = _delegate;
@synthesize date                    = _date;



- (id)initWithFrame:(CGRect)frame delegate:(id<DeskPickerViewDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        
        //UIPickerView
        {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0 ,frame.size.width, frame.size.height)];
            _pickerView.backgroundColor = [UIColor whiteColor];
            [_pickerView setShowsSelectionIndicator:YES];
            [_pickerView setDelegate:self];
            [_pickerView setDataSource:self];
            [self addSubview:_pickerView];
        }
        
        //UIDatePicker
        {
            _datePicker = [[UIDatePicker alloc] initWithFrame:_pickerView.frame];
            [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            _datePicker.frame = _pickerView.frame;
         NSDate *currentTime  = [NSDate date];
             [_datePicker setDate:currentTime animated:YES];
                 [_datePicker setMaximumDate:currentTime];
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            [self addSubview:_datePicker];
        }
        
        //Initial settings
        {
            self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
           [self setFrame:frame];
//            self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
//            _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//            _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
    }
    
    _delegate = delegate;
    
    return self;
}

-(void)setActionSheetPickerStyle:(DesktPickerStyle)actionSheetPickerStyle
{
    _actionSheetPickerStyle = actionSheetPickerStyle;
    
    switch (actionSheetPickerStyle) {
        case DesktPickerStyleTextPicker:
            [_pickerView setHidden:NO];
            [_datePicker setHidden:YES];
            
           
            break;
        case DesktPickerStyleDatePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            break;
        case DesktPickerStyleDateTimePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        case DesktPickerStyleTimePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeTime];
            break;
            
        default:
            break;
    }
}



-(void)dateChanged:(UIDatePicker*)datePicker
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];

    

    
    if ([self.delegate respondsToSelector:@selector(DeskPickerView:didSelectDate:)]) {
        [self.delegate DeskPickerView: self didSelectDate:[datePicker.date dateByAddingTimeInterval:timeZoneOffset] ];
    }
}


-(void) setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}

-(void)setDate:(NSDate *)date animated:(BOOL)animated
{
    _date = date;
    if (_date != nil)   [_datePicker setDate:_date animated:animated];
}

-(void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    
    _datePicker.minimumDate = minimumDate;
}

-(void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    
    _datePicker.maximumDate = maximumDate;
}



-(void)reloadComponent:(NSInteger)component
{
    [_pickerView reloadComponent:component];
}

-(void)reloadAllComponents
{
    [_pickerView reloadAllComponents];
}

-(void)setSelectedTitles:(NSArray *)selectedTitles
{
    [self setSelectedTitles:selectedTitles animated:NO];
}

-(NSArray *)selectedTitles
{
    if (_actionSheetPickerStyle == DesktPickerStyleTextPicker)
    {
        NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
        
        NSUInteger totalComponent = _pickerView.numberOfComponents;
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSInteger selectedRow = [_pickerView selectedRowInComponent:component];
            
            if (selectedRow == -1)
            {
                [selectedTitles addObject:[NSNull null]];
            }
            else
            {
                NSArray *items = _titlesForComponenets[component];
                
                if ([items count] > selectedRow)
                {
                    id selectTitle = items[selectedRow];
                    [selectedTitles addObject:selectTitle];
                }
                else
                {
                    [selectedTitles addObject:[NSNull null]];
                }
            }
        }
        
        return selectedTitles;
    }
    else
    {
        return nil;
    }
}

-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated
{
    if (_actionSheetPickerStyle == DesktPickerStyleTextPicker)
    {
        NSUInteger totalComponent = MIN(selectedTitles.count, _pickerView.numberOfComponents);
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSArray *items = _titlesForComponenets[component];
            id selectTitle = selectedTitles[component];
            
            if ([items containsObject:selectTitle])
            {
                NSUInteger rowIndex = [items indexOfObject:selectTitle];
                [_pickerView selectRow:rowIndex inComponent:component animated:animated];
            }
        }
    }
}

-(void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    if (_actionSheetPickerStyle == DesktPickerStyleTextPicker)
    {
        NSUInteger totalComponent = MIN(indexes.count, _pickerView.numberOfComponents);
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSArray *items = _titlesForComponenets[component];
            NSUInteger selectIndex = [indexes[component] unsignedIntegerValue];
            
            if (selectIndex < items.count)
            {
                [_pickerView selectRow:selectIndex inComponent:component animated:animated];
            }
        }
    }
}

#pragma mark - UIPickerView delegate/dataSource

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //If having widths
    if (_widthsForComponents)
    {
        //If object isKind of NSNumber class
        if ([_widthsForComponents[component] isKindOfClass:[NSNumber class]])
        {
            CGFloat width = [_widthsForComponents[component] floatValue];
            
            //If width is 0, then calculating it's size.
            if (width == 0)
                return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
            //Else returning it's width.
            else
                return width;
        }
        //Else calculating it's size.
        else
            return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
    }
    //Else calculating it's size.
    else
    {
        return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_titlesForComponenets count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_titlesForComponenets[component] count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    labelText.font = [UIFont boldSystemFontOfSize:20.0];
    labelText.backgroundColor = [UIColor clearColor];
    [labelText setTextAlignment:NSTextAlignmentCenter];
    [labelText setText:_titlesForComponenets[component][row]];
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isRangePickerView && pickerView.numberOfComponents == 3)
    {
        if (component == 0)
        {
            [pickerView selectRow:MAX([pickerView selectedRowInComponent:2], row) inComponent:2 animated:YES];
        }
        else if (component == 2)
        {
            [pickerView selectRow:MIN([pickerView selectedRowInComponent:0], row) inComponent:0 animated:YES];
        }
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if ([self.delegate respondsToSelector:@selector(DeskPickerView:didChangeRow:inComponent:)]) {
        [self.delegate DeskPickerView:self didChangeRow:row inComponent:component];
    }
    
    
    NSMutableArray *selectedRow = [[NSMutableArray alloc] init];
    
    
    if ([self.delegate respondsToSelector:@selector(DeskPickerView:didSelectRow:)])
    {
        for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
        {
            NSInteger row = [_pickerView selectedRowInComponent:component];
            
            if (row!= -1)
            {
                [selectedRow addObject:[NSNumber numberWithInt:row]];
            }
        }
        [self.delegate DeskPickerView:self didSelectRow:selectedRow];
    }
    
 
}



@end
