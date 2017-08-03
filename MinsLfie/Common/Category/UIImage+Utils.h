//
//  UIImage+Utils.h
//  Steps-iOS
//
//  Created by Jack Shi on 8/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

+ (UIImage *)createImageFromView:(UIView *)view;
+ (UIImage *)splitImage:(UIImage *)image inRect:(CGRect)rect;

- (CGSize)newSizeOfImage:(CGSize)size;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;


@end
