//
//  UINavigationItem+KMHGenerics.m
//  KMHGenerics
//
//  Created by Ken M. Haggerty on 9/27/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "UINavigationItem+KMHGenerics.h"
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

#pragma mark - // UINavigationItem //

#pragma mark Notifications

NSString * const UINavigationItemNotificationObjectKey = @"object";

NSString * const UINavigationItemTitleDidChangeNotification = @"kUINavigationItemTitleDidChangeNotification";
NSString * const UINavigationItemPromptDidChangeNotification = @"kUINavigationItemPromptDidChangeNotification";
NSString * const UINavigationItemLeftBarButtonItemsDidChangeNotification = @"kUINavigationItemLeftBarButtonItemsDidChangeNotification";
NSString * const UINavigationItemRightBarButtonItemsDidChangeNotification = @"kUINavigationItemRightBarButtonItemsDidChangeNotification";

@implementation UINavigationItem (KMHGenerics)

#pragma mark Setters and Getters (Public)

- (void)setHidesLeftBarButtonItems:(BOOL)hidesLeftBarButtonItems {
    if (hidesLeftBarButtonItems) {
        self.storedLeftBarButtonItems = self.leftBarButtonItems;
        self.leftBarButtonItems = nil;
        objc_setAssociatedObject(self, @selector(hidesLeftBarButtonItems), @(hidesLeftBarButtonItems), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        objc_setAssociatedObject(self, @selector(hidesLeftBarButtonItems), @(hidesLeftBarButtonItems), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.leftBarButtonItems = self.storedLeftBarButtonItems;
        self.storedLeftBarButtonItems = nil;
    }
}

- (BOOL)hidesLeftBarButtonItems {
    NSNumber *hidesRighBarButtonItemsValue = objc_getAssociatedObject(self, @selector(hidesLeftBarButtonItems));
    if (hidesRighBarButtonItemsValue) {
        return hidesRighBarButtonItemsValue.boolValue;
    }
    
    objc_setAssociatedObject(self, @selector(hidesLeftBarButtonItems), @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self.hidesLeftBarButtonItems;
}

- (void)setHidesTitleView:(BOOL)hidesTitleView {
    if (hidesTitleView == self.hidesTitleView) {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(hidesTitleView), @(hidesTitleView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (hidesTitleView) {
        self.storedTitleView = self.titleView;
        self.titleView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else {
        self.titleView = self.storedTitleView;
        self.storedTitleView = nil;
    }
}

- (BOOL)hidesTitleView {
    NSNumber *hidesTitleViewValue = objc_getAssociatedObject(self, @selector(hidesTitleView));
    if (hidesTitleViewValue) {
        return hidesTitleViewValue.boolValue;
    }
    
    objc_setAssociatedObject(self, @selector(hidesTitleView), @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self.hidesTitleView;
}

- (void)setHidesRightBarButtonItems:(BOOL)hidesRightBarButtonItems {
    if (hidesRightBarButtonItems) {
        self.storedRightBarButtonItems = self.rightBarButtonItems;
        self.rightBarButtonItems = nil;
        objc_setAssociatedObject(self, @selector(hidesRightBarButtonItems), @(hidesRightBarButtonItems), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        objc_setAssociatedObject(self, @selector(hidesRightBarButtonItems), @(hidesRightBarButtonItems), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.rightBarButtonItems = self.storedRightBarButtonItems;
        self.storedRightBarButtonItems = nil;
    }
}

- (BOOL)hidesRightBarButtonItems {
    NSNumber *hidesRighBarButtonItemsValue = objc_getAssociatedObject(self, @selector(hidesRightBarButtonItems));
    if (hidesRighBarButtonItemsValue) {
        return hidesRighBarButtonItemsValue.boolValue;
    }
    
    objc_setAssociatedObject(self, @selector(hidesRightBarButtonItems), @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self.hidesRightBarButtonItems;
}

#pragma mark Setters and Getters (Private)

- (void)setStoredLeftBarButtonItems:(NSArray <UIBarButtonItem *> *)storedLeftBarButtonItems {
    objc_setAssociatedObject(self, @selector(storedLeftBarButtonItems), storedLeftBarButtonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray <UIBarButtonItem *> *)storedLeftBarButtonItems {
    return objc_getAssociatedObject(self, @selector(storedLeftBarButtonItems));
}

- (void)setStoredTitleView:(UIView *)storedTitleView {
    objc_setAssociatedObject(self, @selector(storedTitleView), storedTitleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)storedTitleView {
    return objc_getAssociatedObject(self, @selector(storedTitleView));
}

- (void)setStoredRightBarButtonItems:(NSArray <UIBarButtonItem *> *)storedRightBarButtonItems {
    objc_setAssociatedObject(self, @selector(storedRightBarButtonItems), storedRightBarButtonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray <UIBarButtonItem *> *)storedRightBarButtonItems {
    return objc_getAssociatedObject(self, @selector(storedRightBarButtonItems));
}

#pragma mark Inits and Loads

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setTitle:) withMethod:@selector(swizzled_setTitle:)];
        [self swizzleMethod:@selector(setPrompt:) withMethod:@selector(swizzled_setPrompt:)];
        [self swizzleMethod:@selector(setLeftBarButtonItems:) withMethod:@selector(swizzled_setLeftBarButtonItems:)];
        [self swizzleMethod:@selector(setRightBarButtonItems:) withMethod:@selector(swizzled_setRightBarButtonItems:)];
    });
}

#pragma mark Swizzled Methods

- (void)swizzled_setTitle:(NSString *)title {
    if ((!title && !self.title) || ([title isEqualToString:self.title])) {
        return;
    }
    
    [self swizzled_setTitle:title];
    
    NSDictionary *userInfo = title ? @{UINavigationItemNotificationObjectKey : title} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:UINavigationItemTitleDidChangeNotification object:self userInfo:userInfo];
}

- (void)swizzled_setPrompt:(NSString *)prompt {
    if ((!prompt && !self.prompt) || ([prompt isEqualToString:self.prompt])) {
        return;
    }
    
    [self swizzled_setPrompt:prompt];
    
    NSDictionary *userInfo = prompt ? @{UINavigationItemNotificationObjectKey : prompt} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:UINavigationItemPromptDidChangeNotification object:self userInfo:userInfo];
}

- (void)swizzled_setLeftBarButtonItems:(NSArray <UIBarButtonItem *> *)leftBarButtonItems {
    if (self.hidesLeftBarButtonItems) {
        self.storedLeftBarButtonItems = leftBarButtonItems;
    }
    else {
        [self swizzled_setLeftBarButtonItems:leftBarButtonItems];
    }
    
    if ((!leftBarButtonItems && !self.leftBarButtonItems) || [leftBarButtonItems isEqualToArray:self.leftBarButtonItems]) {
        return;
    }
    
    NSDictionary *userInfo = leftBarButtonItems ? @{UINavigationItemNotificationObjectKey : leftBarButtonItems} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:UINavigationItemLeftBarButtonItemsDidChangeNotification object:self userInfo:userInfo];
}

- (void)swizzled_setRightBarButtonItems:(NSArray <UIBarButtonItem *> *)rightBarButtonItems {
    if (self.hidesRightBarButtonItems) {
        self.storedRightBarButtonItems = rightBarButtonItems;
    }
    else {
        [self swizzled_setRightBarButtonItems:rightBarButtonItems];
    }
    
    if ((!rightBarButtonItems && !self.rightBarButtonItems) || [rightBarButtonItems isEqualToArray:self.rightBarButtonItems]) {
        return;
    }
    
    NSDictionary *userInfo = rightBarButtonItems ? @{UINavigationItemNotificationObjectKey : rightBarButtonItems} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:UINavigationItemRightBarButtonItemsDidChangeNotification object:self userInfo:userInfo];
}

@end
