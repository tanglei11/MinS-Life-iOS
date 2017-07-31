//
//  DSNAnnotation.h
//  CityGuide
//
//  Created by Chris on 2016/12/9.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "PlaceObject.h"

typedef enum : NSUInteger {
    DSNAnnotationTypeAttraction,
    DSNAnnotationTypeHotel,
    DSNAnnotationTypeRestaurant,
    DSNAnnotationTypeMall,
    DSNAnnotationTypeStation,
    DSNAnnotationTypeActivity
} DSNAnnotationType;

@interface DSNAnnotation : BMKPointAnnotation
{
    CLLocationCoordinate2D _coordinate2D;
    NSString *_title;
    NSString *_subTitle;
}
// 项目对应属性
@property (nonatomic, strong) NSString *attitudeName;
@property (nonatomic, strong) PlaceObject *place;

@property (nonatomic) DSNAnnotationType type;

- (NSString *)title;
- (NSString *)subtitle;
- (CLLocationCoordinate2D)coordinate;
// 重写构造函数 以接口的形式修改上述的属性
- (id)initWithCoordinate2D:(CLLocationCoordinate2D)tempCoordinate2D title:(NSString *)tempTitle subTitle:(NSString *)tempSubTitle;
-(void)setType:(DSNAnnotationType)type;

@end
