//
//  CommunityCell.h
//  MinsLfie
//
//  Created by Peanut丶 on 2017/7/29.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicsObject.h"

typedef void(^CommunityCollectBlock)(DynamicsObject *dynamicsObject);
typedef void(^CommunityMapBlock)(DynamicsObject *dynamicsObject);
@interface CommunityCell : UITableViewCell

@property (nonatomic,strong) DynamicsObject *dynamicsObject;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,copy) CommunityCollectBlock communityCollectBlock;
@property (nonatomic,copy) CommunityMapBlock communityMapBlock;

@end
