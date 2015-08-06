//
//  FSLineChart.h
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSLineChartViewDelegate;



@interface FSLineChart : UIView

// Block definition for getting a label for a set index (use case: date, units,...)
typedef NSString *(^FSLabelForIndexGetter)(NSUInteger index);

// Same as above, but for the value (for adding a currency, or a unit symbol for example)
typedef NSString *(^FSLabelForValueGetter)(CGFloat value);

// Number of visible step in the chart
@property (nonatomic, readwrite) int gridStep;
@property (nonatomic, readwrite) int verticalgridStep;


// Margin of the chart
@property (nonatomic, readwrite) CGFloat margin;

@property (nonatomic, readonly) CGFloat axisWidth;
@property (nonatomic, readonly) CGFloat axisHeight;

@property (nonatomic, readwrite) BOOL drawGrid;
@property (nonatomic, assign) BOOL selectionVisible;
@property (nonatomic, assign) id<FSLineChartViewDelegate> delegate;

@property (copy) FSLabelForIndexGetter labelForIndex;
@property (copy) FSLabelForValueGetter labelForValue;

// Set the actual data for the chart, and then render it to the view.
- (void)setChartData:(NSArray *)chartData ;
- (id)init;
-(void)setCharColor:(NSArray *)colordata;

@end


@protocol FSLineChartViewDelegate <NSObject>

- (void)lineChartView:(FSLineChart *)lineChartView didSelectChartAtIndex:(NSInteger)index;

@end

@interface LineChartPoint : NSObject

@property (nonatomic, assign) CGPoint position;

@end

