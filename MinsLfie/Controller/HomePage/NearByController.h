//
//  NearByController.h
//  MinsLfie
//
//  Created by wodada on 2017/7/31.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "BaseNavigationController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "POIVIew.h"

@interface NearByController : BaseNavigationController

@property (nonatomic ,strong) BMKMapView* BMKMapView;
@property (nonatomic, strong) POIVIew *POIView; // 点击大头针以后POI详情View

@end
