//
//  ProfileHeaderCell.m
//  MinsLfie
//
//  Created by wodada on 2017/8/3.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ProfileHeaderCell.h"

@interface ProfileHeaderCell ()

@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UIImageView *headerView;

@end

@implementation ProfileHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (55 - 16) / 2, 80, 16)];
        titleLabel.text = @"头像";
        titleLabel.textColor = [UIColor colorFromHex:@"#939393"];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        //
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), (55 - 40) / 2, 40, 40)];
        headerView.clipsToBounds = YES;
        headerView.layer.masksToBounds = YES;
        headerView.layer.cornerRadius = headerView.height / 2;
        headerView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:headerView];
        self.headerView = headerView;
    }
    return self;
}

- (void)setHeaderImage:(UIImage *)headerImage
{
    _headerImage = headerImage;
    self.headerView.image = headerImage;
}

- (void)setHeaderUrl:(NSString *)headerUrl
{
    _headerUrl = headerUrl;
    if (headerUrl && (![headerUrl isEqualToString:@""])) {
        [ToolClass setupImageViewByAVFileWithThumbnailWidth:40 thumbnailHeight:40 url:headerUrl imageView:self.headerView placeholder:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:55 color:[UIColor colorFromHex:MAIN_COLOR]]];
    }else{
        self.headerView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:55 color:[UIColor colorFromHex:MAIN_COLOR]];
    }
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
