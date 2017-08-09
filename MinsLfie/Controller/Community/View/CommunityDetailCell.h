//
//  CommunityDetailCell.h
//  MinsLfie
//
//  Created by wodada on 2017/8/8.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicsObject.h"

@interface CommunityDetailCell : UITableViewCell

@property (nonatomic,strong) DynamicsObject *dynamicsObject;
@property (nonatomic,assign) CGFloat cellHeight;

@end
