//
//  POIVIew.m
//  CityGuide
//
//  Created by 吴桐 on 16/6/7.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#define PLACE_IMAGEVIEW_MARGIN                                                            12
#define PLACE_IMAGEVIEW_RIGHT_MARGIN                                                  12

#import "POIVIew.h"

@implementation POIVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        // 图片视图
        CGFloat pictureWidth;
        if (IS_DEVICE_4_0_INCH) {
            pictureWidth = LISTCELL_PICTURE_WIDTH * WIDTH_SCALE - 8;
        }
        else {
            pictureWidth = LISTCELL_PICTURE_WIDTH;
        }
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PLACE_IMAGEVIEW_MARGIN, PLACE_IMAGEVIEW_MARGIN, pictureWidth, LISTCELL_PICTURE_HEIGHT)];
        // 默认设置为可以被裁减
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.masksToBounds = YES;
        /*
         * 默认这些的image为   BLANK_PICTURE_SIZE_44
         * 背景颜色调试成F2F2F2这样子的浅色
         * 需要居中显示
         */
        self.imageView.image = BLANK_PICTURE_SIZE_44;
        self.imageView.backgroundColor = [UIColor colorFromHex:@"F2F2F2"];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.imageView];
        // 标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + PLACE_IMAGEVIEW_RIGHT_MARGIN, 12, Screen_Width - pictureWidth - PLACE_IMAGEVIEW_MARGIN * 2 - PLACE_IMAGEVIEW_RIGHT_MARGIN, 18)];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
//        // 星级
//        self.starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, LISTCELL_HEIGHT - 12 - 17, 85, 17)];
//        [self addSubview:self.starView];
        // 详情
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + PLACE_IMAGEVIEW_RIGHT_MARGIN, CGRectGetMaxY(self.imageView.frame) - 16 - 6, self.titleLabel.frame.size.width, 16)];
        self.descLabel.font = [UIFont fontWithName:FONT_THIN size:13];
        [self addSubview:self.descLabel];
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

- (void)setPlace:(PlaceObject *)place
{
    CGFloat pictureWidth;
    if (IS_DEVICE_4_0_INCH) {
        pictureWidth = LISTCELL_PICTURE_WIDTH * WIDTH_SCALE - 8;
    }
    else {
        pictureWidth = LISTCELL_PICTURE_WIDTH;
    }
    _place = place;
    self.titleLabel.text  = place.name;
    self.titleLabel.height = [place.name boundingRectWithSize:CGSizeMake(Screen_Width - pictureWidth - PLACE_IMAGEVIEW_MARGIN * 2 - PLACE_IMAGEVIEW_RIGHT_MARGIN, 3 * 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    NSLog(@"%lf",self.titleLabel.height);
}

@end
