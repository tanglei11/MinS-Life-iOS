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
//    //头
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:headerView];
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pho_bg_drawer"]];
//    imageView.frame = CGRectMake(0, 0, self.frame.size.width, 49);
//    [headerView addSubview:imageView];
//    
//    UIView *firstLineView = [[UIView alloc]init];
//    firstLineView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
//    firstLineView.frame = CGRectMake(24, 49, Screen_Width - 2 * 24, 0.5);
//    [headerView addSubview:firstLineView];
//    [self addSubview:headerView];
    //tableView
    UITableView *chooseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    chooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chooseTableView.delegate = self;
    chooseTableView.dataSource = self;
    chooseTableView.scrollEnabled = NO;
    [self addSubview:chooseTableView];
    self.chooseTableView = chooseTableView;
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
    return 4;
}

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
        cell.imagePickerName.text = @"发送给朋友";
        [ToolClass addUnderLineForCell:cell cellHeight:49 lineX:0 lineHeight:LINE_HEIGHT isJustified:YES];
    }else if (indexPath.section == 1){
        cell.imagePickerName.text = @"发送朋友圈";
        [ToolClass addUnderLineForCell:cell cellHeight:49 lineX:0 lineHeight:LINE_HEIGHT isJustified:YES];
    }else if (indexPath.section == 2){
        cell.imagePickerName.text = @"保存图片";
        [ToolClass addUnderLineForCell:cell cellHeight:49 lineX:0 lineHeight:6 isJustified:YES];
    }else{
        cell.imagePickerName.text = @"取消";
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.alertviewSendFriendBlock();
    }else if (indexPath.section == 1){
        self.alertviewSendFriendQuanBlock();
    }else if (indexPath.section == 2){
        self.alertviewSavePictureBlock();
    }else{
       
    }
    [self disappear];
}

@end
