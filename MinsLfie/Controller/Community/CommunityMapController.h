//
//  CommunityMapController.h
//  MinsLfie
//
//  Created by wodada on 2017/8/15.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "BaseNavigationController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "DynamicsObject.h"

@interface CommunityMapController : BaseNavigationController

@property (nonatomic ,strong) BMKMapView *BMKMapView;
@property (nonatomic ,strong) DynamicsObject *dynamicsObject;

@end
