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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
