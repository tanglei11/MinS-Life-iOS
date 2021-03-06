//
//  CommunityAddressSelectController.h
//  MinsLfie
//
//  Created by wodada on 2017/8/1.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "BaseNavigationController.h"
#import "NearByAddressCell.h"
@class CommunityAddressSelectController;

@protocol CommunityAddressSelectControllerDelegate <NSObject>

- (void)communityAddressSelectController:(CommunityAddressSelectController *)communityAddressSelectController disPassPoiInfo:(AMapPOI *)poiInfo;
- (void)communityAddressSelectController:(CommunityAddressSelectController *)communityAddressSelectControllerDidPassEmpty;

@end

@interface CommunityAddressSelectController : BaseNavigationController

@property (nonatomic,weak) id<CommunityAddressSelectControllerDelegate>delegate;
@property (nonatomic,strong) AMapPOI *selectPoi;

@end
