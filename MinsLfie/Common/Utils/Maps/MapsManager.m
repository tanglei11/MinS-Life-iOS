//
//  MapsManager.m
//  Steps-iOS
//
//  Created by Jack Shi on 4/09/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "MapsManager.h"
#import "AppleMapsManager.h"
#import "GoogleMapsManager.h"
#import "BaiduMapsManager.h"
#import "GaoDeMapsManager.h"

@implementation MapsManager

static AppleMapsManager *appleMapsManager;
static GoogleMapsManager *googleMapsManager;
static BaiduMapsManager *baiduMapsManager;
static GaoDeMapsManager *gaodeMapsManager;

+ (void)setUserDefaultMaps:(NSString *)mapsVendor
{
    [[NSUserDefaults standardUserDefaults] setValue:mapsVendor forKey:USER_DEFAULT_MAPS];
}

+ (NSString *)getUserDefaultMaps
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_MAPS];
}

+ (MapsManager *)userDefaultInstance
{
    NSString *userDefaultMaps = [self getUserDefaultMaps];
    if ([userDefaultMaps isEqualToString:GOOGLE_MAPS]) {
        return [self getGoogleMapsManager];
    }
    else if ([userDefaultMaps isEqualToString:BAIDU_MAPS]) {
        return [self getBaiduMapsManager];
    }
    else if ([userDefaultMaps isEqualToString:GAODE_MAPS]) {
        return [self getGaodeMapsManager];
    }
    return [self getAppleMapsManager];
}

+ (MapsManager *)getAppleMapsManager
{
    static dispatch_once_t dispatchOnceToken;
    
    dispatch_once(&dispatchOnceToken, ^{
        appleMapsManager = [AppleMapsManager new];
    });
    
    return appleMapsManager;
}

+ (MapsManager *)getGoogleMapsManager
{
    static dispatch_once_t dispatchOnceToken;
    
    dispatch_once(&dispatchOnceToken, ^{
        googleMapsManager = [GoogleMapsManager new];
    });
    
    return googleMapsManager;
}

+ (MapsManager *)getBaiduMapsManager
{
    static dispatch_once_t dispatchOnceToken;
    
    dispatch_once(&dispatchOnceToken, ^{
        baiduMapsManager = [BaiduMapsManager new];
    });
    
    return baiduMapsManager;
}

+ (MapsManager *)getGaodeMapsManager
{
    static dispatch_once_t dispatchOnceToken;
    
    dispatch_once(&dispatchOnceToken, ^{
        gaodeMapsManager = [GaoDeMapsManager new];
    });
    
    return gaodeMapsManager;
}

+ (BOOL)isGoogleMapsInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
}

+ (BOOL)isBaiduMapsInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
}

+ (BOOL)isGaodeMapsInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
}

- (NSString*)convertAddressToURLFormat:(NSString*)address
{
    return [[address stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)openMapsWithURLString:(NSString *)urlString
{
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)openMapsWithSearchKeywords:(NSString*)keywords
{
    NSAssert(NO, @"openMapsWithSearchKeywords: should be handled by subclass of MapsManager");
}

- (void)openMapsWithAddress:(NSString*)address
{
    NSAssert(NO, @"openMapsWithAddress: should be handled by subclass of MapsManager");
}

- (void)openMapsWithDirectionForDestinationAddress:(NSString *)destinationAddress
{
    NSAssert(NO, @"openMapsWithDirectionForDestinationAddress: should be handled by subclass of MapsManager");
}

- (void)openMapsWithDirectionForStartAddress:(NSString *)startAddress destinationAddress:(NSString *)destinationAddress
{
    NSAssert(NO, @"openMapsWithDirectionForStartAddress: should be handled by subclass of MapsManager");
}

@end
