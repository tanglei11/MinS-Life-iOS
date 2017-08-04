//
//  POIPhotosView.m
//  CityGuide
//
//  Created by Chris on 16/7/19.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import "PhotosView.h"
#import "KYPhotoGallery.h"

#define PhotoW  105
#define PhotoH  140
#define PhotoMargin (Screen_Width - 3 * PhotoW - 2 * 22) / 2
#define PhotoMaxCol 3



@interface PhotosView ()

@property (nonatomic,strong) NSMutableArray *photoViewArray;
@property (nonatomic,strong) KYPhotoGallery *photoGallery;

@end

@implementation PhotosView
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
        photoView.layer.cornerRadius = 4;
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
