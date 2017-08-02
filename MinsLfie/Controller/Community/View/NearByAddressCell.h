//
//  NearByAddressCell.h
//  DccShangbao
//
//  Created by wodada on 2017/7/25.
//  Copyright © 2017年 Wodada-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface NearByAddressCell : UITableViewCell

@property (nonatomic,strong) AMapPOI *poiInfo;
@property (nonatomic,assign) BOOL isSelect;

@end
