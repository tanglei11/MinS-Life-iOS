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
#import "MJRefresh.h"

//控制器
#import "CommunityWriteController.h"
#import "CommunityDetailController.h"
#import "CommunityMapController.h"

@interface CommunityPageController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) CGFloat communityBannerCellHeight;
@property (nonatomic,assign) CGFloat communityCellHeight;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic, assign) int page;
@property (nonatomic,strong) NSMutableArray *dynamicsArray;
@property (nonatomic,assign) BOOL isFirstEnter;
@property (nonatomic,assign) BOOL isNeedScroll;
@property (nonatomic,assign) BOOL isPush;

@end

@implementation CommunityPageController
//懒加载
- (NSMutableArray *)dynamicsArray
{
    if (_dynamicsArray == nil) {
        self.dynamicsArray = [NSMutableArray array];
    }
    return _dynamicsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 0;
    
    self.isFirstEnter = YES;

    [self initNav];
    
    [self initTableView];
    
    [self setBottomShadow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
}

- (void)getDynamicData
{
    int skip = self.page * 20;
    NSDictionary *parameters = @{ @"limit" : @20,
                                  @"skip" : [NSNumber numberWithInt:skip],@"currectUserId":[AVUser currentUser].objectId ? [AVUser currentUser].objectId : @""};
    [MSProgressHUD showHUDAddedToWindow:self.view.window];
    [AVCloud callFunctionInBackground:@"getDynamics" withParameters:parameters block:^(id  _Nullable object, NSError * _Nullable error) {
        [MSProgressHUD hideHUDForWindow:self.view.window animated:YES];
        if (error != nil) {
            [MBProgressHUD showError:@"获取数据失败,请重试" toView:self.view];
        }else{
            NSLog(@"-=-=-=-=-%@",object);
            for (NSDictionary *dict in object) {
                DynamicsObject *dynamicsObject = [[DynamicsObject alloc] init];
                [dynamicsObject setValuesForKeysWithDictionary:dict];
                [self.dynamicsArray addObject:dynamicsObject];
            }
            [self.tableView reloadData];
            if (self.isNeedScroll) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                self.isNeedScroll = NO;
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_header endRefreshing];
            if ([object count] != 20) {
                self.tableView.mj_footer.hidden = YES;
            }
            else {
                self.tableView.mj_footer.hidden = NO;
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isFirstEnter || self.isPush) {
        [self newData];
        self.isFirstEnter = NO;
        self.isPush = NO;
    }
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"动态";
}

- (void)refreshData
{
    self.isNeedScroll = YES;
    [self newData];
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64 - 49) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor colorFromHex:TABLE_BACK_COLOR];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(newData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    tableView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    tableView.mj_footer = footer;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)newData
{
    self.page = 0;
    [self.dynamicsArray removeAllObjects];
    [self getDynamicData];
}

- (void)moreData
{
    self.page ++;
    [self getDynamicData];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dynamicsArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *community_banner_id = @"community_banner_cell";
//    static NSString *community_id = @"community_cell";
    NSString *community_id = [NSString stringWithFormat:@"community_cell_%ld",indexPath.section - 1];
    CommunityBannerCell *communityBannerCell = [tableView dequeueReusableCellWithIdentifier:community_banner_id];
    if (communityBannerCell == nil) {
        communityBannerCell = [[CommunityBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:community_banner_id];
    }
    
    CommunityCell *communityCell = [tableView dequeueReusableCellWithIdentifier:community_id];
    if (communityCell == nil) {
        communityCell = [[CommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:community_id];
    }
//    else{
//        [communityCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        communityCell = [[CommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:community_id];
//    }
    
    if (indexPath.section == 0) {
        communityBannerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        communityBannerCell.content = @"听说校园每时每刻都发生一些新鲜事哦！你看见有趣的事了吗？你看见帅气学长了吗？你看见漂亮学妹了吗？快来分享你的校园生活趣事，大家一起来围观！";
        communityBannerCell.bannerCloseBlock = ^{
            
        };
        self.communityBannerCellHeight = communityBannerCell.cellHeight;
        return communityBannerCell;
    }else{
        DynamicsObject *dynamicsObject = self.dynamicsArray[indexPath.section - 1];
        communityCell.dynamicsObject = dynamicsObject;
        communityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        communityCell.communityCollectBlock = ^(DynamicsObject *dynamicsObject) {
            if ([AVUser currentUser] != nil) {
                if ([dynamicsObject.isCollect intValue] == 1) {
                    dynamicsObject.isCollect = @"0";
                    NSDictionary *params = @{@"dynamicId":dynamicsObject.objectId};
                    [AVCloud callFunctionInBackground:@"deleteCollect" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {
                        if (error != nil) {
                            [MBProgressHUD showError:@"取消收藏失败"];
                        }else{
                            
                        }
                    }];
                }else{
                    dynamicsObject.isCollect = @"1";
                    NSDictionary *params = @{@"dynamicId":dynamicsObject.objectId,@"collectUserId":[AVUser currentUser].objectId,@"collectType":@"dynamic"};
                    [AVCloud callFunctionInBackground:@"saveCollect" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {
                        if (error != nil) {
                            [MBProgressHUD showError:@"收藏失败"];
                        }else{
                            
                        }
                    }];
                }
            }else{
                [self showLoginGuideView];
            }
        };
        communityCell.communityMapBlock = ^(DynamicsObject *dynamicsObject) {
            CommunityMapController *communityMapController = [[CommunityMapController alloc] init];
            communityMapController.dynamicsObject = dynamicsObject;
            communityMapController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:communityMapController animated:YES];
        };
        self.communityCellHeight = communityCell.cellHeight;
        return communityCell;
    }
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }else{
        self.isPush = YES;
        CommunityDetailController *communityDetailController = [[CommunityDetailController alloc] init];
        communityDetailController.dynamicsObject = self.dynamicsArray[indexPath.section - 1];
        communityDetailController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:communityDetailController animated:YES];
    }
}

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
