//
//  DynamicCommentObject.h
//  MinsLfie
//
//  Created by wodada on 2017/8/8.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "BaseObject.h"

@interface DynamicCommentObject : BaseObject

@property (nonatomic,copy) NSString *beCommentUserId;
@property (nonatomic,copy) NSString *beCommentUserName;
@property (nonatomic,copy) NSString *commentContent;
@property (nonatomic,copy) NSString *commentStatus;
@property (nonatomic,copy) NSString *commentType;
@property (nonatomic,copy) NSString *commentUserId;
@property (nonatomic,copy) NSString *commentUserName;
@property (nonatomic,copy) NSString *commentUserProfileUrl;
@property (nonatomic,copy) NSString *createdAt;
@property (nonatomic,copy) NSString *objectId;
@property (nonatomic,copy) NSString *relationId;
@property (nonatomic,copy) NSString *updatedAt;

@end
