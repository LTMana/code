//
//  SenctionView.m
//  可折叠的tableview
//
//  Created by 刘博通 on 16/12/8.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "SenctionView.h"
#import "SectionModel.h"
@interface SenctionView ()

@property (strong ,nonatomic) UIImageView *arrowImage;
@property (strong ,nonatomic) UILabel *titleLabel;


@end



@implementation SenctionView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        self.arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (44 - 8) / 2, 15, 8)];
        self.arrowImage.image = [UIImage imageNamed:@"right.png"];
        [self.contentView addSubview:self.arrowImage];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, w, 44)];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, (44 - 20) / 2, w-20, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = [UIColor blackColor];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, w, 1)];
        line.backgroundColor = [UIColor darkGrayColor];
        [self.contentView addSubview:line];
        
        [self.contentView addSubview:self.titleLabel];
        
        self.contentView.backgroundColor = [UIColor yellowColor];
        
        
    }
    return self;
}


/*
 1、通过懒加载，设置“箭头”的方向
 2、通过头视图SectionView的点击，改变“箭头”的方向
 3、通过点击SectionView，回调block进行section刷新
 */
- (void)setModel:(SectionModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.titleLabel.text = model.title;
    if (model.isExpand) {       //展开
        self.arrowImage.transform = CGAffineTransformIdentity;
    }else{
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)btnClick:(UIButton *)sender{
    self.model.isExpand = ! self.model.isExpand;
    if (self.model.isExpand) {
        self.arrowImage.transform = CGAffineTransformIdentity;
    }else{
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    }
    if (self.block) {
        self.block(self.model.isExpand);
    }
}


@end
