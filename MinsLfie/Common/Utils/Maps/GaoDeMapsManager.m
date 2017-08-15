//
//  GaoDeMapsManager.m
//  Steps
//
//  Created by Auro on 15/3/30.
//  Copyright (c) 2015年 Jack Shi. All rights reserved.
//

#import "GaoDeMapsManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
//#import "ErrorHandler.h"

@implementation GaoDeMapsManager

- (void)openMapsWithAddress:(NSString*)address
{
//    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
//    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
//        if ([placemarks count] > 0 && error == nil)
//        {
//            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
//            NSString *urlString = [NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=0", APP_NAME, URL_SCHEME, address,firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude];
//            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//        }
//        else if ([placemarks count] == 0 && error == nil)
//        {
//            [ErrorHandler alertErrorMessage:[NSString stringWithFormat:@"没有找到%@",address]];
//        }
//        else if (error != nil)
//        {
//            [ErrorHandler alertErrorMessage:@"出错"];
//        }
//    }];
//    NSString *urlString = [NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=%@&backScheme=%@&poiname=%@&dev=0", APP_NAME, URL_SCHEME, address];
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)openMapsWithDirectionForDestinationAddress:(NSString *)destinationAddress
{
//    NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&dev=0&style=0", APP_NAME, URL_SCHEME, destinationAddress];
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
//    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
//    [myGeocoder geocodeAddressString:destinationAddress completionHandler:^(NSArray *placemarks, NSError *error) {
//        if ([placemarks count] > 0 && error == nil)
//        {
//            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
//            NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&poiid=&lat=%f&lon=%f&dev=0&style=2", APP_NAME, URL_SCHEME, destinationAddress, firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude];
//            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//        }
//        else if ([placemarks count] == 0 && error == nil)
//        {
//            [ErrorHandler alertErrorMessage:[NSString stringWithFormat:@"没有找到%@",destinationAddress]];
//        }
//        else if (error != nil)
//        {
//            [ErrorHandler alertErrorMessage:@"出错"];
//        }
//    }];
}


@end




