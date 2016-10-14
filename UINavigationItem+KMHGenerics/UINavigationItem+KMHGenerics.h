//
//  UINavigationItem+KMHGenerics.h
//  KMHGenerics
//
//  Created by Ken M. Haggerty on 9/27/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // UINavigationItem (Swizzled) //

#pragma mark Notifications

extern NSString * const UINavigationItemNotificationObjectKey;

extern NSString * const UINavigationItemTitleDidChangeNotification;
extern NSString * const UINavigationItemPromptDidChangeNotification;
extern NSString * const UINavigationItemLeftBarButtonItemsDidChangeNotification;
extern NSString * const UINavigationItemRightBarButtonItemsDidChangeNotification;

#pragma mark Public Interface

@interface UINavigationItem (Swizzled)
@property (nonatomic) BOOL hidesLeftBarButtonItems;
@property (nonatomic) BOOL hidesTitleView;
@property (nonatomic) BOOL hidesRightBarButtonItems;
@end
