//
//  CommunityMapController.m
//  MinsLfie
//
//  Created by wodada on 2017/8/15.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "CommunityMapController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "DSNAnnotation.h"
#import "WGS84TOGCJ02.h"
#import "ToolButton.h"
#import "MapsManager.h"

@interface CommunityMapController () <BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, strong) UIView *leftSwipeView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) BMKLocationService *locService;

@end

@implementation CommunityMapController
//懒加载
- (BMKMapView *)BMKMapView
{
    if (!_BMKMapView) {
        _BMKMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 49)];
        _BMKMapView.delegate = self;
        //给map添加Annotation
        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([self.dynamicsObject.latitude floatValue], [self.dynamicsObject.longitude floatValue]);
        if ([WGS84TOGCJ02 isLocationOutOfChina:coordinate2D]) {
            coordinate2D = [WGS84TOGCJ02 wgs84ToBd09:coordinate2D];
        }else{
            coordinate2D = [WGS84TOGCJ02 gcj02ToBd09:coordinate2D];
        }
        NSLog(@"latitude = %f longitude = %f",[self.dynamicsObject.latitude floatValue],[self.dynamicsObject.longitude floatValue]);
        BMKCoordinateSpan span = {0.0067, 0.0067};
        BMKCoordinateRegion region = {coordinate2D,span};
        [_BMKMapView setRegion:region];
        DSNAnnotation *annotation = [[DSNAnnotation alloc] initWithCoordinate2D:coordinate2D title:self.dynamicsObject.addressName subTitle:self.dynamicsObject.address];
        // 地图大头针类 必须遵守MKAnnotation协议
        [_BMKMapView addAnnotation:annotation];
        [_BMKMapView selectAnnotation:annotation animated:NO];
    }
    return _BMKMapView;
}

- (UIView *)leftSwipeView
{
    if (!_leftSwipeView) {
        _leftSwipeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 60, Screen_Height - 64)];
    }
    return _leftSwipeView;
}

- (UIView *)toolView
{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 49, Screen_Width, 49)];
        _toolView.backgroundColor = [UIColor whiteColor];
        
        //头部线
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, LINE_HEIGHT)];
        topLine.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
        [_toolView addSubview:topLine];
        
        NSArray *iconArray = @[@"&#xe656;",@"&#xe60e;",@"&#xe773;"];
        NSArray *titleArray = @[@"我的位置",@"商家位置",@"导航"];
        //按钮群
        CGFloat btnW = Screen_Width / 3;
        CGFloat btnH = _toolView.height;
        CGFloat btnY = 0;
        for (int i = 0; i < 3; i++) {
            ToolButton *button = [[ToolButton alloc] initWithFrame:CGRectMake(btnW * i, btnY, btnW, btnH)];
            button.tag = i;
            [button setImage:[ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:iconArray[i]] inFont:ICONFONT size:18 color:[UIColor colorFromHex:MAIN_COLOR]] forState:UIControlStateNormal];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorFromHex:MAIN_COLOR] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(toolClick:) forControlEvents:UIControlEventTouchUpInside];
            [_toolView addSubview:button];
        }
    }
    return _toolView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.BMKMapView];
    
    // 加一个view 取消了地图的左边滑动
    [self.view addSubview:self.leftSwipeView];
    
    [self.view addSubview:self.toolView];
    
    [self initNav];
}

- (void)initNav
{
    [self setupCustomNavigationBarClear];
    [self setupCustomWhiteBackButtonWithMask];
}

- (void)toolClick:(ToolButton *)button
{
    switch (button.tag) {
            case 0:
        {
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate = self;
            //启动LocationService
            [_locService startUserLocationService];
            self.BMKMapView.showsUserLocation = YES;//显示定位图层
            self.BMKMapView.userTrackingMode = MKUserTrackingModeFollow;
        }
            break;
            case 1:
        {
            [_locService stopUserLocationService];
            self.BMKMapView.showsUserLocation = NO;
            CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([self.dynamicsObject.latitude floatValue], [self.dynamicsObject.longitude floatValue]);
            if ([WGS84TOGCJ02 isLocationOutOfChina:coordinate2D]) {
                coordinate2D = [WGS84TOGCJ02 wgs84ToBd09:coordinate2D];
            }else{
                coordinate2D = [WGS84TOGCJ02 gcj02ToBd09:coordinate2D];
            }
            BMKCoordinateSpan span = {0.0067, 0.0067};
            BMKCoordinateRegion region = {coordinate2D,span};
            [self.BMKMapView setRegion:region];
        }
            break;
            case 2:
        {
            if ([MapsManager isBaiduMapsInstalled]) {
                [[MapsManager getBaiduMapsManager] openMapsWithDirectionForDestinationAddress:self.dynamicsObject.addressName];
            }else if ([MapsManager isGoogleMapsInstalled]){
                [[MapsManager getGoogleMapsManager] openMapsWithDirectionForDestinationAddress:self.dynamicsObject.addressName];
            }else{
                [[MapsManager getAppleMapsManager]openMapsWithDirectionForDestinationAddress:self.dynamicsObject.addressName];
            }
        }
            break;
        default:
            break;
    }
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"当前位置%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.BMKMapView updateLocationData:userLocation];
    
    self.BMKMapView.centerCoordinate = userLocation.location.coordinate;
    
    CLLocationCoordinate2D loc = [userLocation.location coordinate];
    
    //放大地图到自身的经纬度位置。
    BMKCoordinateSpan span = {0.0067, 0.0067};
    BMKCoordinateRegion region = {loc,span};
    
    BMKCoordinateRegion adjustedRegion = [self.BMKMapView regionThatFits:region];
    [self.BMKMapView setRegion:adjustedRegion animated:YES];
}

#pragma mark -MKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKUserLocation class]]) {
        return nil;
    }
    //自定义的大头针
    BMKAnnotationView * view = [(BMKMapView *)mapView dequeueReusableAnnotationViewWithIdentifier:@"DSNAnnotation"];
    if (!view) {
        view = [[BMKAnnotationView alloc]initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:@"Annotation"];
    }
    view.width = 32;
    view.height = 32;
    
    //设置大头针的能点击和图片
    view.canShowCallout = YES;
    UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
    bgView.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
    bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    bgView.layer.borderWidth = 2;
    bgView.layer.cornerRadius = 16;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.width - 18) / 2, (bgView.height - 18) / 2, 18, 18)];
    iconView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:@"&#xe69d;"] inFont:ICONFONT size:18 color:[UIColor whiteColor]];
    [bgView addSubview:iconView];
    [view addSubview:bgView];
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
