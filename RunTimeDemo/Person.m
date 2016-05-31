//
//  Person.m
//  RunTimeDemo
//
//  Created by User on 16/5/31.
//  Copyright © 2016年 jlc. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Person

id wrongTypeGetter(id object, SEL sel) {
  
    return nil;
}
void wrongTypeSetter(id object, SEL sel, id value) {
   
    // do nothing
}

+(BOOL)resolveClassMethod:(SEL)sel{
    
    NSString * selName = NSStringFromSelector(sel);
    
    if ([selName hasPrefix: @"set"]) {
        
        class_addMethod(self, sel, (IMP)wrongTypeSetter, "v@:@");
    } else {
        class_addMethod(self, sel, (IMP)wrongTypeGetter, "@@:");
    }

    
    return YES;
}

//如果实例方法没实现，会进入这里动态添加
+(BOOL)resolveInstanceMethod:(SEL)sel{

    NSString * selName = NSStringFromSelector(sel);
    
    if ([selName hasPrefix: @"set"]) {
        
        class_addMethod(self, sel, (IMP)wrongTypeSetter, "v@:@");
    } else {
        class_addMethod(self, sel, (IMP)wrongTypeGetter, "@@:");
    }
    
    return YES;
}

//以下为自动归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int outCount = 0;
        Ivar *vars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
         
            Ivar var = vars[i];
            const char *name = ivar_getName(var);
         
            NSString *key = [NSString stringWithUTF8String:name];
        
            id value = [aDecoder decodeObjectForKey:key];
          
            [self setValue:value forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList([self class], &outCount);
   
    for (int i = 0; i < outCount; i ++) {
        Ivar var = vars[i];
        const char *name = ivar_getName(var);
      
        NSString *key = [NSString stringWithUTF8String:name];
        // 注意kvc的特性是，如果能找到key这个属性的setter方法，则调用setter方法
        // 如果找不到setter方法，则查找成员变量key或者成员变量_key，并且为其赋值
        // 所以这里不需要再另外处理成员变量名称的“_”前缀
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}
@end
