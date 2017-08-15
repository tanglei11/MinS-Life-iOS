//
//  BaiduMapsManager.m
//  Steps-iOS
//
//  Created by Jack Shi on 4/09/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "BaiduMapsManager.h"

@implementation BaiduMapsManager

- (BOOL)isBaiduMapsInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
}

- (void)openMapsWithSearchKeywords:(NSString*)keywords
{
    NSString *urlString = [NSString stringWithFormat: @"baidumap://map/geocoder?address=%@", [self convertAddressToURLFormat:keywords]];
    [self openMapsWithURLString:urlString];
}

- (void)openMapsWithAddress:(NSString*)address
{
    [self openMapsWithSearchKeywords:address];
}

- (void)openMapsWithDirectionForDestinationAddress:(NSString *)destinationAddress
{
    NSString *urlString = [NSString stringWithFormat: @"baidumap://map/direction?origin=我的位置&destination=%@&mode=driving", [self convertAddressToURLFormat:destinationAddress]];
    [self openMapsWithURLString:urlString];
}

- (void)openMapsWithDirectionForStartAddress:(NSString *)startAddress destinationAddress:(NSString *)destinationAddress
{
    NSString *urlString = [NSString stringWithFormat: @"baidumap://map/direction?origin=%@&destination=%@&mode=driving", [self convertAddressToURLFormat:startAddress], [self convertAddressToURLFormat:destinationAddress]];
    [self openMapsWithURLString:urlString];
}
@end
