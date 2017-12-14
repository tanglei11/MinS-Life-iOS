//
//  ProfileInfoSexCell.m
//  MinsLfie
//
//  Created by wodada on 2017/8/3.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ProfileInfoSexCell.h"

@interface ProfileInfoSexCell ()

@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UIButton *womenButton;
@property (nonatomic,weak) UIButton *manButton;

@end

@implementation ProfileInfoSexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (55 - 16) / 2, 80, 16)];
        titleLabel.text = @"性别";
        titleLabel.textColor = [UIColor colorFromHex:@"#939393"];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        //按钮
        UIButton *womenButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width - 20 - 50, (55 - 36) / 2, 50, 36)];
        womenButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [womenButton setTitle:@"女" forState:UIControlStateNormal];
        [womenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        womenButton.backgroundColor = [UIColor colorFromHex:@"#D8D8D8"];
        womenButton.layer.cornerRadius = 18;
        [womenButton addTarget:self action:@selector(womenSelect) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:womenButton];
        self.womenButton = womenButton;
        
        UIButton *manButton = [[UIButton alloc] initWithFrame:CGRectMake(womenButton.x - 10 - 50, (55 - 36) / 2, 50, 36)];
        manButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [manButton setTitle:@"男" forState:UIControlStateNormal];
        [manButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        manButton.backgroundColor = [UIColor colorFromHex:MAIN_COLOR];
        manButton.layer.cornerRadius = 18;
        [manButton addTarget:self action:@selector(manSelect) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:manButton];
        self.manButton = manButton;
        //
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), (55 - 16) / 2, manButton.x - CGRectGetMaxX(titleLabel.frame) - 10, 16)];
        contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}

- (void)setSex:(NSString *)sex
{
    _sex = sex;
    self.contentLabel.text = sex;
    if ([sex isEqualToString:@"男"]) {
        self.womenButton.backgroundColor = [UIColor colorFromHex:@"#D8D8D8"];
        self.manButton.backgroundColor = [UIColor colorFromHex:MAIN_COLOR];
    }else{
        self.womenButton.backgroundColor = [UIColor colorFromHex:MAIN_COLOR];
        self.manButton.backgroundColor = [UIColor colorFromHex:@"#D8D8D8"];
    }
}

- (void)womenSelect
{
    self.womenButton.backgroundColor = [UIColor colorFromHex:MAIN_COLOR];
    self.manButton.backgroundColor = [UIColor colorFromHex:@"#D8D8D8"];
    self.contentLabel.text = @"女";
}

- (void)manSelect
{
    self.womenButton.backgroundColor = [UIColor colorFromHex:@"#D8D8D8"];
    self.manButton.backgroundColor = [UIColor colorFromHex:MAIN_COLOR];
    self.contentLabel.text = @"男";
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
