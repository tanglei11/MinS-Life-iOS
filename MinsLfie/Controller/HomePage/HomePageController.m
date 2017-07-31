//
//  HomePageController.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "HomePageController.h"


//控制器
#import "HomeController.h"
#import "NearByController.h"

#define kSliderWidth (30.0f)
#define kSearchBarWidth (60.0f)

@interface HomePageController ()

@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, strong) UIColor *menuitemNormalColor;  // menuitem的正常颜色
@property (nonatomic, strong) UIColor *menuitemSelectedColor;  // menuitem的选中颜色

@property (nonatomic, assign) NearByController *nearByController;

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置选中颜色
    self.menuitemNormalColor = [UIColor colorFromHex:@"#939393"];
    self.menuitemSelectedColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
    
    // 先在这里设置好滑块的宽度，到时候需要按照字的多少来进行计算
    self.magicView.sliderWidth = kSliderWidth;
    
    [self setupMagicView];
    self.magicView.rightNavigatoinItem.hidden = YES;
    [self generateTestData];
    [self.magicView reloadData];
    
    [self setBottomShadow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setupMagicView
{
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.magicView.navigationInset = UIEdgeInsetsMake(0, kSearchBarWidth, 0, 0);
    self.magicView.layoutStyle = VTLayoutStyleCenter;
    self.magicView.switchStyle = VTSwitchStyleDefault;
    self.magicView.navigationHeight = 44.f;
    self.magicView.againstStatusBar = YES;
    self.magicView.dataSource = self;
    self.magicView.delegate = self;
}

- (void)generateTestData
{
    _menuList = @[@"校园",@"附近"];
}

- (void)setBottomShadow
{
    UIImageView *barLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, Screen_Height - 49 - 13, Screen_Width, 13)];
    barLine.image = [UIImage imageNamed:@"yinying"];
    [self.view addSubview:barLine];
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        // 设置菜单item的选中和非选中颜色
        [menuItem setTitleColor:_menuitemNormalColor forState:UIControlStateNormal];
        [menuItem setTitleColor:_menuitemSelectedColor forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    if (pageIndex == 0) {
        [self.magicView.rightNavigatoinItem setHidden:YES];
    }
    else if (pageIndex == 1) {
        [self.magicView.rightNavigatoinItem setHidden:NO];
    }
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (pageIndex == 0)
    {
        static NSString *gridId = @"Message.identifier";
        HomeController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[HomeController alloc] init];
        }
        return viewController;
    }
    static NSString *gridId = @"Dynamic.identifier";
    NearByController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[NearByController alloc] init];
        self.nearByController = viewController;
    }
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex
{
    if (itemIndex == 0) {
        [self.magicView.rightNavigatoinItem setHidden:YES];
    }
    else {
        [self.magicView.rightNavigatoinItem setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
