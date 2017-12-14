//
//  CommunityCell.m
//  MinsLfie
//
//  Created by Peanut丶 on 2017/7/29.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityCell.h"
#import "PhotosView.h"

@interface CommunityCell ()

@property (nonatomic,weak) UIImageView *headerView;
@property (nonatomic,weak) UILabel *nickLabel;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UIButton *collectButton;
@property (nonatomic,weak) PhotosView *photosView;
@property (nonatomic,weak) UILabel *contentLabel;
@property (nonatomic,weak) UIView *addressView;
@property (nonatomic,weak) UIImageView *addressImage;
@property (nonatomic,weak) UILabel *addressLabel;
@property (nonatomic,weak) UILabel *commentLabel;
@property (nonatomic,weak) UILabel *likeLabel;

@end

@implementation CommunityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 40, 40)];
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
        //收藏
        UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width - 20 - 60, (headerView.height - 30) / 2 + headerView.y, 60, 30)];
        collectButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [collectButton setTitle:@"已收藏" forState:UIControlStateSelected];
        [collectButton setTitleColor:[UIColor colorFromHex:NORMAL_BG_COLOR] forState:UIControlStateNormal];
        [collectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        collectButton.layer.cornerRadius = 6;
        collectButton.layer.borderColor = [[UIColor colorFromHex:NORMAL_BG_COLOR] CGColor];
        collectButton.layer.borderWidth = 1;
        [collectButton addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:collectButton];
        self.collectButton = collectButton;
        //图片集
//        NSArray *photos = @[@"photo_1",@"photo_2",@"photo_3"];
//        CGSize photosSize = [PhotosView SizeWithCount:(int)photos.count];
        PhotosView *photosView = [[PhotosView alloc] init];
//        WithFrame:CGRectMake(22, CGRectGetMaxY(headerView.frame) + 18, photosSize.width, photosSize.height)];
//        photosView.photos = photos;
        [self.contentView addSubview:photosView];
        self.photosView = photosView;
        //内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        //赞
        UILabel *likeLabel = [[UILabel alloc] init];
        likeLabel.font = [UIFont systemFontOfSize:14];
        likeLabel.textColor = [UIColor colorFromHex:@"#939393"];
        likeLabel.text = @"0 赞";
        [self.contentView addSubview:likeLabel];
        self.likeLabel = likeLabel;
        //评论
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.font = [UIFont systemFontOfSize:14];
        commentLabel.textColor = [UIColor colorFromHex:@"#939393"];
        commentLabel.text = @"0 评论";
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        //地址
        UIView *addressView = [[UIView alloc] init];
        addressView.userInteractionEnabled = YES;
        addressView.hidden = YES;
        addressView.layer.borderColor = [[UIColor colorFromHex:@"#E9E9E9"] CGColor];
        addressView.layer.borderWidth = LINE_HEIGHT;
        UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressMap)];
        [addressView addGestureRecognizer:addressTap];
        [self.contentView addSubview:addressView];
        self.addressView = addressView;
        
        UIImageView *addressImage = [[UIImageView alloc] init];
        addressImage.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe607;"] inFont:ICONFONT size:18 color:[UIColor colorFromHex:NORMAL_BG_COLOR]];
        [addressView addSubview:addressImage];
        self.addressImage = addressImage;
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.textColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        addressLabel.font = [UIFont systemFontOfSize:14];
        [addressView addSubview:addressLabel];
        self.addressLabel = addressLabel;
    }
    return self;
}

- (void)addressMap
{
    self.communityMapBlock(_dynamicsObject);
}

- (void)collectClick
{
    if ([AVUser currentUser] != nil) {
        if ([_dynamicsObject.isCollect intValue] == 1) {
            self.collectButton.selected = NO;
            self.collectButton.backgroundColor = [UIColor whiteColor];
        }else{
            self.collectButton.selected = YES;
            self.collectButton.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        }
    }
    self.communityCollectBlock(_dynamicsObject);
}

- (void)setDynamicsObject:(DynamicsObject *)dynamicsObject
{
    _dynamicsObject = dynamicsObject;
    if ([dynamicsObject.dynamicsUser.profileUrl isEqualToString:@""]) {
        self.headerView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:40 color:[UIColor colorFromHex:MAIN_COLOR]];
    }else{
        [ToolClass setupImageViewByAVFileWithThumbnailWidth:40 thumbnailHeight:40 url:dynamicsObject.dynamicsUser.profileUrl imageView:self.headerView placeholder:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:40 color:[UIColor colorFromHex:MAIN_COLOR]]];
    }
    self.nickLabel.text = [dynamicsObject.dynamicsUser.nickname isEqualToString:@""] ? dynamicsObject.dynamicsUser.username : dynamicsObject.dynamicsUser.nickname;
    self.timeLabel.text = [NSString stringWithAccurateTimeChangeToBlurryTime:dynamicsObject.createdAt dateFormat:nil];
    
    if ([dynamicsObject.isCollect intValue] == 1) {
        self.collectButton.selected = YES;
        self.collectButton.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
    }else{
        self.collectButton.selected = NO;
        self.collectButton.backgroundColor = [UIColor whiteColor];
    }
    
    NSMutableArray *imgs = [[dynamicsObject.imgs componentsSeparatedByString:@","] mutableCopy];
    NSArray * photos = [NSArray array];
    if (imgs.count > 3) {
        photos = [imgs subarrayWithRange:NSMakeRange(0, 3)];
    }else{
        photos = [imgs copy];
    }
    self.photosView.photos = photos;
    CGSize photosSize = [PhotosView SizeWithCount:(int)photos.count];
    self.photosView.frame = CGRectMake(22, CGRectGetMaxY(self.headerView.frame) + 18, photosSize.width, photosSize.height);
    
    self.contentLabel.attributedText = [ToolClass createTextWithString:dynamicsObject.content fontSize:14 lineSpacing:6 isFontThin:YES];
    CGRect rect = [ToolClass caculateText:self.contentLabel.attributedText maxSize:CGSizeMake(Screen_Width - 2 * 22, MAXFLOAT)];
    self.contentLabel.frame = CGRectMake(22, CGRectGetMaxY(self.photosView.frame) + 15, Screen_Width - 2 * 22, rect.size.height);
    
    self.commentLabel.text = [NSString stringWithFormat:@"%d 评论",[dynamicsObject.commentCount intValue]];
    CGSize commentSize = [self.commentLabel.text sizeWithFont:[UIFont systemFontOfSize:14]];
    self.commentLabel.frame = CGRectMake(Screen_Width - 22 - commentSize.width, CGRectGetMaxY(self.contentLabel.frame) + 22, commentSize.width, 14);
    
    self.likeLabel.text = [NSString stringWithFormat:@"%d 赞",[dynamicsObject.likeCount intValue]];
    CGSize likeSize = [self.likeLabel.text sizeWithFont:[UIFont systemFontOfSize:14]];
    self.likeLabel.frame = CGRectMake(self.commentLabel.x - 12 - likeSize.width, self.commentLabel.y, likeSize.width, 14);
    
    if ([dynamicsObject.addressName isEqualToString:@""]) {
        self.addressView.hidden = YES;
    }else{
        self.addressView.hidden = NO;
        self.addressLabel.text = dynamicsObject.addressName;
        CGSize addressSize = [dynamicsObject.addressName sizeWithFont:[UIFont systemFontOfSize:14]];
        CGFloat addressViewW = addressSize.width + 18 + 20;
        CGFloat addressLabelW = addressSize.width;
        if (addressViewW > (self.likeLabel.x - 20 - 22)) {
            addressViewW = self.likeLabel.x - 20 - 22;
            addressLabelW = addressViewW - 18 - 20;
        }
        self.addressView.frame = CGRectMake(22, self.likeLabel.y - (26 - 14) / 2, addressViewW, 26);
        self.addressView.layer.cornerRadius = 13;
        self.addressImage.frame = CGRectMake(5, (self.addressView.height - 18) / 2, 18, 18);
        self.addressLabel.frame = CGRectMake(CGRectGetMaxX(self.addressImage.frame) + 5, (self.addressView.height - 14) / 2, addressLabelW, 14);
    }
    self.cellHeight = CGRectGetMaxY(self.likeLabel.frame) + 30;
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
