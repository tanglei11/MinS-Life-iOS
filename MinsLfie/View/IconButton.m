//
//  KHIconButton.m
//  快点来
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "IconButton.h"

@interface IconButton ()
@property (nonatomic,weak) UILabel *iconLbl;
@end

@implementation IconButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *iconLbl = [[UILabel alloc]init];
        CGFloat font = 18;
        iconLbl.font = [UIFont fontWithName:ICONFONT size:font];
        [self addSubview:iconLbl];
        self.iconLbl = iconLbl;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.iconLbl.text = [NSString changeISO88591StringToUnicodeString:text];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.iconLbl.textColor = textColor;
}

- (void)setIsTransForm:(BOOL)isTransForm
{
    if (isTransForm) {
        self.iconLbl.transform = CGAffineTransformMakeRotation(M_PI * 3 / 2);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.iconLbl.width = 18;
    self.iconLbl.height = 18;
    self.iconLbl.x = self.iconLbl.y = 0;
}

@end
