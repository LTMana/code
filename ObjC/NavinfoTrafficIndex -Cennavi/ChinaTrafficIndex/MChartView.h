//
//  MChartView.h
//  TrafficIndex
//
//  Created by Mickey on 14-8-28.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
#define DeepGreen   [UIColor colorWithRed:104.0/255 green:200.0/255 blue:19.0/255 alpha:1]
#define lightGreen  [UIColor colorWithRed:181.0/255 green:241.0/255 blue:78.0/255 alpha:1]
#define yellow      [UIColor colorWithRed:238.0/255 green:162.0/255 blue:0.0/255 alpha:1]
#define red         [UIColor colorWithRed:255.0/255 green:0.0/255 blue:0.0/255 alpha:1]
#define DeepRed         [UIColor colorWithRed:205.0/255 green:0.0/255 blue:0.0/255 alpha:1]
*/

#define IOS7            ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES : NO)
#define YGap (20)
#define XGap (20)
#define detailGap (40)

@class MChartView;

@protocol MChartViewDelegate <NSObject>
@optional
/**
 *  when touched and did moved to index
 */
- (void)chartView:(MChartView *)chartView didMovedToIndex:(NSInteger)index;
- (UIView *)chartView:(MChartView *)chartView descriptionViewAtIndex:(NSInteger)index;
@end

@interface MChartView : UIView
@property(nonatomic,retain)NSArray *XLineText;
@property(nonatomic,retain)NSArray *YLineText;
@property(nonatomic,assign)NSUInteger max;
@property(nonatomic,assign)NSUInteger min;
@property(nonatomic,retain)NSArray *LineColors;
@property(nonatomic,retain)NSArray *Lines;     //画线数组   
@property(nonatomic,assign)NSUInteger TotleCount;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSArray *DisColors;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)NSArray *linesName;
@property(nonatomic,assign)BOOL hideDescriptionViewWhenTouchesEnd;
@property(nonatomic,assign)float ItemWidth;
@property (nonatomic, retain) UIView *descriptionView;
@property (nonatomic, retain) UIView *slideLineView;
@property (nonatomic, assign) IBOutlet id<MChartViewDelegate> delegate;


@end
