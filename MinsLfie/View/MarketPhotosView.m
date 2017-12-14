//
//  MarketPhotosView.m
//  MinsLfie
//
//  Created by Peanut丶 on 2017/12/14.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "MarketPhotosView.h"
#import "KYPhotoGallery.h"

#define PhotoMargin 15
#define PhotoW  (Screen_Width - 2 * 20 - 2 * PhotoMargin) / 3
#define PhotoH  (Screen_Width - 2 * 20 - 2 * PhotoMargin) / 3
#define PhotoMaxCol 3

@interface MarketPhotosView ()

@property (nonatomic,strong) NSMutableArray *photoViewArray;
@property (nonatomic,strong) KYPhotoGallery *photoGallery;

@end

@implementation MarketPhotosView

//懒加载
- (NSMutableArray *)photoViewArray
{
    if (_photoViewArray == nil) {
        self.photoViewArray = [NSMutableArray array];
    }
    return _photoViewArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    //创建足够数量的图片控件
    while (self.subviews.count < photos.count) {
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.layer.masksToBounds = YES;
        photoView.clipsToBounds = YES;
        photoView.userInteractionEnabled = YES;
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:photoView];
        [self.photoViewArray addObject:photoView];
    }
    
    //遍历所有的图片控件,设置图片
    for (int i = 0; i < self.subviews.count; i++) {
        UIImageView *photoView = self.subviews[i];
        photoView.tag = i + 1;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        singleTap.numberOfTapsRequired = 1;
        [photoView addGestureRecognizer:singleTap];
        if (i < photos.count) {
            photoView.hidden = NO;
            int thumbnailWidth = PhotoW;
            int thumbnailHeight = PhotoH;
            
            
            thumbnailWidth *= 3;
            thumbnailHeight *= 3;
            AVFile *avFile = [AVFile fileWithURL:(NSString *)photos[i]];
            [avFile getThumbnail:YES width:thumbnailWidth height:thumbnailHeight withBlock:^(UIImage *image, NSError *error) {
                if (error) {
                    photoView.contentMode = UIViewContentModeCenter;
                    photoView.image = BLANK_PICTURE_SIZE_44;
                    photoView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
                }
                else {
                    //normalCell.imagView.contentMode = UIViewContentModeScaleAspectFill;
                    photoView.contentMode = UIViewContentModeScaleAspectFill;
                    photoView.image = image;
                }
            }];
        }else{
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < self.photos.count; i++) {
        UIImageView *photoView = self.subviews[i];
        photoView.x = (i % PhotoMaxCol) * (PhotoW + PhotoMargin);
        photoView.y = (i / PhotoMaxCol) * (PhotoH + PhotoMargin);
        photoView.width = PhotoW;
        photoView.height = PhotoH;
        
    }
}

+ (CGSize)SizeWithCount:(int)count
{
    //列数
    int cols = count >= PhotoMaxCol ? PhotoMaxCol : count ;
    CGFloat photosW = PhotoW * cols + PhotoMargin * (cols - 1);
    //行数
    int rows = count / PhotoMaxCol;
    if (count % PhotoMaxCol != 0) {
        rows = count / PhotoMaxCol + 1;
    }
    CGFloat photosH = PhotoH * rows + PhotoMargin * (rows - 1);
    return CGSizeMake(photosW, photosH);
}
- (void)tapClick:(UITapGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    
    NSMutableArray *arrayModels = [NSMutableArray array];
    for (int i = 0; i < self.photos.count; i++) {
        [arrayModels addObject:(NSString *)self.photos[i]];
    }
    
    _photoGallery = [[KYPhotoGallery alloc]initWithTappedImageView:imageView andImageUrls:arrayModels andInitialIndex:imageView.tag];
    _photoGallery.imageViewArray = self.photoViewArray;
    [_photoGallery finishAsynDownload:^{
        [[self viewController] presentViewController:_photoGallery animated:NO completion:nil];
    }];
    
}

@end
