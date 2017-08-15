//
//  Constants.h
//  MinsLfie
//
//  Created by wodada on 2017/7/28.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define IPHONE_6_PLUS_WIDTH_IN_PIXELS          1242
#define IPHONE_6_PLUS_HEIGHT_IN_PIXELS         2208
#define IS_DEVICE_3_5_INCH ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE
#define IS_DEVICE_4_0_INCH ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define IS_DEVICE_4_7_INCH ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define IS_DEVICE_5_5_INCH ([[UIScreen mainScreen] bounds].size.height == 736)?TRUE:FALSE
#define DEVICE_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// Navigation Controller
#define STATUS_BAR_HEIGHT                      (([UIApplication sharedApplication].statusBarFrame.size.height == 0) ? 20 : [UIApplication sharedApplication].statusBarFrame.size.height)
#define NAVIGATION_BAR_HEIGHT                  self.navigationController.navigationBar.frame.size.height
#define TOOLBAR_HEIGHT                         self.navigationController.toolbar.frame.size.height
#define TAB_BAR_HEIGHT                         self.tabBarController.tabBar.frame.size.height
#define STATIC_NAVIGATION_BAR_HEIGHT           44.0f
#define STATIC_TOOLBAR_HEIGHT                  44.0f
#define STATUS_AND_NAVIGATION_BAR_HEIGHT        (STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT)
#define STATIC_STATUS_AND_NAVIGATION_BAR_HEIGHT (STATUS_BAR_HEIGHT + STATIC_NAVIGATION_BAR_HEIGHT)

//百度地图
#define BAIDU_MAP_KEY           @"yWoNDQohry8mVZWg4mrFutewKj1aWHdg"

// NormalCell
#define LISTCELL_PICTURE_WIDTH                                                (171.0f)
#define LISTCELL_PICTURE_HEIGHT                                               (115.0f)
#define LISTCELL_HEIGHT                                                             (137.0f)

// 屏幕适配  长宽比例
#define WIDTH_SCALE Screen_Width / 375
#define HEIGHT_SCALE Screen_Height / 667

//line
#define LINE_HEIGHT 0.5

// FontName
#define FONT_THIN                                           @"HelveticaNeue-Thin"
#define NORMAL_FONT                                     @"Helvetica"

/* color  颜色  */
#define TABLE_BACK_COLOR                                                    @"#F5F7FB"
#define WHITE_GREY                                                          @"#F0F0F1"
#define MAIN_COLOR                                                          @"#4A505A"
#define PLACE_HOLDER_COLOR                                                  @"#C0C0C0"
#define NORMAL_BG_COLOR                                                     @"#F6654E"

//FONT
#define ICONFONT @"iconfont"

//UserDefault
#define DYNAMIC_FLAG_IS_READ_USER_DEFAULT                                   @"dynamicIsRead"

//常用图标
// 从我的位置导航
#define ICON_GUIDE_TO_HERE  [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe773;"]  inFont:ICONFONT size:22 color:[UIColor colorFromHex:@"#FFFFFF"]];

#define BLANK_PICTURE_SIZE_66  [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe648;"]  inFont:ICONFONT size:66 color:[UIColor colorFromHex:@"#D2D2D2"]]

#define BLANK_PICTURE_SIZE_44 [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe648;"]  inFont:ICONFONT size:44 color:[UIColor colorFromHex:@"#D2D2D2"]]

#define BLACK_RETURN [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe679;"]  inFont:ICONFONT size:22 color:[UIColor colorFromHex:MAIN_COLOR]];
// 返回按钮
#define WHITE_RETURN [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe679;"]  inFont:ICONFONT size:22 color:[UIColor whiteColor]]
// 返回  X
#define BACK  [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe6dc;"]  inFont:ICONFONT size:22 color:[UIColor colorFromHex:MAIN_COLOR]]

#endif /* Constants_h */
