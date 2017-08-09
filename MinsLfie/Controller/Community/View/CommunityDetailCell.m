//
//  CommunityDetailCell.m
//  MinsLfie
//
//  Created by wodada on 2017/8/8.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityDetailCell.h"
#import "PhotosView.h"

@interface CommunityDetailCell ()

@property (nonatomic,weak) UIImageView *headerView;
@property (nonatomic,weak) UILabel *nickLabel;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) PhotosView *photosView;
@property (nonatomic,weak) UILabel *contentLabel;

@end

@implementation CommunityDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 40, 40)];
        headerView.layer.masksToBounds = YES;
        headerView.layer.cornerRadius = 20;
        headerView.image = [UIImage imageNamed:@"pro_head"];
        [self.contentView addSubview:headerView];
        self.headerView = headerView;
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = [UIColor colorFromHex:@"#C0C0C0"];
        timeLabel.text = @"03-30 10:49";
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //昵称
        UILabel *nickLabel = [[UILabel alloc] init];
        nickLabel.font = [UIFont boldSystemFontOfSize:14];
        nickLabel.text = @"Peanut丶";
        [self.contentView addSubview:nickLabel];
        self.nickLabel = nickLabel;
        
        //图片集
        PhotosView *photosView = [[PhotosView alloc] init];
        [self.contentView addSubview:photosView];
        self.photosView = photosView;
        //内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}

- (void)setDynamicsObject:(DynamicsObject *)dynamicsObject
{
    _dynamicsObject = dynamicsObject;
    //头像
    if ([dynamicsObject.dynamicsUser.profileUrl isEqualToString:@""]) {
        self.headerView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:40 color:[UIColor colorFromHex:MAIN_COLOR]];
    }else{
        [ToolClass setupImageViewByAVFileWithThumbnailWidth:40 thumbnailHeight:40 url:dynamicsObject.dynamicsUser.profileUrl imageView:self.headerView placeholder:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:40 color:[UIColor colorFromHex:MAIN_COLOR]]];
    }
    //时间
    NSString *time = [NSString stringWithAccurateTimeChangeToBlurryTime:dynamicsObject.createdAt dateFormat:nil];
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:14]];
    self.timeLabel.text = time;
    self.timeLabel.frame = CGRectMake(Screen_Width - 20 - timeSize.width, (self.headerView.height - 14) / 2 + self.headerView.y, timeSize.width, 14);
    //昵称
    self.nickLabel.text = [dynamicsObject.dynamicsUser.nickname isEqualToString:@""] ? dynamicsObject.dynamicsUser.username : dynamicsObject.dynamicsUser.nickname;
    self.nickLabel.frame = CGRectMake(CGRectGetMaxX(self.headerView.frame) + 15, self.timeLabel.y, self.timeLabel.x - CGRectGetMaxX(self.headerView.frame) - 15 - 20, 14);
    //图片集
    NSArray *photos = [dynamicsObject.imgs componentsSeparatedByString:@","];
    self.photosView.photos = photos;
    CGSize photosSize = [PhotosView SizeWithCount:(int)photos.count];
    self.photosView.frame = CGRectMake(22, CGRectGetMaxY(self.headerView.frame) + 18, photosSize.width, photosSize.height);
    //内容
    self.contentLabel.attributedText = [ToolClass createTextWithString:dynamicsObject.content fontSize:14 lineSpacing:6 isFontThin:YES];
    CGRect rect = [ToolClass caculateText:self.contentLabel.attributedText maxSize:CGSizeMake(Screen_Width - 2 * 22, MAXFLOAT)];
    self.contentLabel.frame = CGRectMake(22, CGRectGetMaxY(self.photosView.frame) + 15, Screen_Width - 2 * 22, rect.size.height);
    
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
