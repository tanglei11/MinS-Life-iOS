//
//  ProfilePageController.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ProfilePageController.h"
#import "ProfileInfoCell.h"
#import "ProfileNormalCell.h"

//控制器
#import "LoginController.h"

@interface ProfilePageController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation ProfilePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self initTableView];
    
    [self setBottomShadow];
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"我的";
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorFromHex:TABLE_BACK_COLOR];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pro_info_id = @"pro_info_cell";
    static NSString *pro_normal_id = @"pro_normal_cell";
    
    ProfileInfoCell *proInfoCell = [tableView dequeueReusableCellWithIdentifier:pro_info_id];
    if (proInfoCell == nil) {
        proInfoCell = [[ProfileInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pro_info_id];
    }
    
    ProfileNormalCell *proNormalcell = [tableView dequeueReusableCellWithIdentifier:pro_normal_id];
    if (proNormalcell == nil) {
        proNormalcell = [[ProfileNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pro_normal_id];
    }
    
    if (indexPath.section == 0) {
        proInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        proInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return proInfoCell;
    }else if (indexPath.section == 1){
        NSDictionary *proNormalcellData;
        if (indexPath.row == 0) {
            proNormalcellData = @{@"icon":@"&#xe669;",@"title":@"我赞过的动态"};
            [ToolClass addUnderLineForCell:proNormalcell cellHeight:PRO_NORMAL_CELL_HEIGHT lineX:15 lineHeight:LINE_HEIGHT isJustified:NO];
        }else{
            proNormalcellData = @{@"icon":@"&#xe64c;",@"title":@"我的Collect"};
        }
        proNormalcell.cellData = proNormalcellData;
        proNormalcell.selectionStyle = UITableViewCellSelectionStyleNone;
        proNormalcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return proNormalcell;
    }else{
        NSDictionary *proNormalcellData;
        if (indexPath.row == 0) {
            proNormalcellData = @{@"icon":@"&#xe7bd;",@"title":@"支持与反馈"};
        }else if (indexPath.row == 1){
            proNormalcellData = @{@"icon":@"&#xe68a;",@"title":@"设置"};
        }else{
            proNormalcellData = @{@"icon":@"&#xe644;",@"title":@"给我们评分吧"};
        }
        if (indexPath.row < 2) {
            [ToolClass addUnderLineForCell:proNormalcell cellHeight:PRO_NORMAL_CELL_HEIGHT lineX:15 lineHeight:LINE_HEIGHT isJustified:NO];
        }
        proNormalcell.cellData = proNormalcellData;
        proNormalcell.selectionStyle = UITableViewCellSelectionStyleNone;
        proNormalcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return proNormalcell;
    }
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIAlertController *loginAlertController = [UIAlertController alertControllerWithTitle:@"你还未登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"现在登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LoginController *loginController = [[LoginController alloc] init];
                self.view.window.rootViewController = loginController;
            }];
            [loginAlertController addAction:cancelAction];
            [loginAlertController addAction:loginAction];
            [self presentViewController:loginAlertController animated:YES completion:nil];
        });
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return PRO_INFO_CELL_HEIGHT;
    }else{
        return PRO_NORMAL_CELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000000000000001f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
