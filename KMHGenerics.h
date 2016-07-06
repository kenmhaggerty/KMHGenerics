//
//  KMHGenerics.h
//  KMHGenerics
//
//  Created by Ken M. Haggerty on 7/4/16.
//  Copyright (c) Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#pragma mark - // PROTOCOLS //

#pragma mark - // DEFINITIONS (KMHGenerics) //

extern NSString * _Nonnull const NOTIFICATION_OBJECT_KEY;

#define stringFromVariable(variable) (@""#variable)

@interface KMHGenerics : NSObject
+ (BOOL)object:(nullable id)object1 isEqualToObject:(nullable id)object2;
+ (nullable UIViewController *)rootViewController;
+ (nonnull UIWindow *)fullscreenWindow;
+ (void)incrementBadge;
+ (void)decrementBadge;
+ (void)setBadgeToCount:(NSUInteger)count;
+ (nullable id)valueForBool:(BOOL)boolValue yesValue:(nullable id)yesValue noValue:(nullable id)noValue;
+ (nullable NSString *)pluralizationForCount:(NSUInteger)count singular:(nullable NSString *)singular plural:(nullable NSString *)plural;
+ (nullable NSNumber *)angleForDeviceOrientation:(UIDeviceOrientation)orientation;
+ (nullable NSNumber *)angleForInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (CGFloat)angleForImageOrientation:(UIImageOrientation)orientation;
+ (AVCaptureVideoOrientation)convertInterfaceOrientationToVideoOrientation:(UIInterfaceOrientation)interfaceOrientation;
+ (CGFloat)statusBarHeight;
+ (nonnull NSURL *)applicationDocumentsDirectory;
@end

#pragma mark - // DEFINITIONS (NSArray) //

@interface NSArray (KMHGenerics)
+ (nonnull instancetype)arrayWithNullableObjects:(nullable id)firstObj, ...
NS_REQUIRES_NIL_TERMINATION;
+ (nonnull instancetype)arrayWithValue:(float)value increment:(float)increment length:(NSUInteger)length;
+ (nonnull instancetype)arrayWithStartValue:(NSInteger)startValue endValue:(NSUInteger)endValue;
+ (nonnull instancetype)arrayWithLength:(NSUInteger)length block:(nonnull id _Nonnull (^)(NSUInteger index))block;
- (nonnull instancetype)arrayByRemovingObjectsInArray:(nonnull NSArray *)otherArray;
- (nonnull instancetype)arrayByRemovingObjectsNotInArray:(nonnull NSArray *)otherArray;
- (nonnull instancetype)sortedArray:(BOOL)ascending;
- (void)compareToArray:(nonnull NSArray *)newArray andGenerateIndexPathsToInsert:(NSArray * _Nonnull * _Nonnull)indexPaths withSection:(NSUInteger)section;
- (void)compareToArray:(nonnull NSArray *)newArray andGenerateIndexPaths:(NSArray * _Nonnull * _Nonnull)indexPaths toMoveToIndexPaths:(NSArray * _Nonnull * _Nonnull)newIndexPaths withSection:(NSUInteger)section;
- (void)compareToArray:(nonnull NSArray *)newArray andGenerateIndexPathsToDelete:(NSArray * _Nonnull * _Nonnull)indexPaths withSection:(NSUInteger)section;
- (NSUInteger)countObject:(nonnull id)object;
@end

#pragma mark - // DEFINITIONS (NSData) //

@interface NSData (KMHGenerics)
- (nonnull NSData *)AES256EncryptWithKey:(nonnull NSString *)key;
- (nonnull NSData *)AES256DecryptWithKey:(nonnull NSString *)key;
- (nonnull NSDictionary *)convertToDictionary;
@end

#pragma mark - // DEFINITIONS (NSDate) //

@interface NSDate (KMHGenerics)
- (nonnull instancetype)dateRoundedToPrecision:(NSUInteger)decimalPoints;
@end

#pragma mark - // DEFINITIONS (NSDictionary) //

@interface NSDictionary (KMHGenerics)
+ (nonnull instancetype)dictionaryWithNullableObject:(nullable id)object forKey:(nonnull id <NSCopying>)key;
- (nonnull NSSet *)pathURLs;
- (nonnull NSData *)convertToData;
@end

#pragma mark - // DEFINITIONS (NSMutableDictionary) //

@interface NSMutableDictionary (KMHGenerics)
- (void)setNullableObject:(nullable id)anObject forKey:(nonnull id <NSCopying>)aKey;
@end

#pragma mark - // DEFINITIONS (NSNotificationCenter) //

@interface NSNotificationCenter (KMHGenerics)
+ (void)addObserver:(nonnull id)notificationObserver selector:(nonnull SEL)notificationSelector name:(nullable NSString *)notificationName object:(nullable id)notificationSender;
+ (void)removeObserver:(nonnull id)notificationObserver name:(nullable NSString *)notificationName object:(nullable id)notificationSender;
+ (void)postNotificationToMainThread:(nonnull NSString *)aName object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo;
@end

#pragma mark - // DEFINITIONS (NSObject) //

@interface NSObject (KMHGenerics)
- (void)setup;
- (void)teardown;
@end

#pragma mark - // DEFINITIONS (NSString) //

@interface NSString (KMHGenerics)
+ (nonnull instancetype)randomStringWithCharacters:(nonnull NSString *)charactersString length:(NSUInteger)length;
- (BOOL)isEmail;
- (BOOL)isNumeric;
- (nonnull instancetype)encryptedStringUsingKey:(nonnull NSString *)key;
- (nonnull instancetype)decryptedStringUsingKey:(nonnull NSString *)key;
- (NSUInteger)length;
- (BOOL)onlyContainsCharactersInSet:(nonnull NSCharacterSet *)characterSet;
@end

#pragma mark - // DEFINITIONS (UIAlertController) //

@interface UIAlertController (KMHGenerics)
+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(nullable NSArray <NSString *> *)actions preferredAction:(nullable NSString *)preferredAction dismissalText:(nullable NSString *)dismissalText completion:(nullable void (^)(UIAlertAction * _Nonnull action))completionBlock;
- (void)clearTextFields;
@end

#pragma mark - // DEFINITIONS (UICollectionViewCell) //

@interface UICollectionViewCell (KMHGenerics)
+ (nonnull instancetype)cellWithReuseIdentifier:(nullable NSString *)reuseIdentifier collectionView:(nonnull UICollectionView *)collectionView atIndexPath:(nonnull NSIndexPath *)indexPath;
@end

#pragma mark - // DEFINITIONS (UIColor) //

@interface UIColor (KMHGenerics)
+ (nonnull instancetype)iOSBlue;
@end

#pragma mark - // DEFINITIONS (UIImage) //

@interface UIImage (KMHGenerics)
- (nonnull instancetype)imageWithAlpha:(CGFloat)alpha;
- (nonnull instancetype)thumbnailWithSize:(CGSize)size opaque:(BOOL)opaque;
- (nonnull instancetype)croppedImageWithFrame:(CGRect)frame;
@end

#pragma mark - // DEFINITIONS (UINavigationBar) //

@interface UINavigationBar (KMHGenerics)
+ (CGFloat)height;
@end

#pragma mark - // DEFINITIONS (UIScrollView) //

@interface UIScrollView (KMHGenerics)
- (void)scrollToView:(nonnull UIView *)view animated:(BOOL)animated;
@end

#pragma mark - // DEFINITIONS (UITableView) //

@interface UITableView (KMHGenerics)
- (void)moveRowsAtIndexPaths:(nonnull NSArray <NSIndexPath *> *)indexPaths toIndexPaths:(nonnull NSArray <NSIndexPath *> *)newIndexPaths;
- (void)updateFromArray:(nonnull NSArray *)array
                toArray:(nonnull NSArray *)toArray
              inSection:(NSUInteger)section
 withInsertionAnimation:(UITableViewRowAnimation)insertionAnimation
      deletionAnimation:(UITableViewRowAnimation)deletionAnimation
                 setter:(nonnull void (^)(NSArray * _Nonnull data))setterBlock
          insertedCells:(nullable void (^)(NSArray <UITableViewCell *> * _Nonnull cells))insertionBlock
         reorderedCells:(nullable void (^)(NSArray <UITableViewCell *> * _Nonnull cells))reorderingBlock
           deletedCells:(nullable void (^)(NSArray <UITableViewCell *> * _Nonnull cells))deletionBlock
             completion:(nullable void (^)(void))completionBlock;
@end

#pragma mark - // DEFINITIONS (UITableViewCell) //

@interface UITableViewCell (KMHGenerics)
+ (nonnull instancetype)cellWithReuseIdentifier:(nullable NSString *)reuseIdentifier style:(UITableViewCellStyle)style tableView:(nonnull UITableView *)tableView atIndexPath:(nonnull NSIndexPath *)indexPath fromStoryboard:(BOOL)fromStoryboard;
+ (CGFloat)defaultHeight;
@end

#pragma mark - // DEFINITIONS (UITextField) //

@interface UITextField (KMHGenerics)
@property (nonatomic) BOOL selectable;
- (void)selectTextInRange:(NSRange)range;
@end

#pragma mark - // DEFINITIONS (UIView) //

@interface UIView (KMHGenerics)
@property (nonatomic) CGFloat cornerRadius;
- (nullable UIView *)firstResponder;
- (BOOL)isEventualSubviewOfView:(nonnull UIView *)view;
- (void)setFrameWithOriginX:(nullable NSNumber *)originX originY:(nullable NSNumber *)originY width:(nullable NSNumber *)width height:(nullable NSNumber *)height;
- (void)setFrameWithCenterX:(nullable NSNumber *)centerX centerY:(nullable NSNumber *)centerY width:(nullable NSNumber *)width height:(nullable NSNumber *)height;
- (void)addBorderWithColor:(nonnull CGColorRef)color width:(CGFloat)width;
- (void)addShadowWithColor:(nonnull CGColorRef)color opacity:(float)opacity radius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius offset:(CGSize)shadowOffset;
- (void)rotateFromAngle:(CGFloat)fromAngle byAngle:(CGFloat)angle withDuration:(CFTimeInterval)duration completion:(nullable void (^)(void))completion;
- (void)flipHorizontally:(CGFloat)radians withAnimations:(nullable void (^)(void))animations duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(nullable void (^)(BOOL))completion;
- (void)flipVertically:(CGFloat)radians withAnimations:(nullable void (^)(void))animations duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(nullable void (^)(BOOL))completion;
@end

#pragma mark - // DEFINITIONS (UIViewController) //

@interface UIViewController (KMHGenerics)
- (void)performBlockOnChildViewControllers:(nonnull void (^)(UIViewController * _Nonnull childViewController))block;
@end