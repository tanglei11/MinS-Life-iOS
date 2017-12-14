//
//  BubuProgressHUD.h
//  加载动画
//
//  Created by 吴桐 on 16/7/20.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSProgressHUD : UIView
@property (nonatomic, strong) UILabel *lb;

+ (instancetype)showHUDAddedTo:(UIView *)view;
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
+ (instancetype)showMessage:(NSString *)message toView:(UIView *)view;

+ (instancetype)showHUDAddedToWindow:(UIWindow *)view;
+ (BOOL)hideHUDForWindow:(UIWindow *)view animated:(BOOL)animated;
+ (instancetype)HUDForView:(UIView *)view;
@end
