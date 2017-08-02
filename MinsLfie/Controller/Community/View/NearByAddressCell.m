//
//  NearByAddressCell.m
//  DccShangbao
//
//  Created by wodada on 2017/7/25.
//  Copyright © 2017年 Wodada-Mac. All rights reserved.
//

#import "NearByAddressCell.h"

@interface NearByAddressCell ()

@property (nonatomic,weak) UILabel *nameLabel;
@property (nonatomic,weak) UILabel *addressLabel;
@property (nonatomic,weak) UIImageView *checkView;

@end

@implementation NearByAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //name
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        //address
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = [UIFont systemFontOfSize:12];
        addressLabel.textColor = [UIColor colorFromHex:@"#828282"];
        [self.contentView addSubview:addressLabel];
        self.addressLabel = addressLabel;
        //勾
        UIImageView *checkView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width - 12 - 22, 19, 22, 22)];
        checkView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe645;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:NORMAL_BG_COLOR]];
        checkView.hidden = YES;
        [self.contentView addSubview:checkView];
        self.checkView = checkView;
    }
    return self;
}

- (void)setPoiInfo:(AMapPOI *)poiInfo
{
    _poiInfo = poiInfo;
    //name
    self.nameLabel.text = poiInfo.name;
    self.nameLabel.frame = CGRectMake(15, 7, Screen_Width - 2 * 15, 16);
    //address
    self.addressLabel.text = poiInfo.address;
    self.addressLabel.frame = CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame) + 10, self.nameLabel.width, 12);
}

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (isSelect) {
        self.checkView.hidden = NO;
    }else{
        self.checkView.hidden = YES;
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
