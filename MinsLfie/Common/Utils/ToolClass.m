//
//  ToolClass.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ToolClass.h"
#import <CoreText/CoreText.h>

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

// 创建有间距的文字
+ (NSMutableAttributedString *)createTextWithString:(NSString *)str fontSize:(CGFloat)size lineSpacing:(NSInteger)lingSpacing isFontThin:(BOOL)isFontThin
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    long number = 1.f;//间距
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lingSpacing];
    //    [paragraphStyle setParagraphSpacing:-5];
    //    [paragraphStyle setParagraphSpacingBefore:5];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    if (isFontThin) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_THIN size:size] range:NSMakeRange(0, str.length)];
    }else{
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, str.length)];
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
    CFRelease(num);
    return attributedString;
}

// 计算有行间距文字的rect
+ (CGRect)caculateText:(NSMutableAttributedString *)str maxSize:(CGSize)maxSize
{
    if (str) {
        CGRect labelRect = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading context:nil];
        return labelRect;
    }
    else {
        return CGRectZero;
    }
    
}

@end
