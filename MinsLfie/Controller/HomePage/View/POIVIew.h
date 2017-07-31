//
//  POIVIew.h
//  CityGuide
//
//  Created by 吴桐 on 16/6/7.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceObject.h"
//#import "StarView.h"

@interface POIVIew : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) StarView *starView;
@property (nonatomic, strong) PlaceObject *place;

@end
