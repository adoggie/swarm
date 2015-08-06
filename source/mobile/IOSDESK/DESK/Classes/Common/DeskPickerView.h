//
//  DeskPickerView.h
//  DESK
//
//  Created by 51desk on 15/6/24.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DesktPickerStyle) {
    
    DesktPickerStyleTextPicker,
    
   DesktPickerStyleDatePicker,
    
   DesktPickerStyleDateTimePicker,
    
   DesktPickerStyleTimePicker,
};


@class DeskPickerView;
/*!
 ActionSheetPickerView delegate.
 */
@protocol DeskPickerViewDelegate <NSObject>

@optional
- (void)DeskPickerView:(DeskPickerView *)pickerView didSelectRow:(NSArray*)row;
- (void)DeskPickerView:(DeskPickerView *)pickerView didSelectDate:(NSDate*)date;
- (void)DeskPickerView:(DeskPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)DeskPickerView:(DeskPickerView *)pickerView;

@end

@interface DeskPickerView : UIControl

/*!
 Initialization method with a title for toolbar and a callback delegate
 */
- (id)initWithFrame:(CGRect)frame delegate:(id<DeskPickerViewDelegate>)delegate;

/*!
 delegate(weak reference) object to inform about the selected values in pickerView. Delegate method will be called on Done click.
 */
@property(nonatomic, strong) id<DeskPickerViewDelegate> delegate;

/*!
 actionSheetPickerStyle to show in picker. Default is IQActionSheetPickerStyleTextPicker.
 */
@property(nonatomic, assign) DesktPickerStyle actionSheetPickerStyle;   //

/*!
 Color for toolBar
 */
@property(nonatomic, strong) UIColor *barColor;
/*!
 Color for buttons
 */
@property(nonatomic, strong) UIColor *buttonColor;

///----------------------
/// @name Show / Hide
///----------------------


/*!
 selected titles for each component. Please use [ NSArray of NSString ] format. (Not Animated)
 */
@property(nonatomic, strong) NSArray *selectedTitles;

/*!
 set selected titles for each component. Please use [ NSArray of NSString ] format.
 */
-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated;

/*!
 Titles to show for component. Please use [ NSArray(numberOfComponents) of [ NSArray of NSString ](RowValueForEachComponent)] format, even there is single row to show, For example.
 @[ @[ @"1", @"2", @"3", ], @[ @"11", @"12", @"13", ], @[ @"21", @"22", @"23", ]].
 */
@property(nonatomic, strong) NSArray *titlesForComponenets;

/*!
 Width to adopt for each component. Please use [NSArray of NSNumber/NSNull] format. If you don't want to specify a row width then use NSNull to calculate row width automatically.
 */
@property(nonatomic, strong) NSArray *widthsForComponents;

/*!
 Select the provided index row for each component. Please use [ NSArray of NSNumber ] format for indexes. Ignore if actionSheetPickerStyle is IQActionSheetPickerStyleDatePicker.
 */
-(void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated;

/*!
 If YES then it will force to scroll third picker component to pick equal or larger row then the first.
 */
@property(nonatomic, assign) BOOL isRangePickerView;

/*!
 Reload a component in pickerView.
 */
-(void)reloadComponent:(NSInteger)component;

/*!
 Reload all components in pickerView.
 */
-(void)reloadAllComponents;


/*!
 selected date. Can also be use as setter method (not animated).
 */
@property(nonatomic, assign) NSDate *date; //get/set date.

/*!
 set selected date.
 */
-(void)setDate:(NSDate *)date animated:(BOOL)animated;

/*!
 Minimum selectable date in UIDatePicker. Default is nil.
 */
@property (nonatomic, retain) NSDate *minimumDate;

/*!
 Maximum selectable date in UIDatePicker. Default is nil.
 */
@property (nonatomic, retain) NSDate *maximumDate;

@end
