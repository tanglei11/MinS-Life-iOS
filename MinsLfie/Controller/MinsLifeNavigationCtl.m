//
//  MinsLifeNavigationCtl.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "MinsLifeNavigationCtl.h"

@interface MinsLifeNavigationCtl ()<UINavigationControllerDelegate>

@property (nonatomic, weak) id PopDelegate;

@end

@implementation MinsLifeNavigationCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PopDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        // 1.判断是否不是主视图   然后改写跳转到的子视图的tabbar隐藏
        //        viewController.hidesBottomBarWhenPushed = YES;
        
        // 2.不是主视图的返回按钮
        int btnWidth = 22;
        int btnHeight = 22;
        // nav backBtn
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, btnWidth, btnHeight);
        UIImage *BlackReturn = BLACK_RETURN;
        [backButton setImage:BlackReturn forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backClick
{
    [self popViewControllerAnimated:YES];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.PopDelegate;
    }
    else {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
