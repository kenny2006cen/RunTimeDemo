//
//  NSMutableDictionary+NullSafeDic.m
//  test
//
//  Created by jianglincen on 16/2/18.
//  Copyright (c) 2016年 jianglincen. All rights reserved.
//

#import "NSMutableDictionary+NullSafeDic.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (NullSafeDic)

+ (void)swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getClassMethod(class, otherSelector);
    Method originMehtod = class_getClassMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}

+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}

+(void)load
{
    [self swizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM")  originSelector:@selector(objectForKey:) otherSelector:@selector(gy_objectForKey:)];
    
    [self swizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM") originSelector:@selector(setObject:forKey:) otherSelector:@selector(gy_setObject:forKey:)];
    
}

-(id)gy_objectForKey:(NSString*)key{
    
    if ([[self gy_objectForKey:key]isKindOfClass:[NSNull class]]) {
        //
        NSLog(@"dic.value is null or nil");
        return @"";
    }
    return [self gy_objectForKey:key];
}

-(void)gy_setObject:(id)value forKey:(NSString*)key{
    
    if (value==nil||[value isKindOfClass:[NSNull class]]) {
        //
        NSLog(@"dic set value is null or nil");
        
        [self gy_setObject:@"" forKey:key];
    }
    else{
        [self gy_setObject:value forKey:key];
        
    }
}

@end
