//
//  CommunityDetailController.m
//  MinsLfie
//
//  Created by wodada on 2017/8/8.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityDetailController.h"
#import "CommunityDetailCell.h"
#import "CommunityCommentCell.h"

@interface CommunityDetailController () <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic,assign) CGFloat communityDetailCellHeight;
@property (nonatomic,weak) UIView *bottomView;
@property (nonatomic,weak) UITextField *commentTextField;
@property (nonatomic,strong) NSMutableArray *commentArray;
@property (nonatomic,assign) int page;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) CGFloat CommunityCommentCellHeight;
@property (nonatomic,weak) UILabel *headerLable;
@property (nonatomic,weak) UIActionSheet *deleteSheet;
@property (nonatomic,weak) UIActionSheet *replySheet;
@property (nonatomic,assign) BOOL isReply;
@property (nonatomic,strong) DynamicCommentObject *currentSelectCommentObject;
@property (nonatomic,weak) UIButton *likeButton;
//@property (nonatomic,assign) BOOL isLike;

@end

@implementation CommunityDetailController
//懒加载
- (NSMutableArray *)commentArray
{
    if (_commentArray == nil) {
        self.commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 0;
    
    [self getCommentData];
    
    [self getLikeStatus];
    
    [self initNav];
    
    [self initTableView];
    
    [self initBottomView];
    
    [self setBottomShadow];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)getCommentData
{
    int skip = self.page * 20;
    NSDictionary *parameters = @{ @"limit" : @20,
                                  @"skip" : [NSNumber numberWithInt:skip],@"relationId":self.dynamicsObject.objectId,@"commentType":@"dynamic"};
    [MSProgressHUD showHUDAddedToWindow:self.view.window];
    [AVCloud callFunctionInBackground:@"getComments" withParameters:parameters block:^(id  _Nullable object, NSError * _Nullable error) {
        [MSProgressHUD hideHUDForWindow:self.view.window animated:YES];
        if (error != nil) {
            [MBProgressHUD showError:@"获取数据失败,请重试" toView:self.view];
        }else{
            NSLog(@"-=-=-=-=-%@",object);
            for (NSDictionary *dict in object) {
                DynamicCommentObject *dynamicCommentObject = [[DynamicCommentObject alloc] init];
                [dynamicCommentObject setValuesForKeysWithDictionary:dict];
                [self.commentArray addObject:dynamicCommentObject];
            }
            [self.tableView reloadData];
//            self.headerLable.text = [NSString stringWithFormat:@"所有%ld评论",self.commentArray.count];
        }
    }];
}

- (void)getLikeStatus
{
    NSDictionary *params = @{@"relationId":self.dynamicsObject.objectId,@"userId":[AVUser currentUser].objectId ? [AVUser currentUser].objectId : @"",@"likeType":@"dynamic"};
    [AVCloud callFunctionInBackground:@"getLikeStatus" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            [MBProgressHUD showError:@"获取点赞状态失败"];
        }else{
            NSLog(@"-=-=-=-=%@",object);
            if ([object[@"likeStatus"] intValue] == 1) {
                self.likeButton.selected = YES;
//                self.isLike = YES;
            }else{
                self.likeButton.selected = NO;
//                self.isLike = NO;
            }
        }
    }];
}

- (void)initNav
{
    [self setupCustomNavigationBarDefault];
    self.customNavigationItem.title = @"动态正文";
    [self setupCustomBlackBackButton];
    if ([[AVUser currentUser].objectId isEqualToString:self.dynamicsObject.dynamicsUser.objectId]) {
        self.customNavigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(deleteDynamic) imageName:@"&#xe6b4;" imageColor:[UIColor colorFromHex:MAIN_COLOR]];
    }
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor colorFromHex:TABLE_BACK_COLOR];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.delegate = self;
    [tableView addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 49, Screen_Width, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(bottomView.width - 15 - 22, (bottomView.height - 22) / 2, 22, 22)];
    [likeButton setImage:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe669;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:MAIN_COLOR]] forState:UIControlStateNormal];
    [likeButton setImage:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe66a;"] inFont:ICONFONT size:22 color:[UIColor colorFromHex:NORMAL_BG_COLOR]] forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:likeButton];
    self.likeButton = likeButton;
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(6, 7, likeButton.x - 18, 35)];
    textFieldView.backgroundColor = [UIColor colorFromHex:@"#F1F1F1"];
    textFieldView.layer.cornerRadius = 6;
    [bottomView addSubview:textFieldView];
    
    UITextField *commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, (textFieldView.height - 30) / 2, textFieldView.width - 2 * 10, 30)];
    commentTextField.returnKeyType = UIReturnKeySend;
    commentTextField.delegate = self;
    commentTextField.enablesReturnKeyAutomatically = YES;
    commentTextField.font = [UIFont systemFontOfSize:14];
    commentTextField.placeholder = @"喜欢就夸！或者有什么想说的？";
    [textFieldView addSubview:commentTextField];
    self.commentTextField = commentTextField;
    
}

- (void)likeClick
{
    AVUser *user = [AVUser currentUser];
    if (user != nil) {
        if (self.likeButton.selected) {
            self.likeButton.selected = NO;
            //请求接口
            NSDictionary *params = @{@"relationId":self.dynamicsObject.objectId,@"userId":user.objectId,@"likeType":@"dynamic"};
            [AVCloud callFunctionInBackground:@"cancelLike" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {
                if (error != nil) {
                    [MBProgressHUD showError:@"取消点赞失败"];
                }else{
                    
                }
            }];
        }else{
            self.likeButton.selected = YES;
            //请求接口
            NSDictionary *params = @{@"relationId":self.dynamicsObject.objectId,@"userId":user.objectId,@"likeType":@"dynamic"};
            [AVCloud callFunctionInBackground:@"saveLike" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {
                if (error != nil) {
                    [MBProgressHUD showError:@"点赞失败"];
                }else{
                
                    }
            }];
        }
    }else{
        [self showLoginGuideView];
    }
}

- (void)deleteDynamic
{
    UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"确定要删除该动态？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlertView show];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *params = @{@"dynamicId":self.dynamicsObject.objectId};
        [MBProgressHUD showMessage:@"删除中..."];
        [AVCloud callFunctionInBackground:@"deleteDynamic" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {
            [MBProgressHUD hideHUD];
            if (error != nil) {
                [MBProgressHUD showError:@"删除失败,请重试"];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - UIGestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomView.frame = CGRectMake(0, Screen_Height - 49 - keyBoardRect.size.height, Screen_Width, 49);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.isReply = NO;
    self.currentSelectCommentObject = nil;
    self.commentTextField.placeholder = @"喜欢就夸！或者有什么想说的？";
    self.bottomView.frame = CGRectMake(0, Screen_Height - 49, Screen_Width, 49);
}

#pragma mark - scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    AVUser *user = [AVUser currentUser];
    if (user != nil) {
        
        NSString *name = (NSString *)[user objectForKey:@"nickname"] ? (NSString *)[user objectForKey:@"nickname"] : user.username;
        AVFile *file = (AVFile *)[user objectForKey:@"profile"];
        NSString *profileUrl = (NSString *)[user objectForKey:@"profileUrl"];
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        fmt.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        fmt.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
        NSDate *date = [NSDate date];
        NSString *createDateStr = [NSString stringWithFormat:@"%@Z", [fmt stringFromDate:date]];
        
        NSDictionary *params;
        __block NSDictionary *dict;
        
        if (self.isReply) {
            params = @{@"relationId":self.dynamicsObject.objectId,@"commentUserId":user.objectId,@"beCommentUserId":self.currentSelectCommentObject.dynamicsUser.objectId,@"beCommentUserName":self.currentSelectCommentObject.dynamicsUser.nickname ? self.currentSelectCommentObject.dynamicsUser.nickname : self.currentSelectCommentObject.dynamicsUser.username,@"commentContent":[self.commentTextField.text isEqualToString:@""] ? @"" : self.commentTextField.text,@"commentType":@"dynamic"};
        }else{
            params = @{@"relationId":self.dynamicsObject.objectId,@"commentUserId":user.objectId,@"beCommentUserId":self.dynamicsObject.dynamicsUser.objectId,@"beCommentUserName":[self.dynamicsObject.dynamicsUser.nickname isEqualToString:@""] ? self.dynamicsObject.dynamicsUser.username : self.dynamicsObject.dynamicsUser.nickname,@"commentContent":[self.commentTextField.text isEqualToString:@""] ? @"" : self.commentTextField.text,@"commentType":@"dynamic"};
        }
        
        [MBProgressHUD showMessage:@"发送中..."];
        [AVCloud callFunctionInBackground:@"saveComment" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {
            [MBProgressHUD hideHUD];
            if (error != nil) {
                [MBProgressHUD showError:@"发送失败"];
            }else{
                NSLog(@"-=-=-=%@",object);
                if (self.isReply) {
                    dict = @{@"relationId":self.dynamicsObject.objectId,@"objectId":object[@"commentId"],@"commentUserId":user.objectId,@"user":@{@"objectId":user.objectId,@"profileUrl":file.url ? file.url : (profileUrl ? profileUrl : @""),@"nickname":[user objectForKey:@"nickname"],@"username":user.username},@"beCommentUserId":self.currentSelectCommentObject.dynamicsUser.objectId,@"beCommentUserName":self.currentSelectCommentObject.dynamicsUser.nickname ? self.currentSelectCommentObject.dynamicsUser.nickname : self.currentSelectCommentObject.dynamicsUser.username,@"commentContent":[self.commentTextField.text isEqualToString:@""] ? @"" : self.commentTextField.text,@"commentType":@"dynamic",@"createdAt":createDateStr};
                }else{
                    dict = @{@"relationId":self.dynamicsObject.objectId,@"objectId":object[@"commentId"],@"commentUserId":user.objectId,@"user":@{@"objectId":user.objectId,@"profileUrl":file.url ? file.url : (profileUrl ? profileUrl : @""),@"nickname":[user objectForKey:@"nickname"],@"username":user.username},@"beCommentUserName":[self.dynamicsObject.dynamicsUser.nickname isEqualToString:@""] ? self.dynamicsObject.dynamicsUser.username : self.dynamicsObject.dynamicsUser.nickname,@"beCommentUserId":self.dynamicsObject.dynamicsUser.objectId,@"commentContent":[self.commentTextField.text isEqualToString:@""] ? @"" : self.commentTextField.text,@"commentType":@"dynamic",@"createdAt":createDateStr};
                }
                //刷新UI
                DynamicCommentObject *dynamicCommentObject = [[DynamicCommentObject alloc] init];
                [dynamicCommentObject setValuesForKeysWithDictionary:dict];
                [self.commentArray insertObject:dynamicCommentObject atIndex:0];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [self.view endEditing:YES];
                self.commentTextField.text = @"";
            }
        }];
    }else{
        [self.view endEditing:YES];
        [self showLoginGuideView];
    }
    return YES;
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.commentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailID = @"dynamic_detail_cell";
    static NSString *commentID = @"comment_cell";
    
    CommunityDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:detailID];
    if (detailCell == nil) {
        detailCell = [[CommunityDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailID];
    }
    
    CommunityCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentID];
    if (commentCell == nil) {
        commentCell = [[CommunityCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentID];
    }
    
    if (indexPath.section == 0) {
        detailCell.dynamicsObject = self.dynamicsObject;
        self.communityDetailCellHeight = detailCell.cellHeight;
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return detailCell;
    }else{
        commentCell.dynamicUserId = self.dynamicsObject.dynamicsUser.objectId;
        commentCell.dynamicCommentObject = self.commentArray[indexPath.row];
        self.CommunityCommentCellHeight = commentCell.cellHeight;
//        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [ToolClass addUnderLineForCell:commentCell cellHeight:self.CommunityCommentCellHeight lineX:22 lineHeight:LINE_HEIGHT isJustified:NO];
        return commentCell;
    }
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
        AVUser *user = [AVUser currentUser];
        
        if (user != nil) {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            DynamicCommentObject *dynamicCommentObject = self.commentArray[indexPath.row];
            
            UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.commentTextField.placeholder = [NSString stringWithFormat:@"回复%@",dynamicCommentObject.dynamicsUser.nickname ? dynamicCommentObject.dynamicsUser.nickname : dynamicCommentObject.dynamicsUser.username];
                [self.commentTextField becomeFirstResponder];
                self.isReply = YES;
                self.currentSelectCommentObject = dynamicCommentObject;
            }];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                NSDictionary *params = @{@"commentId":dynamicCommentObject.objectId,@"relationId":dynamicCommentObject.relationId,@"commentType":@"dynamic"};
                [MBProgressHUD showMessage:@"删除中..."];
                [AVCloud callFunctionInBackground:@"deleteComment" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {
                    [MBProgressHUD hideHUD];
                    if (error != nil) {
                        [MBProgressHUD showError:@"删除失败,请重试"];
                    }else{
                        [self.commentArray removeObject:dynamicCommentObject];
                        [self.tableView reloadData];
                    }
                }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            if ([user.objectId isEqualToString:dynamicCommentObject.commentUserId]) {
                [alertViewController addAction:deleteAction];
            }else{
                [alertViewController addAction:replyAction];
            }
            [alertViewController addAction:cancelAction];
            [self presentViewController:alertViewController animated:YES completion:nil];
        }else{
            [self showLoginGuideView];
        }
    
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }else{
        if (self.commentArray.count > 0) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 54.0f)];
            headerView.backgroundColor = [UIColor clearColor];
            
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10.0f, headerView.width, 44.0f)];
            containerView.backgroundColor = [UIColor whiteColor];
            [headerView addSubview:containerView];
            
            UILabel *headerLable = [[UILabel alloc] initWithFrame:CGRectMake(22, (containerView.height - 16) / 2, containerView.width - 2 * 22, 14)];
            headerLable.font = [UIFont systemFontOfSize:14];
            headerLable.textColor = [UIColor colorFromHex:@"#C2C2C2"];
            headerLable.text = [NSString stringWithFormat:@"所有%ld评论",self.commentArray.count];
            [containerView addSubview:headerLable];
            self.headerLable = headerLable;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(22, headerView.height - LINE_HEIGHT, Screen_Width - 22, LINE_HEIGHT)];
            lineView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
            [headerView addSubview:lineView];
            
            return headerView;
        }else{
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 180)];
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10.0f, headerView.width, 44.0f)];
            containerView.backgroundColor = [UIColor whiteColor];
            [headerView addSubview:containerView];
            
            UILabel *headerLable = [[UILabel alloc] initWithFrame:CGRectMake(22, (containerView.height - 16) / 2, containerView.width - 2 * 22, 14)];
            headerLable.font = [UIFont systemFontOfSize:14];
            headerLable.textColor = [UIColor colorFromHex:@"#C2C2C2"];
            headerLable.text = [NSString stringWithFormat:@"所有%ld评论",self.commentArray.count];
            [containerView addSubview:headerLable];
            self.headerLable = headerLable;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(containerView.frame), Screen_Width - 22 * 22, LINE_HEIGHT)];
            lineView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
            [headerView addSubview:lineView];
            
            UIView *flagView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), Screen_Width, headerView.height - CGRectGetMaxY(lineView.frame))];
            flagView.backgroundColor = [UIColor whiteColor];
            [headerView addSubview:flagView];
            
            UIImageView *flagImage = [[UIImageView alloc] initWithFrame:CGRectMake((flagView.width - 40) / 2, 30, 45, 45)];
            flagImage.layer.masksToBounds = YES;
            flagImage.layer.cornerRadius = flagImage.height / 2;
            flagImage.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe666;"] inFont:ICONFONT size:40 color:[UIColor colorFromHex:@"#C2C2C2"]];
            [flagView addSubview:flagImage];
            
            UILabel *flagLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(flagImage.frame) + 20, flagView.width, 14)];
            flagLable.font = [UIFont systemFontOfSize:14];
            flagLable.text = @"现在没有人评论！还不赶紧抢沙发？";
            flagLable.textColor = [UIColor colorFromHex:@"#C2C2C2"];
            flagLable.textAlignment = NSTextAlignmentCenter;
            [flagView addSubview:flagLable];
            
            return headerView;
            
           
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.communityDetailCellHeight;
    }else{
        return self.CommunityCommentCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }else{
        return 54.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000000000000001f;
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
