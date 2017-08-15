//
//  MapsManager.h
//  Steps-iOS
//
//  Created by Jack Shi on 4/09/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_DEFAULT_MAPS   @"UserDefalutMaps"
#define APPLE_MAPS          @"APPLE_MAPS"
#define GOOGLE_MAPS         @"GOOGLE_MAPS"
#define BAIDU_MAPS          @"BAIDU_MAPS"
#define GAODE_MAPS          @"GAODE_MAPS"

@interface MapsManager : NSObject

+ (void)setUserDefaultMaps:(NSString *)mapsVendor;
+ (NSString *)getUserDefaultMaps;
+ (MapsManager *)userDefaultInstance;
+ (MapsManager *)getAppleMapsManager;
+ (MapsManager *)getGoogleMapsManager;
+ (MapsManager *)getBaiduMapsManager;
+ (BOOL)isGoogleMapsInstalled;
+ (BOOL)isBaiduMapsInstalled;
+ (BOOL)isGaodeMapsInstalled;

- (NSString*)convertAddressToURLFormat:(NSString*)address;
- (void)openMapsWithURLString:(NSString *)urlString;

- (void)openMapsWithSearchKeywords:(NSString*)keywords;
- (void)openMapsWithAddress:(NSString*)address;
- (void)openMapsWithDirectionForDestinationAddress:(NSString *)destinationAddress;
- (void)openMapsWithDirectionForStartAddress:(NSString *)startAddress destinationAddress:(NSString *)destinationAddress;
@end
