//
//  CommunityCommentCell.m
//  MinsLfie
//
//  Created by wodada on 2017/8/8.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityCommentCell.h"

@interface CommunityCommentCell ()

@property (nonatomic,weak) UIImageView *headerView;
@property (nonatomic,weak) UILabel *nickLabel;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UILabel *contentLabel;

@end

@implementation CommunityCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
        headerView.layer.masksToBounds = YES;
        headerView.layer.cornerRadius = 15;
        headerView.image = [UIImage imageNamed:@"pro_head"];
        [self.contentView addSubview:headerView];
        self.headerView = headerView;
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12];
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
        
        //评论
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}

- (void)setDynamicUserId:(NSString *)dynamicUserId
{
    _dynamicUserId = dynamicUserId;
}

- (void)setDynamicCommentObject:(DynamicCommentObject *)dynamicCommentObject
{
    _dynamicCommentObject = dynamicCommentObject;
    //头像
    if ([dynamicCommentObject.commentUserProfileUrl isEqualToString:@""]) {
        self.headerView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:40 color:[UIColor colorFromHex:MAIN_COLOR]];
    }else{
        [ToolClass setupImageViewByAVFileWithThumbnailWidth:40 thumbnailHeight:40 url:dynamicCommentObject.commentUserProfileUrl imageView:self.headerView placeholder:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:40 color:[UIColor colorFromHex:MAIN_COLOR]]];
    }
    //时间
    NSString *time = [NSString stringWithAccurateTimeChangeToBlurryTime:dynamicCommentObject.createdAt dateFormat:nil];
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:12]];
    self.timeLabel.text = time;
    self.timeLabel.frame = CGRectMake(Screen_Width - 20 - timeSize.width, self.headerView.y + 6, timeSize.width, 12);
    //昵称
    self.nickLabel.text = dynamicCommentObject.commentUserName;
    self.nickLabel.frame = CGRectMake(CGRectGetMaxX(self.headerView.frame) + 10, self.timeLabel.y, self.timeLabel.x - CGRectGetMaxX(self.headerView.frame) - 10 - 20, 14);
    //评论
    NSString *content;
    if ([_dynamicUserId isEqualToString:dynamicCommentObject.beCommentUserId]) {
        content = dynamicCommentObject.commentContent;
    }else{
        content = [NSString stringWithFormat:@"回复%@:%@",dynamicCommentObject.beCommentUserName,dynamicCommentObject.commentContent];
    }
    NSMutableAttributedString *attr = [ToolClass createTextWithString:content fontSize:14 lineSpacing:6 isFontThin:YES];
    if (![_dynamicUserId isEqualToString:dynamicCommentObject.beCommentUserId]) {
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHex:NORMAL_BG_COLOR] range:NSMakeRange(2, dynamicCommentObject.beCommentUserName.length)];
    }
    self.contentLabel.attributedText = attr;
    CGRect rect = [ToolClass caculateText:self.contentLabel.attributedText maxSize:CGSizeMake(self.timeLabel.x - self.nickLabel.x - 20, MAXFLOAT)];
    self.contentLabel.frame = CGRectMake(self.nickLabel.x, CGRectGetMaxY(self.nickLabel.frame) + 10, self.timeLabel.x - self.nickLabel.x - 20, rect.size.height);
    
    self.cellHeight = CGRectGetMaxY(self.contentLabel.frame) + 10;
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
