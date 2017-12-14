//
//  MSTabBar.h
//  MinsLfie
//
//  Created by wodada on 2017/8/2.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSTabBar;

@protocol MSTabBarDelegate <NSObject>

- (void)MSTabBar:(MSTabBar *)MSTabBarDidClick;

@end

@interface MSTabBar : UITabBar

@property (strong,nonatomic) UIButton *plusBtn;
@property (nonatomic,weak) id<MSTabBarDelegate>mstabBarDelegate;

@end
