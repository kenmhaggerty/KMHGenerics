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

#pragma mark - // DEFINITIONS (Public) //

#define stringFromVariable(variable) (@""#variable)

#pragma mark - // KMHGenerics //

#pragma mark Public Interface

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

#pragma mark Public Interface

@interface NSArray (KMHGenerics)
@property (nonatomic, strong, nullable, readonly) id penultimateObject;
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
@end

#pragma mark - // NSData //

#pragma mark Public Interface

@interface NSData (KMHGenerics)
- (nonnull NSData *)AES256EncryptWithKey:(nonnull NSString *)key;
- (nonnull NSData *)AES256DecryptWithKey:(nonnull NSString *)key;
- (nonnull NSDictionary *)convertToDictionary;
@end

#pragma mark - // NSDate //

#pragma mark Public Interface

@interface NSDate (KMHGenerics)
- (nonnull instancetype)dateRoundedToPrecision:(NSUInteger)decimalPoints;
@end

#pragma mark - // NSDictionary //

#pragma mark Public Interface

@interface NSDictionary (KMHGenerics)
@property (nonatomic, strong, nonnull, readonly) NSSet *pathURLs;
+ (nonnull instancetype)dictionaryWithNullableObject:(nullable id)object forKey:(nonnull id <NSCopying>)key;
- (nonnull NSData *)convertToData;
@end

#pragma mark - // NSIndexSet //

#pragma mark Public Interface

@interface NSIndexSet (KMHGenerics)
@property (nonatomic, strong, nonnull, readonly) NSArray *array;
+ (nonnull instancetype)indexSetWithArray:(nonnull NSArray <NSNumber *> *)array;
@end

#pragma mark - // NSMutableArray //

#pragma mark Public Interface

@interface NSMutableArray (KMHGenerics)
- (void)removeFirstObject;
@end

#pragma mark - // NSMutableDictionary //

#pragma mark Public Interface

@interface NSMutableDictionary (KMHGenerics)
- (void)setNullableObject:(nullable id)anObject forKey:(nonnull id <NSCopying>)aKey;
@end

#pragma mark - // NSNotificationCenter //

#pragma mark Public Interface

@interface NSNotificationCenter (KMHGenerics)
+ (void)addObserver:(nonnull id)notificationObserver selector:(nonnull SEL)notificationSelector name:(nullable NSString *)notificationName object:(nullable id)notificationSender;
+ (void)removeObserver:(nonnull id)notificationObserver name:(nullable NSString *)notificationName object:(nullable id)notificationSender;
+ (void)postNotificationToMainThread:(nonnull NSString *)aName object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo;
@end

#pragma mark - // NSObject //

#pragma mark Public Interface

@interface NSObject (KMHGenerics)
- (void)setup;
- (void)teardown;
- (void)setup:(nullable void(^)(void))block;
- (void)teardown:(nullable void(^)(void))block;
- (void)swizzleMethod:(nonnull SEL)originalSelector withMethod:(nonnull SEL)swizzledSelector;
- (void)performOnceUsingToken:(nonnull id)token block:(nullable void (^)(void))block;
@end

#pragma mark - // NSOrderedSet //

#pragma mark Public Interface

@interface NSOrderedSet (KMHGenerics)
- (nonnull instancetype)orderedSetByAddingObject:(nonnull id)anObject;
- (nonnull instancetype)orderedSetByRemovingObject:(nonnull id)anObject;
- (nonnull instancetype)orderedSetBySubtractingSet:(nonnull NSSet *)set;
@end

#pragma mark - // NSSet //

#pragma mark Public Interface

@interface NSSet (KMHGenerics)
- (nonnull instancetype)setByRemovingObject:(nonnull id)anObject;
- (nonnull instancetype)setBySubtractingSet:(nonnull NSSet *)set;
- (nonnull NSSet *)setByApplyingBlock:(nullable _Nullable id (^)(_Nonnull id))block;
- (nonnull NSOrderedSet *)orderedSetUsingComparator:(nonnull NSComparator)cmptr;
- (nonnull NSArray *)sortedArrayUsingComparator:(nonnull NSComparator)cmptr;
@end

#pragma mark - // NSString //

#pragma mark Public Interface

@interface NSString (KMHGenerics)
@property (nonatomic, readonly) BOOL isEmail;
@property (nonatomic, readonly) BOOL isNumeric;
//@property (nonatomic, readonly) NSUInteger length;
+ (nonnull instancetype)randomStringWithCharacters:(nonnull NSString *)charactersString length:(NSUInteger)length;
- (nonnull instancetype)encryptedStringUsingKey:(nonnull NSString *)key;
- (nonnull instancetype)decryptedStringUsingKey:(nonnull NSString *)key;
- (BOOL)onlyContainsCharactersInSet:(nonnull NSCharacterSet *)characterSet;
@end

#pragma mark - // NSUUID //

#pragma mark Public Interface

@interface NSUUID (KMHGenerics)
+ (nonnull NSUUID *)uuidWithValidator:(nullable BOOL(^)(NSUUID * _Nonnull uuid))validationBlock;
@end

#pragma mark - // UIAlertController //

#pragma mark Public Interface

@interface UIAlertController (KMHGenerics)
+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(nullable NSArray <NSString *> *)actions preferredAction:(nullable NSString *)preferredAction dismissalText:(nullable NSString *)dismissalText completion:(nullable void(^)(UIAlertAction * _Nonnull action, NSArray <UITextField *> * _Nonnull textFields))completionBlock;
- (void)clearTextFields;
@end

#pragma mark - // UICollectionViewCell //

#pragma mark Public Interface

@interface UICollectionViewCell (KMHGenerics)
+ (nonnull instancetype)cellWithReuseIdentifier:(nullable NSString *)reuseIdentifier collectionView:(nonnull UICollectionView *)collectionView atIndexPath:(nonnull NSIndexPath *)indexPath;
@end

#pragma mark - // UIButton //

#pragma mark Public Interface

@interface UIButton (KMHGenerics)
@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong, nullable) UIImage *image;
@end

#pragma mark - // UIColor //

#pragma mark Public Interface

@interface UIColor (KMHGenerics)
+ (nonnull instancetype)iOSBlue;
@end

#pragma mark - // UIDevice //

#pragma mark Public Interface

@interface UIDevice (KMHGenerics)
@property (nonatomic, readonly) BOOL isPortrait;
@property (nonatomic, readonly) BOOL isLandscape;
@end

#pragma mark - // UIImage //

#pragma mark Public Interface

@interface UIImage (KMHGenerics)
- (nonnull instancetype)imageWithAlpha:(CGFloat)alpha;
- (nonnull instancetype)imageWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode retina:(BOOL)retina;
- (nonnull instancetype)thumbnailWithSize:(CGSize)size opaque:(BOOL)opaque;
- (nonnull instancetype)croppedImageWithFrame:(CGRect)frame;
- (nonnull instancetype)croppedImageWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;
@end

#pragma mark - // UINavigationBar //

#pragma mark Public Interface

@interface UINavigationBar (KMHGenerics)
+ (CGFloat)height;
@end

#pragma mark - // UINavigationController //

#pragma mark Public Interface

@interface UINavigationController (KMHGenerics)
@property (nonatomic, strong, nullable, readonly) UIViewController *rootViewController;
@end

#pragma mark - // UIScreen //

#pragma mark Public Interface

@interface UIScreen (KMHGenerics)
@property (nonatomic, readonly) BOOL isRetina;
@end

#pragma mark - // UIScrollView //

#pragma mark Public Interface

@interface UIScrollView (KMHGenerics)
- (void)scrollToView:(nonnull UIView *)view animated:(BOOL)animated;
@end

#pragma mark - // UISegmentedControl //

#pragma mark Public Interface

@interface UISegmentedControl (KMHGenerics)
@property (nonatomic, strong, nullable, readonly) NSString *selectedSegmentTitle;
@end

#pragma mark - // UIStoryboard //

#pragma mark Public Interface

@interface UIStoryboard (KMHGenerics)
+ (nullable UIViewController *)storyboard:(nonnull NSString *)name viewControllerWithIdentifier:(nonnull NSString *)identifier;
@end

#pragma mark - // UIStoryboardSegue //

#pragma mark Public Interface

@interface UIStoryboardSegue (KMHGenerics)
@property (nonatomic, strong, nullable, readonly) UIViewController *contentDestinationViewController;
@end

#pragma mark - // UITableView //

#pragma mark Public Interface

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

#pragma mark Public Interface

@interface UITableViewCell (KMHGenerics)
@property (nonatomic, strong, nullable) NSIndexPath *indexPath;
+ (nonnull instancetype)cellWithReuseIdentifier:(nullable NSString *)reuseIdentifier style:(UITableViewCellStyle)style tableView:(nonnull UITableView *)tableView atIndexPath:(nonnull NSIndexPath *)indexPath fromStoryboard:(BOOL)fromStoryboard;
+ (CGFloat)defaultHeight;
@end

#pragma mark - // UITextField //

#pragma mark Public Interface

@interface UITextField (KMHGenerics)
@property (nonatomic, getter=isSelectable) BOOL selectable;
- (void)selectTextInRange:(NSRange)range;
@end

#pragma mark - // UITextView //

#pragma mark Public Interface

@interface UITextView (KMHGenerics) <UITextViewDelegate>
@property (nonatomic, strong, nullable) NSString *placeholder;
- (void)showPlaceholder:(BOOL)show animated:(BOOL)animated;
@end

#pragma mark - // UIView //

#pragma mark Public Interface

@interface UIView (KMHGenerics)
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic, strong, nullable, readonly) UIView *firstResponder;
@property (nonatomic, readonly) BOOL isUsingAutoLayout;
+ (nullable instancetype)loadViewFromNibNamed:(nonnull NSString *)name withOwner:(nullable id)owner options:(nullable NSDictionary *)options;
- (BOOL)isEventualSubviewOfView:(nonnull UIView *)view;
- (void)setFrameWithOriginX:(nullable NSNumber *)originX originY:(nullable NSNumber *)originY width:(nullable NSNumber *)width height:(nullable NSNumber *)height;
- (void)setFrameWithCenterX:(nullable NSNumber *)centerX centerY:(nullable NSNumber *)centerY width:(nullable NSNumber *)width height:(nullable NSNumber *)height;
- (void)addBorderWithColor:(nonnull CGColorRef)color width:(CGFloat)width;
- (void)addShadowWithColor:(nonnull CGColorRef)color opacity:(float)opacity radius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius offset:(CGSize)shadowOffset;
- (void)rotateFromAngle:(CGFloat)fromAngle byAngle:(CGFloat)angle withDuration:(CFTimeInterval)duration completion:(nullable void (^)(void))completion;
- (void)flipHorizontally:(CGFloat)radians withAnimations:(nullable void (^)(void))animations duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(nullable void (^)(BOOL))completion;
- (void)flipVertically:(CGFloat)radians withAnimations:(nullable void (^)(void))animations duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(nullable void (^)(BOOL))completion;
- (void)updateConstraintsWithDuration:(NSTimeInterval)duration block:(nullable void (^)(void))block completion:(nullable void (^)(BOOL finished))completionBlock;
- (void)removeAllSubviews;
- (void)addConstraintsToCenterSubview:(nonnull UIView *)subview;
- (void)addConstraintsToScaleSubview:(nonnull UIView *)subview withMultiplier:(CGFloat)multiplier;
@end

#pragma mark - // UIViewController //

#pragma mark Public Interface

@interface UIViewController (KMHGenerics)
@property (nonatomic, strong, nullable) NSMutableDictionary *userInfo;
@property (nonatomic) BOOL isModal;
@property (nonatomic, readonly) BOOL isVisible;
@property (nonatomic, strong, nullable, readonly) UIViewController *priorViewController;
@property (nonatomic, readonly) BOOL forceTouchIsEnabled;
- (void)performBlockOnChildViewControllers:(nonnull void (^)(UIViewController * _Nonnull childViewController))block;
- (void)presentError:(nonnull NSError *)error;
- (void)popOrDismissViewControllerAnimated:(BOOL)animated;
@end

#pragma mark - // UIWindow //

#pragma mark Public Interface

@interface UIWindow (KMHGenerics)
@property (nonatomic, strong, nonnull, readonly) NSArray <UIViewController *> *visibleViewControllers;
@end
