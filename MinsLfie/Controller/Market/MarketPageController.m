//
//  MarketPageController.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "MarketPageController.h"
#import "CommunityBannerCell.h"
#import "MarketCell.h"

@interface MarketPageController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) CGFloat communityBannerCellHeight;
@property (nonatomic,assign) CGFloat marketCellHeight;
@property (nonatomic,strong) NSMutableArray *marketArray;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) BOOL isFirstEnter;
@property (nonatomic,assign) BOOL isNeedScroll;
@property (nonatomic,assign) BOOL isPush;

@end

@implementation MarketPageController
//懒加载
- (NSMutableArray *)marketArray
{
    if (_marketArray == nil) {
        self.marketArray = [NSMutableArray array];
    }
    return _marketArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 0;
    
    self.isFirstEnter = YES;
    
    [self initNav];
    
    [self initTableView];
    
    [self setBottomShadow];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isFirstEnter || self.isPush) {
        self.page = 0;
        [self.marketArray removeAllObjects];
        [self getMarketData];
        self.isFirstEnter = NO;
        self.isPush = NO;
    }
    
    
}

- (void)getMarketData
{
    int skip = self.page * 20;
    NSDictionary *parameters = @{ @"limit" : @20,
                                  @"skip" : [NSNumber numberWithInt:skip],@"currectUserId":[AVUser currentUser].objectId ? [AVUser currentUser].objectId : @""};
    [MSProgressHUD showHUDAddedToWindow:self.view.window];
    [AVCloud callFunctionInBackground:@"getMarkets" withParameters:parameters block:^(id  _Nullable object, NSError * _Nullable error) {
        [MSProgressHUD hideHUDForWindow:self.view.window animated:YES];
        if (error != nil) {
            [MBProgressHUD showError:@"获取数据失败,请重试" toView:self.view];
        }else{
            NSLog(@"-=-=-=-=-%@",object);
            for (NSDictionary *dict in object) {
                MarketObject *marketObject = [[MarketObject alloc] init];
                [marketObject setValuesForKeysWithDictionary:dict];
                [self.marketArray addObject:marketObject];
            }
            [self.tableView reloadData];
//            if (self.isNeedScroll) {
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                self.isNeedScroll = NO;
//            }
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_header endRefreshing];
//            if ([object count] != 20) {
//                self.tableView.mj_footer.hidden = YES;
//            }
//            else {
//                self.tableView.mj_footer.hidden = NO;
//            }
        }
    }];
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"跳蚤";
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 49 - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorFromHex:TABLE_BACK_COLOR];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.marketArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *market_banner_id = @"market_banner_cell";
    //    static NSString *community_id = @"community_cell";
    NSString *market_id = [NSString stringWithFormat:@"market_cell_%ld",indexPath.section - 1];
    CommunityBannerCell *marketBannerCell = [tableView dequeueReusableCellWithIdentifier:market_banner_id];
    if (marketBannerCell == nil) {
        marketBannerCell = [[CommunityBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:market_banner_id];
    }
    
    MarketCell *marketCell = [tableView dequeueReusableCellWithIdentifier:market_id];
    if (marketCell == nil) {
        marketCell = [[MarketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:market_id];
    }
    //    else{
    //        [communityCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //        communityCell = [[CommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:community_id];
    //    }
    
    if (indexPath.section == 0) {
        marketBannerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        marketBannerCell.content = @"听说校园里藏着很多”宝贝“！你不需要的东西或许是别人期望的”宝贝“，快来分享你的”宝贝“，我们来交易一番吧！";
        marketBannerCell.bannerCloseBlock = ^{
            
        };
        self.communityBannerCellHeight = marketBannerCell.cellHeight;
        return marketBannerCell;
    }else{
        marketCell.marketObject = self.marketArray[indexPath.section - 1];
        marketCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.marketCellHeight = marketCell.cellHeight;
        return marketCell;
    }
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.communityBannerCellHeight;
    }else{
        return self.marketCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0000000000000001;
    }else{
        return 10.0f;
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
