//
//  ProfileInfoCell.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ProfileInfoCell.h"

@interface ProfileInfoCell ()

@property (nonatomic,weak) UIImageView *headerView;
@property (nonatomic,weak) UILabel *nickNameLabel;

@end

@implementation ProfileInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (PRO_INFO_CELL_HEIGHT - 55) / 2, 55, 55)];
        headerView.layer.masksToBounds = YES;
        headerView.layer.cornerRadius = headerView.height / 2;
        headerView.image = [UIImage imageNamed:@"pro_head"];
        [self.contentView addSubview:headerView];
        self.headerView = headerView;
        //昵称
        UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame) + 15, (PRO_INFO_CELL_HEIGHT - 16) / 2, Screen_Width - CGRectGetMaxX(headerView.frame) - 15 - 2 * 20 - 16, 16)];
        nickNameLabel.text = @"Peanut丶";
        nickNameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:nickNameLabel];
        self.nickNameLabel = nickNameLabel;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
