//
//  PlaceObject.h
//  MinsLfie
//
//  Created by wodada on 2017/7/31.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "BaseObject.h"

@interface PlaceObject : BaseObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *bgImg;
@property (nonatomic,copy) NSString *createdAt;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *objectId;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *placeType;
@property (nonatomic,copy) NSString *updatedAt;

@end
