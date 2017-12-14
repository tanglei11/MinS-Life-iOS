//
//  ImagePickerChooseCell.m
//  MyFamily
//
//  Created by 陆洋 on 15/7/15.
//  Copyright (c) 2015年 maili. All rights reserved.
//

#import "AlertCell.h"

@implementation AlertCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"ImagePickerChooseCell";
    
    //缓存中取
    AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    //创建
    if (!cell)
    {
        cell = [[AlertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *imagePickerName = [[UILabel alloc]initWithFrame:CGRectMake(48, 0, Screen_Width - 2 * 48, 49)];
        imagePickerName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:imagePickerName];
        self.imagePickerName = imagePickerName;
    }
    return self;
}

@end
