//
//  CommunityPageController.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityPageController.h"
#import "CommunityBannerCell.h"
#import "CommunityCell.h"

//控制器
#import "CommunityWriteController.h"

@interface CommunityPageController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) CGFloat communityBannerCellHeight;
@property (nonatomic,assign) CGFloat communityCellHeight;

@end

@implementation CommunityPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self initTableView];
    
    [self setBottomShadow];
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"动态";
    self.customNavigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(post) imageName:@"&#xe653;" imageColor:[UIColor colorFromHex:MAIN_COLOR]];
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64 - 49) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor colorFromHex:TABLE_BACK_COLOR];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
}

- (void)post
{
    CommunityWriteController *communityWriteController = [[CommunityWriteController alloc] init];
    communityWriteController.hidesBottomBarWhenPushed = YES;
    [self.navigationController presentViewController:communityWriteController animated:YES completion:nil];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *community_banner_id = @"community_banner_cell";
    static NSString *community_id = @"community_cell";
    CommunityBannerCell *communityBannerCell = [tableView dequeueReusableCellWithIdentifier:community_banner_id];
    if (communityBannerCell == nil) {
        communityBannerCell = [[CommunityBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:community_banner_id];
    }
    
    CommunityCell *communityCell = [tableView dequeueReusableCellWithIdentifier:community_id];
    if (communityCell == nil) {
        communityCell = [[CommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:community_id];
    }
    
    if (indexPath.section == 0) {
        communityBannerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        communityBannerCell.content = @"听说校园每时每刻都发生一些新鲜事哦！你看见有趣的事了吗？你看见帅气学长了吗？你看见漂亮学妹了吗？快来分享你的校园生活趣事，大家一起来围观！";
        self.communityBannerCellHeight = communityBannerCell.cellHeight;
        return communityBannerCell;
    }else{
        communityCell.content = @"没有人告诉我长大以后的我们会做着平凡的工作 谈一场不怎么样的恋爱 原来长大后没什么了不起 还是会犯错 还是会迷惘 后悔没对讨厌的人更坏一点 对喜欢的人更珍惜 但是只有我们自己才可以决定自己的样子";
        communityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.communityCellHeight = communityCell.cellHeight;
        return communityCell;
    }
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.communityBannerCellHeight;
    }else{
        return self.communityCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0000000000000001;
    }else{
       return 1.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000000000001;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
