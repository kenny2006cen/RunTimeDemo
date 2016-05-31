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

@implementation Person{

    Person *_helper;
}

id wrongTypeGetter(id object, SEL sel) {
  
    return nil;
}
void wrongTypeSetter(id object, SEL sel, id value) {
   
    // do nothing
}

#pragma mark -RunTime method
+(BOOL)resolveClassMethod:(SEL)sel{
    
    NSString * selName = NSStringFromSelector(sel);
    
    if ([selName hasPrefix: @"set"]) {
        
        class_addMethod(self, sel, (IMP)wrongTypeSetter, "v@:@");
    } else {
        class_addMethod(self, sel, (IMP)wrongTypeGetter, "@@:");
    }

    
    return YES;
}

void dynamicMethodIMP(id self, SEL _cmd)
{
    // implementation ....
}

//如果实例方法没实现，会进入这里动态添加
+(BOOL)resolveInstanceMethod:(SEL)sel{

    NSString * selName = NSStringFromSelector(sel);
    
    if (sel != @selector(resolveThisMethodDynamically))
    {
        NSLog(@"%@类:%@:方法找不到,动态添加",self,selName);
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
       
        return YES;
    }
    
    return YES;
    
//    if ([selName hasPrefix: @"set"]) {
//        
//        
//        class_addMethod(self, sel, (IMP)wrongTypeSetter, "v@:@");
//    } else {
//        NSLog(@"%@类方法找不到,%@:,动态添加",self,selName);
//        class_addMethod(self, sel, (IMP)wrongTypeGetter, "@@:");
//   
//    }
    
    return YES;
}

//运行时系统会在这一步给消息接收者最后一次机会将消息转发给其它对象。对象会创建一个表示消息的NSInvocation对象，把与尚未处理的消息 有关的全部细节都封装在anInvocation中，包括selector，目标(target)和参数。我们可以在forwardInvocation 方法中选择将消息转发给其它对象。
//forwardInvocation:方法的实现有两个任务：
//
//1. 定位可以响应封装在anInvocation中的消息的对象。这个对象不需要能处理所有未知消息。
//
//2. 使用anInvocation作为参数，将消息发送到选中的对象。anInvocation将会保留调用结果，运行时系统会提取这一结果并将其发送到消息的原始发送者。
//
//不过，在这个方法中我们可以实现一些更复杂的功能，我们可以对消息的内容进行修改，比如追回一个参数等，然后再去触发消息。另外，若发现某个消息不应由本类处理，则应调用父类的同名方法，以便继承体系中的每个类都有机会处理此调用请求。
//
//还有一个很重要的问题，我们必须重写以下方法：
//
//1
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
//消息转发机制使用从这个方法中获取的信息来创建NSInvocation对象。因此我们必须重写这个方法，为给定的selector提供一个合适的方法签名。

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    //aSelector = "length"
    if (!signature) {
      
        //如果实例类响应该方法，则返回对应方法签名
        if ([[self class] instancesRespondToSelector:aSelector]) {
        
            signature = [[self class] instanceMethodSignatureForSelector:aSelector];
        }
        else{
        
          //  signature = [NSMethodSignature new];
            
            //aSelector为传进来的方法
            NSString *info = [NSString stringWithFormat:@"%s:%@方法找不到", __FUNCTION__,NSStringFromSelector(aSelector)];
            
            NSLog(@"方法调用出现异常:%@",info);//
            
            //[NSException raise:@"方法调用出现异常" format:info, nil];
            
          //  NSAlert();
        }
    }
    
    return signature;
}


//NSObject的forwardInvocation:方法实现只是简单调用了doesNotRecognizeSelector:方法，它不会转发任何消息。这样，如果不在以上所述的三个步骤中处理未知消息，则会引发一个异常。
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    if ([[self class] instancesRespondToSelector:anInvocation.selector]) {
       
        [anInvocation invokeWithTarget:_helper];
     //   [anInvocation invokeWithTarget:self];

    }
    else{
    
        NSLog(@"方法不能识别:%@",anInvocation);
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector{
    
    
    
}


#pragma mark - auto code
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
