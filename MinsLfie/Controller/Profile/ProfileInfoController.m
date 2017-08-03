//
//  ProfileInfoController.m
//  MinsLfie
//
//  Created by wodada on 2017/8/3.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "ProfileInfoController.h"
#import "ProfileHeaderCell.h"
#import "ProfileInfoNormalCell.h"
#import "ProfileInfoSexCell.h"
#import "ProfileInfoNickCell.h"
#import "takePhoto.h"
#import "DatePickerView.h"

@interface ProfileInfoController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) BOOL isHeaderImageSelectStatus;
@property (nonatomic,strong) UIImage *selectHeaderImage;
@property (nonatomic,assign) BOOL isDateSelectStatus;
@property (nonatomic,strong) NSDate *selectBirthday;
@property (nonatomic,weak) UITextField *nickField;
@property (nonatomic,weak) UILabel *sexLable;

@end

@implementation ProfileInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self initTableView];
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"个人中心";
    [self setupCustomBlackBackButton];
    self.customNavigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(saveUserInfo) title:@"保存" titleColor:[UIColor colorFromHex:NORMAL_BG_COLOR]];
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorFromHex:TABLE_BACK_COLOR];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)saveUserInfo
{
    AVUser *user = [AVUser currentUser];
    if (self.selectHeaderImage) {
        CGSize newSize = [self.selectHeaderImage newSizeOfImage:self.selectHeaderImage.size];
        self.selectHeaderImage = [self.selectHeaderImage resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
        
        NSError *error;
        NSData *fileData = UIImageJPEGRepresentation(self.selectHeaderImage, 0.5);
        if (fileData == nil) {
            NSLog(@"Failed to read file, error %@", error);
            return;
        }
        
        NSString *photoOriginalName = [NSString stringWithFormat:@"Profile_%@.png",[AVUser currentUser].username];
        // init MBProgressHUD
        [MBProgressHUD showMessage:@"正在保存..." toView:self.view];
        AVFile *file = [AVFile fileWithName:photoOriginalName data:fileData];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (succeeded == YES) {
                [self saveInfoforUser:user file:file];
            }else{
                
            }
        }];
    }else{
        [MBProgressHUD showMessage:@"正在保存..." toView:self.view];
        [self saveInfoforUser:user file:nil];
    }
}

- (void)saveInfoforUser:(AVUser *)user file:(AVFile *)file
{
    if (file) {
        [user setObject:file forKey:@"profile"];
        [user setObject:file.url forKey:@"profileUrl"];
    }
    [user setObject:self.nickField.text forKey:@"nickname"];
    [user setObject:self.sexLable.text forKey:@"sex"];
    if (self.selectBirthday) {
         [user setObject:self.selectBirthday forKey:@"birthday"];
    }
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"%@",error);
            [MBProgressHUD showSuccess:@"上传失败,请重试" toView:self.view];
        }
    }];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AVUser *user = [AVUser currentUser];
    
    static NSString *headerId = @"pro_header_cell";
    static NSString *nickId = @"pro_nick_cell";
    static NSString *normalId = @"pro_normal_cell";
    static NSString *sexId = @"pro_sex_cell";
    
    ProfileHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:headerId];
    if (headerCell == nil) {
        headerCell = [[ProfileHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerId];
    }
    
    ProfileInfoNickCell *nickCell = [tableView dequeueReusableCellWithIdentifier:nickId];
    if (nickCell == nil) {
        nickCell = [[ProfileInfoNickCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nickId];
    }
    
    ProfileInfoNormalCell *normalCell = [tableView dequeueReusableCellWithIdentifier:normalId];
    if (normalCell == nil) {
        normalCell = [[ProfileInfoNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalId];
    }
    
    ProfileInfoSexCell *sexCell = [tableView dequeueReusableCellWithIdentifier:sexId];
    if (sexCell == nil) {
        sexCell = [[ProfileInfoSexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sexId];
    }
    
    if (indexPath.row == 0) {
        if (self.isHeaderImageSelectStatus) {
            headerCell.headerImage = self.selectHeaderImage;
        }else{
            AVFile *file = (AVFile *)[user objectForKey:@"profile"];
            NSString *profileUrl = (NSString *)[user objectForKey:@"profileUrl"];
            headerCell.headerUrl = file.url ? file.url : (profileUrl ? profileUrl : @"");
        }
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [ToolClass addUnderLineForCell:headerCell cellHeight:55 lineX:20 lineHeight:LINE_HEIGHT isJustified:NO];
        return headerCell;
    }else if (indexPath.row == 1){
        [self setUpProfileNormalCellWithCell:normalCell Title:@"用户名" content:user.username];
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [ToolClass addUnderLineForCell:normalCell cellHeight:55 lineX:20 lineHeight:LINE_HEIGHT isJustified:NO];
        return normalCell;
    }else if (indexPath.row == 2){
        NSString *name = (NSString *)[user objectForKey:@"nickname"] ? (NSString *)[user objectForKey:@"nickname"] : @"";
        nickCell.textField.text = name;
        self.nickField = nickCell.textField;
        nickCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [ToolClass addUnderLineForCell:nickCell cellHeight:55 lineX:20 lineHeight:LINE_HEIGHT isJustified:NO];
        return nickCell;
    }else if (indexPath.row == 3){
        NSString *sexStr = (NSString *)[user objectForKey:@"sex"];
        sexCell.sex = sexStr ? sexStr : @"男";
        self.sexLable = sexCell.contentLabel;
        sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [ToolClass addUnderLineForCell:sexCell cellHeight:55 lineX:20 lineHeight:LINE_HEIGHT isJustified:NO];
        return sexCell;
    }else if (indexPath.row == 4){
        NSString *birthday;
        if (self.isDateSelectStatus) {
            birthday = [NSString stringWithDate:self.selectBirthday isNeedWeek:NO];
        }else{
            birthday = [NSString stringWithDate:(NSDate *)[user objectForKey:@"birthday"] isNeedWeek:NO] && ![[NSString stringWithDate:(NSDate *)[user objectForKey:@"birthday"] isNeedWeek:NO] isEqualToString:@"0年0月0日"] ? [NSString stringWithDate:(NSDate *)[user objectForKey:@"birthday"] isNeedWeek:NO] : @"未设置";
        }
        [self setUpProfileNormalCellWithCell:normalCell Title:@"生日" content:birthday];
        normalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [ToolClass addUnderLineForCell:normalCell cellHeight:55 lineX:20 lineHeight:LINE_HEIGHT isJustified:NO];
        return normalCell;
    }else{
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpProfileNormalCellWithCell:normalCell Title:@"手机号" content:user.mobilePhoneNumber];
        return normalCell;
    }
}

- (void)setUpProfileNormalCellWithCell:(ProfileInfoNormalCell *)cell Title:(NSString *)title content:(NSString *)content
{
    cell.title = title;
    cell.content = content;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [takePhoto chooseViewController:self isEdit:NO sharePicture:^(UIImage *image) {
            self.isHeaderImageSelectStatus = YES;
            self.selectHeaderImage = image;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }else if (indexPath.row == 4){
        [self.view endEditing:YES];
        //生日
        DatePickerView *datePickerView = [[DatePickerView alloc]initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, DataPickerViewHeight) andAboveView:self.view];
        
        __block DatePickerView *strongDataPickerView = datePickerView;
        
        [datePickerView setDataPickerViewBlock:^{
            self.isDateSelectStatus = YES;
            self.selectBirthday = strongDataPickerView.datePicker.date;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [UIView animateWithDuration:0.25f animations:^{
            datePickerView.frame = CGRectMake(0, Screen_Height - DataPickerViewHeight, Screen_Width, DataPickerViewHeight);
        } completion:^(BOOL finished) {
        }];
        
        [self.view addSubview:datePickerView];
        [datePickerView addDataPickerView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000000000001f;
}


#pragma mark - scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
