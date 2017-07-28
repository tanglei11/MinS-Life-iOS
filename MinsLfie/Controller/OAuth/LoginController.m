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
    topBgView.image = [UIImage boxblurImage:[UIImage imageNamed:@"top_bg"] withBlurNumber:0.6];
    [self.view addSubview:topBgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, Screen_Width, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"MINS  LIFE";
    [topBgView addSubview:titleLabel];
    
    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(topBgView.width * 0.25 - 8, topBgView.height - 10, 16, 16)];
    flagView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe79c;"] inFont:ICONFONT size:16 color:[UIColor whiteColor]];
    [topBgView addSubview:flagView];
    
    NSArray *titleArray = @[@"登录",@"注册"];
    CGFloat btnW = topBgView.width / 2;
//    CGFloat btnH = 
//    for (int i = 0; i < titleArray.count; i++) {
//        UIButton *button = [UIButton alloc] initWithFrame:CGRectMake(i * , <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    }
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
