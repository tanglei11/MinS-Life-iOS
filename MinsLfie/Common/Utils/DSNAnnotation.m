//
//  DSNAnnotation.m
//  CityGuide
//
//  Created by Chris on 2016/12/9.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import "DSNAnnotation.h"

@implementation DSNAnnotation

- (NSString *)title
{
    return _title;
}
- (NSString *)subtitle
{
    return _subTitle;
}
- (CLLocationCoordinate2D)coordinate
{
    return _coordinate2D;
}
// 重写构造函数 以接口的形式修改上述的属性
- (id)initWithCoordinate2D:(CLLocationCoordinate2D)tempCoordinate2D title:(NSString *)tempTitle subTitle:(NSString *)tempSubTitle
{
    if (self = [super init])
    {
        _coordinate2D = tempCoordinate2D;
        _title = tempTitle;
        _subTitle = tempSubTitle;
    }
    return self;
}

@end
