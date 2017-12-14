//
//  MSTabBar.m
//  MinsLfie
//
//  Created by wodada on 2017/8/2.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "MSTabBar.h"

@implementation MSTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个按钮到tabbar中
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setImage:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe6da;"] inFont:ICONFONT size:25 color:[UIColor whiteColor]] forState:UIControlStateNormal];
        plusBtn.backgroundColor = [UIColor colorFromHex:MAIN_COLOR];
        plusBtn.layer.cornerRadius = 2;
        CGRect temp = plusBtn.frame;
        temp.size = CGSizeMake(55, 40);
        plusBtn.frame=temp;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)plusClick
{
    // 通知代理
    if ([self.mstabBarDelegate respondsToSelector:@selector(MSTabBar:)]) {
        [self.mstabBarDelegate MSTabBar:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
    CGPoint temp = self.plusBtn.center;
    temp.x=self.frame.size.width / 2;
    temp.y=self.frame.size.height / 2;
    self.plusBtn.center=temp;
    
    // 2.设置其它UITabBarButton的位置和尺寸
    CGFloat tabbarButtonW = self.frame.size.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            CGRect temp1=child.frame;
            temp1.size.width=tabbarButtonW;
            temp1.origin.x=tabbarButtonIndex * tabbarButtonW;
            child.frame=temp1;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

@end
