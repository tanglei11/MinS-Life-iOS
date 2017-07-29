//
//  POIPhotosView.h
//  CityGuide
//
//  Created by Chris on 16/7/19.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosView : UIView

@property (nonatomic,strong) NSArray *photos;
//计算相册大小
+ (CGSize)SizeWithCount:(int)count;

@end
