//
//  NSObject+Unicode.m
//  UnicodeLog
//
//  Created by pi on 16/1/1.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NSObject+Unicode.h"
#import <objc/runtime.h>

@implementation NSObject (Unicode)

+(void)load{
#if 0
    [self swizzleDescription:[NSArray class]];
    [self swizzleDescription:[NSDictionary class]];
#endif
}

+ (NSString *)stringByReplaceUnicode:(NSString *)string
{
    NSMutableString *convertedString = [string mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    return convertedString;
}


+(void)swizzleDescription:(Class)class{

//http://stackoverflow.com/questions/21598122/suppress-undeclared-selector-warning-in-xcode-5
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    //remove undeclared selector warning

    SEL swizzleDescription=@selector(swizzleDescription);
    SEL swizzleDescriptionWithLocale=@selector(swizzleDescriptionWithLocale:);
    SEL swizzleDescriptionWithLocaleIndent=@selector(swizzleDescriptionWithLocale:indent:);
#pragma clang diagnostic pop
    
    SEL description=@selector(description);
    SEL descriptionWithLocale=@selector(descriptionWithLocale:);
    SEL descriptionWithLocaleIndent=@selector(descriptionWithLocale:indent:);
    
    [self swizzleMethod:class originalSelector:description swizzledSelector:swizzleDescription];
    [self swizzleMethod:class originalSelector:descriptionWithLocale swizzledSelector:swizzleDescriptionWithLocale];
    [self swizzleMethod:class originalSelector:descriptionWithLocaleIndent swizzledSelector:swizzleDescriptionWithLocaleIndent];
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

@end

#pragma mark - NSArray

@implementation NSArray (Unicode)

- (NSString *)swizzleDescription {
    return [NSObject stringByReplaceUnicode:[self swizzleDescription]];
}

- (NSString *)swizzleDescriptionWithLocale:(nullable id)locale {
    return [NSObject stringByReplaceUnicode:[self swizzleDescriptionWithLocale:locale]];
}

- (NSString *)swizzleDescriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [NSObject stringByReplaceUnicode:[self swizzleDescriptionWithLocale:locale indent:level]];
}
@end

#pragma mark - NSDictionary

@implementation NSDictionary (Unicode)

- (NSString *)swizzleDescription {
    return [NSObject stringByReplaceUnicode:[self swizzleDescription]];
}

- (NSString *)swizzleDescriptionWithLocale:(nullable id)locale {
    return [NSObject stringByReplaceUnicode:[self swizzleDescriptionWithLocale:locale]];
}

- (NSString *)swizzleDescriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [NSObject stringByReplaceUnicode:[self swizzleDescriptionWithLocale:locale indent:level]];
}
@end