//
//  BubuProgressHUD.m
//  加载动画
//
//  Created by 吴桐 on 16/7/20.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import "MSProgressHUD.h"

@interface MSProgressHUD ()
@property (nonatomic, strong) UIImageView *pi;

@end

@implementation MSProgressHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        UIView *hud = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 130) / 2 , (frame.size.height - 110) / 2, 130, 110)];
        hud.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        hud.layer.cornerRadius = 15.f;
        
        [self addSubview:hud];
        
        UIImageView *pi = [[UIImageView alloc] initWithFrame:CGRectMake((130 - 50) / 2, 18, 50, 50)];
        pi.image = [UIImage imageNamed:@"pho_loading"];
        [hud addSubview:pi];
        self.pi = pi;
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pi.frame) + 8, hud.frame.size.width, 16)];
        lb.text = @"拼命加载中";
        lb.textColor = [UIColor whiteColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:14.f];
        [hud addSubview:lb];
        self.lb = lb;
    }
    return self;
}

+ (instancetype)showHUDAddedTo:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MSProgressHUD *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    [hud startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUDForView:view animated:YES];
    });
    return hud;
}

+ (instancetype)showHUDAddedToWindow:(UIWindow *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MSProgressHUD *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    [hud startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUDForWindow:view animated:YES];
    });
    return hud;
}

+ (BOOL)hideHUDForWindow:(UIWindow *)view animated:(BOOL)animated {
    MSProgressHUD *hud = [self HUDForWindow:view];
    if (hud != nil) {
        [hud removeFromSuperview];
        return YES;
    }
    return NO;
}

+ (instancetype)HUDForWindow:(UIWindow *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (MSProgressHUD *)subview;
        }
    }
    return nil;
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    MSProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        [hud removeFromSuperview];
        return YES;
    }
    return NO;
}

+ (instancetype)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MSProgressHUD *hud = [[self alloc] initWithView:view];
    hud.lb.text = message;
    [view addSubview:hud];
    [hud startAnimation];
    return hud;
}

+ (instancetype)HUDForView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (MSProgressHUD *)subview;
        }
    }
    return nil;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}


- (void)startAnimation
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.pi.height = 48;
        self.pi.y = 18 + 2;
    } completion:^(BOOL finished) {
        
    }];
}
@end
