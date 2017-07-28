//
//  MarketPageController.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "MarketPageController.h"

@interface MarketPageController ()

@end

@implementation MarketPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self setBottomShadow];
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"跳蚤";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
