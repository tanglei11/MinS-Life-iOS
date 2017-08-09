//
//  CommunityCommentCell.h
//  MinsLfie
//
//  Created by wodada on 2017/8/8.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicCommentObject.h"

@interface CommunityCommentCell : UITableViewCell

@property (nonatomic,strong) DynamicCommentObject *dynamicCommentObject;
@property (nonatomic,strong) NSString *dynamicUserId;
@property (nonatomic,assign) CGFloat cellHeight;

@end
