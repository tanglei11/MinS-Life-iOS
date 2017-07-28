//
//  LoginController.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "LoginController.h"
#import "UIImage+FEBoxBlur.h"

@interface LoginController ()

@property (nonatomic)BOOL statusBarStyleControl;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNav];
    
    [self initContentView];
}

- (void)initNav
{
    [self setupCustomNavigationBarClear];
}

- (void)initContentView
{
    UIImageView *topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 170)];
    topBgView.clipsToBounds = YES;
    topBgView.contentMode = UIViewContentModeScaleAspectFill;
    topBgView.image = [UIImage boxblurImage:[UIImage imageNamed:@"top_bg"] withBlurNumber:0.3];
    [self.view addSubview:topBgView];
}

#ifdef __IPHONE_8_0
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.statusBarStyleControl) {
        return UIStatusBarStyleDefault;
    }
    else {
        return UIStatusBarStyleLightContent;
    }
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
