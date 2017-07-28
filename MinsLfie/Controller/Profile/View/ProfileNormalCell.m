//
//  ProfileNormalCell.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ProfileNormalCell.h"

@interface ProfileNormalCell ()

@property (nonatomic,weak) UIImageView *iconView;
@property (nonatomic,weak) UILabel *titleLabel;

@end

@implementation ProfileNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //图标
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (PRO_NORMAL_CELL_HEIGHT - 20) / 2, 20, 20)];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 12, (PRO_NORMAL_CELL_HEIGHT - 16) / 2, Screen_Width - CGRectGetMaxX(iconView.frame) - 12 - 2 * 20 - 16, 16)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)setCellData:(NSDictionary *)cellData
{
    _cellData = cellData;
    self.iconView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:cellData[@"icon"]] inFont:ICONFONT size:20 color:[UIColor colorFromHex:MAIN_COLOR]];
    self.titleLabel.text = cellData[@"title"];
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
