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
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

//控制器
#import "CommunityAddressSelectController.h"

#define leftPadding 15
#define padding 3
#define pictureHW (Screen_Width - 2 * padding - 2 * leftPadding) / 3
#define deleImageWH 17 // 删除按钮的宽高
#define MaxImageCount 9

@interface CommunityWriteController () <UITableViewDataSource,UITableViewDelegate,ACEExpandableTableViewDelegate,TZImagePickerControllerDelegate,CommunityAddressSelectControllerDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) CGFloat textViewCellHeight;
@property (nonatomic,strong) NSString *textViewStr;
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,assign) BOOL isSelectOriginalPhoto;
@property (nonatomic,weak) UIView *bottomView;
@property (nonatomic,weak) UIView *addressView;
@property (nonatomic,weak) UIImageView *addressImgae;
@property (nonatomic,weak) UILabel *addressLable;
@property (nonatomic,weak) UILabel *textNumLabel;
@property (nonatomic,weak) UIView *cancelView;
@property (nonatomic,strong) AMapPOI *poiInfo;
@property (nonatomic,weak) UITextField *titleField;
@property (nonatomic,weak) UITextField *priceFiled;
@property (nonatomic,assign) CGFloat priceCellY;
@property (nonatomic,assign) BOOL isKeyboardScroll;

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
    if (self.type == CommunityWriteControllerTypeMarket) {
        self.customNavigationItem.title = @"发跳蚤";
    }else{
        self.customNavigationItem.title = @"发动态";
    }
    self.customNavigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(closeClick) imageName:@"&#xe625;" imageColor:[UIColor colorFromHex:MAIN_COLOR]];
    self.customNavigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(post) imageName:@"&#xe671;" imageColor:[UIColor colorFromHex:@"#B4B4B4"]];
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64 - 34) style:UITableViewStyleGrouped];
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
    
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(8, (bottomView.height - 26) / 2, 104, 26)];
    addressView.userInteractionEnabled = YES;
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressSelect)];
    [addressView addGestureRecognizer:addressTap];
    addressView.backgroundColor = [UIColor colorFromHex:@"#F8F8F8"];
    addressView.layer.borderColor = [[UIColor colorFromHex:@"#E9E9E9"] CGColor];
    addressView.layer.borderWidth = LINE_HEIGHT;
    addressView.layer.cornerRadius = 13;
    [bottomView addSubview:addressView];
    self.addressView = addressView;
    
    UIImageView *addressImgae = [[UIImageView alloc] initWithFrame:CGRectMake(5, (addressView.height - 18) / 2, 18, 18)];
    addressImgae.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe607;"] inFont:ICONFONT size:18 color:[UIColor colorFromHex:@"#A5A5A5"]];
    [addressView addSubview:addressImgae];
    self.addressImgae = addressImgae;
    
    UILabel *addressLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressImgae.frame) + 5, (addressView.height - 14) / 2, addressView.width - CGRectGetMaxX(addressImgae.frame) - 5 - 10, 14)];
    addressLable.font = [UIFont systemFontOfSize:14];
    addressLable.text = @"你在哪里?";
    addressLable.textColor = [UIColor colorFromHex:@"#A5A5A5"];
    [addressView addSubview:addressLable];
    self.addressLable = addressLable;
    //取消地址
    UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(addressView.width - 26, 0, 26, 26)];
    cancelView.userInteractionEnabled = YES;
    cancelView.hidden = YES;
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAddress)];
    [cancelView addGestureRecognizer:cancelTap];
    cancelView.backgroundColor = [UIColor colorFromHex:@"#F8F8F8"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cancelView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = cancelView.bounds;
    maskLayer.path = maskPath.CGPath;
    cancelView.layer.mask = maskLayer;
    [addressView addSubview:cancelView];
    self.cancelView = cancelView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LINE_HEIGHT, cancelView.height)];
    lineView.backgroundColor = [UIColor colorFromHex:@"#E9E9E9"];
    [cancelView addSubview:lineView];
    
    UIImageView *cancelImage = [[UIImageView alloc] initWithFrame:CGRectMake((cancelView.width - 16) / 2, (cancelView.height - 16) / 2, 16, 16)];
    cancelImage.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe646;"] inFont:ICONFONT size:16 color:[UIColor colorFromHex:NORMAL_BG_COLOR]];
    [cancelView addSubview:cancelImage];
    
    
    NSString *text = @"114/114 字数";
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14]];
    UILabel *textNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width - 8 - textSize.width - 10, (bottomView.height - 14) / 2, textSize.width + 10, 14)];
    textNumLabel.text = text;
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
    photosView.frame = CGRectMake(0, 20, Screen_Width, headViewHeight);
    
    return photosView;
}

- (void)closeClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addressSelect
{
    CommunityAddressSelectController *communityAddressSelectController = [[CommunityAddressSelectController alloc] init];
    communityAddressSelectController.selectPoi = self.poiInfo;
    communityAddressSelectController.delegate = self;
    [self presentViewController:communityAddressSelectController animated:YES completion:nil];
}

- (void)post
{
    if (self.selectedPhotos.count == 0) return;
    //获取图片名字
    NSMutableArray *nameArray = [NSMutableArray array];
    for (PHAsset *asset in _selectedAssets) {
        [nameArray addObject:[asset valueForKey:@"filename"]];
    }
    
    __block NSMutableString *imgList = [NSMutableString string];
    __block NSMutableArray *imgArray = [NSMutableArray array];
    for (int i = 0; i < self.selectedPhotos.count; i++) {
        UIImage *image = _selectedPhotos[i];
        CGSize newSize = [image newSizeOfImage:image.size];
        image = [image resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
        
        NSError *error;
        NSData *fileData = UIImageJPEGRepresentation(image, 0.5);
        AVFile *file = [AVFile fileWithName:nameArray[i] data:fileData];
        if (i == _selectedPhotos.count - 1) {
            [MBProgressHUD showMessage:@"发送中..." toView:self.view];
        }
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [imgArray addObject:@{@"index":[NSString stringWithFormat:@"%d",i],@"url":file.url}];
            NSLog(@"xxxxxxx----------%@",imgArray);
            if (_selectedPhotos.count == imgArray.count) {
                NSSortDescriptor *description = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
                [imgArray sortUsingDescriptors:@[description]];
                for (int i = 0; i < imgArray.count; i++) {
                    NSDictionary *dict = imgArray[i];
                    imgList = (NSMutableString *)[imgList stringByAppendingString:[NSString stringWithFormat:@"%@,",dict[@"url"]]];
                }
                imgList = (NSMutableString *)[imgList substringToIndex:[imgList length]-1];
                if (self.type == CommunityWriteControllerTypeMarket) {
                    
                }else{
                    [self getDynamicParamsAndSendPostWithImgList:imgList];
                }
            }
        }];
    }
    
}

- (void)getDynamicParamsAndSendPostWithImgList:(NSString *)imgList
{
    NSDictionary *params = @{@"content":self.textViewStr,@"imgs":imgList,@"addressName":self.poiInfo ? self.poiInfo.name : @"",@"address":self.poiInfo ? self.poiInfo.address : @"",@"latitude":self.poiInfo ? [NSString stringWithFormat:@"%f",self.poiInfo.location.latitude] : @"",@"longitude":self.poiInfo ? [NSString stringWithFormat:@"%f",self.poiInfo.location.longitude] : @"",@"userId":[AVUser currentUser].objectId};
    [AVCloud callFunctionInBackground:@"saveDynamic" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error != nil) {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"发布失败" toView:self.view];
        }else{
            [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goToDynamic" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
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
        
        [self reloadCommomCellforAblum];
        
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
    
    [self reloadCommomCellforAblum];
    
    [self changeRightBarItemStatus];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    [self reloadCommomCellforAblum];
    
    [self changeRightBarItemStatus];
}

- (void)reloadCommomCellforAblum
{
    NSInteger section = 0;
    if (self.type == CommunityWriteControllerTypeMarket) {
        section = 1;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:section];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if (self.type == CommunityWriteControllerTypeMarket) {
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == CommunityWriteControllerTypeMarket) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 2;
        }else{
            return 1;
        }
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == CommunityWriteControllerTypeMarket) {
        if (indexPath.section == 0) {
            static NSString *ID = @"title_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, Screen_Width - 2 * 15, 30)];
                NSString *holderText = @"商品标题";
                NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
                [placeholder addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorFromHex:@"#939393"]
                                    range:NSMakeRange(0, holderText.length)];
                [placeholder addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:18]
                                    range:NSMakeRange(0, holderText.length)];
                titleField.attributedPlaceholder = placeholder;
                titleField.font = [UIFont systemFontOfSize:18];
                titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
                titleField.tintColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
                [cell.contentView addSubview:titleField];
                self.titleField = titleField;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [ToolClass addUnderLineForCell:cell cellHeight:50 lineX:15 lineHeight:LINE_HEIGHT isJustified:YES];
            return cell;
        }else if (indexPath.section == 1){
            return [self commonCellWithTableView:tableView ForRowAtIndexPath:indexPath];
        }else{
            static NSString *ID = @"price_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                //布局
                NSString *price = @"价格(元)";
                CGSize priceSize = [price sizeWithFont:[UIFont systemFontOfSize:16]];
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, priceSize.width, 16)];
                priceLabel.font = [UIFont systemFontOfSize:16];
                priceLabel.textColor = [UIColor colorFromHex:@"#636363"];
                priceLabel.text = price;
                [cell.contentView addSubview:priceLabel];
                
                UITextField *priceFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame) + 50, 10, Screen_Width - CGRectGetMaxX(priceLabel.frame) - 50 - 15, 30)];
                priceFiled.delegate = self;
                priceFiled.placeholder = @"0.00";
                priceFiled.font = [UIFont systemFontOfSize:16];
                priceFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
                priceFiled.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:priceFiled];
                self.priceFiled = priceFiled;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [ToolClass addTopLineForCell:cell lineX:15 lineHeight:LINE_HEIGHT isJustified:YES];
            return cell;
        }
    }else{
        return [self commonCellWithTableView:tableView ForRowAtIndexPath:indexPath];
    }
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.type == CommunityWriteControllerTypeMarket) {
        if (section == 2) {
            return 10.0f;
        }else{
            return 0.0000000000000001f;
        }
    }else{
       return 0.0000000000000001f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000000000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == CommunityWriteControllerTypeMarket) {
        if (indexPath.section == 0) {
            return 50.0f;
        }else if (indexPath.section == 1){
            return [self commonHeightForRowAtIndexPath:indexPath];
        }else{
            return 50.0f;
        }
    }else{
        return [self commonHeightForRowAtIndexPath:indexPath];
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

#pragma mark - 公共模块
- (UITableViewCell *)commonCellWithTableView:(UITableView *)tableView ForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ACEExpandableTextCell *cell = [tableView expandableTextCellWithId:@"desc_cell"];
        cell.textView.tintColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        cell.textView.textContainerInset = UIEdgeInsetsMake(10, 12, 0, 6);
        cell.textView.font = [UIFont systemFontOfSize:16];
        if (self.type == CommunityWriteControllerTypeMarket) {
            cell.textView.placeholder = @"商品描述（选填）";
        }else{
            cell.textView.placeholder = @"分享校园新鲜事...";
        }
        
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

- (CGFloat)commonHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.textViewCellHeight;
    }else{
        if ([_selectedPhotos count] < MaxImageCount) {
            return (10 + pictureHW)*([_selectedPhotos count]/3 + 1) + 20;
        }else{
            return (10 + pictureHW)*([_selectedPhotos count]/3) + 20;
        }
    }
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
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomView.frame = CGRectMake(0, Screen_Height - 34 - keyBoardRect.size.height, Screen_Width, 34);
    NSLog(@"%f---------%f",self.priceCellY,keyBoardRect.origin.y);
    if (self.priceCellY - keyBoardRect.origin.y > 0) {
        if (self.textViewCellHeight > 75.0f) {
            [self.tableView setContentOffset:CGPointMake(0, self.priceCellY - keyBoardRect.origin.y + 50 + 10 + (self.textViewCellHeight - 75.0f)) animated:YES];
        }else{
            [self.tableView setContentOffset:CGPointMake(0, self.priceCellY - keyBoardRect.origin.y + 50 + 10) animated:YES];
        }
    }else{
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.bottomView.frame = CGRectMake(0, Screen_Height - 34, Screen_Width, 34);
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    CGRect parentRect = [cell convertRect:textField.frame toView:self.view];
    self.priceCellY = parentRect.origin.y;
    self.isKeyboardScroll = YES;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.priceCellY = 0;
    return YES;
}

#pragma mark - scroll delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isKeyboardScroll) {
//        self.isKeyboardScroll = NO;
    }else{
       [self.view endEditing:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isKeyboardScroll = NO;
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    self.isKeyboardScroll = NO;
//}

- (void)cancelAddress
{
    [UIView animateWithDuration:0.25 animations:^{
        self.addressView.width = 104;
        self.addressLable.width = self.addressView.width - CGRectGetMaxX(self.addressImgae.frame) - 5 - 10;
        self.addressImgae.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe607;"] inFont:ICONFONT size:18 color:[UIColor colorFromHex:@"#A5A5A5"]];
        self.addressLable.text = @"你在哪里?";
        self.addressLable.textColor = [UIColor colorFromHex:@"#A5A5A5"];
        self.cancelView.x = self.addressView.width - self.cancelView.width;
        self.cancelView.hidden = YES;
    }];
}

#pragma mark - CommunityAddressSelectController Delegate
- (void)communityAddressSelectController:(CommunityAddressSelectController *)communityAddressSelectController disPassPoiInfo:(AMapPOI *)poiInfo
{
    NSLog(@"-=-=-==%@",poiInfo);
    self.poiInfo = poiInfo;
    CGSize addressSize = [poiInfo.name sizeWithFont:[UIFont systemFontOfSize:14]];
    CGFloat addressViewW = addressSize.width + 18 + 20 + 26;
    CGFloat addressLabelW = addressSize.width;
    if (addressViewW > (Screen_Width - self.textNumLabel.width - 2 * 8 - 10)) {
        addressViewW = Screen_Width - self.textNumLabel.width - 2 * 8 - 10;
        addressLabelW = addressViewW - 18 - 20 - 26;
    }
    self.addressView.width = addressViewW;
    self.addressLable.width = addressLabelW;
    self.addressImgae.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe607;"] inFont:ICONFONT size:18 color:[UIColor colorFromHex:NORMAL_BG_COLOR]];
    self.addressLable.text = poiInfo.name;
    self.addressLable.textColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
    self.cancelView.hidden = NO;
    self.cancelView.x = self.addressView.width - self.cancelView.width;
}

- (void)communityAddressSelectController:(CommunityAddressSelectController *)communityAddressSelectControllerDidPassEmpty
{
    self.poiInfo = nil;
    [self cancelAddress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
