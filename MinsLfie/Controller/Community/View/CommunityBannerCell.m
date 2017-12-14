//
//  CommunityBannerCell.m
//  MinsLfie
//
//  Created by Peanut丶 on 2017/7/29.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityBannerCell.h"

@interface CommunityBannerCell ()

@property (nonatomic,weak) UILabel *contentLabel;

@end

@implementation CommunityBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        //关闭
        UIImageView *closeView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width - 44, 0, 44, 44)];
        closeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
        [closeView addGestureRecognizer:closeTap];
        closeView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe62c;"] inFont:ICONFONT size:44 color:[UIColor colorFromHex:NORMAL_BG_COLOR]];
        [self.contentView addSubview:closeView];
        
        UIImageView *caView = [[UIImageView alloc] initWithFrame:CGRectMake(closeView.width - 20 - 4, 4, 20, 20)];
        caView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe646;"] inFont:ICONFONT size:20 color:[UIColor whiteColor]];
        [closeView addSubview:caView];
    }
    return self;
}

- (void)closeClick
{
    self.bannerCloseBlock();
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.attributedText = [ToolClass createTextWithString:content fontSize:14 lineSpacing:6 isFontThin:YES];
    CGRect rect = [ToolClass caculateText:self.contentLabel.attributedText maxSize:CGSizeMake(Screen_Width - 25 - 35, MAXFLOAT)];
    self.contentLabel.frame = CGRectMake(25, 15, Screen_Width - 25 - 35, rect.size.height);
    self.cellHeight = CGRectGetMaxY(self.contentLabel.frame) + 15;
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
