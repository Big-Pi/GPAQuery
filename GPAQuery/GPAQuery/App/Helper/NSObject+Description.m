//
//  NSObject+Description.m
//  ModelDescription
//
//  Created by pi on 16/1/1.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NSObject+Description.h"
#import <objc/runtime.h>


@implementation NSObject (Description)

+(void)load{
    [self swizzleMethod:[self class] originalSelector:@selector(description) swizzledSelector:@selector(swizzleDescription)];
}

+(void)swizzleMethod:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    //http://tech.glowing.com/cn/method-swizzling-aop/
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

//http://www.cocoachina.com/ios/20151231/14846.html
-(NSString*)swizzleDescription{
    
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class],&count);
    
    for(int i=0;i<count;i++){
        objc_property_t property=properties[i];
        NSString*name=@(property_getName(property));
        id value=[self valueForKey:name]?:@"nil";
        [dictionary setObject:value forKey:name];
    }
    free(properties);
    return [NSString stringWithFormat:@"＜%@：%p> : %@",[self class],self,dictionary];
}
@end
