//
//  FSLineChart.m
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FSLineChart.h"

@interface FSLineChart ()

@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong) NSMutableArray* colordata;

@property (nonatomic) NSMutableArray* min;
@property (nonatomic) NSMutableArray* max;
@property (nonatomic) CGMutablePathRef initialPath;
@property (nonatomic) CGMutablePathRef newPath;
@property (nonatomic, strong) UIView *selectionView;
@property (nonatomic, strong) UILabel * selectionlabel;
@property (nonatomic, strong) NSArray *chartpointData;


@end

@implementation FSLineChart


- (id)init
{
    self = [super init];
    if (self) {
        [self setDefaultParameters];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setDefaultParameters];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paned:)];
        panGesture.cancelsTouchesInView = FALSE;  // 解决touchesMoved 冲突
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void) paned:(UIPanGestureRecognizer *)tapGesture
{
    
    //it's None here! :
    //use to disable panGestrue in DynamicsDrawViewController;
}

- (void)setChartData:(NSArray *)chartData
{
    
     [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.layer.sublayers  makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    _data = [NSMutableArray arrayWithArray:chartData];

    
    _min=[NSMutableArray array];
     _max=[NSMutableArray array];
    for (int i=0; i<_data.count; i++) {
        _min[i] = [NSNumber numberWithFloat:0];
        _max[i] = [NSNumber numberWithFloat:0];
        for(int j=0;j<((NSArray*) _data[i]).count;j++) {
            NSNumber* number = _data[i][j];
            if([number floatValue] < [[_max objectAtIndex:i ] floatValue])
                _min[i] = [NSNumber numberWithFloat:[number floatValue]] ;
            
            if([number floatValue] > [[_max objectAtIndex:i ] floatValue])
                _max[i] = [NSNumber numberWithFloat:[number floatValue]] ;
        }
        _max[i] =[NSNumber numberWithFloat:[self getUpperRoundNumber:[[_max objectAtIndex:i ] floatValue] forGridStep:_verticalgridStep]] ;
        
    }
    
    
    
    
    
    // No data
//    if(isnan(_max)) {
//        [[_max objectAtIndex:i ] floatValue] = 1;
//    }
    
    [self strokeChart];
    
    
    if(_labelForValue) {
        for (int j=0; j<_max.count ; j++) {
            
            for(int i=0;i<_verticalgridStep;i++) {
                int x_width=j>0?_axisWidth:0;
                CGPoint p = CGPointMake(_margin+x_width , _axisHeight + _margin - (i + 1) * _axisHeight / _verticalgridStep);
                
                NSString* text = _labelForValue([[_max objectAtIndex:j] floatValue] / _verticalgridStep * (i + 1));
                CGRect rect = CGRectMake(_margin, p.y + 2, self.frame.size.width - _margin * 2 - 4.0f, 14);
                
                float width =
                [text
                 boundingRectWithSize:rect.size
                 options:NSStringDrawingUsesLineFragmentOrigin
                 attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12.0f] }
                 context:nil]
                .size.width;
                
                UILabel* label = [[UILabel alloc] init];
                if (j==0) {
                    label.frame=CGRectMake(p.x -width -6 , p.y + 2, width + 2, 14);
                }else
                {
                        label.frame=CGRectMake(p.x , p.y + 2, width + 2, 14);
                }
                label.text = text;
                label.font = [UIFont systemFontOfSize:12.0f];
                label.textColor = [_colordata objectAtIndex:j];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.75f];
                
                [self addSubview:label];
            }
            
        }

    }
    
    
    if(_labelForIndex) {
        float scale = 1.0f;
        int q = (int)(((NSArray*) _data[0]).count ) / _gridStep;// 一格的间距
        scale = (CGFloat)(q * _gridStep) / (CGFloat)((((NSArray*) _data[0]).count ) - 1);
    
        for(int i=0;i<_gridStep + 1;i++) {
            NSInteger itemIndex = q * i;
            if(itemIndex >= (((NSArray*) _data[0]).count ))
            {
                itemIndex = (((NSArray*) _data[0]).count )-1;
            }
              NSString* text = _labelForIndex(itemIndex);
            
            float width =
            [text
             boundingRectWithSize:CGSizeMake(100, 20)
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:10.0f] }
             context:nil]
            .size.width;
            
          
            CGPoint p = CGPointMake(_margin + i * (_axisWidth / _gridStep) , _axisHeight + _margin);
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - 4.0f-width/2, p.y + 2, (_axisWidth / _gridStep), 14)];
            label.text = text;
  
            label.font = [UIFont boldSystemFontOfSize:10.0f];
            label.textColor = [UIColor grayColor];
            [self addSubview:label];
        }
    }
    
    dispatch_block_t createSelectionView = ^{
        
        self.selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, _margin,3, _axisHeight)];
        self.selectionView.alpha = 0;
        
        self.selectionView.backgroundColor =DESKCOLOR(0x93ce69);
        
        
        
        [self addSubview:self.selectionView ];
        
        
        self.selectionlabel= [[UILabel alloc] initWithFrame:CGRectMake(0, _margin,80, 20)];
        _selectionlabel.alpha = 0;
      _selectionlabel.backgroundColor =[UIColor clearColor];
        _selectionlabel.font=[UIFont systemFontOfSize:12.0f];
      _selectionlabel.textColor=DESKCOLOR(0x93ce69);;

        [self addSubview:_selectionlabel ];
    };
    
    
    dispatch_block_t createChartData = ^{
        
        CGFloat pointSpace = (self.bounds.size.width - (10 * 2)) / ((((NSArray*) _data[0]).count ) - 1); // Space in between points
        CGFloat xOffset = 10;
        CGFloat yOffset = 0;
        
   
        NSMutableArray *mutableChartData = [NSMutableArray array];
        for (NSInteger index=0; index<(((NSArray*) _data[0]).count ); index++)
        {
            LineChartPoint *chartPoint = [[LineChartPoint alloc] init];
            NSInteger rawHeight = [_data[0][index] intValue];
            CGFloat normalizedHeight = [self normalizedHeightForRawHeight:rawHeight];
            yOffset =_axisHeight- normalizedHeight;
            
            //yOffset = mainViewRect.size.height - yOffset;
            chartPoint.position = CGPointMake(xOffset, yOffset);
            
            [mutableChartData addObject:chartPoint];
            xOffset += pointSpace;
        }
        
        _chartpointData = [NSArray arrayWithArray:mutableChartData];
    };
    
    if (_selectionVisible) {
        createSelectionView();
        createChartData();
    }

    
    [self setNeedsDisplay];
}

-(void)setCharColor:(NSArray *)colordata
{

    if (_colordata!=nil) {
        [_colordata removeAllObjects];
    }
        _colordata=[NSMutableArray arrayWithArray:colordata];
    
}

-(CGFloat)normalizedHeightForRawHeight:(NSInteger)rawHeight
{
    CGFloat minHeight = [self minHeight];
    CGFloat maxHeight = [self maxHeight];
    
    if ((maxHeight - minHeight) <= 0)
    {
        return 0;
    }
    
    return ceil(((rawHeight - minHeight) / (maxHeight - minHeight)) * [self availableHeight]);
}

- (CGFloat)availableHeight
{
    return _axisHeight;
}

- (CGFloat)maxHeight
{

    NSInteger maxHeight = 0;
    for (NSInteger index=0; index<(((NSArray*) _data[0]).count ); index++)
    {
        if ([_data[0][index] intValue] > maxHeight)
        {
            maxHeight = [_data[0][index] intValue];
        }
    }
    return maxHeight;
}

- (CGFloat)minHeight
{
    return [[_min objectAtIndex:0]intValue];;
}


- (void)drawRect:(CGRect)rect
{
    if (_drawGrid==YES) {
               [self redrawGrid];
    }
 
}
- (void)redrawGrid
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithWhite:0.7 alpha:1.0] CGColor]);
    
    // draw coordinate axis
//    CGContextMoveToPoint(ctx, _margin, _margin);
//    CGContextAddLineToPoint(ctx, _margin, _axisHeight + _margin + 3);
//    CGContextStrokePath(ctx);
//    
//    
    CGContextMoveToPoint(ctx, _margin, _axisHeight + _margin);
    CGContextAddLineToPoint(ctx, _axisWidth + _margin, _axisHeight + _margin);
    CGContextStrokePath(ctx);
    
    float scale = 1.0f;
    int q = (int)((((NSArray*) _data[0]).count )- _verticalgridStep);
    scale = (CGFloat)(q * _verticalgridStep) / (CGFloat)((((NSArray*) _data[0]).count )- 1);
    
    // draw grid
//    for(int i=0;i<_gridStep;i++) {
//        CGContextSetLineWidth(ctx, 0.5);
//        
//        CGPoint point = CGPointMake((1 + i) * _axisWidth / _gridStep * scale + _margin, _margin);
//        
//        CGContextMoveToPoint(ctx, point.x, point.y);
//        CGContextAddLineToPoint(ctx, point.x, _axisHeight + _margin);
//        CGContextStrokePath(ctx);
//        
//        
//        CGContextSetLineWidth(ctx, 2);
//        CGContextMoveToPoint(ctx, point.x - 0.5f, _axisHeight + _margin);
//        CGContextAddLineToPoint(ctx, point.x - 0.5f, _axisHeight + _margin + 3);
//        CGContextStrokePath(ctx);
//    }
    
    for(int i=0;i<_verticalgridStep;i++) {
        CGContextSetLineWidth(ctx, 0.5);
        
        CGPoint point = CGPointMake(_margin, (i) * _axisHeight / _verticalgridStep + _margin);
        
        CGContextMoveToPoint(ctx, point.x, point.y);
        CGContextAddLineToPoint(ctx, _axisWidth + _margin, point.y);
        CGContextStrokePath(ctx);
    }
    
}

- (void)strokeChart
{
    if([_data count] == 0) {
        NSLog(@"Warning: no data provided for the chart");
        return;
    }
    
    for (int j=0; j<_data.count; j++) {
        
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        UIBezierPath *noPath = [UIBezierPath bezierPath];
        UIBezierPath* fill = [UIBezierPath bezierPath];
        UIBezierPath* noFill = [UIBezierPath bezierPath];
        
        CGFloat scale = _axisHeight / [[_max objectAtIndex:j] floatValue];
        NSNumber* first = _data[j][0];
        
        for(int i=1;i<((NSArray*) _data[j]).count;i++) {
            NSNumber* last = _data[j][i - 1];
            NSNumber* number = _data[j][i];
            
            CGPoint p1 = CGPointMake(_margin + (i - 1) * (_axisWidth / (((NSArray*) _data[j]).count - 1)), _axisHeight + _margin - [last floatValue] * scale);
            
            CGPoint p2 = CGPointMake(_margin + i * (_axisWidth / (((NSArray*) _data[j]).count - 1)), _axisHeight + _margin - [number floatValue] * scale);
            
            [fill moveToPoint:p1];
            [fill addLineToPoint:p2];
            [fill addLineToPoint:CGPointMake(p2.x, _axisHeight + _margin)];
            [fill addLineToPoint:CGPointMake(p1.x, _axisHeight + _margin)];
            
            [noFill moveToPoint:CGPointMake(p1.x, _axisHeight + _margin)];
            [noFill addLineToPoint:CGPointMake(p2.x, _axisHeight + _margin)];
            [noFill addLineToPoint:CGPointMake(p2.x, _axisHeight + _margin)];
            [noFill addLineToPoint:CGPointMake(p1.x, _axisHeight + _margin)];
        }
        
        
        [path moveToPoint:CGPointMake(_margin, _axisHeight + _margin - [first floatValue] * scale)];
        [noPath moveToPoint:CGPointMake(_margin, _axisHeight + _margin)];
        
        for(int i=1;i<((NSArray*) _data[j]).count;i++) {
            NSNumber* number = _data[j][i];
            
            [path addLineToPoint:CGPointMake(_margin + i * (_axisWidth / (((NSArray*) _data[j]).count - 1)), _axisHeight + _margin - [number floatValue] * scale)];
            [noPath addLineToPoint:CGPointMake(_margin + i * (_axisWidth / (((NSArray*) _data[j]).count - 1)), _axisHeight + _margin)];
        }
        
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.frame = self.bounds;
        fillLayer.bounds = self.bounds;
        fillLayer.path = fill.CGPath;
        fillLayer.strokeColor = nil;
        fillLayer.fillColor =[UIColor whiteColor]  .CGColor;
        fillLayer.lineWidth = 0;
        fillLayer.lineJoin = kCALineJoinRound;
        
        CAGradientLayer  * gradLayer1 = [CAGradientLayer   layer ];
        gradLayer1. frame =  self.bounds;
        
        UIColor * aaa=[_colordata objectAtIndex:j];
        [gradLayer1 setColors :[ NSArray  arrayWithObjects :(id) [aaa colorWithAlphaComponent:0.6].CGColor,[aaa colorWithAlphaComponent:0.2].CGColor,  nil ]];
        
        
        [gradLayer1 setLocations: @[@0.2, @0.8 ]];
        [gradLayer1 setStartPoint :CGPointMake ( 0 ,  0 )];
        [gradLayer1 setEndPoint: CGPointMake( 0,  1)];
        
        [gradLayer1 setMask:fillLayer];
        [self. layer  addSublayer:gradLayer1];
        
        
        
        
        
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.bounds = self.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [[_colordata objectAtIndex:j] CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = 1;
        pathLayer.lineJoin = kCALineJoinRound;
        
        [self.layer addSublayer:pathLayer];
        
        CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        fillAnimation.duration = 0.25;
        fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        fillAnimation.fillMode = kCAFillModeForwards;
        fillAnimation.fromValue = (id)noFill.CGPath;
        fillAnimation.toValue = (id)fill.CGPath;
        [fillLayer addAnimation:fillAnimation forKey:@"path"];
        
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = 0.25;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = (__bridge id)(noPath.CGPath);
        pathAnimation.toValue = (__bridge id)(path.CGPath);
        [pathLayer addAnimation:pathAnimation forKey:@"path"];
        
        
    }
}

- (void)setDefaultParameters
{

    _gridStep = 4;
    _verticalgridStep=5;
    _margin = 5.0f;
    _axisWidth = self.frame.size.width - 2 * _margin;
    _axisHeight = self.frame.size.height - 2 * _margin;
    
    
 
}

- (int)getUpperRoundNumber:(float)value forGridStep:(int)gridStep
{
    // We consider a round number the following by 0.5 step instead of true round number (with step of 1)

    if (value>10) {
        CGFloat logValue = log10f(value); //对数的
        CGFloat scale = powf(10, floorf(logValue)); //计算以x为底数的y次幂
        CGFloat n = ceilf(value/scale*2 );
        
        int tmp = (int)(n) % gridStep;
        
        if(tmp != 0) {
            n += gridStep - tmp;
        }
        
        return n * scale / 2.0f;
    }

 
    int scale=value>10?10:1;
    
    CGFloat temp= (value/gridStep/scale);
    
    int n= (int)(temp+1)*scale;

  
    return n *gridStep;
}

#pragma mark - Gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    
    if (!_selectionVisible||([_data count] == 0)) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if ([self.delegate respondsToSelector:@selector(lineChartView:didSelectChartAtIndex:)])  //选中
    {
        [self.delegate lineChartView:self didSelectChartAtIndex:[self indexForPoint:touchPoint]];
    }
    

    
    CGFloat xOffset = fmin(self.bounds.size.width - self.selectionView.frame.size.width, fmax(0, touchPoint.x - (ceil(self.selectionView.frame.size.width * 0.5))));
  
   


    self.selectionView.frame = CGRectMake(xOffset, self.selectionView.frame.origin.y, self.selectionView.frame.size.width, self.selectionView.frame.size.height);
    
    
    if (xOffset>self.bounds.size.width/2) {
        xOffset-=80;
    }
     self.selectionlabel.frame= CGRectMake(xOffset+10, self.selectionlabel.frame.origin.y, self.selectionlabel.frame.size.width, self.selectionlabel.frame.size.height);
    if (_labelForIndex) {
        _selectionlabel.text= _labelForIndex([self indexForPoint:touchPoint]);
    }
    [self setSelectionViewVisible:YES animated:YES];
}




- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_selectionVisible||([_data count] == 0)) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if ([self.delegate respondsToSelector:@selector(lineChartView:didSelectChartAtIndex:)])
    {
        [self.delegate lineChartView:self didSelectChartAtIndex:[self indexForPoint:touchPoint]];
    }
    
  
    CGFloat xOffset = fmin(self.bounds.size.width - self.selectionView.frame.size.width, fmax(0, touchPoint.x - (ceil(self.selectionView.frame.size.width * 0.5))));

    self.selectionView.frame = CGRectMake(xOffset, self.selectionView.frame.origin.y, self.selectionView.frame.size.width, self.selectionView.frame.size.height);
    
    if (xOffset>self.bounds.size.width/2) {
        xOffset-=80;
    }
    self.selectionlabel.frame= CGRectMake(xOffset+10, self.selectionlabel.frame.origin.y, self.selectionlabel.frame.size.width, self.selectionlabel.frame.size.height);
    if (_labelForIndex) {
      _selectionlabel.text= _labelForIndex([self indexForPoint:touchPoint]);
    }
    [self setSelectionViewVisible:YES animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    if (!_selectionVisible||([_data count] == 0)) {
        return;
    }
    [self setSelectionViewVisible:NO animated:YES];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    if ([self.delegate respondsToSelector:@selector(lineChartView:didSelectChartAtIndex:)])
    {
        [self.delegate lineChartView:self didSelectChartAtIndex:[self indexForPoint:touchPoint]];
    }

   
}




- (void)setSelectionViewVisible:(BOOL)selectionViewVisible animated:(BOOL)animated
{
//    _selectionViewVisible = selectionViewVisible;
    
    if (animated)
    {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.selectionView.alpha = selectionViewVisible ? 1.0 : 0.0;
            
                self.selectionlabel.alpha = selectionViewVisible ? 1.0 : 0.0;
        } completion:nil];
    }
    else
    {
        self.selectionView.alpha = selectionViewVisible ? 1.0 : 0.0;
           self.selectionlabel.alpha = selectionViewVisible ? 1.0 : 0.0;
    }
}



- (int)indexForPoint:(CGPoint)point
{
    int index = 0;
    CGFloat currentDistance = INT_MAX;
    int selectedIndex = -1;
    for (LineChartPoint *lineChartPoint  in _chartpointData)
    {
        if ((abs(point.x - lineChartPoint.position.x)) < currentDistance)
        {
            currentDistance = (abs(point.x - lineChartPoint.position.x));
            selectedIndex = index;
        }
        index++;
    }
    return selectedIndex;
}

- (void)setSelectionViewVisible:(BOOL)selectionViewVisible
{
    [self setSelectionViewVisible:selectionViewVisible animated:NO];
}
@end


@implementation LineChartPoint

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self)
    {
        _position = CGPointZero;
    }
    return self;
}

#pragma mark - Compare

- (NSComparisonResult)compare:(LineChartPoint *)otherObject
{
    return self.position.x > otherObject.position.x;
}

@end

