//
//  CommunityWriteController.h
//  MinsLfie
//
//  Created by wodada on 2017/8/1.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "BaseNavigationController.h"

typedef enum : NSUInteger {
    CommunityWriteControllerTypeMarket,
    CommunityWriteControllerTypeDynamic
} CommunityWriteControllerType;

@interface CommunityWriteController : BaseNavigationController

@property (nonatomic,assign) CommunityWriteControllerType type;

@end
