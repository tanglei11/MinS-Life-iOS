//
//  MarketDetailCell.h
//  MinsLfie
//
//  Created by Peanut丶 on 2017/12/14.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketObject.h"

@interface MarketDetailCell : UITableViewCell

@property (nonatomic,strong) MarketObject *marketObject;
@property (nonatomic,assign) CGFloat cellHeight;

@end
