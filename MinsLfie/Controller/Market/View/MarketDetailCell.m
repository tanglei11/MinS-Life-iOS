//
//  MarketDetailCell.m
//  MinsLfie
//
//  Created by Peanut丶 on 2017/12/14.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "MarketDetailCell.h"
#import "MarketPhotosView.h"

@interface MarketDetailCell ()

@property (nonatomic,weak) UIImageView *headerView;
@property (nonatomic,weak) UILabel *nickLabel;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UIImageView *coverView;
@property (nonatomic,weak) MarketPhotosView *photosView;
@property (nonatomic,weak) UILabel *priceLabel;
@property (nonatomic,weak) UILabel *contentLabel;

@end

@implementation MarketDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 40, 40)];
        headerView.layer.masksToBounds = YES;
        headerView.layer.cornerRadius = 20;
        headerView.image = [UIImage imageNamed:@"pro_head"];
        [self.contentView addSubview:headerView];
        self.headerView = headerView;
        //昵称
        UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame) + 15, headerView.y, Screen_Width - CGRectGetMaxX(headerView.frame) - 15 - 100, 14)];
        nickLabel.textColor = [UIColor colorFromHex:@"#333333"];
        nickLabel.font = [UIFont boldSystemFontOfSize:14];
        nickLabel.text = @"Peanut丶";
        [self.contentView addSubview:nickLabel];
        self.nickLabel = nickLabel;
        //时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickLabel.x, CGRectGetMaxY(nickLabel.frame) + 10, nickLabel.width, 14)];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = [UIColor colorFromHex:@"#C0C0C0"];
        timeLabel.text = @"03-30 10:49";
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        //拨打电话
        UIButton *callButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width - 20 - 35, (headerView.height - 35) / 2 + headerView.y, 35, 35)];
        callButton.layer.cornerRadius = callButton.height / 2;
        callButton.layer.borderWidth = LINE_HEIGHT;
        callButton.layer.borderColor = [[UIColor colorFromHex:NORMAL_BG_COLOR] CGColor];
//        callButton.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        [callButton setImage:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe606;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:NORMAL_BG_COLOR]] forState:UIControlStateNormal];
        [callButton addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:callButton];
        //封面图
        UIImageView *coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame) + 18, Screen_Width, 187)];
        coverView.clipsToBounds = YES;
        coverView.image = BLANK_PICTURE_SIZE_66;
        coverView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
        coverView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:coverView];
        self.coverView = coverView;
        //图片集
        MarketPhotosView *photosView = [[MarketPhotosView alloc] init];
        [self.contentView addSubview:photosView];
        self.photosView = photosView;
        //价格
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        priceLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        //内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}

- (void)callClick
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_marketObject.dynamicsUser.mobilePhoneNumber];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    });
}

- (void)setMarketObject:(MarketObject *)marketObject
{
    _marketObject = marketObject;
    if ([marketObject.dynamicsUser.profileUrl isEqualToString:@""]) {
        self.headerView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:40 color:[UIColor colorFromHex:MAIN_COLOR]];
    }else{
        [ToolClass setupImageViewByAVFileWithThumbnailWidth:40 thumbnailHeight:40 url:marketObject.dynamicsUser.profileUrl imageView:self.headerView placeholder:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:40 color:[UIColor colorFromHex:MAIN_COLOR]]];
    }
    self.nickLabel.text = [marketObject.dynamicsUser.nickname isEqualToString:@""] ? marketObject.dynamicsUser.username : marketObject.dynamicsUser.nickname;
    self.timeLabel.text = [NSString stringWithAccurateTimeChangeToBlurryTime:marketObject.createdAt dateFormat:nil];
    NSMutableArray *imgs = [[marketObject.imgs componentsSeparatedByString:@","] mutableCopy];
    NSArray * photos = [imgs copy];
    CGFloat priceY = 0;
    if (imgs.count > 1) {
        self.coverView.hidden = YES;
        self.photosView.photos = photos;
        CGSize photosSize = [MarketPhotosView SizeWithCount:(int)photos.count];
        self.photosView.frame = CGRectMake(20, CGRectGetMaxY(self.headerView.frame) + 18, photosSize.width, photosSize.height);
        priceY = CGRectGetMaxY(self.photosView.frame) + 15;
    }else{
        self.photosView.hidden = YES;
        [ToolClass setupImageViewByAVFileWithThumbnailWidth:self.coverView.width thumbnailHeight:self.coverView.height url:photos[0] imageView:self.coverView placeholder:BLANK_PICTURE_SIZE_66];
        priceY = CGRectGetMaxY(self.coverView.frame) + 15;
    }
    NSString *price = [NSString stringWithFormat:@"价格：%@ 元",marketObject.price];
    CGSize priceSize = [price sizeWithFont:[UIFont systemFontOfSize:16]];
    self.priceLabel.text = price;
    self.priceLabel.frame = CGRectMake(20, priceY, priceSize.width, 16);
    
    self.contentLabel.attributedText = [ToolClass createTextWithString:marketObject.content fontSize:14 lineSpacing:6 isFontThin:YES];
    CGRect rect = [ToolClass caculateText:self.contentLabel.attributedText maxSize:CGSizeMake(Screen_Width - 2 * 20, MAXFLOAT)];
    self.contentLabel.frame = CGRectMake(20, CGRectGetMaxY(self.priceLabel.frame) + 15, Screen_Width - 2 * 20, rect.size.height);
    
    self.cellHeight = CGRectGetMaxY(self.contentLabel.frame) + 20;
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
