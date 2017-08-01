//
//  MJRefreshImageHeader.m
//  CityGuide
//
//  Created by Chris on 16/8/11.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import "MJRefreshImageHeader.h"

@implementation MJRefreshImageHeader
//#pragma mark - 懒加载子控件
//- (UIImageView *)bgView
//{
//    if (!_bgView) {
//        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullDown_bg"]];
//        [self addSubview:_bgView = bgView];
//    }
//    return _bgView;
//}
//
//- (UIImageView *)airView
//{
//    if (!_airView) {
//        UIImageView *airView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullDown_air"]];
//        airView.hidden = YES;
//        [self addSubview:_airView = airView];
//    }
//    return _airView;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        /* 背景 */
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullDown_bg"]];
        [self addSubview:bgView];
        self.bgView = bgView;
        /* 飞机 */
        UIImageView *airView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullDown_air"]];
        airView.hidden = YES;
        [self addSubview:airView];
        self.airView = airView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    /* 背景 */
    self.bgView.width = self.bgView.image.size.width;
    self.bgView.height = self.bgView.image.size.height;
    self.bgView.x = (self.width - self.bgView.width) / 2;
    self.bgView.y = self.height - self.bgView.height;
    /* 飞机 */
    self.airView.width = self.airView.image.size.width;
    self.airView.height = self.airView.image.size.height;
    //self.airView.x = self.bgView.x + self.airView.width * 0.5;
    self.airView.y = self.bgView.y - self.airView.height * 0.6;
    
    self.height = _bgView.size.height + _airView.size.height ;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.airView.hidden = YES;
            self.airView.x = self.bgView.x + self.airView.width * 0.5;
            
            [UIView animateWithDuration:0 animations:^{
                
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                self.airView.hidden = YES;
                self.airView.x = self.bgView.x + self.airView.width * 0.5;
            }];
        } else {
            self.airView.hidden = YES;
            self.airView.x = self.bgView.x + self.airView.width * 0.5;
        }
    } else if (state == MJRefreshStatePulling) {
        self.airView.hidden = NO;
        self.airView.x = self.bgView.x + self.airView.width * 0.5;
        
    } else if (state == MJRefreshStateRefreshing) {
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:MJRefreshFastAnimationDuration];
        [UIView setAnimationDelegate:self];
        //改变它的frame的x,y的值
        self.airView.x = CGRectGetMaxX(self.bgView.frame) - self.airView.width;
        [UIView commitAnimations];

//        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//            
//        }];
    }
}

@end
