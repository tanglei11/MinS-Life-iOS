//
//  GoogleMapsManager.m
//  Steps-iOS
//
//  Created by Jack Shi on 4/09/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "GoogleMapsManager.h"

@implementation GoogleMapsManager

- (BOOL)isGoogleMapsInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
}

- (void)openMapsWithSearchKeywords:(NSString*)keywords
{
//    NSString *urlString = [NSString stringWithFormat: @"comgooglemaps://?q=%@", [self convertAddressToURLFormat:keywords]];
//    [self openMapsWithURLString:urlString];
//    [self openMapsWithSearchKeywords:keywords callBackAppName:APP_NAME callBackUrlScheme:URL_SCHEME];
}

- (void)openMapsWithAddress:(NSString*)address
{
    [self openMapsWithSearchKeywords:address];
}

- (void)openMapsWithDirectionForDestinationAddress:(NSString *)destinationAddress
{
//    NSString *urlString = [NSString stringWithFormat: @"comgooglemaps://?daddr=%@", [self convertAddressToURLFormat:destinationAddress]];
//    [self openMapsWithURLString:urlString];
//    [self openMapsWithDirectionForDestinationAddress:destinationAddress callBackAppName:APP_NAME callBackUrlScheme:URL_SCHEME];
}

- (void)openMapsWithDirectionForStartAddress:(NSString *)startAddress destinationAddress:(NSString *)destinationAddress
{
//    NSString *urlString = [NSString stringWithFormat: @"comgooglemaps://?saddr=%@&daddr=%@", [self convertAddressToURLFormat:startAddress], [self convertAddressToURLFormat:destinationAddress]];
//    [self openMapsWithURLString:urlString];
//    [self openMapsWithDirectionForStartAddress:startAddress destinationAddress:destinationAddress callBackAppName:APP_NAME callBackUrlScheme:URL_SCHEME];
}


/**
  *   Call back functions
  */

- (void)openMapsWithSearchKeywords:(NSString*)keywords callBackAppName:(NSString *)callBackAppName callBackUrlScheme:(NSString *)callBackUrlScheme
{
    NSString *urlString = [NSString stringWithFormat: @"comgooglemaps-x-callback://?q=%@", [self convertAddressToURLFormat:keywords]];
    urlString = [NSString stringWithFormat:@"%@&x-source=%@&x-success=%@", urlString, callBackAppName, callBackUrlScheme];
    [self openMapsWithURLString:urlString];
}

- (void)openMapsWithAddress:(NSString*)address callBackAppName:(NSString *)callBackAppName callBackUrlScheme:(NSString *)callBackUrlScheme
{
    [self openMapsWithSearchKeywords:address callBackAppName:callBackAppName callBackUrlScheme:callBackUrlScheme];
}

- (void)openMapsWithDirectionForDestinationAddress:(NSString *)destinationAddress callBackAppName:(NSString *)callBackAppName callBackUrlScheme:(NSString *)callBackUrlScheme
{
    NSString *urlString = [NSString stringWithFormat: @"comgooglemaps-x-callback://?daddr=%@", [self convertAddressToURLFormat:destinationAddress]];
    urlString = [NSString stringWithFormat:@"%@&x-source=%@&x-success=%@", urlString, callBackAppName, callBackUrlScheme];
    [self openMapsWithURLString:urlString];
}

- (void)openMapsWithDirectionForStartAddress:(NSString *)startAddress destinationAddress:(NSString *)destinationAddress callBackAppName:(NSString *)callBackAppName callBackUrlScheme:(NSString *)callBackUrlScheme
{
    NSString *urlString = [NSString stringWithFormat: @"comgooglemaps-x-callback://?saddr=%@&daddr=%@", [self convertAddressToURLFormat:startAddress], [self convertAddressToURLFormat:destinationAddress]];
    urlString = [NSString stringWithFormat:@"%@&x-source=%@&x-success=%@", urlString, callBackAppName, callBackUrlScheme];
    [self openMapsWithURLString:urlString];
}

@end
