//
//  UIViewController+RunDealloc.m
//  TestGCD
//
//  Created by admin on 16/4/22.
//  Copyright © 2016年 GHYS. All rights reserved.
//

#import "UIViewController+RunDealloc.h"
#import <objc/runtime.h>

@implementation UIViewController (RunDealloc)

+(void)load{

    [super load];
    
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                                     class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
    
}


-(void)swizzledDealloc{
    
    NSLog(@"class:%@ 释放了",[self class]);
    
    [self swizzledDealloc];
   
}
@end
