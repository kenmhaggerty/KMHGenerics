//
//  KMHGenerics.h
//  KMHGenerics
//
//  Created by Ken M. Haggerty on 7/4/16.
//  Copyright (c) Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // KMHGenerics //

#pragma mark Constants

extern NSString * _Nonnull const NOTIFICATION_OBJECT_KEY;

#define stringFromVariable(variable) (@""#variable)

@interface KMHGenerics : NSObject
+ (BOOL)object:(nullable id)object1 isEqualToObject:(nullable id)object2;
+ (nullable UIViewController *)rootViewController;
+ (nonnull UIWindow *)fullscreenWindow;
+ (void)incrementBadge;
+ (void)decrementBadge;
+ (void)setBadgeToCount:(NSUInteger)count;
+ (nullable NSNumber *)angleForDeviceOrientation:(UIDeviceOrientation)orientation;
+ (nullable NSNumber *)angleForInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (CGFloat)angleForImageOrientation:(UIImageOrientation)orientation;
+ (CGFloat)statusBarHeight;
+ (void)setStatusBarStyle:(UIStatusBarStyle)style;
+ (void)setStatusBarStyle:(UIStatusBarStyle)style animated:(BOOL)animated;
+ (UIStatusBarStyle)statusBarStyle;
+ (void)setStatusBarHidden:(BOOL)statusBarHidden;
+ (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;
+ (BOOL)isStatusBarHidden;
+ (nonnull NSURL *)applicationDocumentsDirectory;
+ (nullable NSString *)appName;
+ (float)iOSVersion;
+ (CGSize)scaleSize:(CGSize)size toFitInsideSize:(CGSize)aSize;
+ (CGSize)scaleSize:(CGSize)size toFitOutsideSize:(CGSize)aSize;
@end

#pragma mark - // NSArray //

@interface NSArray (KMHGenerics)
+ (nonnull instancetype)arrayWithNullableObject:(nullable id)anObject;
+ (nonnull instancetype)arrayWithNullableObjects:(nullable id)firstObj, ...
NS_REQUIRES_NIL_TERMINATION;
+ (nonnull instancetype)arrayWithValue:(float)value increment:(float)increment length:(NSUInteger)length;
+ (nonnull instancetype)arrayWithStartValue:(NSInteger)startValue endValue:(NSUInteger)endValue;
+ (nonnull instancetype)arrayWithLength:(NSUInteger)length block:(nonnull id _Nonnull (^)(NSUInteger index))block;
- (nonnull instancetype)arrayByInsertingObject:(nonnull id)anObject atIndex:(NSUInteger)index;
- (nonnull instancetype)arrayByRemovingLastObject;
- (nonnull instancetype)arrayFromIndex:(NSUInteger)index;
- (nonnull instancetype)arrayByRemovingObjectsFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;
- (nonnull instancetype)arrayByRemovingObject:(nonnull id)anObject;
- (nonnull instancetype)arrayByRemovingObjectsInArray:(nonnull NSArray *)otherArray;
- (nonnull instancetype)arrayByRemovingObjectsAtIndexes:(nonnull NSIndexSet *)indexSet;
- (nonnull instancetype)arrayByRemovingObjectsNotInArray:(nonnull NSArray *)otherArray;
- (nonnull instancetype)arrayByApplyingBlock:(nonnull _Nullable id (^)(_Nonnull id))block;
- (nonnull instancetype)sortedArray:(BOOL)ascending;
- (void)compareToArray:(nonnull NSArray *)newArray andGenerateIndexPathsToInsert:(NSArray * _Nonnull * _Nonnull)indexPaths withSection:(NSUInteger)section;
- (void)compareToArray:(nonnull NSArray *)newArray andGenerateIndexPaths:(NSArray * _Nonnull * _Nonnull)indexPaths toMoveToIndexPaths:(NSArray * _Nonnull * _Nonnull)newIndexPaths withSection:(NSUInteger)section;
- (void)compareToArray:(nonnull NSArray *)newArray andGenerateIndexPathsToDelete:(NSArray * _Nonnull * _Nonnull)indexPaths withSection:(NSUInteger)section;
- (NSUInteger)countObject:(nonnull id)object;
- (nonnull NSIndexSet *)indexesOfObject:(nonnull id)anObject;
- (nullable id)penultimateObject;
@end

#pragma mark - // NSData //

@interface NSData (KMHGenerics)
- (nonnull NSData *)AES256EncryptWithKey:(nonnull NSString *)key;
- (nonnull NSData *)AES256DecryptWithKey:(nonnull NSString *)key;
- (nonnull NSDictionary *)convertToDictionary;
@end

#pragma mark - // NSDate //

@interface NSDate (KMHGenerics)
- (nonnull instancetype)dateRoundedToPrecision:(NSUInteger)decimalPoints;
@end

#pragma mark - // NSDictionary //

@interface NSDictionary (KMHGenerics)
+ (nonnull instancetype)dictionaryWithNullableObject:(nullable id)object forKey:(nonnull id <NSCopying>)key;
- (nonnull NSSet *)pathURLs;
- (nonnull NSData *)convertToData;
@end

#pragma mark - // NSIndexSet //

@interface NSIndexSet (KMHGenerics)
+ (nonnull instancetype)indexSetWithArray:(nonnull NSArray <NSNumber *> *)array;
- (nonnull NSArray *)array;
@end

#pragma mark - // NSMutableDictionary //

@interface NSMutableDictionary (KMHGenerics)
- (void)setNullableObject:(nullable id)anObject forKey:(nonnull id <NSCopying>)aKey;
@end

#pragma mark - // NSNotificationCenter //

@interface NSNotificationCenter (KMHGenerics)
+ (void)addObserver:(nonnull id)notificationObserver selector:(nonnull SEL)notificationSelector name:(nullable NSString *)notificationName object:(nullable id)notificationSender;
+ (void)removeObserver:(nonnull id)notificationObserver name:(nullable NSString *)notificationName object:(nullable id)notificationSender;
+ (void)postNotificationToMainThread:(nonnull NSString *)aName object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo;
@end

#pragma mark - // NSObject //

@interface NSObject (KMHGenerics)
- (void)setup;
- (void)teardown;
- (void)setup:(nullable void(^)(void))block;
- (void)teardown:(nullable void(^)(void))block;
- (void)swizzleMethod:(nonnull SEL)originalSelector withMethod:(nonnull SEL)swizzledSelector;
- (void)performOnceUsingToken:(nonnull id)token block:(nullable void (^)(void))block;
@end

#pragma mark - // NSOrderedSet //

@interface NSOrderedSet (KMHGenerics)
- (nonnull instancetype)orderedSetByRemovingObject:(nonnull id)anObject;
- (nonnull instancetype)orderedSetBySubtractingSet:(nonnull NSSet *)set;
@end

#pragma mark - // NSSet //

@interface NSSet (KMHGenerics)
- (nonnull instancetype)setByRemovingObject:(nonnull id)anObject;
- (nonnull instancetype)setBySubtractingSet:(nonnull NSSet *)set;
- (nonnull NSSet *)setByApplyingBlock:(nullable _Nullable id (^)(_Nonnull id))block;
- (nonnull NSOrderedSet *)orderedSetUsingComparator:(nonnull NSComparator)cmptr;
- (nonnull NSArray *)sortedArrayUsingComparator:(nonnull NSComparator)cmptr;
@end

#pragma mark - // NSString //

@interface NSString (KMHGenerics)
+ (nonnull instancetype)randomStringWithCharacters:(nonnull NSString *)charactersString length:(NSUInteger)length;
- (BOOL)isEmail;
- (BOOL)isNumeric;
- (nonnull instancetype)encryptedStringUsingKey:(nonnull NSString *)key;
- (nonnull instancetype)decryptedStringUsingKey:(nonnull NSString *)key;
- (NSUInteger)length;
- (BOOL)onlyContainsCharactersInSet:(nonnull NSCharacterSet *)characterSet;
@end

#pragma mark - // UIAlertController //

@interface UIAlertController (KMHGenerics)
+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(nullable NSArray <NSString *> *)actions preferredAction:(nullable NSString *)preferredAction dismissalText:(nullable NSString *)dismissalText completion:(nullable void(^)(UIAlertAction * _Nonnull action, NSArray <UITextField *> * _Nonnull textFields))completionBlock;
- (void)clearTextFields;
@end

#pragma mark - // UICollectionViewCell //

@interface UICollectionViewCell (KMHGenerics)
+ (nonnull instancetype)cellWithReuseIdentifier:(nullable NSString *)reuseIdentifier collectionView:(nonnull UICollectionView *)collectionView atIndexPath:(nonnull NSIndexPath *)indexPath;
@end

#pragma mark - // UIButton //

@interface UIButton (KMHGenerics)
- (void)setText:(nullable NSString *)text;
- (nullable NSString *)text;
- (void)setImage:(nullable UIImage *)image;
- (nullable UIImage *)image;
@end

#pragma mark - // UIColor //

@interface UIColor (KMHGenerics)
+ (nonnull instancetype)iOSBlue;
@end

#pragma mark - // UIDevice //

@interface UIDevice (KMHGenerics)
- (BOOL)isPortrait;
- (BOOL)isLandscape;
@end

#pragma mark - // UIImage //

@interface UIImage (KMHGenerics)
- (nonnull instancetype)imageWithAlpha:(CGFloat)alpha;
- (nonnull instancetype)imageWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode retina:(BOOL)retina;
- (nonnull instancetype)thumbnailWithSize:(CGSize)size opaque:(BOOL)opaque;
- (nonnull instancetype)croppedImageWithFrame:(CGRect)frame;
- (nonnull instancetype)croppedImageWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;
@end

#pragma mark - // UINavigationBar //

@interface UINavigationBar (KMHGenerics)
+ (CGFloat)height;
@end

#pragma mark - // UINavigationController //

@interface UINavigationController (KMHGenerics)
- (nullable UIViewController *)rootViewController;
@end

#pragma mark - // UIScreen //

@interface UIScreen (KMHGenerics)
- (BOOL)isRetina;
@end

#pragma mark - // UIScrollView //

@interface UIScrollView (KMHGenerics)
- (void)scrollToView:(nonnull UIView *)view animated:(BOOL)animated;
@end

#pragma mark - // UISegmentedControl //

@interface UISegmentedControl (KMHGenerics)
- (nullable NSString *)selectedSegmentTitle;
@end

#pragma mark - // UIStoryboard //

@interface UIStoryboard (KMHGenerics)
+ (nullable UIViewController *)storyboard:(nonnull NSString *)name viewControllerWithIdentifier:(nonnull NSString *)identifier;
@end

#pragma mark - // UIStoryboardSegue //

@interface UIStoryboardSegue (KMHGenerics)
- (nullable UIViewController *)contentDestinationViewController;
@end

#pragma mark - // UITableView //

@interface UITableView (KMHGenerics)
- (void)refreshWithDuration:(NSTimeInterval)animationDuration block:(nullable void (^)(void))block;
- (void)moveRowsAtIndexPaths:(nonnull NSArray <NSIndexPath *> *)indexPaths toIndexPaths:(nonnull NSArray <NSIndexPath *> *)newIndexPaths;
- (void)updateSection:(NSUInteger)section
             withData:(nonnull NSArray *)data
   insertionAnimation:(UITableViewRowAnimation)insertionAnimation
    deletionAnimation:(UITableViewRowAnimation)deletionAnimation
               getter:(nonnull NSArray * _Nonnull(^)(void))getter
               setter:(nonnull void (^)(NSArray * _Nonnull data))setter
        insertedCells:(nullable void (^)(NSArray <UITableViewCell *> * _Nonnull cells))insertionBlock
       reorderedCells:(nullable void (^)(NSArray <UITableViewCell *> * _Nonnull cells))reorderingBlock
         deletedCells:(nullable void (^)(NSArray <UITableViewCell *> * _Nonnull cells))deletionBlock
           completion:(nullable void (^)(void))completionBlock;
- (void)tapRowAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
@end

#pragma mark - // UITableViewCell //

@interface UITableViewCell (KMHGenerics)
@property (nonatomic, strong, nullable) NSIndexPath *indexPath;
+ (nonnull instancetype)cellWithReuseIdentifier:(nullable NSString *)reuseIdentifier style:(UITableViewCellStyle)style tableView:(nonnull UITableView *)tableView atIndexPath:(nonnull NSIndexPath *)indexPath fromStoryboard:(BOOL)fromStoryboard;
+ (CGFloat)defaultHeight;
@end

#pragma mark - // UITextField //

@interface UITextField (KMHGenerics)
@property (nonatomic) BOOL selectable;
- (void)selectTextInRange:(NSRange)range;
@end

#pragma mark - // UITextView //

@interface UITextView (KMHGenerics) <UITextViewDelegate>
@property (nonatomic, strong, nullable) NSString *placeholder;
- (void)showPlaceholder:(BOOL)show animated:(BOOL)animated;
@end

#pragma mark - // UIView //

@interface UIView (KMHGenerics)
@property (nonatomic) CGFloat cornerRadius;
+ (nullable instancetype)loadViewFromNibNamed:(nonnull NSString *)name withOwner:(nullable id)owner options:(nullable NSDictionary *)options;
- (nullable UIView *)firstResponder;
- (BOOL)isEventualSubviewOfView:(nonnull UIView *)view;
- (void)setFrameWithOriginX:(nullable NSNumber *)originX originY:(nullable NSNumber *)originY width:(nullable NSNumber *)width height:(nullable NSNumber *)height;
- (void)setFrameWithCenterX:(nullable NSNumber *)centerX centerY:(nullable NSNumber *)centerY width:(nullable NSNumber *)width height:(nullable NSNumber *)height;
- (void)addBorderWithColor:(nonnull CGColorRef)color width:(CGFloat)width;
- (void)addShadowWithColor:(nonnull CGColorRef)color opacity:(float)opacity radius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius offset:(CGSize)shadowOffset;
- (void)rotateFromAngle:(CGFloat)fromAngle byAngle:(CGFloat)angle withDuration:(CFTimeInterval)duration completion:(nullable void (^)(void))completion;
- (void)flipHorizontally:(CGFloat)radians withAnimations:(nullable void (^)(void))animations duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(nullable void (^)(BOOL))completion;
- (void)flipVertically:(CGFloat)radians withAnimations:(nullable void (^)(void))animations duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(nullable void (^)(BOOL))completion;
- (void)updateConstraintsWithDuration:(NSTimeInterval)duration block:(nullable void (^)(void))block;
- (BOOL)isUsingAutoLayout;
@end

#pragma mark - // UIViewController //

@interface UIViewController (KMHGenerics)
@property (nonatomic, strong, nullable) NSDictionary *info;
@property (nonatomic) BOOL isModal;
- (nullable UIViewController *)priorViewController;
- (BOOL)forceTouchIsEnabled;
- (void)performBlockOnChildViewControllers:(nonnull void (^)(UIViewController * _Nonnull childViewController))block;
- (void)presentError:(nonnull NSError *)error;
- (void)popOrDismissViewControllerAnimated:(BOOL)animated;
@end
