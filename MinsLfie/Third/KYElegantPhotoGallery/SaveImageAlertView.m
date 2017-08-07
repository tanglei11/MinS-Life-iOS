//
//  SaveImageAlertView.m
//  CityGuide
//
//  Created by 吴桐 on 16/8/23.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import "SaveImageAlertView.h"

@implementation SaveImageAlertView
// override
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertCell *cell = [AlertCell cellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        cell.imagePickerName.text = @"保存照片";
        cell.imagePickerName.textColor = [UIColor colorFromHex:@"#e00000"];
        [ToolClass addUnderLineForCell:cell cellHeight:49 lineX:0 lineHeight:LINE_HEIGHT isJustified:NO];
    }
    else {
        cell.imagePickerName.text = @"取消";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.alertviewSaveImageBlock();
    }else{
        [self disappear];
    }
}

@end
