//
//  ImagePickerChooseCell.h
//  MyFamily
//
//  Created by 陆洋 on 15/7/15.
//  Copyright (c) 2015年 maili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertCell : UITableViewCell
@property (nonatomic,weak)UILabel *imagePickerName;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
