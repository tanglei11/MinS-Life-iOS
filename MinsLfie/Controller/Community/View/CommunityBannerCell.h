//
//  CommunityBannerCell.h
//  MinsLfie
//
//  Created by Peanut丶 on 2017/7/29.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BannerCloseBlock)();
@interface CommunityBannerCell : UITableViewCell

@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,copy) BannerCloseBlock bannerCloseBlock;

@end
