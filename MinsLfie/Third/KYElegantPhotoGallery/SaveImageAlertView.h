//
//  SaveImageAlertView.h
//  CityGuide
//
//  Created by 吴桐 on 16/8/23.
//  Copyright © 2016年 吴桐. All rights reserved.
//

#import "AlertView.h"

typedef void (^AlertviewSaveImageBlock)();

@interface SaveImageAlertView : AlertView

@property (nonatomic,strong)AlertviewSaveImageBlock  alertviewSaveImageBlock;

-(void)setAlertviewSaveImageBlock:(AlertviewSaveImageBlock)saveImageBlock;

@end
