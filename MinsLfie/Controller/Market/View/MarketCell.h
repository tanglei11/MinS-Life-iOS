//
//  marketCell.h
//  MinsLfie
//
//  Created by wodada on 2017/8/15.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketObject.h"

@interface MarketCell : UITableViewCell

@property (nonatomic,strong) MarketObject *marketObject;
@property (nonatomic,assign) CGFloat cellHeight;

@end
