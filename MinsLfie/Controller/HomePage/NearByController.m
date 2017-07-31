//
//  NearByController.m
//  MinsLfie
//
//  Created by wodada on 2017/7/31.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "NearByController.h"
#import "DSNAnnotation.h"

#define kMenuBarHeight                               (33.0f)
#define kGuideMapButtonWidth                         (43.0f)

#define POIWH   32

@interface NearByController () <BMKMapViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) PlaceObject *selectedPlace; //点击后的Place
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic ,strong) UIScrollView *menubarView;
@property (nonatomic, strong) UIView *menuShadowView;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) NSMutableArray<UILabel *> *menuLabelArray;
@property (nonatomic, strong) UILabel *selectedLabel;

@end

@implementation NearByController
{
    CGFloat menuItemWidth;
}

#pragma mark 懒加载百度地图
- (BMKMapView *)BMKMapView
{
    if (!_BMKMapView) {
        _BMKMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, kMenuBarHeight, Screen_Width, Screen_Height - 64 - 49 - kMenuBarHeight)];
        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(24.514471, 117.645695);
        BMKCoordinateRegion region ;//表示范围的结构体
        region.center = coordinate2D;//中心点
        region.span.latitudeDelta = 0.0067;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
        region.span.longitudeDelta = 0.0067;//纬度范围
        _BMKMapView.delegate = self;
        [_BMKMapView setRegion:region animated:YES];
    }
    return _BMKMapView;
}

- (UIView *)POIView
{
    if (!_POIView) {
        _POIView = [[POIVIew alloc] initWithFrame:CGRectMake(0, Screen_Height - 49 - LISTCELL_HEIGHT, Screen_Width, LISTCELL_HEIGHT)];
        _POIView.backgroundColor = [UIColor whiteColor];
        UIView *guideView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width - 7 - kGuideMapButtonWidth, -kGuideMapButtonWidth * 0.5, kGuideMapButtonWidth, kGuideMapButtonWidth)];
        guideView.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        guideView.layer.cornerRadius = kGuideMapButtonWidth * 0.5;
        guideView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideToHere)];
        [guideView addGestureRecognizer:tap];
        
        [_POIView addSubview:guideView];
        UIImageView *guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kGuideMapButtonWidth - 22) / 2, (kGuideMapButtonWidth - 22) / 2, 22, 22)];
        guideImageView.image = ICON_GUIDE_TO_HERE;
        [guideView addSubview:guideImageView];
    }
    return _POIView;
}

- (NSArray *)menuArray
{
    if (!_menuArray) {
        NSMutableArray *menus = [@[@"校园建筑",@"美食",@"购物",@"其他"] mutableCopy];
        _menuArray = menus.copy;
    }
    return _menuArray;
}

- (NSMutableArray<UILabel *> *)menuLabelArray
{
    if (!_menuLabelArray) {
        _menuLabelArray = [NSMutableArray array];
    }
    return _menuLabelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItemWidth = (IS_DEVICE_4_0_INCH == TRUE || IS_DEVICE_3_5_INCH == TRUE)?(65.0f):(85.0f);
    
    [self.view addSubview:self.BMKMapView];
    
    // 设置返回的手势识别view
    [self setupBackGestureRecognizerView];
    [self setupMenubarView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getPlaceData];
}

- (void)getPlaceData
{
    [MSProgressHUD showHUDAddedToWindow:self.view.window];
    [AVCloud callFunctionInBackground:@"getPlaces" withParameters:nil block:^(id  _Nullable object, NSError * _Nullable error) {
        [MSProgressHUD hideHUDForWindow:self.view.window animated:YES];
        NSMutableArray *placeArray = [NSMutableArray array];
        for (NSDictionary *dict in object) {
            PlaceObject *placeObject = [[PlaceObject alloc] init];
            [placeObject setValuesForKeysWithDictionary:dict];
            //判断
            NSString *category = self.menuArray[self.tag];
            if ([category isEqualToString:@"校园建筑"]) {
                if ([placeObject.placeType isEqualToString:@"office"] || [placeObject.placeType isEqualToString:@"playground"] || [placeObject.placeType isEqualToString:@"house"] || [placeObject.placeType isEqualToString:@"bridge"] || [placeObject.placeType isEqualToString:@"doorway"]) {
                    [placeArray addObject:placeObject];
                }
            }else if ([category isEqualToString:@"美食"]){
                if ([placeObject.placeType isEqualToString:@"food"]) {
                    [placeArray addObject:placeObject];
                }
            }else if ([category isEqualToString:@"购物"]){
                if ([placeObject.placeType isEqualToString:@"shop"]) {
                    [placeArray addObject:placeObject];
                }
            }else{
                if ([placeObject.placeType isEqualToString:@"organization"]) {
                    [placeArray addObject:placeObject];
                }
            }
        }
        [self BMKmapMoveAndAddAnnotationWithAttitudeArray:placeArray];
    }];
}

- (void)setupMenubarView
{
    _menubarView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kMenuBarHeight)];
    _menubarView.backgroundColor = [UIColor whiteColor];
    _menubarView.contentSize = CGSizeMake(menuItemWidth * self.menuArray.count, kMenuBarHeight);
    _menubarView.showsHorizontalScrollIndicator = NO;
    _menubarView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.menubarView];
    
    NSInteger menuShadowViewWidth = 70;

    self.menuShadowView = [[UIView alloc] initWithFrame:CGRectMake((menuItemWidth - menuShadowViewWidth) / 2, 5.5, menuShadowViewWidth, 22)];
    self.menuShadowView.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
    self.menuShadowView.layer.cornerRadius = 8.0f;
    [self.menubarView addSubview:self.menuShadowView];
    
    _menubarView.delegate = self;
    for (int i = 0; i < self.menuArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * menuItemWidth, 0, menuItemWidth, kMenuBarHeight)];
        label.text = self.menuArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.highlightedTextColor = [UIColor whiteColor];
        label.textColor = [UIColor colorFromHex:@"#999999"];
        if (i == 0) {
            label.highlighted = YES;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemClick:)];
        [label addGestureRecognizer:tap];
        label.userInteractionEnabled = YES;
        label.tag = 10 + i;
        [_menubarView addSubview:label];
        [self.menuLabelArray addObject:label];
    }
    
    NSLog(@"%d",self.menubarView.tracking);
    NSLog(@"%d",self.menubarView.delaysContentTouches);
}

- (void)guideToHere
{
    
}

- (void)menuItemClick:(UITapGestureRecognizer *)tap
{
    for (UIView *view in self.menubarView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.highlighted = NO;
        }
    }
    UILabel *selLabel = (UILabel *)tap.view;
    [self selLabel:selLabel];
    // 点击以后判断存在POIView然后把他移除
    if (self.POIView) {
        [UIView animateWithDuration:0.25 animations:^{
            self.POIView.y = Screen_Height;
//            self.gobackMe.y = [AppConfig isSingleApp] && [AppConfig getLoginType] == LoginTypeNone ? Screen_Height - 120 : Screen_Height - 49 - 120;
        } completion:^(BOOL finished) {
            [self.POIView removeFromSuperview];
        }];
    }
    NSInteger tag = tap.view.tag - 10;
    [self setupTtileCenter:(UILabel *)tap.view];
    [UIView animateWithDuration:0.3 animations:^{
        if (tag == 0) {
            NSInteger menuShadowViewWidth = 70;
            self.menuShadowView.width = menuShadowViewWidth;
            self.menuShadowView.x = (menuItemWidth - menuShadowViewWidth) / 2;
        }
        else {
            self.menuShadowView.width = 49;
            self.menuShadowView.x = (tap.view.tag - 10) * menuItemWidth + (menuItemWidth - 49) / 2;
        }
    } completion:^(BOOL finished) {
    }];
    
    self.tag = tag;
    if (tag > 1 && tag < self.menuArray.count - 2) {
        self.menubarView.contentOffset = CGPointMake(CGRectGetMaxX(tap.view.frame) - menuItemWidth / 2 - Screen_Width / 2, 0);
    }
    // 1.先进行移除
    [self.BMKMapView removeAnnotations:self.BMKMapView.annotations];
    // 2.然后再进行添加
    [self getPlaceData];
    
}

- (void)selLabel:(UILabel *)label
{
    _selectedLabel.highlighted = NO;
    label.highlighted = YES;
    _selectedLabel = label;
}

// 设置标题居中
- (void)setupTtileCenter:(UILabel *)centerLabel
{
    CGFloat offsetX = centerLabel.center.x - Screen_Width * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.menubarView.contentSize.width - Screen_Width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.menubarView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)BMKmapMoveAndAddAnnotationWithAttitudeArray:(NSArray *)attitudeArray
{
    NSMutableArray *annotationArray = [NSMutableArray array];
    for (PlaceObject *place in attitudeArray) {
        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([place.latitude floatValue], [place.longitude floatValue]);
        DSNAnnotation *annotation = [[DSNAnnotation alloc] initWithCoordinate2D:coordinate2D title:place.name subTitle:place.address];
        [annotation setCoordinate:coordinate2D];
        annotation.place = place;
        [annotationArray addObject:annotation];
    }
    NSMutableSet *before = [NSMutableSet setWithArray:self.BMKMapView.annotations];
    NSSet *after = [NSSet setWithArray:annotationArray];
    
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.BMKMapView addAnnotations:[toAdd allObjects]];
        [self.BMKMapView removeAnnotations:[toRemove allObjects]];
        [self.BMKMapView selectAnnotation:[self.BMKMapView.annotations lastObject] animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
//            self.gobackMe.y = [AppConfig isSingleApp] && [AppConfig getLoginType] == LoginTypeNone ? Screen_Height - LISTCELL_HEIGHT - 90 - 50 : Screen_Height - 49 - LISTCELL_HEIGHT - 90 - 50;
        }];
    }];
}

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
    view.width = POIWH;
    view.height = POIWH;
    
    //设置大头针的能点击和图片
    view.canShowCallout = NO;
    UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
    bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    bgView.layer.borderWidth = 2;
    bgView.layer.cornerRadius = POIWH / 2;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.width - 18) / 2, (bgView.height - 18) / 2, 18, 18)];
    NSString *icon;
    if ([[(DSNAnnotation *)annotation place].placeType isEqualToString:@"office"]) {
        icon = @"&#xe61e;";
        bgView.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
    }
    else if ([[(DSNAnnotation *)annotation place].placeType isEqualToString:@"playground"])
    {
        icon = @"&#xe683;";
        bgView.backgroundColor = [UIColor colorFromHex:@"#82CD6B"];
    }
    else if ([[(DSNAnnotation *)annotation place].placeType isEqualToString:@"house"])
    {
        icon = @"&#xe61e;";
        bgView.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
    }
    else if ([[(DSNAnnotation *)annotation place].placeType isEqualToString:@"bridge"])
    {
        icon = @"&#xe62b;";
        bgView.backgroundColor = [UIColor colorFromHex:@"#B199E1"];
    }
    else if ([[(DSNAnnotation *)annotation place].placeType isEqualToString:@"doorway"])
    {
        icon = @"&#xe601;";
        bgView.backgroundColor = [UIColor colorFromHex:@"#9D7ECF"];
    }
    else if ([[(DSNAnnotation *)annotation place].placeType isEqualToString:@"shop"])
    {
        icon = @"&#xe603;";
        bgView.backgroundColor = [UIColor colorFromHex:@"#FF62A0"];
    }
    else if ([[(DSNAnnotation *)annotation place].placeType isEqualToString:@"food"])
    {
        icon = @"&#xe604;";
        bgView.backgroundColor = [UIColor colorFromHex:@"#F7B4AB"];
    }
    else if ([[(DSNAnnotation *)annotation place].placeType isEqualToString:@"organization"])
    {
        icon = @"&#xe619;";
        bgView.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
    }
    iconView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:icon] inFont:ICONFONT size:18 color:[UIColor whiteColor]];
    [bgView addSubview:iconView];
    [view addSubview:bgView];
    return (BMKAnnotationView *)view;
}

// 选中大头针时候触发
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if (![view isKindOfClass:NSClassFromString(@"BMKModernUserLocationView")]) {
        view.width = POIWH;
        view.height = POIWH;
        
        //设置大头针的能点击和图片
        view.canShowCallout = NO;
        UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 2;
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = POIWH / 2;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.width - 18) / 2, (bgView.height - 18) / 2, 18, 18)];
        NSString *icon;
        NSString *iconColor;
        if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"office"]) {
            icon = @"&#xe61e;";
            iconColor = NORMAL_BG_COLOR;
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"playground"])
        {
            icon = @"&#xe683;";
            iconColor = @"#82CD6B";
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"house"])
        {
            icon = @"&#xe61e;";
            iconColor = NORMAL_BG_COLOR;
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"bridge"])
        {
            icon = @"&#xe62b;";
            iconColor = @"#B199E1";
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"doorway"])
        {
            icon = @"&#xe601;";
            iconColor = @"#9D7ECF";
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"shop"])
        {
            icon = @"&#xe603;";
            iconColor = @"#FF62A0";
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"food"])
        {
            icon = @"&#xe604;";
            iconColor = @"#F7B4AB";
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"organization"])
        {
            icon = @"&#xe619;";
            iconColor = NORMAL_BG_COLOR;
        }
        iconView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:icon] inFont:ICONFONT size:18 color:[UIColor colorFromHex:iconColor]];
        [bgView addSubview:iconView];
        [view addSubview:bgView];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.POIView.y = Screen_Height;
    } completion:^(BOOL finished) {
        if (![view isKindOfClass:NSClassFromString(@"BMKModernUserLocationView")]) {
            [self.POIView removeFromSuperview];
            [self.view addSubview:self.POIView];
            [UIView animateWithDuration:0.25 animations:^{
                self.POIView.y = Screen_Height - 49 - LISTCELL_HEIGHT - 64;
            }];
        }else {
            [self.POIView removeFromSuperview];
        }
    }];
    if ([view.annotation isKindOfClass:[BMKUserLocation class]]) {
        
    }else {
        PlaceObject *place = [(DSNAnnotation *)view.annotation place];
        self.selectedPlace = place;
        _POIView.place = place;
        _POIView.descLabel.text = [NSString stringWithFormat:@"%@",place.address];
        UIImage *placeholder = BLANK_PICTURE_SIZE_44;
        [self setupImageViewByAVFileWithThumbnailWidth:_POIView.imageView.width thumbnailHeight:LISTCELL_PICTURE_HEIGHT url:(NSString *)place.bgImg imageView:_POIView.imageView placeholder:placeholder];
        UITapGestureRecognizer *tapNormalCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPOIView:)];
        [_POIView addGestureRecognizer:tapNormalCell];
    }
}

// 取消选中大头针时候触发
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if (![view isKindOfClass:NSClassFromString(@"BMKModernUserLocationView")]) {
        view.width = POIWH;
        view.height = POIWH;
        
        //设置大头针的能点击和图片
        view.canShowCallout = NO;
        UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 2;
        bgView.layer.cornerRadius = POIWH / 2;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.width - 18) / 2, (bgView.height - 18) / 2, 18, 18)];
        NSString *icon;
        if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"office"]) {
            icon = @"&#xe61e;";
            bgView.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"playground"])
        {
            icon = @"&#xe683;";
            bgView.backgroundColor = [UIColor colorFromHex:@"#82CD6B"];
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"house"])
        {
            icon = @"&#xe61e;";
            bgView.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"bridge"])
        {
            icon = @"&#xe62b;";
            bgView.backgroundColor = [UIColor colorFromHex:@"#B199E1"];
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"doorway"])
        {
            icon = @"&#xe601;";
            bgView.backgroundColor = [UIColor colorFromHex:@"#9D7ECF"];
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"shop"])
        {
            icon = @"&#xe603;";
            bgView.backgroundColor = [UIColor colorFromHex:@"#FF62A0"];
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"food"])
        {
            icon = @"&#xe604;";
            bgView.backgroundColor = [UIColor colorFromHex:@"#F7B4AB"];
        }
        else if ([[(DSNAnnotation *)view.annotation place].placeType isEqualToString:@"organization"])
        {
            icon = @"&#xe619;";
            bgView.backgroundColor = [UIColor colorFromHex:NORMAL_BG_COLOR];
        }
        iconView.image = [ToolClass imageWithIcon:[NSString changeISO88591StringToUnicodeString:icon] inFont:ICONFONT size:18 color:[UIColor whiteColor]];
        [bgView addSubview:iconView];
        [view addSubview:bgView];
    }
}

// 点击POIView
- (void)tapPOIView:(UITapGestureRecognizer *)tap
{
    
}


- (void)setupBackGestureRecognizerView
{
    // 不加任何手势的就是为了取消mapview的滑动事件
    UIView *gestureRecognizerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.BMKMapView.x, 44, self.BMKMapView.height)];
    [self.view addSubview:gestureRecognizerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
