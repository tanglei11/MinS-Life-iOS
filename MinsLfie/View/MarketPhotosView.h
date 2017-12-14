//
//  MarketPhotosView.h
//  MinsLfie
//
//  Created by Peanut丶 on 2017/12/14.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketPhotosView : UIView

@property (nonatomic,strong) NSArray *photos;
//计算相册大小
+ (CGSize)SizeWithCount:(int)count;

@end
