//
//  DeskActionSheetPickerView.m
//  DESK
//
//  Created by 51desk on 15/6/17.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "DeskActionSheetPickerView.h"


@interface DeskActionSheetPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView    *_pickerView;
    UIDatePicker    *_datePicker;
    UIToolbar       *_actionToolbar;
    UILabel         *_titleLabel;
    
    DeskActionSheetPickerController *_actionSheetController;
}

@end

@implementation DeskActionSheetPickerView

@synthesize actionSheetPickerStyle  = _actionSheetPickerStyle;
@synthesize titlesForComponenets    = _titlesForComponenets;
@synthesize widthsForComponents     = _widthsForComponents;
@synthesize isRangePickerView       = _isRangePickerView;
@synthesize delegate                = _delegate;
@synthesize date                    = _date;


- (instancetype)initWithTitle:(NSString *)title delegate:(id<DeskActionSheetPickerViewDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        //UIToolbar
        {
            _actionToolbar = [[UIToolbar alloc] init];
            _actionToolbar.barStyle = UIBarStyleDefault;
            [_actionToolbar sizeToFit];
            
            CGRect toolbarFrame = _actionToolbar.frame;
            toolbarFrame.size.height = 44;
            _actionToolbar.frame = toolbarFrame;
            
            NSMutableArray *items = [[NSMutableArray alloc] init];
            
            //  Create a cancel button to show on keyboard to resign it. Adding a selector to resign it.
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelClicked:)];
            [items addObject:cancelButton];
            
            //  Create a fake button to maintain flexibleSpace between cancelButton and titleLabel.(Otherwise the titleLabel will lean to the left）
            UIBarButtonItem *leftNilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [items addObject:leftNilButton];
            
            //  Create a title label to show on toolBar for the title you need.
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _actionToolbar.frame.size.width-66-57.0-16, 44)];
            _titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
            [_titleLabel setBackgroundColor:[UIColor clearColor]];
            [_titleLabel setTextAlignment:NSTextAlignmentCenter];
            [_titleLabel setText:title];
            [_titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            
            UIBarButtonItem *titlebutton = [[UIBarButtonItem alloc] initWithCustomView:_titleLabel];
            titlebutton.enabled = NO;
            [items addObject:titlebutton];
            
            
            //  Create a fake button to maintain flexibleSpace between doneButton and nilButton. (Actually it moves done button to right side.
            UIBarButtonItem *rightNilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [items addObject:rightNilButton];
            
            //  Create a done button to show on keyboard to resign it. Adding a selector to resign it.
            UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
            [items addObject:doneButton];
            
            //  Adding button to toolBar.
            [_actionToolbar setItems:items];
            
            [self addSubview:_actionToolbar];
        }
        
        //UIPickerView
        {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_actionToolbar.frame) , CGRectGetWidth(_actionToolbar.frame), 216)];
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
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            [self addSubview:_datePicker];
        }
        
        //Initial settings
        {
            self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(_pickerView.frame), CGRectGetMaxY(_pickerView.frame))];
            [self setActionSheetPickerStyle:DeskActionSheetPickerStyleTextPicker];
            
            self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
            _actionToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
    }
    
    _delegate = delegate;
    
    return self;
}

-(void)setActionSheetPickerStyle:(DeskActionSheetPickerStyle)actionSheetPickerStyle
{
    _actionSheetPickerStyle = actionSheetPickerStyle;
    
    switch (actionSheetPickerStyle) {
        case DeskActionSheetPickerStyleTextPicker:
            [_pickerView setHidden:NO];
            [_datePicker setHidden:YES];
            break;
        case DeskActionSheetPickerStyleDatePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            break;
        case DeskActionSheetPickerStyleDateTimePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        case DeskActionSheetPickerStyleTimePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeTime];
            break;
            
        default:
            break;
    }
}

/**
 *  Set Action Bar Color
 *
 *  @param barColor Custom color for toolBar
 */
-(void)setBarColor:(UIColor *)barColor{
    
    [_actionToolbar setBarTintColor:barColor];
}

/**
 *  Set Action Tool Bar Button Color
 *
 *  @param buttonColor Custom color for toolBar button
 */
-(void)setButtonColor:(UIColor *)buttonColor{
    
    [_actionToolbar setTintColor:buttonColor];
}

#pragma mark - Done/Cancel

-(void)pickerCancelClicked:(UIBarButtonItem*)barButton
{
    if ([self.delegate respondsToSelector:@selector(actionSheetPickerViewWillCancel:)])
    {
        [self.delegate actionSheetPickerViewWillCancel:self];
    }
    
    [self dismissWithCompletion:^{
        
        if ([self.delegate respondsToSelector:@selector(actionSheetPickerViewDidCancel:)])
        {
            [self.delegate actionSheetPickerViewDidCancel:self];
        }
    }];
}

-(void)pickerDoneClicked:(UIBarButtonItem*)barButton
{
    switch (_actionSheetPickerStyle)
    {
        case DeskActionSheetPickerStyleTextPicker:
        {
            NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
                   NSMutableArray *selectedRows = [[NSMutableArray alloc] init];
            
            for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
            {
                int row = (int)[_pickerView selectedRowInComponent:component];
                
                if (row!= -1)
                {
                    [selectedTitles addObject:_titlesForComponenets[component][row]];
                }
                else
                {
                    [selectedTitles addObject:[NSNull null]];
                }
                
                if (row!= -1)
                {
                    [selectedRows addObject:[NSNumber numberWithInt:row]];
                }
                else
                {
                    [selectedRows addObject:0];
                }
                

            }
            
            [self setSelectedTitles:selectedTitles];
            
            if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didSelectTitles:)])
            {
                [self.delegate actionSheetPickerView:self didSelectTitles:selectedTitles];
            }
            
            if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didSelectRows:)])
            {
                [self.delegate actionSheetPickerView:self didSelectRows:selectedRows];
            }
            
        }
            break;
        case DeskActionSheetPickerStyleTimePicker:
        case DeskActionSheetPickerStyleDateTimePicker:
        case DeskActionSheetPickerStyleDatePicker:
        {
            [self setDate:_datePicker.date];
            
            [self setSelectedTitles:@[_datePicker.date]];
            
            if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didSelectDate:)])
            {
                [self.delegate actionSheetPickerView:self didSelectDate:_datePicker.date];
            }
        }
            
        default:
            break;
    }
    
    [self dismiss];
}



-(void)dateChanged:(UIDatePicker*)datePicker
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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

#pragma mark - IQActionSheetPickerStyleTextPicker

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
    if (_actionSheetPickerStyle == DeskActionSheetPickerStyleTextPicker)
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
    if (_actionSheetPickerStyle == DeskActionSheetPickerStyleTextPicker)
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
    if (_actionSheetPickerStyle == DeskActionSheetPickerStyleTextPicker)
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
    
    if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didChangeRow:inComponent:)]) {
        [self.delegate actionSheetPickerView:self didChangeRow:row inComponent:component];
    }
}

#pragma mark - show/Hide

-(void)dismiss
{
    [_actionSheetController dismissWithCompletion:nil];
}

-(void)dismissWithCompletion:(void (^)(void))completion
{
    [_actionSheetController dismissWithCompletion:completion];
}

-(void)show
{
    [self showWithCompletion:nil];
}

-(void)showWithCompletion:(void (^)(void))completion
{
    [_pickerView reloadAllComponents];
    
    _actionSheetController = [[DeskActionSheetPickerController alloc] init];
    [_actionSheetController showPickerView:self completion:completion];
}



@end


@interface DeskActionSheetPickerController ()<UIApplicationDelegate>

@end

@implementation DeskActionSheetPickerController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)showPickerView:(DeskActionSheetPickerView*)pickerView completion:(void (^)(void))completion
{
    _pickerView = pickerView;
    
    //  Getting topMost ViewController
    UIViewController *topController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while ([topController presentedViewController])	topController = [topController presentedViewController];
    
    //Sending pickerView to bottom of the View.
    __block CGRect pickerViewFrame = pickerView.frame;
    {
        pickerViewFrame.origin.y = self.view.bounds.size.height;
        pickerView.frame = pickerViewFrame;
        [self.view addSubview:pickerView];
    }
    
    //Adding self.view to topMostController.view and adding self as childViewController to topMostController
    {
        self.view.frame = CGRectMake(0, 0, topController.view.bounds.size.width, topController.view.bounds.size.height);
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [topController addChildViewController: self];
        [topController.view addSubview: self.view];
    }
    
    //Sliding up the pickerView with animation
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        pickerViewFrame.origin.y = self.view.bounds.size.height-pickerViewFrame.size.height;
        pickerView.frame = pickerViewFrame;
        
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

-(void)dismissWithCompletion:(void (^)(void))completion
{
    //Sliding down the pickerView with animation.
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        CGRect pickerViewFrame = _pickerView.frame;
        pickerViewFrame.origin.y = self.view.bounds.size.height;
        _pickerView.frame = pickerViewFrame;
        
    } completion:^(BOOL finished) {
        
        //Removing pickerView from self.view
        [_pickerView removeFromSuperview];
        
        //Removing self.view from topMostController.view and removing self as childViewController from topMostController
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        if (completion) completion();
    }];
}

@end
