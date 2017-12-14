//
//  ProfileInfoNickCell.m
//  MinsLfie
//
//  Created by wodada on 2017/8/3.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ProfileInfoNickCell.h"

@interface ProfileInfoNickCell ()

@property (nonatomic,weak) UILabel *titleLabel;

@end

@implementation ProfileInfoNickCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (55 - 16) / 2, 80, 16)];
        titleLabel.text = @"昵称";
        titleLabel.textColor = [UIColor colorFromHex:@"#939393"];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        //textField
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), (55 - 30) / 2, Screen_Width - CGRectGetMaxX(titleLabel.frame) - 20, 30)];
        textField.font = [UIFont systemFontOfSize:16];
        textField.placeholder = @"点击可编辑昵称";
        textField.tintColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:textField];
        self.textField = textField;
    }
    return self;
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
