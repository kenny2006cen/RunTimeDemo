//
//  ViewController.m
//  RunTimeDemo
//
//  Created by User on 16/5/31.
//  Copyright © 2016年 jlc. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//       NSArray *pushTypeArray =@[@"2801",@"2802",@"2803",@"1001",@"1002",@"1003",@"1004",@"1005",@"2532",@"2531",@"1011",@"1012",@"1013",@"1014",@"1015",@"1016",@"2501",@"2502",@"2503",@"2504",@"2505",@"2506",@"2507",@"2508",@"2509",@"2510",@"2511",@"2512",@"2513",@"2541",@"2542",@"2543",@"2544",@"2545",@"2546",@"2547"];
//    
//    NSString *str =[NSString stringWithFormat:@"%@",@"2801"];
//    
//    if ([pushTypeArray containsObject:str]) {
//        
//        
//    }
    
   Person *obj= [[Person alloc]init];
    
    NSString *str = obj;
    
    [str length];
    
    [obj addName];
  //  [obj addName];
    
//    objc_msgSend 在使用时都被强制转换了一下，这是因为 objc_msgSend 函数可以hold住各种不同的返回值以及多个参数，但默认情况下是没有参数和返回值的。如果我们把调用 showAge 方法改成这样：
//    
//    objc_msgSend(objct, sel_registerName("showAge"));
//    Xcode 就会报错：
//    
//    1
//    Too many arguments to function call, expected 0, have 2.
  //  objc_msgSend();
    
    /*
     判断接收者是否为nil，如果为nil，清空寄存器，消息发送返回nil
     到类缓存中查找方法，如果存在直接返回方法
     没有找到缓存，到类的方法列表中依次寻找
     
     查找方法实现是通过_class_lookupMethodAndLoadCache3这个奇怪的函数完成的:
     */
}
    /*
     IMP _class_lookupMethodAndLoadCache3(id obj, SEL sel, Class cls)
     {
         return lookUpImpOrForward(cls, sel, obj,
                               YES, NO, YES/*resolver);

IMP lookUpImpOrForward(Class cls, SEL sel, id inst,
                                          bool initialize, bool cache, bool resolver)
{
        Class curClass;
        IMP methodPC = nil;
        Method meth;
        bool triedResolver = NO;
        methodListLock.assertUnlocked();
        // 如果传入的cache为YES，到类缓存中查找方法缓存
        if (cache) {
                methodPC = _cache_getImp(cls, sel);
                if (methodPC) return methodPC;
            }
        // 判断类是否已经被释放
        if (cls == _class_getFreedObjectClass())
                return (IMP) _freedHandler;
        // 如果类未初始化，对其进行初始化。如果这个消息是initialize，那么直接进行类的初始化
        if (initialize  &&  !cls->isInitialized()) {
                _class_initialize (_class_getNonMetaClass(cls, inst));
            }
     retry:
        methodListLock.lock();
        // 忽略在GC环境下的部分消息，比如retain、release等
        if (ignoreSelector(sel)) {
                methodPC = _cache_addIgnoredEntry(cls, sel);
                goto done;
            }
        // 遍历缓存方法，如果找到，直接返回
        methodPC = _cache_getImp(cls, sel);
        if (methodPC) goto done;
        // 遍历类自身的方法列表查找方法实现
        meth = _class_getMethodNoSuper_nolock(cls, sel);
        if (meth) {
                log_and_fill_cache(cls, cls, meth, sel);
                methodPC = method_getImplementation(meth);
                goto done;
            }
        // 尝试向上遍历父类的方法列表查找实现
        curClass = cls;
        while ((curClass = curClass->superclass)) {
                // Superclass cache.
                meth = _cache_getMethod(curClass, sel, _objc_msgForward_impcache);
                if (meth) {
                        if (meth != (Method)1) {
                                log_and_fill_cache(cls, curClass, meth, sel);
                                methodPC = method_getImplementation(meth);
                                goto done;
                            }
                        else {
                                // Found a forward:: entry in a superclass.
                                // Stop searching, but don't cache yet; call method
                                // resolver for this class first.
                                break;
                            }
                    }
                // 查找父类的方法列表
                meth = _class_getMethodNoSuper_nolock(curClass, sel);
                if (meth) {
                        log_and_fill_cache(cls, curClass, meth, sel);
                        methodPC = method_getImplementation(meth);
                        goto done;
                    }
            }
        // 没有找到任何的方法实现，进入消息转发第一阶段“动态方法解析”
        // 调用+ (BOOL)resolveInstanceMethod: (SEL)selector
        // 征询接收者所属的类是否能够动态的添加这个未实现的方法来解决问题
        if (resolver  &&  !triedResolver) {
                methodListLock.unlock();
                _class_resolveMethod(cls, sel, inst);
                triedResolver = YES;
                goto retry;
            }
        // 仍然没有找到方法实现进入消息转发第二阶段“备援接收者”
        // 先后会调用 -(id)forwardingTargetForSelector: (SEL)selector
        // 以及 - (void)forwardInvocation: (NSInvocation*)invocation 进行最后的补救
        // 如果补救未成功抛出消息发送错误异常
        _cache_addForwardEntry(cls, sel);
        methodPC = _objc_msgForward_impcache;
     done:
        methodListLock.unlock();
        assert(!(ignoreSelector(sel)  &&  methodPC != (IMP)&_objc_ignored_method));
        return methodPC;
}
     */


-(void)playWith:(NSString*)friend{

//    objc_msgSend(self,@selector(playWith:));

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
