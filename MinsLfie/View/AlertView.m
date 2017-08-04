//
//  ImagePickerChooseView.m
//  MyFamily
//
//  Created by 陆洋 on 15/7/15.
//  Copyright (c) 2015年 maili. All rights reserved.
//

#import "AlertView.h"

#define ReportState_HeaderContent_h
#define padding 10
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#define imageTag 2000

@interface AlertView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UIView *tapView;
@property (nonatomic,weak) UITableView *chooseTableView;

@end
@implementation AlertView

//一定要这种方式添加背景，不然响应不了tap,还没想清楚为什么
-(id)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化背景
        UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,screenWidth, screenHeight)];
        tapView.backgroundColor = [UIColor blackColor];
        tapView.alpha = 0.6;
        tapView.userInteractionEnabled = YES;
        [bgView addSubview:tapView];
        self.tapView = tapView;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
        [self.tapView addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)addAlertView
{
        
}

-(void)disappear
{
    //((UITableView *)self.superview).scrollEnabled = YES;
    [self.tapView removeFromSuperview];
    self.tapView = nil;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = CGRectMake(0, screenHeight, screenWidth, AlertViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertCell *cell = [AlertCell cellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.imagePickerName.text = @"保存草稿";
            [ToolClass addUnderLineForCell:cell cellHeight:49 lineX:24 lineHeight:LINE_HEIGHT isJustified:YES];
        }
        else
        {
            cell.imagePickerName.text = @"不保存";
            cell.imagePickerName.textColor = [UIColor colorFromHex:MAIN_COLOR];
            [ToolClass addUnderLineForCell:cell cellHeight:49 lineX:24 lineHeight:LINE_HEIGHT isJustified:YES];
        }
        
    }else{
        cell.imagePickerName.text = @"取消";
    }
    return cell;
}

-(void)setAlertViewBlock:(AlertViewSaveBlock)block
{
    self.AlertViewSaveBlock = block;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.AlertViewSaveBlock();
        }
        else
        {
            [[self viewController] dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self disappear];
    }
}

@end
