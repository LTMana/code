//
//  MChartView.m
//  TrafficIndex
//
//  Created by Mickey on 14-8-28.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "MChartView.h"

@implementation MChartView
@synthesize XLineText,YLineText,Lines,max,min,LineColors,title;
@synthesize titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self InitData];
    }
    return self;
}

- (void)InitData
{
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [self SetLinesName];
    
    [titleLabel removeFromSuperview];
    
    titleLabel = [[UILabel alloc]init];
    if (title)
    {
        titleLabel.text = [NSString stringWithFormat:@"%@指数趋势",title];
    }
    [titleLabel setFont:[UIFont fontWithName:@"TimesNewRomanPSMT" size:15]];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(self.frame.size.width/2, 2);
    [self addSubview:titleLabel];

    
     _DisColors = @[DeepGreen,lightGreen,yellow,lightRed,DeepRed];
    
    [self GetMaxIndex];
    // Drawing code
    //画Y轴文字
    for (int i = 0; i < self.YLineText.count; i++)
    {
        float yStart = self.frame.size.height - XGap-detailGap;
        float yTextSpace = (yStart-YGap) / (self.YLineText.count-1);
        
        [self drawTextStartX:YGap/2-3 StartY:(yStart-yTextSpace*i)-5 withString:[self.YLineText objectAtIndex:i]];
        
        [self drawLineStartX:YGap StartY:(yStart-yTextSpace*i) EndX:self.frame.size.width-YGap EndY:(yStart-yTextSpace*i) LineColor:[UIColor lightGrayColor].CGColor];
        
        //画色值块
        if (i<self.YLineText.count-1 && i < _DisColors.count)
        {
            CGRect frame = CGRectMake(YGap, (yStart-yTextSpace*(i+1)), 3, yTextSpace);
            [self drawDetailLayer:[_DisColors objectAtIndex:i] withFrame:frame];
        }
    }
    
    //X轴文字
    for (int i = 0; i < self.XLineText.count; i++)
    {
        float xStart = YGap;
        float xTextSpace = (self.frame.size.width-2*YGap)/(self.XLineText.count-1);
        
        [self drawTextStartX:(xStart+xTextSpace*i) StartY:(self.frame.size.height-XGap-detailGap/2)-5 withString:[self.XLineText objectAtIndex:i]];
        
        [self drawLineStartX:(xStart+xTextSpace*i) StartY:self.frame.size.height-XGap-detailGap EndX:(xStart+xTextSpace*i) EndY:XGap LineColor:[UIColor lightGrayColor].CGColor];
        
        [self drawLineStartX:YGap StartY:self.frame.size.height-XGap-detailGap EndX:YGap EndY:XGap LineColor:[UIColor lightGrayColor].CGColor];
        
         [self drawLineStartX:self.frame.size.width-YGap StartY:self.frame.size.height-XGap-detailGap EndX:self.frame.size.width-YGap EndY:XGap LineColor:[UIColor lightGrayColor].CGColor];
    }
    
    //画线
    self.ItemWidth = ((self.frame.size.width-2*YGap)/(self.TotleCount-1));
    
    for (int i = 0;i<self.Lines.count;i++)
    {
        NSArray* pointArray = [self.Lines objectAtIndex:i];
        UIColor *color = [self.LineColors objectAtIndex:i];
        
        for (int j = 0; j<pointArray.count-1; j++)
        {
            NSNumber* value = [pointArray objectAtIndex:j];
            float floatValue = value.floatValue;
            float y =  self.frame.size.height - XGap - detailGap - ((self.frame.size.height-2*XGap - detailGap)/self.max)*floatValue;
            float x = YGap + self.ItemWidth*j;
            
            NSNumber* value1 = [pointArray objectAtIndex:j+1];
            float floatValue1 = value1.floatValue;
            float NextY = self.frame.size.height - XGap - detailGap - ((self.frame.size.height-2*XGap - detailGap)/self.max)*floatValue1;
            float NextX = YGap + self.ItemWidth*(j+1);
            
            [self drawBoldLineStartX:x StartY:y EndX:NextX EndY:NextY LineColor:color.CGColor];
        }
    }
}

- (void)drawTextStartX:(CGFloat)X StartY:(CGFloat)Y withString:(NSString *)String
{
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*写文字*/
    CGContextSetRGBFillColor (context,  168/255.0, 168/255.0, 168/255.0, 1.0);//设置填充颜色
   
    NSMutableDictionary *strAttribs = [[NSMutableDictionary alloc] init];
    [strAttribs setObject:[UIColor blackColor] forKey:NSFontAttributeName];
    [String drawInRect:CGRectMake(X, Y, 45, 15) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIFont fontWithName:@"Helvetica" size:12], NSFontAttributeName,
                                                                    [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                                                    nil]];
}

- (void)drawLineStartX:(CGFloat)Start_X StartY:(CGFloat)Start_Y EndX:(CGFloat)End_X EndY:(CGFloat)End_Y LineColor :(CGColorRef)color
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //设置上下文
    //画一条线
    CGContextSetStrokeColorWithColor(context, color);//线条颜色
    CGContextSetLineWidth(context, 0.3);//线条宽度
    CGContextMoveToPoint(context, Start_X, Start_Y); //开始画线, x，y 为开始点的坐标
    CGContextAddLineToPoint(context, End_X, End_Y);//画直线, x，y 为线条结束点的坐标
    CGContextStrokePath(context); //开始画线
}

- (void)drawBoldLineStartX:(CGFloat)Start_X StartY:(CGFloat)Start_Y EndX:(CGFloat)End_X EndY:(CGFloat)End_Y LineColor :(CGColorRef)color
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //设置上下文
    //画一条线
    CGContextSetStrokeColorWithColor(context, color);//线条颜色
    CGContextSetLineWidth(context, 2.0);//线条宽度
    CGContextMoveToPoint(context, Start_X, Start_Y); //开始画线, x，y 为开始点的坐标
    CGContextAddLineToPoint(context, End_X, End_Y);//画直线, x，y 为线条结束点的坐标
    CGContextStrokePath(context); //开始画线
}

- (void)drawDetailLayer:(UIColor *)color withFrame:(CGRect)frame
{
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor =color.CGColor;
    sublayer.frame = frame;
    [self.layer addSublayer:sublayer];
}

- (void)SetLinesName
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i<self.linesName.count;i++)
    {
        NSString *name = [self.linesName objectAtIndex:i];
        
        float count;
        if (self.linesName.count>5)
        {
            count = 5;
        }
        else
        {
            count = self.linesName.count;
        }
        float width = ((self.frame.size.width - 40)/count);
        float x;
        float y;
        if (i>=5)
        {
            y = self.frame.size.height-15;
            x = YGap + (i-5)*width;
        }
        else
        {
            y = self.frame.size.height-30;
            x = YGap + i*width;
        }
        
        UILabel *lineName = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, 15)];
        lineName.text = [NSString stringWithFormat:@"—%@",name];
        lineName.textColor = [self.LineColors objectAtIndex:i];
        lineName.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:10];
        [self addSubview:lineName];
    }
}

- (void)GetMaxIndex
{
    float maxIndex = 0;
    
    for (NSArray *pointArray in self.Lines)
    {
        for (NSNumber *value in pointArray)
        {
            float floatValue = value.floatValue;
            if (floatValue > maxIndex)
            {
                maxIndex = floatValue;
            }
        }
    }
    if (maxIndex < 5)
    {
        self.YLineText = @[@"0",@"1",@"2",@"3",@"4",@"5"];
        self.max = 5;
        _DisColors = @[DeepGreen,DeepGreen,DeepGreen,DeepGreen,lightGreen];
    }
    else if (maxIndex < 10 && maxIndex >= 5)
    {
        self.YLineText = @[@"0",@"2",@"4",@"6",@"8",@"10"];
        self.max = 10;
        _DisColors = @[DeepGreen,DeepGreen,lightGreen,lightGreen,yellow];
    }
    else
    {
        self.YLineText = @[@"0",@"4",@"8",@"12",@"16",@"20"];
        self.max = 20;
        _DisColors = @[DeepGreen,lightGreen,yellow,lightRed,DeepRed];
    }
}


- (CGPoint)valuePoint:(float)value atIndex:(int)index
{
    CGPoint retPoint = CGPointZero;
    
    retPoint.x = index * self.ItemWidth + YGap;
    retPoint.y = self.frame.size.height - XGap - detailGap - value * ((self.frame.size.height-(2*XGap)-detailGap)/self.max);
    
    return retPoint;
}
/**
 *  display description view
 */
- (void)descriptionViewPointWithTouches:(NSSet *)touches
{
    CGSize size = self.frame.size;
    CGPoint location = [[touches anyObject] locationInView:self];
    if (location.x >= 0 && location.x <= size.width && location.y >= 0 && location.y <= size.height)
    {
        int intValue = location.x / self.ItemWidth;
        float remainder = location.x - intValue * self.ItemWidth;
        
        int index = intValue + (remainder >= self.ItemWidth * 0.5f ? 1 : 0);
        
        NSArray *indexs = [self.Lines objectAtIndex:0];
        if (index < indexs.count)
        {
            float value = [(NSNumber *)indexs[index] floatValue];
            CGPoint point = [self valuePoint:value atIndex:index];
            
            if ([self.delegate respondsToSelector:@selector(chartView:descriptionViewAtIndex:)])
            {
                UIView *descriptionView = [self.delegate chartView:self descriptionViewAtIndex:index];
                CGRect frame = descriptionView.frame;
                if (point.x + frame.size.width > size.width)
                {
                    frame.origin.x = point.x - frame.size.width;
                }
                else
                {
                    frame.origin.x = point.x;
                }
                
                if (frame.size.height + point.y > size.height)
                {
                    frame.origin.y = 10;
                   // frame.origin.y = point.y - frame.size.height;
                }
                else
                {
                    frame.origin.y = 10;
                   // frame.origin.y = point.y;
                }
                
                descriptionView.frame = frame;
                
                if (self.descriptionView)   [self.descriptionView removeFromSuperview];
                
                if (!self.slideLineView)
                {
                    //slide line view
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(.0f,
                                                                                 XGap,
                                                                                 1.0f,
                                                                                 self.frame.size.height - (XGap*2+detailGap))];
                    lineView.backgroundColor = [UIColor blackColor];
                    lineView.hidden = YES;
                    self.slideLineView = lineView;
                    [self addSubview:self.slideLineView];
                }
                
                //draw line
                CGRect slideLineViewFrame = self.slideLineView.frame;
                slideLineViewFrame.origin.x = point.x;
                self.slideLineView.frame = slideLineViewFrame;
                self.slideLineView.hidden = NO;
                
                [self addSubview:descriptionView];
                self.descriptionView = descriptionView;
                
                //delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:didMovedToIndex:)])
                {
                    [self.delegate chartView:self didMovedToIndex:index];
                }
                
            }
        }
    }
}
#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.Lines || !self.Lines.count) return;
    
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [UIView performWithoutAnimation:^{
        sleep(1);
        [self.descriptionView setHidden:YES];
        [self.slideLineView setHidden:YES];
    }];
    
    if (self.descriptionView && self.hideDescriptionViewWhenTouchesEnd)
    {
        [self.descriptionView removeFromSuperview];
        
        

    }
}
@end
