//
//  KYPhotoGallery.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//



#import "KYPhotoGallery.h"
#import "Macro.h"
#import "PhotoGalleryScrollView.h"

#import "UCZProgressView.h"
#import "UIImageView+WebCache.h"

#import "SaveImageAlertView.h"

@interface KYPhotoGallery ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIImageView *fromImageView;
@property(nonatomic,strong)UIVisualEffectView *blurView;
@property(nonatomic,strong)PhotoGalleryScrollView *photosGalleryScroll;
@property(nonatomic,strong)UIImageView *animatedImageView;
@property(nonatomic,assign)CGRect initialImageViewFrame;
@property(nonatomic,assign)CGRect finalImageViewFrame;
@property(nonatomic,assign)NSInteger initialPageIndex;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)SaveImageAlertView *alertView;

@property(nonatomic,copy)void (^finishAsynDownloadBlock)(void);
@property(nonatomic,strong)NSMutableArray *imagesUrls;

#pragma mark -- Private method
-(void)loadingImage:(UIImageView *)needLoadingImageView withURL:(NSString *)url shouldCompleted:(BOOL)flag;
-(void)panGestureRecognized:(UIPanGestureRecognizer *)pan;

@end

@implementation KYPhotoGallery{
    
    UIImage *fromVCSnapShot;
    
    // iOS 7
    UIViewController *_applicationTopViewController;
    int _previousModalPresentationStyle;
    
    NSMutableArray *indexs;
}

#pragma mark -- Initial method

-(id)initWithTappedImageView:(UIImageView *)tappedImageView andImageUrls:(NSMutableArray *)imagesUrls andInitialIndex:(NSInteger )currentIndex {
    
    self = [super init];
    if (self) {
        
        self.imagesUrls = imagesUrls;
        self.fromImageView = tappedImageView;
        self.initialPageIndex = currentIndex;
        
        [self loadingImage:tappedImageView withURL:_imagesUrls[currentIndex-1] shouldCompleted:YES];
        
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            
            self.modalPresentationStyle = UIModalPresentationCustom;
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.modalPresentationCapturesStatusBarAppearance = YES;
            
        }else{
            
            _applicationTopViewController = [self topviewController];
            _previousModalPresentationStyle = _applicationTopViewController.modalPresentationStyle;
            _applicationTopViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
        }
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
    }
    return self;
}


#pragma mark -- Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //initial
    self.fromImageView.hidden = YES;
    //    fromVCSnapShot = [self screenshot];
    self.view.backgroundColor = [UIColor clearColor];
    float scaleFactor = self.fromImageView.image.size.width / SCREENWIDTH;
    
    self.initialImageViewFrame = [self.fromImageView.superview convertRect:self.fromImageView.frame toView:nil];
    
    self.finalImageViewFrame = CGRectMake(0, (SCREENHEIGHT/2)-((self.fromImageView.image.size.height / scaleFactor)/2), SCREENWIDTH, self.fromImageView.image.size.height / scaleFactor);
    
    
    //模糊图层
    self.blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.blurView.frame = self.view.frame;
    self.blurView.alpha = 0.0f;
    [self.view addSubview:self.blurView];
    
    
    
    //图片滚动视图
    _photosGalleryScroll = [[PhotoGalleryScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+PHOTOS_SPACING, self.view.frame.size.height) imageViews:self.imageViewArray initialPageIndex:self.initialPageIndex withPhotoGallery:self];
    [self.view addSubview:_photosGalleryScroll];
    _photosGalleryScroll.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showSaveImageAlertView:)];
    [_photosGalleryScroll addGestureRecognizer:longPress];
    
    indexs = [NSMutableArray array];
    [indexs addObject:[NSNumber numberWithInteger:self.initialPageIndex-1]];
    
    //动画视图
    self.animatedImageView = [[UIImageView alloc]initWithImage:self.fromImageView.image];
    self.animatedImageView.frame = self.initialImageViewFrame;
    self.animatedImageView.clipsToBounds = YES;
    self.animatedImageView.layer.cornerRadius = 8.0f;
    self.animatedImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.animatedImageView belowSubview:self.photosGalleryScroll];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.view addGestureRecognizer:pan];
    
    
    [UIView animateWithDuration:ANIMATEDURATION delay:0.0 usingSpringWithDamping:ANIMATEDAMPING initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.blurView.alpha = 1.0f;
        self.animatedImageView.frame = self.finalImageViewFrame;
        
    } completion:^(BOOL finished) {
        
        self.photosGalleryScroll.hidden = NO;
        self.animatedImageView.hidden   = YES;
    }];
    
    
    [self.photosGalleryScroll DidScrollBlock:^(NSInteger currentIndex) {
        self.currentIndex = currentIndex;
        UIImageView *parentImageView = (UIImageView *)self.imageViewArray[self.currentIndex];
        self.animatedImageView.image = parentImageView.image;
        
        self.fromImageView.hidden = NO;
        self.fromImageView = (UIImageView *)self.imageViewArray[currentIndex];
        self.fromImageView.hidden = YES;
        self.initialImageViewFrame = [self.fromImageView.superview convertRect:self.fromImageView.frame toView:nil];
        NSLog(@"currentIndex:%ld",(long)currentIndex);
    }];
    
    
    [self.photosGalleryScroll DidEndDecelerateBlock:^(NSInteger currentIndex) {
        
        self.currentIndex = currentIndex;
        UIImageView *photoInScrollView = (UIImageView *)self.photosGalleryScroll.photos[currentIndex];
        
        if (![indexs containsObject:[NSNumber numberWithInteger:currentIndex]]) {
            [indexs addObject:[NSNumber numberWithInteger:currentIndex]];
            [self loadingImage:photoInScrollView withURL:self.imagesUrls[currentIndex] shouldCompleted:NO];
            
        }
    }];
    
}

- (void)showSaveImageAlertView:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        SaveImageAlertView *alertView = [[SaveImageAlertView alloc]initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, 49 * 2) andAboveView:self.view];
        
        [alertView setAlertViewBlock:^{
            [self saveImage];
        }];
        
        [UIView animateWithDuration:0.25f animations:^{
            alertView.frame = CGRectMake(0, Screen_Height - 49 * 2, Screen_Width, 49 * 2);
        } completion:^(BOOL finished) {
        }];
        
        [self.view addSubview:alertView];
        [alertView addAlertView];
        self.alertView = alertView;
        
    }

}

#pragma mark -Action
- (void)saveImage
{
    [self.alertView disappear];
    UIImageView *photoInScrollView = (UIImageView *)self.photosGalleryScroll.photos[self.currentIndex];
    UIImageWriteToSavedPhotosAlbum(photoInScrollView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

#pragma Private method
-(void)loadingImage:(UIImageView *)needLoadingImageView withURL:(NSString *)url shouldCompleted:(BOOL)flag{
    
    UCZProgressView *progressView = [[UCZProgressView alloc]initWithFrame:CGRectMake(0, 0, needLoadingImageView.bounds.size.width, needLoadingImageView.bounds.size.height)];
    BOOL isInCache = [[SDImageCache sharedImageCache]diskImageExistsWithKey:url];
    
    if (!isInCache) {
        
        [needLoadingImageView addSubview:progressView];
        progressView.indeterminate = YES;
        progressView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        progressView.usesVibrancyEffect = NO;
        progressView.showsText = YES;
        progressView.lineWidth = 1.0f;
        progressView.radius = 20.0f;
        progressView.textSize = 12.0f;
    }
    
    
    
    [needLoadingImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        progressView.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        progressView.progress = 1.0f;
        [progressView progressAnimiationDidStop:^{
            if (flag && image) {
                
                self.finishAsynDownloadBlock();
                
            }else if (!flag && image){
                
                UIImageView *parentImageView = (UIImageView *)self.imageViewArray[self.currentIndex];
                parentImageView.image = needLoadingImageView.image;
                self.animatedImageView.image = parentImageView.image;
            }
        }];
        
    }];
}

- (void)currentAnimatedImageView:(UIImageView *)needLoadingImageView withURL:(NSString *)url
{
    [needLoadingImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImageView *parentImageView = (UIImageView *)self.imageViewArray[self.currentIndex];
        parentImageView.image = needLoadingImageView.image;
        self.animatedImageView.image = parentImageView.image;
    }];
}


-(void)panGestureRecognized:(UIPanGestureRecognizer *)pan{
    
    static CGPoint initialPoint;
    CGFloat factorOfAngle = 0.0f;
    CGFloat factorOfScale = 0.0f;
    CGPoint transition = [pan translationInView:self.view];
    PhotoGalleryImageView *currentPhoto = (PhotoGalleryImageView *)[self.photosGalleryScroll currentPhoto];
    UIScrollView *scroll = (UIScrollView *)currentPhoto.superview;
    
    if (scroll.zoomScale != scroll.minimumZoomScale || currentPhoto.bounds.size.height > SCREENHEIGHT) {
        return;
    }
    
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        NSLog(@"currentIndex:%ld",(long)self.photosGalleryScroll.currentIndex);
        initialPoint = currentPhoto.center;
        
        
    }else if(pan.state == UIGestureRecognizerStateChanged){
        
        
        
        currentPhoto.center = CGPointMake(initialPoint.x,initialPoint.y + transition.y);
        self.animatedImageView.center = CGPointMake(self.animatedImageView.center.x, currentPhoto.center.y);
        
        CGFloat Y =MIN(SCROLLDISTANCE,MAX(0,ABS(transition.y)));
        
        //一个开口向下,顶点(SCROLLDISTANCE/2,1),过(0,0),(SCROLLDISTANCE,0)的二次函数
        factorOfAngle = MAX(0,-4/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-SCROLLDISTANCE));
        //一个开口向下,顶点(SCROLLDISTANCE,1),过(0,0),(2*SCROLLDISTANCE,0)的二次函数
        factorOfScale = MAX(0,-1/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-2*SCROLLDISTANCE));
        
        CATransform3D t = CATransform3DIdentity;
        t.m34  = 1.0/-1000;
        t = CATransform3DRotate(t,factorOfAngle*(M_PI/5), transition.y>0?-1:1, 0, 0);
        t = CATransform3DScale(t, 1-factorOfScale*0.2, 1-factorOfScale*0.2, 0);
        
        currentPhoto.layer.transform = t;
        self.animatedImageView.layer.transform = t;
        
        self.blurView.alpha = 1 - Y / SCROLLDISTANCE;
        
    }else if ((pan.state == UIGestureRecognizerStateEnded) || (pan.state ==UIGestureRecognizerStateCancelled)){
        
        if (ABS(transition.y) > 100) {
            
            [self dismissPhotoGalleryAnimated:YES ];
            
        }else{
            
            self.animatedImageView.center = CGPointMake(self.animatedImageView.center.x,initialPoint.y);
            self.animatedImageView.layer.transform = CATransform3DIdentity;
            [UIView animateWithDuration:ANIMATEDURATION delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                currentPhoto.layer.transform = CATransform3DIdentity;
                currentPhoto.center = initialPoint;
                self.blurView.alpha = 1.0f;
            } completion:nil];
            
        }
        
    }
    
}


#pragma mark -- dealloc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    _fromImageView = nil;
    _blurView = nil;
    _photosGalleryScroll = nil;
    _animatedImageView = nil;
    _imageViewArray = nil;
    fromVCSnapShot = nil;
    _applicationTopViewController = nil;
    
}


#pragma mark -- Public method

-(void)finishAsynDownload:(void(^)(void))finishAsynDownloadBlock{
    self.finishAsynDownloadBlock = finishAsynDownloadBlock;
    
}


-(void)dismissPhotoGalleryAnimated:(BOOL)animated{
    
    @autoreleasepool {
        for (UIImageView *igv in self.imageViewArray) {
            if (![igv isEqual:self.fromImageView]) {
                igv.hidden = NO;
            }
        }
    }
    
    self.animatedImageView.hidden   = NO;
    self.animatedImageView.layer.cornerRadius = 0.0f;
    self.photosGalleryScroll.hidden = YES;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [UIView animateWithDuration:ANIMATEDURATION delay:0.0f usingSpringWithDamping:ANIMATEDAMPING initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.blurView.alpha = 0.0f;
        self.animatedImageView.frame = self.initialImageViewFrame;
        self.animatedImageView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
        self.animatedImageView.hidden = YES;
        self.fromImageView.hidden = NO;
        [self dismissViewControllerAnimated:animated completion:^{
            
            if (SYSTEM_VERSION_LESS_THAN(@"8.0")){
                _applicationTopViewController.modalPresentationStyle = _previousModalPresentationStyle;
            }
        }];
        
    }];
    
}





#pragma Helper method
- (UIViewController *)topviewController
{
    UIViewController *topviewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topviewController.presentedViewController) {
        topviewController = topviewController.presentedViewController;
    }
    
    return topviewController;
}

//Snapshot
- (UIImage *)screenshot
{
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}






@end
