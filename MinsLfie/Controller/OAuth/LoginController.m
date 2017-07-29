//
//  LoginController.m
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "LoginController.h"
#import "UIImage+FEBoxBlur.h"

#define LOGIN_TYPE_TAG  1000

@interface LoginController () <UIScrollViewDelegate>

@property (nonatomic)BOOL statusBarStyleControl;
@property (nonatomic,assign) NSInteger cuttentIndex;
@property (nonatomic,weak) UIImageView *topBgView;
@property (nonatomic,weak) UIImageView *flagView;
@property (nonatomic,weak) UIButton *submitButton;
@property (nonatomic,weak) UIButton *forgetButton;
@property (nonatomic,weak) UITextField *passField;
@property (nonatomic,weak) UIView *phoneView;
@property (nonatomic,weak) UIView *passView;
@property (nonatomic,weak) UIView *codeView;
@property (nonatomic,weak) UIView *lineSView;
@property (nonatomic,weak) UIView *containerView;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNav];
    
    [self initContentView];
}

- (void)initNav
{
    [self setupCustomNavigationBarClear];
}

- (void)initContentView
{
    UIImageView *topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 170)];
    topBgView.userInteractionEnabled = YES;
    topBgView.clipsToBounds = YES;
    topBgView.contentMode = UIViewContentModeScaleAspectFill;
    topBgView.image = [UIImage boxblurImage:[UIImage imageNamed:@"top_bg"] withBlurNumber:0.2];
    [self.view addSubview:topBgView];
    self.topBgView = topBgView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, Screen_Width, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"MINS  LIFE";
    [topBgView addSubview:titleLabel];
    
    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(topBgView.width * 0.25 - 8, topBgView.height - 10, 16, 16)];
    flagView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe79c;"] inFont:ICONFONT size:16 color:[UIColor whiteColor]];
    [topBgView addSubview:flagView];
    self.flagView = flagView;
    
    NSArray *titleArray = @[@"登录",@"注册"];
    CGFloat btnW = topBgView.width / 2;
    CGFloat btnH = 44.0f;
    CGFloat btnY = flagView.y - 5 - btnH;
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * btnW, btnY, btnW, btnH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = LOGIN_TYPE_TAG + i;
        [button addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [topBgView addSubview:button];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(btnW - LINE_HEIGHT * 0.5, btnY + (btnH - 18) / 2, LINE_HEIGHT, 18)];
    lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [topBgView addSubview:lineView];
    
    //随便逛逛
    UIButton *goButtom = [[UIButton alloc] initWithFrame:CGRectMake(topBgView.width - 68 - 20, 44, 68, 16)];
    [goButtom setTitle:@"随便逛逛" forState:UIControlStateNormal];
    [goButtom setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    goButtom.titleLabel.font = [UIFont systemFontOfSize:16];
    [goButtom addTarget:self action:@selector(goClick) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:goButtom];
    
    //scroll
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topBgView.frame), Screen_Width, Screen_Height - topBgView.height - 120)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [scrollView addGestureRecognizer:tap];
    scrollView.delegate = self;
    scrollView.contentSize =  CGSizeMake(Screen_Width, Screen_Height - topBgView.height - 119.5);
    [self.view addSubview:scrollView];
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 56)];
    [scrollView addSubview:phoneView];
    self.phoneView = phoneView;
    
    UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(20, (phoneView.height - 30) / 2, phoneView.width - 2 * 20, 30)];
    phoneField.placeholder = @"手机号";
    phoneField.font = [UIFont systemFontOfSize:15];
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneField.keyboardType = UIKeyboardTypePhonePad;
    [phoneView addSubview:phoneField];
    
    UIView *lineFView = [[UIView alloc] initWithFrame:CGRectMake(20, phoneView.height - 1, phoneView.width - 2, 1)];
    lineFView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
    [phoneView addSubview:lineFView];
    
    //验证码
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneView.frame), Screen_Width, 56)];
    codeView.hidden = YES;
    [scrollView addSubview:codeView];
    self.codeView = codeView;
    
    UIButton *codeButton = [[UIButton alloc] initWithFrame:CGRectMake(codeView.width - 20 - 78, (codeView.height - 15) / 2, 78, 15)];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor colorFromHex:@"#FF4735"] forState:UIControlStateNormal];
    [codeView addSubview:codeButton];
    
    UITextField *codeFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, (codeView.height - 30) / 2, codeButton.x - 2 * 20, 30)];
    codeFiled.placeholder = @"验证码";
    codeFiled.font = [UIFont systemFontOfSize:15];
    codeFiled.keyboardType = UIKeyboardTypeNumberPad;
    codeFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [codeView addSubview:codeFiled];
    
    UIView *lineTView = [[UIView alloc] initWithFrame:CGRectMake(20, codeView.height - 1, codeView.width - 2 * 20, 1)];
    lineTView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
    [codeView addSubview:lineTView];
    
    UIView *containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    self.containerView = containerView;
    
    UIView *passView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 56)];
    [containerView addSubview:passView];
    self.passView = passView;
    
    UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(passView.width - 20 - 70, (passView.height - 15) / 2, 70, 15)];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor colorFromHex:PLACE_HOLDER_COLOR] forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [passView addSubview:forgetButton];
    self.forgetButton = forgetButton;
    
    UITextField *passField = [[UITextField alloc] initWithFrame:CGRectMake(20, (passView.height - 30) / 2, forgetButton.x - 2 * 20, 30)];
    passField.placeholder = @"密码";
    passField.font = [UIFont systemFontOfSize:15];
    passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passField.keyboardType = UIKeyboardTypeASCIICapable;
    [passView addSubview:passField];
    self.passField = passField;
    
    UIView *lineSView = [[UIView alloc] initWithFrame:CGRectMake(20, passView.height - 1, passView.width - 20, 1)];
    lineSView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
    [passView addSubview:lineSView];
    self.lineSView = lineSView;
    
    //登录or注册按钮
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(passView.frame) + 20, Screen_Width - 2 * 28, 50)];
    [submitButton setTitle:@"登录" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    submitButton.backgroundColor = [UIColor blackColor];
    submitButton.layer.cornerRadius = 25;
    [containerView addSubview:submitButton];
    self.submitButton = submitButton;
    
    containerView.frame = CGRectMake(0, CGRectGetMaxY(phoneView.frame), Screen_Width, CGRectGetMaxY(submitButton.frame));
    
    //底部按钮群
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 120, Screen_Width, 120)];
    [self.view addSubview:bottomView];
    
    UILabel *guideLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 14)];
    guideLabel.text = @"使用其他账号登录";
    guideLabel.textColor = [UIColor colorFromHex:@"#939393"];
    guideLabel.font = [UIFont systemFontOfSize:14];
    guideLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:guideLabel];
    
    NSArray *iconArray = @[@"&#xe620;",@"&#xe635;",@"&#xe624;"];
    NSArray *colorArray = @[@"#00D570",@"#FD0000",@"#4296FF"];
    CGFloat thiBtnW = 60;
    CGFloat thiBtnH = 60;
    CGFloat thiBtnY = CGRectGetMaxY(guideLabel.frame) + 15;
    CGFloat margin = (bottomView.width - iconArray.count * thiBtnW) / (iconArray.count + 1);
    for (int i = 0; i < iconArray.count; i++) {
        UIButton *thirdButton = [[UIButton alloc] initWithFrame:CGRectMake(margin + (margin + thiBtnW) * i, thiBtnY, thiBtnW, thiBtnH)];
        [thirdButton setImage:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:iconArray[i]] inFont:ICONFONT size:22 color:[UIColor colorFromHex:colorArray[i]]] forState:UIControlStateNormal];
        thirdButton.layer.cornerRadius = 30;
        thirdButton.layer.borderColor = [[UIColor colorFromHex:WHITE_GREY] CGColor];
        thirdButton.layer.borderWidth = 1;
        [bottomView addSubview:thirdButton];
    }
}

- (void)changeClick:(UIButton *)button
{
    NSInteger index = button.tag - LOGIN_TYPE_TAG;
    if (index == self.cuttentIndex) return;
    if (index == 1) {
        self.flagView.x = self.topBgView.width * 0.75 - 8;
        [self.submitButton setTitle:@"注册" forState:UIControlStateNormal];
        self.forgetButton.hidden = YES;
        self.passField.width = self.passView.width - 2 * 20;
        self.lineSView.frame = CGRectMake(0, self.passView.height - 1, self.passView.width, 1);
        self.codeView.hidden = NO;
        self.containerView.y = CGRectGetMaxY(self.codeView.frame);
    }else{
        self.flagView.x = self.topBgView.width * 0.25 - 8;
        [self.submitButton setTitle:@"登录" forState:UIControlStateNormal];
        self.forgetButton.hidden = NO;
        self.passField.width = self.forgetButton.x - 2 * 20;
        self.lineSView.frame = CGRectMake(20, self.passView.height - 1, self.passView.width - 20, 1);
        self.codeView.hidden = YES;
        self.containerView.y = CGRectGetMaxY(self.phoneView.frame);
    }
    self.cuttentIndex = index;
}

- (void)goClick
{
    MainTabBarController *mainTabBarController = [[MainTabBarController alloc] init];
    self.view.window.rootViewController = mainTabBarController;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)hideKeyBoard
{
    [self.view endEditing:YES];
}

#ifdef __IPHONE_8_0
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.statusBarStyleControl) {
        return UIStatusBarStyleDefault;
    }
    else {
        return UIStatusBarStyleLightContent;
    }
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
