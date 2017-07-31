//
//  BaseObject.m
//  JZB
//
//  Created by wodada on 2017/4/19.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "BaseObject.h"

@implementation BaseObject

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"%@类缺少%@属性",NSStringFromClass([self class]),key);
}

@end
