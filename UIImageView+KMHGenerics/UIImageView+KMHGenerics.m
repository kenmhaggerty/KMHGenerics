//
//  UIImageView+KMHGenerics.m
//  Akay
//
//  Created by Ken M. Haggerty on 9/28/16.
//  Copyright © 2016 Eureka Valley Co. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "UIImageView+KMHGenerics.h"
#import <objc/runtime.h>

#pragma mark - // NSObject (Swizzle) //

#pragma mark Interface (Swizzle)

@interface NSObject (Swizzle)
- (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;
@end

#pragma mark Implementation

@implementation NSObject (Swizzle)

#pragma mark // Methods (Swizzle) //

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

#pragma mark - // UIImageView (Swizzled) //

#pragma mark Notifications

NSString * const UIImageViewNotificationObjectKey = @"object";

NSString * const UIImageViewImageDidChangeNotification = @"kUIImageViewImageDidChangeNotification";

#pragma mark Implementation

@implementation UIImageView (Swizzled)

#pragma mark // Inits and Loads //

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setImage:) withMethod:@selector(swizzled_setImage:)];
    });
}

#pragma mark // Swizzled Methods //

- (void)swizzled_setImage:(UIImage *)image {
    UIImage *primitiveImage = self.image;
    
    [self swizzled_setImage:image];
    
    if ((!image && !self.image) || [image isEqual:primitiveImage]) {
        return;
    }
    
    NSDictionary *userInfo = image ? @{UIImageViewNotificationObjectKey : image} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:UIImageViewImageDidChangeNotification object:self userInfo:userInfo];
}

@end
