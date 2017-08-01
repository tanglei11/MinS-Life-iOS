//
//  CommunityWriteController.m
//  MinsLfie
//
//  Created by wodada on 2017/8/1.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityWriteController.h"
#import "ACEExpandableTextCell.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

//控制器
#import "CommunityAddressSelectController.h"

#define leftPadding 15
#define padding 3
#define pictureHW (Screen_Width - 2 * padding - 2 * leftPadding) / 3
#define deleImageWH 17 // 删除按钮的宽高
#define MaxImageCount 9

@interface CommunityWriteController () <UITableViewDataSource,UITableViewDelegate,ACEExpandableTableViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) CGFloat textViewCellHeight;
@property (nonatomic,strong) NSString *textViewStr;
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,assign) BOOL isSelectOriginalPhoto;
@property (nonatomic,weak) UIView *bottomView;
@property (nonatomic,weak) UIButton *addressButton;
@property (nonatomic,weak) UILabel *textNumLabel;

@end

@implementation CommunityWriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textViewCellHeight = 75.0f;
   
    [self initNav];
    
    [self initTableView];
    
    [self initBottomView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"发动态";
    self.customNavigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(closeClick) imageName:@"&#xe625;" imageColor:[UIColor colorFromHex:MAIN_COLOR]];
    self.customNavigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(post) imageName:@"&#xe671;" imageColor:[UIColor colorFromHex:@"#B4B4B4"]];
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 34, Screen_Width, 34)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton *addressButton = [[UIButton alloc] initWithFrame:CGRectMake(8, (bottomView.height - 26) / 2, 104, 26)];
    [addressButton setImage:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe607;"] inFont:ICONFONT size:18 color:[UIColor colorFromHex:@"#A5A5A5"]] forState:UIControlStateNormal];
    [addressButton setTitle:@"你在哪里?" forState:UIControlStateNormal];
    [addressButton setTitleColor:[UIColor colorFromHex:@"#A5A5A5"] forState:UIControlStateNormal];
    addressButton.titleLabel.font = [UIFont systemFontOfSize:14];
    addressButton.layer.cornerRadius = 13;
    addressButton.backgroundColor = [UIColor colorFromHex:@"#F8F8F8"];
    [addressButton addTarget:self action:@selector(addressSelect) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addressButton];
    self.addressButton = addressButton;
    
    UILabel *textNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width * 0.5, (bottomView.height - 14) / 2, Screen_Width * 0.5 - 8, 14)];
    textNumLabel.text = @"114/114 字数";
    textNumLabel.font = [UIFont systemFontOfSize:14];
    textNumLabel.textColor = [UIColor colorFromHex:@"#A5A5A5"];
    textNumLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:textNumLabel];
    self.textNumLabel = textNumLabel;
}

- (UIView *)setUpPhotosView
{
    UIView *photosView = [[UIView alloc]init];
    
    NSInteger imageCount = [_selectedPhotos count];
    for (NSInteger i = 0; i < imageCount; i++) {
        UIImageView *pictureImageView = [[UIImageView alloc]init];
        pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        pictureImageView.clipsToBounds = YES;
        pictureImageView.layer.masksToBounds = YES;
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH, 0, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"compose_photo_close"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image = _selectedPhotos[i];
        pictureImageView.frame = CGRectMake(leftPadding + (i % 3)*(pictureHW + padding), padding +(i / 3)*(pictureHW + padding), pictureHW, pictureHW);
        [photosView addSubview:pictureImageView];
    }
    if (imageCount < MaxImageCount) {
        UIImageView *addPictureView = [[UIImageView alloc]initWithFrame:CGRectMake(leftPadding + (imageCount % 3)*(pictureHW+padding), padding +(imageCount / 3)*(pictureHW + padding), pictureHW, pictureHW)];
        addPictureView.userInteractionEnabled = YES;
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicture)];
        [addPictureView addGestureRecognizer:addTap];
        addPictureView.image = [UIImage imageNamed:@"compose_pic_add"];
        [photosView addSubview:addPictureView];
    }
    NSInteger headViewHeight = 0;
    if ([_selectedPhotos count] < MaxImageCount) {
        headViewHeight = 100 + (10 + pictureHW)*([_selectedPhotos count]/3 + 1);
    }else{
        headViewHeight = 100 + (10 + pictureHW)*([_selectedPhotos count]/3);
    }
    photosView.frame = CGRectMake(0, 0, Screen_Width, headViewHeight);
    
    return photosView;
}

- (void)closeClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addressSelect
{
    CommunityAddressSelectController *communityAddressSelectController = [[CommunityAddressSelectController alloc] init];
    [self presentViewController:communityAddressSelectController animated:YES completion:nil];
}

- (void)post
{
    
}

#pragma mark - addPicture
-(void)addPicture
{
    [self pushImagePickerController];
}

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

#pragma mark - gesture method
-(void)tapImageView:(UITapGestureRecognizer *)tap
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:tap.view.tag];
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        _isSelectOriginalPhoto = isSelectOriginalPhoto;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self changeRightBarItemStatus];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 删除图片
-(void)deletePic:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;
        [_selectedPhotos removeObjectAtIndex:imageView.tag];
        [_selectedAssets removeObjectAtIndex:imageView.tag];
        [imageView removeFromSuperview];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self changeRightBarItemStatus];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self changeRightBarItemStatus];
}

- (void)changeRightBarItemStatus
{
    if (_selectedPhotos.count >0) {
        self.customNavigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(post) imageName:@"&#xe671;" imageColor:[UIColor colorFromHex:MAIN_COLOR]];
    }else{
        self.customNavigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(post) imageName:@"&#xe671;" imageColor:[UIColor colorFromHex:@"#B4B4B4"]];
    }
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ACEExpandableTextCell *cell = [tableView expandableTextCellWithId:@"cellId"];
        cell.textView.tintColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        cell.textView.textContainerInset = UIEdgeInsetsMake(10, 15, 0, 15);
        cell.textView.font = [UIFont systemFontOfSize:16];
        cell.textView.placeholder = @"分享校园新鲜事...";
        return cell;
    }else{
        static NSString *ID = @"photos_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }else {
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:[self setUpPhotosView]];
        return cell;
    }
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0000000000000001f;
    }else{
        return 20.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000000000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.textViewCellHeight;
    }else{
        if ([_selectedPhotos count] < MaxImageCount) {
            return (10 + pictureHW)*([_selectedPhotos count]/3 + 1);
        }else{
            return (10 + pictureHW)*([_selectedPhotos count]/3);
        }
    }
}

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    if (height <= 75.0) {
        self.textViewCellHeight = 75.0;
    }else{
        self.textViewCellHeight = height;
    }
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
    self.textViewStr = text;
}

#pragma mark - textView delegate
- (void)tableView:(UITableView *)tableView textViewDidChangText:(UITextView *)textView
{
    int maxLength = 114;
    
    NSString *toBeString = textView.text;
    
    UITextRange *selectedRange = [textView markedTextRange];
    
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (!position){//非高亮
        int count = (int)(maxLength - toBeString.length);
        
        if (count > 0) {
            self.textNumLabel.text = [NSString stringWithFormat:@"%d/%d 字数",count,maxLength];
        }else{
            self.textNumLabel.text = [NSString stringWithFormat:@"0/%d 字数",maxLength];
        }
        
        if (toBeString.length > maxLength) {
            
            textView.text = [toBeString substringToIndex:maxLength];
        }
    }
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomView.frame = CGRectMake(0, Screen_Height - 34 - keyBoardRect.size.height, Screen_Width, 34);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.bottomView.frame = CGRectMake(0, Screen_Height - 34, Screen_Width, 34);
}

#pragma mark - scroll delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
