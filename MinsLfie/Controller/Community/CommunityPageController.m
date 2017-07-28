//
//  CommunityPageController.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityPageController.h"

@interface CommunityPageController ()

@end

@implementation CommunityPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self setBottomShadow];
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"社区";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
