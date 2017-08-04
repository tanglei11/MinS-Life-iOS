//
//  DynamicsObject.h
//  MinsLfie
//
//  Created by wodada on 2017/8/4.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "BaseObject.h"
#import "DynamicsUserObject.h"

@interface DynamicsObject : BaseObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *addressName;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createdAt;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *objectId;
@property (nonatomic,strong) DynamicsUserObject *dynamicsUser;
@property (nonatomic,copy) NSString *userId;

@end
