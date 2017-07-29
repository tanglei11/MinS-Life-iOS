
//
//  BaseNavigationController.m
//  JZB
//
//  Created by wodada on 2017/4/17.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PopDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    
}

- (void)setBottomShadow
{
    UIImageView *barLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, Screen_Height - 49 - 13, Screen_Width, 13)];
    barLine.image = [UIImage imageNamed:@"yinying"];
    [self.view addSubview:barLine];
}

#pragma mark -custom navigation bar 自定义的导航控制器
- (void)setupCustomNavigationBar3DTouch
{
    [self setupCustomNavigationBarWithStyle:CityGuideNavigationBarStyle3DTouch];
}

- (void)setupCustomNavigationBarDefault
{
    [self setupCustomNavigationBarWithStyle:CityGuideNavigationBarStyleDefault];
}

- (void)setupCustomNavigationBarClear
{
    [self setupCustomNavigationBarWithStyle:CityGuideNavigationBarStyleClear];
}

- (void)setupCustomNavigationBarWithStyle:(CityGuideNavigationBarStyle)style
{
    self.navigationController.navigationBarHidden = YES;
    
    CGFloat backgroundViewHeight = 0;
    CGFloat navigationBarHeight = 0;
    
    if (style == CityGuideNavigationBarStyle3DTouch) {
        backgroundViewHeight = STATUS_BAR_HEIGHT + 24;
        navigationBarHeight = 24;
    }else{
        backgroundViewHeight = STATIC_STATUS_AND_NAVIGATION_BAR_HEIGHT;
        navigationBarHeight = STATIC_NAVIGATION_BAR_HEIGHT;
    }
    
    UIView *customNavigationBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, backgroundViewHeight)];
    [self.view addSubview:customNavigationBarBackgroundView];
    //    [self.view addSubview:customNavigationBarBackgroundView];
    
    // 创建自定义的navigationBar
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, Screen_Width, navigationBarHeight)];
    if (style == CityGuideNavigationBarStyleDefault) {
        customNavigationBarBackgroundView.backgroundColor = [UIColor whiteColor];
        navigationBar.backgroundColor = [UIColor whiteColor];
        // 给加一条线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, STATIC_NAVIGATION_BAR_HEIGHT - LINE_HEIGHT, Screen_Width, LINE_HEIGHT)];
        lineView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
        [navigationBar addSubview:lineView];
    }
    
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17.f]}];
    [navigationBar setTintColor:[UIColor blackColor]];
    
    // remove navigation bar shadow, so segmented control looks like on the navigation bar
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationBar.items = [NSArray arrayWithObjects:navigationItem, nil];
    [customNavigationBarBackgroundView addSubview:navigationBar];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-6];
    
    self.customNavigationBarBackgroundView = customNavigationBarBackgroundView;
    self.customNavigationBar = navigationBar;
    self.customNavigationItem = navigationItem;
    self.customNavigationItemSpacer = negativeSpacer;
}

- (UIBarButtonItem *)setupCustomBlackBackButton
{
    int btnWidth = 18;
    int btnHeight = 18;
    // nav backBtn
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    UIImage *BlackReturn = BLACK_RETURN;
    [backButton setImage:BlackReturn forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(customBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.customNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return (UIBarButtonItem *)backButton;
}

- (UIBarButtonItem *)setupCustomWhiteBackButton
{
    int btnWidth = 18;
    int btnHeight = 18;
    // nav backBtn
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    UIImage *BlackReturn = WHITE_RETURN;
    [backButton setImage:BlackReturn forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(customBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.customNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return (UIBarButtonItem *)backButton;
}

- (UIBarButtonItem *)setupCustomWhiteBackButtonWithMask
{
    int btnWidth = 18;
    int btnHeight = 18;
    // nav backBtn
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(4, 6, btnWidth, btnHeight);
    UIImage *whiteReturn = WHITE_RETURN;
    [backButton setImage:whiteReturn forState:UIControlStateNormal];
    //    [backButton addTarget:self action:@selector(customBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    backButton.userInteractionEnabled = NO;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    backgroundView.layer.cornerRadius = 15;
    [backgroundView addSubview:backButton];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customBackButtonTapped:)];
    [backgroundView addGestureRecognizer:tap];
    self.customNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backgroundView];
    return (UIBarButtonItem *)backButton;
}

- (UIBarButtonItem *)setupCustomCloseButton
{
    int btnWidth = 18;
    int btnHeight = 18;
    // nav backBtn
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    UIImage *back = BACK;
    [backButton setImage:back forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(customBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.customNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return (UIBarButtonItem *)backButton;
}

- (void)customBackButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
