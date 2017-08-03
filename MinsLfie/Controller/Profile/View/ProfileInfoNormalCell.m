//
//  ProfileInfoNormalCell.m
//  MinsLfie
//
//  Created by wodada on 2017/8/3.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ProfileInfoNormalCell.h"

@interface ProfileInfoNormalCell ()

@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *contentLabel;

@end

@implementation ProfileInfoNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (55 - 16) / 2, 80, 16)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor colorFromHex:@"#939393"];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        //
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), (55 - 16) / 2, Screen_Width - CGRectGetMaxX(titleLabel.frame) - 20 - 40, 16)];
        contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.text = content;
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
