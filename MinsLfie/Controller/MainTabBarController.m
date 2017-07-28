//
//  MainTabBarController.m
//  DccShangbao
//
//  Created by Wodada-Mac on 2017/5/17.
//  Copyright © 2017年 Wodada-Mac. All rights reserved.
//

#import "MainTabBarController.h"
//#import "BaseNavigationController.h"
#import "MinsLifeNavigationCtl.h"
#import "HomePageController.h"
#import "MarketPageController.h"
#import "CommunityPageController.h"
#import "ProfilePageController.h"

@interface MainTabBarController () <UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllChildVc];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
}

- (void)setUpAllChildVc
{
    
    HomePageController *homePageController = [[HomePageController alloc] init];
    UIImage *homeNormalImage = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe6b8;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#4A505A"]];
    UIImage *homeSelectImage = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe6bb;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#4A505A"]];
    
    [self setUpOneChildVcWithVc:homePageController Image:homeNormalImage selectedImage:homeSelectImage title:@""];
    
    MarketPageController *marketPageController = [[MarketPageController alloc] init];
    UIImage *marketNormalImage = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe7c0;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#4A505A"]];
    UIImage *marketSelectImage = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe7bf;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#4A505A"]];
    [self setUpOneChildVcWithVc:marketPageController Image:marketNormalImage selectedImage:marketSelectImage title:@""];
    
    CommunityPageController *communityPageController = [[CommunityPageController alloc] init];
    UIImage *communityNormalImage = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe65f;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#4A505A"]];
    UIImage *communitySelectImage = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe65e;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#4A505A"]];
    [self setUpOneChildVcWithVc:communityPageController Image:communityNormalImage selectedImage:communitySelectImage title:@""];
    
    ProfilePageController *profilePageController = [[ProfilePageController alloc] init];
    UIImage *profileNormalImage = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe736;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#4A505A"]];
    UIImage *profileSelectImage = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe735;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#4A505A"]];
    [self setUpOneChildVcWithVc:profilePageController Image:profileNormalImage selectedImage:profileSelectImage title:@""];
    
}
#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    MinsLifeNavigationCtl *nav = [[MinsLifeNavigationCtl alloc] initWithRootViewController:Vc];
    
    Vc.view.backgroundColor = [UIColor whiteColor];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = image;
    
    Vc.tabBarItem.selectedImage = selectedImage;
    
    Vc.tabBarItem.title = title;
    
    Vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    Vc.navigationItem.title = title;
    
    Vc.tabBarItem.enabled = YES;
    
    [self addChildViewController:nav];
}

@end