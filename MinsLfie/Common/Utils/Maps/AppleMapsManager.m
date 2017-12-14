//
//  AppleMapsManager.m
//  Steps-iOS
//
//  Created by Jack Shi on 4/09/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "AppleMapsManager.h"

@implementation AppleMapsManager

- (void)openMapsWithSearchKeywords:(NSString*)keywords
{
    NSString *urlString = [NSString stringWithFormat: @"http://maps.apple.com/?q=%@", [self convertAddressToURLFormat:keywords]];
    [self openMapsWithURLString:urlString];
}

- (void)openMapsWithAddress:(NSString*)address
{
    [self openMapsWithSearchKeywords:address];
}

- (void)openMapsWithDirectionForDestinationAddress:(NSString *)destinationAddress
{
    NSString *urlString = [NSString stringWithFormat: @"http://maps.apple.com/maps?saddr=&daddr=%@", [self convertAddressToURLFormat:destinationAddress]];
    [self openMapsWithURLString:urlString];
}


- (void)openMapsWithDirectionForStartAddress:(NSString *)startAddress destinationAddress:(NSString *)destinationAddress
{
    NSString *urlString = [NSString stringWithFormat: @"http://maps.apple.com/maps?saddr=%@&daddr=%@", [self convertAddressToURLFormat:startAddress], [self convertAddressToURLFormat:destinationAddress]];
    [self openMapsWithURLString:urlString];
}

@end
