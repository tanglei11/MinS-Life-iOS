//
//  CommunityAddressSelectController.m
//  MinsLfie
//
//  Created by wodada on 2017/8/1.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityAddressSelectController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MapKit/MapKit.h>
#import "BTSearchBar.h"
#import "WGS84TOGCJ02.h"
#import "MJRefresh.h"

@interface CommunityAddressSelectController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@property (nonatomic,strong) BTSearchBar *searchBar;
@property (nonatomic,strong) AMapSearchAPI *search;
@property (nonatomic,strong) AMapLocationManager *locationManager;
@property (nonatomic,assign) CLLocationCoordinate2D  Coordinate2D;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *POIArray;
@property (nonatomic,assign) int page;
@property (nonatomic,copy) NSString *keyword;
@property (nonatomic,assign) BOOL isFirstEnter;
@property (nonatomic,assign) NSInteger getPOIDataWay; //0 刷新; 1上拉加载

@end

@implementation CommunityAddressSelectController
//懒加载
- (NSMutableArray *)POIArray
{
    if (_POIArray == nil) {
        self.POIArray = [NSMutableArray array];
    }
    return _POIArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AMapServices sharedServices].apiKey = @"cd238529f488981aeb96f6629c627a8a";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.page = 1;
    
    self.keyword = @"";
    
    self.isFirstEnter = YES;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDistanceFilter:200];
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    
    [self initNav];
    
    [self initTableView];
}

- (void)getPOIData
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:self.Coordinate2D.latitude longitude:self.Coordinate2D.longitude];
    /* 按照距离排序. */
    request.sortrule = 1;
    request.requireExtension = YES;
    request.page = self.page;
    request.keywords = self.keyword;
    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|住宿服务|风景名胜|商务住宅|公司企业";
    [self.search AMapPOIAroundSearch:request];
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"签到";
    self.customNavigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(closeClick) imageName:@"&#xe625;" imageColor:[UIColor colorFromHex:MAIN_COLOR]];
    self.customNavigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(hideAddress) title:@"隐藏位置" titleColor:[UIColor colorFromHex:MAIN_COLOR]];
}

- (BTSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[BTSearchBar alloc] initWithFrame:CGRectMake(40, 44, Screen_Width - 30 - 10, 44.0)];
        _searchBar.placeholder = @"找不到地址?点这里";
        _searchBar.delegate = self;
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        // image background
        _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor colorFromHex:@"#f4f5f7"]];
        // hide search icon
        [_searchBar setImage:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe641;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#999999"]] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        // search text field background
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"TextFieldBg"] forState:UIControlStateNormal];
    }
    return _searchBar;
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = self.searchBar;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(newData)];
    tableView.mj_header = header;
    [tableView.mj_header beginRefreshing];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    tableView.mj_footer = footer;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)newData
{
    self.page = 1;
    self.getPOIDataWay = 0;
    [self.POIArray removeAllObjects];
    [self getPOIData];
}

- (void)moreData
{
    self.page ++;
    self.getPOIDataWay = 1;
    [self getPOIData];
}

- (void)closeClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideAddress
{
    if (self.selectPoi) {
        if ([self.delegate respondsToSelector:@selector(communityAddressSelectController:)]) {
            [self.delegate communityAddressSelectController:self];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    if (self.selectPoi && self.getPOIDataWay == 0) {
        [self.POIArray addObject:self.selectPoi];
    }
    //解析response获取POI信息，具体解析见 Demo
    NSLog(@"-=-=-=-=-=%@",response.pois);
    for (AMapPOI *poiInfo in response.pois) {
        if ([poiInfo.uid isEqualToString:self.selectPoi.uid]) {
            //不添加
        }else{
            [self.POIArray addObject:poiInfo];
        }
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (response.pois.count != 20) {
        self.tableView.mj_footer.hidden = YES;
    }
    else {
        self.tableView.mj_footer.hidden = NO;
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.keyword = searchText;
    self.page = 1;
    self.getPOIDataWay = 0;
    [self.POIArray removeAllObjects];
    [self getPOIData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    self.searchBar.showsCancelButton = YES;
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
    if ([searchBar.text isEqualToString:@""]) {
        self.keyword = @"";
        self.page = 1;
        self.getPOIDataWay = 0;
        [self.POIArray removeAllObjects];
        [self getPOIData];
    }
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
    [self.searchBar resignFirstResponder];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.POIArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"nearby_address_cell";
    NearByAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NearByAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.selectPoi) {
        if (indexPath.section == 0) {
            cell.isSelect = YES;
        }else{
            cell.isSelect = NO;
        }
    }
    cell.poiInfo = self.POIArray[indexPath.section];
    [ToolClass addUnderLineForCell:cell cellHeight:55 lineX:15 lineHeight:LINE_HEIGHT isJustified:NO];
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(communityAddressSelectController:disPassPoiInfo:)]) {
        [self.delegate communityAddressSelectController:self disPassPoiInfo:self.POIArray[indexPath.section]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00000000000000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000000000000001f;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (self.isFirstEnter) {
        self.Coordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [self getPOIData];
        self.isFirstEnter = NO;
    }
    self.Coordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
