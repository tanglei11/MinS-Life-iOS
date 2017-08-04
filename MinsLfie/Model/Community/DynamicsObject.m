//
//  DynamicsObject.m
//  MinsLfie
//
//  Created by wodada on 2017/8/4.
//  Copyright © 2017年 汤磊. All rights reserved.
//

#import "DynamicsObject.h"

@implementation DynamicsObject

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"user"]) {
        self.dynamicsUser = [[DynamicsUserObject alloc] init];
        [self.dynamicsUser setValuesForKeysWithDictionary:(NSDictionary *)value];
    }
    [super setValue:value forKey:key];
}

@end
