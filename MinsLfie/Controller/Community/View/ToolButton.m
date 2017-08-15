//
//  ToolButton.m
//  DccShangbao
//
//  Created by wodada on 2017/7/19.
//  Copyright © 2017年 Wodada-Mac. All rights reserved.
//

#import "ToolButton.h"

@implementation ToolButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.width = self.imageView.height = 18;
    self.imageView.x = (self.width - self.imageView.width) / 2;
    self.imageView.y = (self.height - 18 - 12 - 6) / 2;
    
    self.titleLabel.width = self.width;
    self.titleLabel.height = 12;
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 6;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
