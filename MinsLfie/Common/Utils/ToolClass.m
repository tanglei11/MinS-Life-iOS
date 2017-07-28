//
//  ToolClass.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ToolClass.h"

@implementation ToolClass

//iconfont 转化 image
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color {
    CGSize imageSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font = [UIFont fontWithName:fontName size:size];
    label.text = iconCode;
    if(color){
        label.textColor = color;
    }
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    return retImage;
}

//添加cell下划线
+ (void)addUnderLineForCell:(UITableViewCell *)cell cellHeight:(CGFloat)height lineX:(CGFloat)lineX lineHeight:(CGFloat)lineHeight isJustified:(BOOL)isJustified
{
    
    UIView *line = [[UIView alloc]init];
    
    if (isJustified) {
        line.frame = CGRectMake(lineX, height - LINE_HEIGHT, Screen_Width - lineX * 2, lineHeight);
    }else{
        line.frame = CGRectMake(lineX, height - LINE_HEIGHT, Screen_Width - lineX, lineHeight);
    }
    
    line.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
    [cell addSubview:line];
}

//添加cell顶部线
+ (void)addTopLineForCell:(UITableViewCell *)cell lineX:(CGFloat)lineX lineHeight:(CGFloat)lineHeight isJustified:(BOOL)isJustified
{
    UIView *line = [[UIView alloc]init];
    
    if (isJustified) {
        line.frame = CGRectMake(lineX, 0, Screen_Width - lineX * 2, lineHeight);
    }else{
        line.frame = CGRectMake(lineX, 0, Screen_Width - lineX, lineHeight);
    }
    
    line.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
    [cell addSubview:line];
}

@end
