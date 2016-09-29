//
//  UIViewController+KMHGenerics.m
//  Akay
//
//  Created by Ken M. Haggerty on 9/28/16.
//  Copyright © 2016 Eureka Valley Co. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "UIViewController+KMHGenerics.h"
#import <UIKit/UIKit.h>
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

#pragma mark - // UIViewController //

@implementation UIViewController (KMHGenerics)

#pragma mark Notifications

NSString * const UIViewControllerNotificationObjectKey = @"object";

NSString * const UIViewControllerEditingDidChangeNotification = @"kUIViewControllerEditingDidChangeNotification";

#pragma mark Inits and Loads

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setEditing:) withMethod:@selector(swizzled_setEditing:)];
    });
}

#pragma mark Swizzled Methods

- (void)swizzled_setEditing:(BOOL)editing {
    if (editing == self.editing) {
        return;
    }
    
    [self swizzled_setEditing:editing];
    
    NSDictionary *userInfo = @{UIViewControllerNotificationObjectKey : @(editing)};
    [[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerEditingDidChangeNotification object:self userInfo:userInfo];
}

@end
