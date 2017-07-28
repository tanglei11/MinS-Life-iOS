//
//  BaseNavigationController.h
//  JZB
//
//  Created by wodada on 2017/4/17.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CityGuideNavigationBarStyle)
{
    CityGuideNavigationBarStyle3DTouch,
    CityGuideNavigationBarStyleDefault, // with entered text section
    CityGuideNavigationBarStyleClear
};


@interface BaseNavigationController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, retain) UIView *customNavigationBarBackgroundView;
@property (nonatomic, retain) UINavigationBar *customNavigationBar;
@property (nonatomic, retain) UINavigationItem *customNavigationItem;
@property (nonatomic, retain) UIBarButtonItem *customNavigationItemSpacer;

- (void)setupCustomNavigationBar3DTouch;
- (void)setupCustomNavigationBarDefault;
- (void)setupCustomNavigationBarClear;
- (void)setupCustomNavigationBarWithStyle:(CityGuideNavigationBarStyle)style;
- (UIBarButtonItem *)setupCustomBlackBackButton;


- (UIBarButtonItem *)setupCustomWhiteBackButton;

- (UIBarButtonItem *)setupCustomWhiteBackButtonWithMask;


- (UIBarButtonItem *)setupCustomCloseButton;

@property (nonatomic, weak) id PopDelegate;

- (void)setBottomShadow;

@end
