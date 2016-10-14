//
//  NSTextContainer+KMHGenerics.m
//  KMHGenerics
//
//  Created by Ken M. Haggerty on 10/4/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "NSTextContainer+KMHGenerics.h"
#import <objc/runtime.h>

#pragma mark - // NSObject //

@interface NSObject (Swizzled)
- (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;
@end

@implementation NSObject (Swizzled)

// copied w/ modifications via Mattt Thompson's tutorial at http://nshipster.com/method-swizzling/
- (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    // ...
    // Method originalMethod = class_getClassMethod(class, originalSelector);
    // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

#pragma mark - // NSTextContainer //

#pragma mark Notifications

NSString * const NSTextContainerNotificationObjectKey = @"kNSTextContainerNotificationObjectKey";

NSString * const NSTextContainerLineBreakModeDidChangeNotification = @"NSTextContainerLineBreakModeDidChangeNotification";

#pragma mark Methods

@implementation NSTextContainer (KMHGenerics)

#pragma mark Inits and Loads

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setLineBreakMode:) withMethod:@selector(swizzled_setLineBreakMode:)];
    });
}

#pragma mark Swizzled Methods

- (void)swizzled_setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSLineBreakMode primitiveLineBreakMode = self.lineBreakMode;
    [self swizzled_setLineBreakMode:lineBreakMode];
    if (lineBreakMode == primitiveLineBreakMode) {
        return;
    }
    
    NSDictionary *userInfo = @{NSTextContainerNotificationObjectKey : @(lineBreakMode)};
    [[NSNotificationCenter defaultCenter] postNotificationName:NSTextContainerLineBreakModeDidChangeNotification object:self userInfo:userInfo];
}

@end
