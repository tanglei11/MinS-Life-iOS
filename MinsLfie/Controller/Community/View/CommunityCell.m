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
@property (nonatomic,weak) PhotosView *photosView;
@property (nonatomic,weak) UILabel *contentLabel;
@property (nonatomic,weak) UILabel *commentLabel;
@property (nonatomic,weak) UILabel *likeLabel;
@property (nonatomic,weak) UIImageView *likeView;
@property (nonatomic,weak) UIImageView *commentView;

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
        //收藏
        UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width - 20 - 60, (headerView.height - 30) / 2 + headerView.y, 60, 30)];
        collectButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [collectButton setTitleColor:[UIColor colorFromHex:@"#FF4735"] forState:UIControlStateNormal];
        collectButton.layer.cornerRadius = 8;
        collectButton.layer.borderColor = [[UIColor colorFromHex:@"#FF4735"] CGColor];
        collectButton.layer.borderWidth = 1;
        [self.contentView addSubview:collectButton];
        //图片集
        NSArray *photos = @[@"photo_1",@"photo_2",@"photo_3"];
        CGSize photosSize = [PhotosView SizeWithCount:(int)photos.count];
        PhotosView *photosView = [[PhotosView alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(headerView.frame) + 18, photosSize.width, photosSize.height)];
        photosView.photos = photos;
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
        likeLabel.text = @"8108 赞";
        [self.contentView addSubview:likeLabel];
        self.likeLabel = likeLabel;
        //评论
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.font = [UIFont systemFontOfSize:14];
        commentLabel.textColor = [UIColor colorFromHex:@"#939393"];
        commentLabel.text = @"265 评论";
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        //赞图标
        UIImageView *likeView = [[UIImageView alloc] init];
        likeView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe644;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#939393"]];
        [self.contentView addSubview:likeView];
        self.likeView = likeView;
        //评论图标
        UIImageView *commentView = [[UIImageView alloc] init];
        commentView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe667;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#939393"]];
        [self.contentView addSubview:commentView];
        self.commentView = commentView;
    }
    return self;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.attributedText = [ToolClass createTextWithString:content fontSize:14 lineSpacing:6 isFontThin:YES];
    CGRect rect = [ToolClass caculateText:self.contentLabel.attributedText maxSize:CGSizeMake(Screen_Width - 2 * 22, MAXFLOAT)];
    self.contentLabel.frame = CGRectMake(22, CGRectGetMaxY(self.photosView.frame) + 15, Screen_Width - 2 * 22, rect.size.height);
    
    CGSize likeSize = [self.likeLabel.text sizeWithFont:[UIFont systemFontOfSize:14]];
    self.likeLabel.frame = CGRectMake(22, CGRectGetMaxY(self.contentLabel.frame) + 22, likeSize.width, 14);
    
    CGSize commentSize = [self.commentLabel.text sizeWithFont:[UIFont systemFontOfSize:14]];
    self.commentLabel.frame = CGRectMake(CGRectGetMaxX(self.likeLabel.frame) + 12, self.likeLabel.y, commentSize.width, 14);
    
    self.commentView.frame = CGRectMake(Screen_Width - 22 - 22, (self.likeLabel.height - 22) / 2 + self.likeLabel.y, 22, 22);
    
    self.likeView.frame = CGRectMake(self.commentView.x - 28 - 22, self.commentView.y, 22, 22);
    
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
