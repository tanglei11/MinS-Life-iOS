//
//  ToolClass.h
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolClass : NSObject

//iconfont 转化 image
+ (UIImage*)imageWithIcon:(NSString *)iconCode inFont:(NSString *)fontName size:(NSUInteger)size color:(UIColor *)color;

//添加cell下划线
+ (void)addUnderLineForCell:(UITableViewCell *)cell cellHeight:(CGFloat)height lineX:(CGFloat)lineX lineHeight:(CGFloat)lineHeight isJustified:(BOOL)isJustified;

//添加cell顶部线
+ (void)addTopLineForCell:(UITableViewCell *)cell lineX:(CGFloat)lineX lineHeight:(CGFloat)lineHeight isJustified:(BOOL)isJustified;
@end
