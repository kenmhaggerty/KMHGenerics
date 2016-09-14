//
//  KMHGenerics.m
//  KMHGenerics
//
//  Created by Ken M. Haggerty on 7/4/16.
//  Copyright (c) 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "KMHGenerics.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>

#pragma mark - // DEFINITIONS (Private) //

NSString * _Nonnull const NOTIFICATION_OBJECT_KEY = @"kNotificationUserInfo_Object";

@interface KMHGenerics ()
CGImageRef CGImageRotated(CGImageRef originalCGImage, double radians);
@end

#pragma mark - // IMPLEMENTATION (KMHGenerics) //

@implementation KMHGenerics

#pragma mark Public Methods

+ (BOOL)object:(nullable id)object1 isEqualToObject:(nullable id)object2 {
    // nil == nil
    if (!object1 && !object2) {
        return YES;
    }
    
    // nil != non-nil
    if (!object1 || !object2) {
        return NO;
    }
    
    // NSArray
    if ([object1 isKindOfClass:[NSArray class]] && [object2 isKindOfClass:[NSArray class]]) {
        return [object1 isEqualToArray:object2];
    }
    
    // NSAttributedString
    if ([object1 isKindOfClass:[NSAttributedString class]] && [object2 isKindOfClass:[NSAttributedString class]]) {
        return [object1 isEqualToAttributedString:object2];
    }
    
    // NSData
    if ([object1 isKindOfClass:[NSData class]] && [object2 isKindOfClass:[NSData class]]) {
        return [object1 isEqualToData:object2];
    }
    
    // NSDate
    if ([object1 isKindOfClass:[NSDate class]] && [object2 isKindOfClass:[NSDate class]]) {
        return [object1 isEqualToDate:object2];
    }
    
    // NSDictionary
    if ([object1 isKindOfClass:[NSDictionary class]] && [object2 isKindOfClass:[NSDictionary class]]) {
        return [object1 isEqualToDictionary:object2];
    }
    
    // NSHashTable
    if ([object1 isKindOfClass:[NSHashTable class]] && [object2 isKindOfClass:[NSHashTable class]]) {
        return [object1 isEqualToHashTable:object2];
    }
    
    // NSIndexPath
    if ([object1 isKindOfClass:[NSIndexPath class]] && [object2 isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath *indexPath1 = (NSIndexPath *)object1;
        NSIndexPath *indexPath2 = (NSIndexPath *)object2;
        return ((indexPath1.section == indexPath2.section) && ((indexPath1.row == indexPath2.row) || (indexPath1.item == indexPath2.item)));
    }
    
    // NSIndexSet
    if ([object1 isKindOfClass:[NSIndexSet class]] && [object2 isKindOfClass:[NSIndexSet class]]) {
        return [object1 isEqualToIndexSet:object2];
    }
    
    // NSNumber
    if ([object1 isKindOfClass:[NSNumber class]] && [object2 isKindOfClass:[NSNumber class]]) {
        return [object1 isEqualToNumber:object2];
    }
    
    // NSOrderedSet
    if ([object1 isKindOfClass:[NSOrderedSet class]] && [object2 isKindOfClass:[NSOrderedSet class]]) {
        return [object1 isEqualToOrderedSet:object2];
    }
    
    // NSSet
    if ([object1 isKindOfClass:[NSSet class]] && [object2 isKindOfClass:[NSSet class]]) {
        return [object1 isEqualToSet:object2];
    }
    
    // NSString
    if ([object1 isKindOfClass:[NSString class]] && [object2 isKindOfClass:[NSString class]]) {
        return [object1 isEqualToString:object2];
    }
    
    // NSTimeZone
    if ([object1 isKindOfClass:[NSTimeZone class]] && [object2 isKindOfClass:[NSTimeZone class]]) {
        return [object1 isEqualToTimeZone:object2];
    }
    
    // NSValue
    if ([object1 isKindOfClass:[NSValue class]] && [object2 isKindOfClass:[NSValue class]]) {
        return [object1 isEqualToValue:object2];
    }
    
    return [object1 isEqual:object2];
}

+ (nullable UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (nonnull UIWindow *)fullscreenWindow {
    return [UIApplication sharedApplication].delegate.window;
}

+ (void)incrementBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
}

+ (void)decrementBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber-1;
}

+ (void)setBadgeToCount:(NSUInteger)count {
    [UIApplication sharedApplication].applicationIconBadgeNumber = count;
}

+ (nullable id)valueForBool:(BOOL)boolValue yesValue:(nullable id)yesValue noValue:(nullable id)noValue {
    if (boolValue) {
        return yesValue;
    }
    
    return noValue;
}

+ (nullable NSString *)pluralizationForCount:(NSUInteger)count singular:(nullable NSString *)singular plural:(nullable NSString *)plural {
    if (count == 1) {
        return singular;
    }
    
    return plural;
}

+ (nullable NSNumber *)angleForDeviceOrientation:(UIDeviceOrientation)orientation {
    switch (orientation) {
        case UIDeviceOrientationLandscapeRight:
            return [NSNumber numberWithFloat:3.0f*M_PI_2];
        case UIDeviceOrientationPortraitUpsideDown:
            return [NSNumber numberWithFloat:M_PI];
        case UIDeviceOrientationLandscapeLeft:
            return [NSNumber numberWithFloat:M_PI_2];
        case UIDeviceOrientationPortrait:
            return [NSNumber numberWithFloat:0.0f];
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            return nil;
    }
}

+ (nullable NSNumber *)angleForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return [NSNumber numberWithFloat:3.0f*M_PI_2];
        case UIInterfaceOrientationPortraitUpsideDown:
            return [NSNumber numberWithFloat:M_PI];
        case UIInterfaceOrientationLandscapeRight:
            return [NSNumber numberWithFloat:M_PI_2];
        case UIInterfaceOrientationPortrait:
            return [NSNumber numberWithFloat:0.0f];
        case UIInterfaceOrientationUnknown:
            return nil;
    }
}

+ (CGFloat)angleForImageOrientation:(UIImageOrientation)orientation {
    switch (orientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            return 3.0f*M_PI_2;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            return M_PI;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            return M_PI_2;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            return 0.f;
    }
}

+ (AVCaptureVideoOrientation)convertInterfaceOrientationToVideoOrientation:(UIInterfaceOrientation)interfaceOrientation {
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationUnknown:
            return 0.0;
    }
}

+ (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

+ (nonnull NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (BOOL)frontCameraCanTakePhoto {
    return [KMHGenerics cameraCanTakePhoto:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)frontCameraCanTakeVideo {
    return [KMHGenerics cameraCanTakeVideo:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)frontCameraHasFlash {
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)rearCameraCanTakePhoto {
    return [KMHGenerics cameraCanTakePhoto:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL)rearCameraCanTakeVideo {
    return [KMHGenerics cameraCanTakeVideo:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL)rearCameraHasFlash {
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL)canAccessCameraRoll {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

+ (BOOL)canAccessPhotoLibrary {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark Private Methods

CGImageRef CGImageRotated(CGImageRef originalCGImage, double radians) {
    CGSize imageSize = CGSizeMake(CGImageGetWidth(originalCGImage), CGImageGetHeight(originalCGImage));
    CGSize rotatedSize = imageSize;
    if (ABS(radians) == M_PI_2) {
        rotatedSize = CGSizeMake(imageSize.height, imageSize.width);
    }
    
    double rotatedCenterX = rotatedSize.width*0.5f;
    double rotatedCenterY = rotatedSize.height*0.5f;
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, 1.0f);
    CGContextRef rotatedContext = UIGraphicsGetCurrentContext();
    if ((radians == 0.0f) || (radians == M_PI)) {
        CGContextTranslateCTM(rotatedContext, rotatedCenterX, rotatedCenterY);
        if (radians == 0.0f) {
            CGContextScaleCTM(rotatedContext, 1.0f, -1.0f);
        }
        else {
            CGContextScaleCTM(rotatedContext, -1.0f, 1.0f);
        }
        CGContextTranslateCTM(rotatedContext, -1.0f*rotatedCenterX, -1.0f*rotatedCenterY);
    }
    else if (ABS(radians) == M_PI_2) {
        CGContextTranslateCTM(rotatedContext, rotatedCenterX, rotatedCenterY);
        CGContextRotateCTM(rotatedContext, radians);
        CGContextScaleCTM(rotatedContext, 1.0f, -1.0f);
        CGContextTranslateCTM(rotatedContext, -1.0f*rotatedCenterY, -1.0f*rotatedCenterX);
    }
    
    CGRect drawingRect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    CGContextDrawImage(rotatedContext, drawingRect, originalCGImage);
    CGImageRef rotatedCGImage = CGBitmapContextCreateImage(rotatedContext);
    UIGraphicsEndImageContext();
    return rotatedCGImage;
}

+ (BOOL)cameraCanTakePhoto:(UIImagePickerControllerCameraDevice)camera {
    NSArray *captureModes = [UIImagePickerController availableCaptureModesForCameraDevice:camera];
    NSNumber *photoMode = @(UIImagePickerControllerCameraCaptureModePhoto);
    return [captureModes containsObject:photoMode];
}

+ (BOOL)cameraCanTakeVideo:(UIImagePickerControllerCameraDevice)camera {
    NSArray *captureModes = [UIImagePickerController availableCaptureModesForCameraDevice:camera];
    NSNumber *photoMode = @(UIImagePickerControllerCameraCaptureModeVideo);
    return [captureModes containsObject:photoMode];
}

+ (NSArray <NSString *> *)arrayForMediaType:(KMHMediaType)mediaType {
    switch (mediaType) {
        case KMHMediaTypeNone:
            return @[];
        case KMHMediaTypeImage:
            return @[(NSString *)kUTTypeImage];
        case KMHMediaTypeVideo:
            return @[(NSString *)kUTTypeMovie];
        case KMHMediaTypeImageAndVideo:
            return @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
    }
}

+ (KMHMediaType)returnAvailableMediaTypesForRequestedCameraType:(KMHCameraType)cameraType andMediaType:(KMHMediaType)mediaType {
    KMHMediaType availableMediaTypes = KMHMediaTypeNone;
    BOOL checkForImage = [KMHGenerics mediaType:mediaType includesMediaType:KMHMediaTypeImage];
    BOOL checkForVideo = [KMHGenerics mediaType:mediaType includesMediaType:KMHMediaTypeVideo];
    if ([KMHGenerics cameraType:cameraType includesCameraType:KMHCameraTypeFront]) {
        if (checkForImage && [KMHGenerics frontCameraCanTakePhoto]) {
            availableMediaTypes = [KMHGenerics mediaTypeByAddingMediaType:KMHMediaTypeImage toMediaType:availableMediaTypes];
        }
        if (checkForVideo && [KMHGenerics frontCameraCanTakeVideo]) {
            availableMediaTypes = [KMHGenerics mediaTypeByAddingMediaType:KMHMediaTypeVideo toMediaType:availableMediaTypes];
        }
    }
    if ([KMHGenerics cameraType:cameraType includesCameraType:KMHCameraTypeRear]) {
        if (checkForImage && [KMHGenerics rearCameraCanTakePhoto]) {
            availableMediaTypes = [KMHGenerics mediaTypeByAddingMediaType:KMHMediaTypeImage toMediaType:availableMediaTypes];
        }
        if (checkForVideo && [KMHGenerics rearCameraCanTakeVideo]) {
            availableMediaTypes = [KMHGenerics mediaTypeByAddingMediaType:KMHMediaTypeVideo toMediaType:availableMediaTypes];
        }
    }
    
    return availableMediaTypes;
}

+ (BOOL)mediaType:(KMHMediaType)mediaType includesMediaType:(KMHMediaType)targetMediaType {
    if ((targetMediaType == KMHMediaTypeNone) || (mediaType == targetMediaType)) {
        return YES;
    }
    
    if (targetMediaType != KMHMediaTypeImageAndVideo) {
        return (mediaType == KMHMediaTypeImageAndVideo);
    }
    
    return NO;
}

+ (BOOL)cameraType:(KMHCameraType)cameraType includesCameraType:(KMHCameraType)targetCameraType {
    if ((targetCameraType == KMHCameraTypeNone) || (cameraType == targetCameraType)) {
        return YES;
    }
    
    if (targetCameraType != KMHCameraTypeFrontOrRear) {
        return (cameraType == KMHCameraTypeFrontOrRear);
    }
    
    return NO;
}

+ (KMHMediaType)mediaTypeByAddingMediaType:(KMHMediaType)mediaType toMediaType:(KMHMediaType)baseMediaType {
    if ((baseMediaType == KMHMediaTypeImageAndVideo) || (mediaType == KMHMediaTypeNone) || (mediaType == baseMediaType)) {
        return baseMediaType;
    }
    
    if ((baseMediaType == KMHMediaTypeNone) || (mediaType == KMHMediaTypeImageAndVideo)) {
        return mediaType;
    }
    
    return KMHMediaTypeImageAndVideo;
}

+ (KMHImageLibraryType)returnAvailableImageLibraryTypesForRequestedLibraryType:(KMHImageLibraryType)libraryType {
    if (libraryType == KMHImageLibraryNone) {
        return KMHImageLibraryNone;
    }
    
    BOOL cameraRoll = [KMHGenerics canAccessCameraRoll];
    BOOL photoLibrary = [KMHGenerics canAccessPhotoLibrary];
    if (!cameraRoll && !photoLibrary) {
        return KMHImageLibraryNone;
    }
    
    if ((libraryType == KMHImageLibraryCameraRoll) || (!photoLibrary)) {
        return KMHImageLibraryCameraRoll;
    }
    
    return KMHImageLibraryPhotoLibrary;
}

@end

#pragma mark - // IMPLEMENTATION (NSArray) //

@implementation NSArray (KMHGenerics)

#pragma mark Public Methods

+ (nonnull instancetype)arrayWithNullableObject:(id)anObject {
    if (anObject) {
        return @[anObject];
    }
    
    return [NSArray array];
}

+ (nonnull instancetype)arrayWithNullableObjects:(nullable id)firstObj, ... {
    NSMutableArray *array = [NSMutableArray array];
    va_list objs;
    va_start(objs, firstObj);
    for (id obj = firstObj; obj != nil; obj = va_arg(objs, id)) {
        [array addObject:obj];
    }
    va_end(objs);
    return [NSArray arrayWithArray:array];
}

+ (nonnull instancetype)arrayWithValue:(float)value increment:(float)increment length:(NSUInteger)length {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [array addObject:[NSNumber numberWithFloat:value+i*increment]];
    }
    return [[self class] arrayWithArray:array];
}

+ (nonnull instancetype)arrayWithStartValue:(NSInteger)startValue endValue:(NSUInteger)endValue {
    if (startValue == endValue) {
        return [[self class] arrayWithObject:[NSNumber numberWithInteger:startValue]];
    }
    
    NSUInteger increment = (startValue < endValue) ? 1 : -1;
    NSUInteger count = ABS(endValue-startValue);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        [array addObject:[NSNumber numberWithInteger:startValue+i*increment]];
    }
    return [[self class] arrayWithArray:array];
}

+ (nonnull instancetype)arrayWithLength:(NSUInteger)length block:(nonnull id _Nonnull (^)(NSUInteger index))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [array addObject:block(i)];
    }
    return [[self class] arrayWithArray:array];
}

- (nonnull instancetype)arrayByInsertingObject:(nonnull id)anObject atIndex:(NSUInteger)index {
    NSMutableArray *array = [self mutableCopy];
    [array insertObject:anObject atIndex:index];
    return [NSArray arrayWithArray:array];
}

- (nonnull instancetype)arrayByRemovingLastObject {
    NSMutableArray *array = [self mutableCopy];
    [array removeLastObject];
    return [NSArray arrayWithArray:array];
}

- (nonnull instancetype)arrayFromIndex:(NSUInteger)index {
    if (index == 0) {
        return [self copy];
    }
    
    return [self arrayByRemovingObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index-1)]];
}

- (nonnull instancetype)arrayByRemovingObjectsFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex {
    return [self arrayByRemovingObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, toIndex-index+1)]];
}

- (nonnull instancetype)arrayByRemovingObject:(nonnull id)anObject {
    NSMutableArray *array = [self mutableCopy];
    [array removeObject:anObject];
    return [NSArray arrayWithArray:array];
}

- (nonnull instancetype)arrayByRemovingObjectsInArray:(nonnull NSArray *)otherArray {
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectsInArray:otherArray];
    return [NSArray arrayWithArray:array];
}

- (nonnull instancetype)arrayByRemovingObjectsAtIndexes:(nonnull NSIndexSet *)indexSet {
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectsAtIndexes:indexSet];
    return [NSArray arrayWithArray:array];
}

- (nonnull instancetype)arrayByRemovingObjectsNotInArray:(nonnull NSArray *)otherArray {
    NSMutableArray *array = [self mutableCopy];
    for (id object in array) {
        if (![otherArray containsObject:object]) {
            [array removeObject:object];
        }
    }
    return [NSArray arrayWithArray:array];
}

- (nonnull instancetype)sortedArray:(BOOL)ascending {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NSNumber *value1 = [NSArray sortValueForObject:obj1];
        NSNumber *value2 = [NSArray sortValueForObject:obj2];
        
        if (value1 && value2) {
            return ascending ? [value1 compare:value2] : [value2 compare:value1];
        }
        
        if (value1 && !value2) {
            return NSOrderedAscending;
        }
        
        if (!value1 && value2) {
            return NSOrderedDescending;
        }
        
        NSString *string1 = [NSArray sortStringForObject:obj1];
        NSString *string2 = [NSArray sortStringForObject:obj2];
        
        if (string1 && string2) {
            return ascending ? [string1 compare:string2] : [string2 compare:string1];
        }
        
        if (string1 && !string2) {
            return NSOrderedAscending;
        }
        
        if (!string1 && string2) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
}

- (void)compareToArray:(nonnull NSArray *)newArray andGenerateIndexPathsToInsert:(NSArray *__autoreleasing _Nonnull * _Nonnull)indexPaths withSection:(NSUInteger)section {
    
    NSMutableArray <NSIndexPath *> *indexPathsToInsert = [NSMutableArray array];
    NSArray *subarray;
    id object;
    for (int i = 0; i < newArray.count; i++) {
        subarray = [newArray subarrayWithRange:NSMakeRange(0, i+1)];
        object = newArray[i];
        if (([self countObject:object] < [subarray countObject:object])) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    
    *indexPaths = [NSArray arrayWithArray:indexPathsToInsert];
}

- (void)compareToArray:(nonnull NSArray *)newArray andGenerateIndexPaths:(NSArray * _Nonnull * _Nonnull)indexPaths toMoveToIndexPaths:(NSArray * _Nonnull * _Nonnull)newIndexPaths withSection:(NSUInteger)section {
    
    NSCountedSet *oldSet = [NSCountedSet setWithArray:self];
    NSCountedSet *newSet = [NSCountedSet setWithArray:newArray];
    NSAssert([oldSet isEqualToSet:newSet], @"arrays do not contain identical objects");
    
    NSMutableArray *fromIndexPaths = [NSMutableArray array];
    NSMutableArray *toIndexPaths = [NSMutableArray array];
    
    id object;
    NSArray <NSNumber *> *indices;
    NSArray *subarray;
    NSUInteger count, newIndex;
    for (int i = 0; i < self.count; i++) {
        object = self[i];
        indices = [newArray indexesOfObject:object].array;
        subarray = [self subarrayWithRange:NSMakeRange(0, i+1)];
        count = [subarray countObject:object];
        newIndex = indices[count-1].integerValue;
        if (i != newIndex) {
            [fromIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            [toIndexPaths addObject:[NSIndexPath indexPathForRow:newIndex inSection:section]];
        }
    }
    
    *indexPaths = [NSArray arrayWithArray:fromIndexPaths];
    *newIndexPaths = [NSArray arrayWithArray:toIndexPaths];
}

- (void)compareToArray:(nonnull NSArray *)newArray andGenerateIndexPathsToDelete:(NSArray *__autoreleasing  _Nonnull * _Nonnull)indexPaths withSection:(NSUInteger)section {
    
    [newArray compareToArray:self andGenerateIndexPathsToInsert:indexPaths withSection:section];
}

- (NSUInteger)countObject:(nonnull id)object {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id _Nonnull evaluatedObject, NSDictionary <NSString *, id> * _Nullable bindings) {
        return [evaluatedObject isEqual:object];
    }]].count;
}

- (nonnull NSIndexSet *)indexesOfObject:(nonnull id)anObject {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < self.count; i++) {
        if ([self[i] isEqual:anObject]) {
            [indexSet addIndex:i];
        }
    }
    return indexSet;
}

#pragma mark Private Methods

+ (NSNumber *)sortValueForObject:(id _Nonnull)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)obj;
        if (string.isNumeric) {
            return [NSNumber numberWithFloat:string.floatValue];
        }
    }
    
    return nil;
}

+ (NSString *)sortStringForObject:(id _Nonnull)obj {
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSAttributedString class]]) {
        NSAttributedString *attributedString = (NSAttributedString *)obj;
        return attributedString.string;
    }
    
    return nil;
}

@end

#pragma mark - // IMPLEMENTATION (NSData) //

#pragma mark Imports

#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (KMHGenerics)

#pragma mark Public Methods

// I believe this came from this StackOverflow post:
// http://stackoverflow.com/questions/9794383/aes256-decryption-issue-in-objective-c
- (nonnull instancetype)AES256EncryptWithKey:(nonnull NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [[self class] dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

// I believe this came from this StackOverflow post:
// http://stackoverflow.com/questions/9794383/aes256-decryption-issue-in-objective-c
- (nonnull instancetype)AES256DecryptWithKey:(nonnull NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [[self class] dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (nonnull NSDictionary *)convertToDictionary {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self];
}

@end

#pragma mark - // IMPLEMENTATION (NSDate) //

@implementation NSDate (KMHGenerics)

#pragma mark Public Methods

- (nonnull instancetype)dateRoundedToPrecision:(NSUInteger)decimalPoints {
    NSTimeInterval timeInterval = self.timeIntervalSince1970;
    NSTimeInterval expandedTimeInterval = timeInterval*powl(10, decimalPoints);
    NSTimeInterval roundedTimeInterval = round(expandedTimeInterval);
    NSMutableString *stringTimeInterval = [NSMutableString stringWithFormat:@"%.f", roundedTimeInterval];
    [stringTimeInterval insertString:@"." atIndex:stringTimeInterval.length-decimalPoints];
    NSDecimalNumber *decimalTimeInterval = [NSDecimalNumber decimalNumberWithString:stringTimeInterval];
    double doubleTimeInterval = decimalTimeInterval.doubleValue;
    return [[self class] dateWithTimeIntervalSince1970:doubleTimeInterval];
}

@end

#pragma mark - // IMPLEMENTATION (NSDictionary) //

@implementation NSDictionary (KMHGenerics)

#pragma mark Public Methods

+ (nonnull instancetype)dictionaryWithNullableObject:(nullable id)object forKey:(nonnull id <NSCopying>)key {
    if (!object) {
        return [[self class] dictionary];
    }
    
    return [[self class] dictionaryWithObject:object forKey:key];
}

- (nonnull NSSet *)pathURLs {
    NSMutableSet *pathURLs = [NSMutableSet set];
    NSMutableArray *keyArrays = [NSMutableArray arrayWithCapacity:self.allKeys.count];
    for (NSString *key in self.allKeys) {
        [keyArrays addObject:@[key]];
    }
    NSArray *keyArray, *subkeyArray;
    id child;
    NSDictionary *dictionary;
    NSURL *pathURL;
    while (keyArrays.count) {
        keyArray = keyArrays.firstObject;
        child = self;
        for (int i = 0; i < keyArray.count; i++) {
            child = child[keyArray[i]];
        }
        if ([child isKindOfClass:[NSDictionary class]]) {
            dictionary = (NSDictionary *)child;
            if (dictionary.allKeys.count) {
                for (NSString *subkey in dictionary.allKeys) {
                    subkeyArray = [keyArray arrayByAddingObject:subkey];
                    [keyArrays addObject:subkeyArray];
                }
            }
            else {
                pathURL = [NSURL fileURLWithPathComponents:keyArray];
                [pathURLs addObject:pathURL];
            }
        }
        else {
            pathURL = [NSURL fileURLWithPathComponents:keyArray];
            [pathURLs addObject:pathURL];
        }
        [keyArrays removeObject:keyArray];
    }
    return [NSSet setWithSet:pathURLs];
}

- (nonnull NSData *)convertToData {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end

#pragma mark - // IMPLEMENTATION (NSIndexSet) //

@implementation NSIndexSet (KMHGenerics)

+ (nonnull instancetype)indexSetWithArray:(nonnull NSArray <NSNumber *> *)array {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSNumber *indexValue in array) {
        [indexSet addIndex:indexValue.integerValue];
    }
    return indexSet;
}

- (nonnull NSArray *)array {
    NSMutableArray *array = [NSMutableArray array];
    [self enumerateIndexesUsingBlock:^(NSUInteger index, BOOL * _Nonnull stop) {
        [array addObject:@(index)];
    }];
    return [array sortedArray:YES];
}

@end

#pragma mark - // IMPLEMENTATION (NSMutableDictionary) //

@implementation NSMutableDictionary (KMHGenerics)

#pragma mark Public Methods

- (void)setNullableObject:(nullable id)anObject forKey:(nonnull id <NSCopying>)aKey {
    if (!anObject) {
        return;
    }
    
    [self setObject:anObject forKey:aKey];
}

@end

#pragma mark - // IMPLEMENTATION (NSNotificationCenter) //

@implementation NSNotificationCenter (KMHGenerics)

#pragma mark - Public Methods

+ (void)addObserver:(nonnull id)notificationObserver selector:(nonnull SEL)notificationSelector name:(nullable NSString *)notificationName object:(nullable id)notificationSender {
    [[NSNotificationCenter defaultCenter] addObserver:notificationObserver selector:notificationSelector name:notificationName object:notificationSender];
}

+ (void)removeObserver:(nonnull id)notificationObserver name:(nullable NSString *)notificationName object:(nullable id)notificationSender {
    [[NSNotificationCenter defaultCenter] removeObserver:notificationObserver name:notificationName object:notificationSender];
}

+ (void)postNotificationToMainThread:(nonnull NSString *)aName object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo {
    if ([NSThread isMainThread]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:aName object:object userInfo:userInfo];
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:aName object:object userInfo:userInfo];
    });
}

@end

#pragma mark - // IMPLEMENTATION (NSObject) //

@implementation NSObject (KMHGenerics)

#pragma mark Setters and Getters

- (void)setSetupComplete:(BOOL)setupComplete {
    objc_setAssociatedObject(self, @selector(setupComplete), @(setupComplete), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)setupComplete {
    NSNumber *setupCompleteValue = objc_getAssociatedObject(self, @selector(setupComplete));
    if (setupCompleteValue) {
        return setupCompleteValue.boolValue;
    }
    
    self.setupComplete = NO;
    return self.setupComplete;
}

- (void)setTeardownComplete:(BOOL)teardownComplete {
    objc_setAssociatedObject(self, @selector(teardownComplete), @(teardownComplete), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)teardownComplete {
    NSNumber *teardownCompleteValue = objc_getAssociatedObject(self, @selector(teardownComplete));
    if (teardownCompleteValue) {
        return teardownCompleteValue.boolValue;
    }
    
    self.teardownComplete = NO;
    return self.teardownComplete;
}

#pragma mark Public Methods

- (void)setup {
    [self setup:nil];
}

- (void)teardown {
    [self teardown:nil];
}

- (void)setup:(nullable void(^)(void))block {
    if (self.setupComplete) {
        return;
    }
    
    if (block) {
        block();
    }
    self.setupComplete = YES;
}

- (void)teardown:(nullable void(^)(void))block {
    if (self.teardownComplete) {
        return;
    }
    
    if (block) {
        block();
    }
    self.teardownComplete = YES;
}

#pragma mark Private Methods

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

#pragma mark - // IMPLEMENTATION (NSOrderedSet) //

@implementation NSOrderedSet (KMHGenerics)

#pragma mark Public Methods

- (nonnull instancetype)orderedSetByRemovingObject:(nonnull id)anObject {
    NSMutableOrderedSet *mutableOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self];
    [mutableOrderedSet removeObject:anObject];
    return [[self class] orderedSetWithOrderedSet:mutableOrderedSet];
}

- (nonnull instancetype)orderedSetBySubtractingSet:(nonnull NSSet *)set {
    NSMutableOrderedSet *mutableOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self];
    [mutableOrderedSet minusSet:set];
    return [[self class] orderedSetWithOrderedSet:mutableOrderedSet];
}

@end

#pragma mark - // IMPLEMENTATION (NSSet) //

@implementation NSSet (KMHGenerics)

#pragma mark Public Methods

- (nonnull instancetype)setByRemovingObject:(nonnull id)anObject {
    NSMutableSet *mutableSet = [NSMutableSet setWithSet:self];
    [mutableSet removeObject:anObject];
    return [[self class] setWithSet:mutableSet];
}

- (nonnull instancetype)setBySubtractingSet:(nonnull NSSet *)set {
    NSMutableSet *mutableSet = [NSMutableSet setWithSet:self];
    [mutableSet minusSet:set];
    return [[self class] setWithSet:mutableSet];
}

- (nonnull instancetype)setByApplyingBlock:(nonnull _Nonnull id (^)(_Nonnull id))block {
    NSMutableSet *set = [NSMutableSet set];
    for (id object in self) {
        [set addObject:block(object)];
    }
    return [NSSet setWithSet:set];
}

- (nonnull NSOrderedSet *)orderedSetUsingComparator:(nonnull NSComparator)cmptr {
    NSArray *array = [self sortedArrayUsingComparator:cmptr];
    return [NSOrderedSet orderedSetWithArray:array];
}

- (nonnull NSArray *)sortedArrayUsingComparator:(nonnull NSComparator)cmptr {
    NSArray *array = [self allObjects];
    return [array sortedArrayUsingComparator:cmptr];
}

@end

#pragma mark - // IMPLEMENTATION (NSString) //

@implementation NSString (KMHGenerics)

#pragma mark Public Methods

+ (nonnull instancetype)randomStringWithCharacters:(nonnull NSString *)charactersString length:(NSUInteger)length {
    NSMutableString *randomString = [[NSMutableString alloc] initWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [charactersString characterAtIndex:(arc4random() % charactersString.length)]];
    }
    return [[self class] stringWithString:randomString];
}

- (BOOL)isEmail {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange range = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)].range;
    return (range.length > 0);
}

- (BOOL)isNumeric {
    return [[NSCharacterSet decimalDigitCharacterSet] isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:self]];
}

- (nonnull instancetype)encryptedStringUsingKey:(nonnull NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    data = [data AES256EncryptWithKey:key];
    return [data base64EncodedStringWithOptions:0];
}

- (nonnull instancetype)decryptedStringUsingKey:(nonnull NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    data = [data AES256DecryptWithKey:key];
    return [[[self class] alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSUInteger)length {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet nonBaseCharacterSet];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet controlCharacterSet]];
    return [[self componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""].length;
}

- (BOOL)onlyContainsCharactersInSet:(nonnull NSCharacterSet *)characterSet {
    return [KMHGenerics object:self isEqualToObject:[[self componentsSeparatedByCharactersInSet:characterSet.invertedSet] componentsJoinedByString:@""]];
}

@end

#pragma mark - // IMPLEMENTATION (UIAlertController) //

@implementation UIAlertController (KMHGenerics)

#pragma mark Public Methods

+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(nullable NSArray <NSString *> *)actions preferredAction:(nullable NSString *)preferredAction dismissalText:(nullable NSString *)dismissalText completion:(nullable void(^)(UIAlertAction * _Nonnull action, NSArray <UITextField *> * _Nonnull textFields))completionBlock {
    UIAlertController *alertController = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (dismissalText || !actions) {
        [alertController addAction:[UIAlertAction actionWithTitle:(dismissalText ?: @"Dismiss") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController clearTextFields];
        }]];
    }
    if (actions) {
        UIAlertAction *alertAction;
        for (NSString *title in actions) {
            alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (completionBlock) {
                    completionBlock(action, alertController.textFields);
                }
            }];
            [alertController addAction:alertAction];
            if ([title isEqualToString:preferredAction]) {
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0f) {
                    ((UIAlertController *)alertController).preferredAction = alertAction;
                }
            }
        }
    }
    return alertController;
}

- (void)clearTextFields {
    for (UITextField *textField in self.textFields) {
        textField.text = nil;
    }
}

@end

#pragma mark - // IMPLEMENTATION (UIButton) //

@implementation UIButton (KMHGenerics)

#pragma mark Public Methods

- (void)setText:(nullable NSString *)text {
    [self setTitle:text forState:UIControlStateNormal];
    [self setTitle:text forState:UIControlStateHighlighted];
    [self setTitle:text forState:UIControlStateDisabled];
    [self setTitle:text forState:UIControlStateSelected];
    [self setTitle:text forState:UIControlStateFocused];
}

- (nullable NSString *)text {
    return [self titleForState:self.state];
}

- (void)setImage:(nullable UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateDisabled];
    [self setImage:image forState:UIControlStateSelected];
    [self setImage:image forState:UIControlStateFocused];
}

- (nullable UIImage *)image {
    return [self imageForState:self.state];
}

@end

#pragma mark - // IMPLEMENTATION (UICollectionViewCell) //

@implementation UICollectionViewCell (KMHGenerics)

#pragma mark Public Methods

+ (nonnull instancetype)cellWithReuseIdentifier:(nullable NSString *)reuseIdentifier collectionView:(nonnull UICollectionView *)collectionView atIndexPath:(nonnull NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];;
}

@end

#pragma mark - // IMPLEMENTATION (UIColor) //

@implementation UIColor (KMHGenerics)

#pragma mark Public Methods

+ (nonnull instancetype)iOSBlue {
    return [[self class] colorWithHue:0.58692810457516342 saturation:1.0 brightness:1.0f alpha:1.0f];
}

@end

#pragma mark - // IMPLEMENTATION (UIImage) //

@implementation UIImage (KMHGenerics)

#pragma mark Public Methods

- (nonnull instancetype)imageWithAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (nonnull instancetype)thumbnailWithSize:(CGSize)size opaque:(BOOL)opaque {
    CGRect cropRect;
    CGFloat newDimension;
    if (self.size.width/self.size.height < size.width/size.height) {
        newDimension = self.size.width*(size.height/size.width);
        cropRect = CGRectMake(0.0, (self.size.height-newDimension)/2.0, self.size.width, newDimension);
    }
    else {
        newDimension = self.size.height*(size.width/size.height);
        cropRect = CGRectMake((self.size.width-newDimension)/2.0, 0.0, newDimension, self.size.height);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0);
    [[UIImage imageWithCGImage:imageRef] drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return thumbnail;
}

- (nonnull instancetype)croppedImageWithFrame:(CGRect)frame {
    CGImageRef imageRef = CGImageRotated([self CGImage], M_PI_2);
    imageRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-frame.origin.y));
    id croppedImage = [[self class] imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

@end

#pragma mark - // IMPLEMENTATION (UIImageView) //

NSString * _Nonnull const UIImageViewImageDidChangeNotification = @"kUIImageViewImageDidChangeNotification";

@implementation UIImageView (KMHGenerics)

#pragma mark Private Methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setImage:) withMethod:@selector(swizzled_setImage:)];
    });
}

- (void)swizzled_setImage:(UIImage *)image {
    UIImage *primitiveImage = self.image;
    
    [self swizzled_setImage:image];
    
    if ([KMHGenerics object:image isEqualToObject:primitiveImage]) {
        return;
    }
    
    NSDictionary *userInfo = image ? @{NOTIFICATION_OBJECT_KEY : image} : @{};
    [NSNotificationCenter postNotificationToMainThread:UIImageViewImageDidChangeNotification object:self userInfo:userInfo];
}

@end

#pragma mark - // IMPLEMENTATION (UINavigationBar) //

@implementation UINavigationBar (KMHGenerics)

#pragma mark Public Methods

+ (CGFloat)height {
    return [[UINavigationController alloc] init].navigationBar.frame.size.height;
}

@end

#pragma mark - // IMPLEMENTATION (UINavigationController) //

#pragma mark Definitions (Private)

NSString * const UINavigationControllerViewControllersDidChangeNotification = @"kUINavigationControllerViewControllersDidChangeNotification";

@implementation UINavigationController (KMHGenerics)

#pragma mark Public Methods

- (nullable UIViewController *)rootViewController {
    return self.viewControllers.firstObject;
}

#pragma mark Private Methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setViewControllers:) withMethod:@selector(swizzled_setViewControllers:)];
        [self swizzleMethod:@selector(pushViewController:animated:) withMethod:@selector(swizzled_pushViewController:animated:)];
        [self swizzleMethod:@selector(popViewControllerAnimated:) withMethod:@selector(swizzled_popViewControllerAnimated:)];
    });
}

- (void)swizzled_setViewControllers:(NSArray <UIViewController *> *)viewControllers {
    NSArray *primitiveViewControllers = self.viewControllers;
    
    [self swizzled_setViewControllers:viewControllers];
    
    if ([KMHGenerics object:viewControllers isEqualToObject:primitiveViewControllers]) {
        return;
    }
    
    NSDictionary *userInfo = viewControllers ? @{NOTIFICATION_OBJECT_KEY : viewControllers} : @{};
    [NSNotificationCenter postNotificationToMainThread:UINavigationControllerViewControllersDidChangeNotification object:self userInfo:userInfo];
}

- (void)swizzled_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self swizzled_pushViewController:viewController animated:animated];
    
    NSDictionary *userInfo = @{NOTIFICATION_OBJECT_KEY : self.viewControllers};
    [NSNotificationCenter postNotificationToMainThread:UINavigationControllerViewControllersDidChangeNotification object:self userInfo:userInfo];
}

- (void)swizzled_popViewControllerAnimated:(BOOL)animated {
    [self swizzled_popViewControllerAnimated:animated];
    
    NSDictionary *userInfo = @{NOTIFICATION_OBJECT_KEY : self.viewControllers};
    [NSNotificationCenter postNotificationToMainThread:UINavigationControllerViewControllersDidChangeNotification object:self userInfo:userInfo];
}

@end

#pragma mark - // IMPLEMENTATION (UINavigationItem) //

NSString * const UINavigationItemTitleDidChangeNotification = @"kUINavigationItemTitleDidChangeNotification";

@implementation UINavigationItem (KMHGenerics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setPrompt:) withMethod:@selector(swizzled_setPrompt:)];
        [self swizzleMethod:@selector(setTitle:) withMethod:@selector(swizzled_setTitle:)];
        [self swizzleMethod:@selector(setRightBarButtonItems:) withMethod:@selector(swizzled_setRightBarButtonItems:)];
    });
}

- (void)swizzled_setTitle:(NSString *)title {
    [self swizzled_setTitle:title];
    
    NSDictionary *userInfo = title ? @{NOTIFICATION_OBJECT_KEY : title} : @{};
    [NSNotificationCenter postNotificationToMainThread:UINavigationItemTitleDidChangeNotification object:self userInfo:userInfo];
}

@end

#pragma mark - // IMPLEMENTATION (UIScrollView) //

@implementation UIScrollView (KMHGenerics)

#pragma mark Public Methods

- (void)scrollToView:(nonnull UIView *)view animated:(BOOL)animated {
    if (![view isEventualSubviewOfView:self]) {
        return;
    }
    
    CGRect rect = [self convertRect:view.frame fromView:view.superview];
    [self scrollRectToVisible:rect animated:animated];
}

@end

#pragma mark - // IMPLEMENTATION (UISegmentedControl) //

@implementation UISegmentedControl (KMHGenerics)

#pragma mark Public Methods

- (nullable NSString *)selectedSegmentTitle {
    return [self titleForSegmentAtIndex:self.selectedSegmentIndex];
}

@end

#pragma mark - // IMPLEMENTATION (UIStoryboardSegue) //

@implementation UIStoryboardSegue (KMHGenerics)

#pragma mark Public Methods

- (nullable UIViewController *)contentDestinationViewController {
    if ([self.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.destinationViewController;
        return navigationController.topViewController;
    }
    
    if ([self.destinationViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)self.destinationViewController;
        return tabBarController.selectedViewController;
    }
    
    return self.destinationViewController;
}

@end

#pragma mark - // IMPLEMENTATION (UITableView) //

@implementation UITableView (KMHGenerics)

#pragma mark Public Methods

- (void)refresh:(nullable void (^)(void))block {
    [self beginUpdates];
    if (block) {
        block();
    }
    [self endUpdates];
}

- (void)moveRowsAtIndexPaths:(NSArray <NSIndexPath *> *)indexPaths toIndexPaths:(NSArray <NSIndexPath *> *)newIndexPaths {
    NSAssert(indexPaths.count == newIndexPaths.count, @"%@ and %@ must have the same number of items", stringFromVariable(indexPaths), stringFromVariable(newIndexPaths));
    
    [self beginUpdates];
    NSIndexPath *indexPath, *newIndexPath;
    for (int i = 0; i < indexPaths.count; i++) {
        indexPath = indexPaths[i];
        newIndexPath = newIndexPaths[i];
        [self moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
    [self endUpdates];
}

- (void)updateSection:(NSUInteger)section
             withData:(nonnull NSArray *)data
   insertionAnimation:(UITableViewRowAnimation)insertionAnimation
    deletionAnimation:(UITableViewRowAnimation)deletionAnimation
               getter:(nonnull NSArray * _Nonnull(^)(void))getter
               setter:(nonnull void (^)(NSArray * _Nonnull data))setter
        insertedCells:(nullable void (^)(NSArray <UITableViewCell *> * _Nonnull cells))insertionBlock
       reorderedCells:(nullable void (^)(NSArray <UITableViewCell *> * _Nonnull cells))reorderingBlock
         deletedCells:(nullable void (^)(NSArray <UITableViewCell *> * _Nonnull cells))deletionBlock
           completion:(nullable void (^)(void))completionBlock {
    
    [CATransaction setValue:@YES forKey:@"cancelled"];
    [self.layer removeAllAnimations];
    
    NSArray *fromArray = getter() ?: [NSArray array];
    
    // DELETION //
    
    NSMutableArray *deletedArray = [NSMutableArray array];
    NSMutableArray <NSIndexPath *> *indexPathsToDelete = [NSMutableArray array];
    id object;
    NSUInteger countAdded, countTarget;
    for (int i = 0; i < fromArray.count; i++) {
        object = fromArray[i];
        countAdded = [deletedArray countObject:object];
        countTarget = [data countObject:object];
        if (countAdded < countTarget) {
            [deletedArray addObject:object];
        }
        else {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
    }
    
    if (![fromArray isEqualToArray:deletedArray]) {
        
        if (deletionBlock) {
            NSMutableArray *deletedCells = [NSMutableArray array];
            UITableViewCell *cell;
            for (NSIndexPath *indexPath in indexPathsToDelete) {
                cell = [self cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [deletedCells addObject:cell];
                }
            }
            deletionBlock(deletedCells);
        }
        
        [CATransaction setValue:@NO forKey:@"cancelled"];
        
        [CATransaction begin];
        [self beginUpdates];
        
        [CATransaction setCompletionBlock:^{
            if ([CATransaction valueForKey:@"cancelled"]) {
                return;
            }
            
            [self updateSection:section withData:data insertionAnimation:insertionAnimation deletionAnimation:deletionAnimation getter:getter setter:setter insertedCells:insertionBlock reorderedCells:reorderingBlock deletedCells:deletionBlock completion:completionBlock];
        }];
        
        setter([NSArray arrayWithArray:deletedArray]);
        [self deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deletionAnimation];
        
        [self endUpdates];
        [CATransaction commit];
        
        return;
    }

    // REORDERING //
    
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:deletedArray.count];
    for (int i = 0; i < data.count; i++) {
        object = data[i];
        if (([deletedArray containsObject:object]) && ([sortedArray countObject:object] < [deletedArray countObject:object])) {
            [sortedArray addObject:object];
        }
    }
    
    if (![deletedArray isEqualToArray:sortedArray]) {
        
        NSMutableArray <NSIndexPath *> *fromIndexPaths, *toIndexPaths;
        [deletedArray compareToArray:sortedArray andGenerateIndexPaths:&fromIndexPaths toMoveToIndexPaths:&toIndexPaths withSection:section];
        
        if (reorderingBlock) {
            NSMutableArray *reorderedCells = [NSMutableArray array];
            UITableViewCell *cell;
            for (NSIndexPath *indexPath in fromIndexPaths) {
                cell = [self cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [reorderedCells addObject:cell];
                }
            }
            reorderingBlock(reorderedCells);
        }
        
        [CATransaction setValue:@NO forKey:@"cancelled"];
        
        [CATransaction begin];
        [self beginUpdates];
        
        [CATransaction setCompletionBlock:^{
            if ([CATransaction valueForKey:@"cancelled"]) {
                return;
            }
            
            [self updateSection:section withData:data insertionAnimation:insertionAnimation deletionAnimation:deletionAnimation getter:getter setter:setter insertedCells:insertionBlock reorderedCells:reorderingBlock deletedCells:deletionBlock completion:completionBlock];
        }];
        
        setter([NSArray arrayWithArray:sortedArray]);
        [self moveRowsAtIndexPaths:fromIndexPaths toIndexPaths:toIndexPaths];
        
        [self endUpdates];
        [CATransaction commit];
        
        return;
    }
    
    // INSERTION //
    
    if (![sortedArray isEqualToArray:data]) {
        
        NSArray <NSIndexPath *> *indexPathsToInsert;
        [sortedArray compareToArray:data andGenerateIndexPathsToInsert:&indexPathsToInsert withSection:0];
        
        [CATransaction setValue:@NO forKey:@"cancelled"];
        
        [CATransaction begin];
        [self beginUpdates];
        
        [CATransaction setCompletionBlock:^{
            if ([CATransaction valueForKey:@"cancelled"]) {
                return;
            }
            
            [self updateSection:section withData:data insertionAnimation:insertionAnimation deletionAnimation:deletionAnimation getter:getter setter:setter insertedCells:insertionBlock reorderedCells:reorderingBlock deletedCells:deletionBlock completion:completionBlock];
        }];
        
        setter([NSArray arrayWithArray:data]);
        [self insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertionAnimation];
        
        [self endUpdates];
        [CATransaction commit];
        
        if (insertionBlock) {
            NSMutableArray *insertedCells = [NSMutableArray array];
            UITableViewCell *cell;
            for (NSIndexPath *indexPath in indexPathsToInsert) {
                cell = [self cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [insertedCells addObject:cell];
                }
            }
            insertionBlock(insertedCells);
        }
        
        return;
    }
    
    // COMPLETION //
    
    if (completionBlock) {
        completionBlock();
    }
}

- (void)tapRowAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    [self selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end

#pragma mark - // IMPLEMENTATION (UITableViewCell) //

@implementation UITableViewCell (KMHGenerics)

#pragma mark Setters and Getters

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, @selector(indexPath), indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, @selector(indexPath));
}

#pragma mark Public Methods

+ (nonnull instancetype)cellWithReuseIdentifier:(nullable NSString *)reuseIdentifier style:(UITableViewCellStyle)style tableView:(nonnull UITableView *)tableView atIndexPath:(nonnull NSIndexPath *)indexPath fromStoryboard:(BOOL)fromStoryboard {
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) || (!fromStoryboard)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[self alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
        }
        return cell;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
}

+ (CGFloat)defaultHeight {
    return 44.0f;
}

@end

#pragma mark - // IMPLEMENTATION (UITextField) //

@implementation UITextField (KMHGenerics)

#pragma mark Setters and Getters

- (void)setSelectable:(BOOL)selectable {
    objc_setAssociatedObject(self, @selector(selectable), @(selectable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)selectable {
    NSNumber *selectableValue = objc_getAssociatedObject(self, @selector(selectable));
    if (selectableValue) {
        return selectableValue.boolValue;
    }
    
    self.selectable = YES;
    return self.selectable;
}

#pragma mark Public Methods

- (void)selectTextInRange:(NSRange)range {
    UITextPosition *start = [self positionFromPosition:[self beginningOfDocument] offset:range.location];
    UITextPosition *end = [self positionFromPosition:start offset:range.length];
    [self setSelectedTextRange:[self textRangeFromPosition:start toPosition:end]];
}

#pragma mark Overwritten Methods

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (!self.selectable) {
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

@end

#pragma mark - // IMPLEMENTATION (UITextView) //

#pragma mark Definitions

CGFloat const UITextViewPlaceholderAlpha = 0.33f;
CGFloat const UITextViewAnimationSpeed = 0.18f;

@implementation UITextView (KMHGenerics)

#pragma mark Setters and Getters

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderTextView.text = placeholder;
}

- (NSString *)placeholder {
    return self.placeholderTextView.text;
}

- (void)setPlaceholderTextView:(UITextView *)placeholderTextView {
    objc_setAssociatedObject(self, @selector(placeholderTextView), placeholderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITextView *)placeholderTextView {
    UITextView *placeholderTextView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (placeholderTextView) {
        if (![self.subviews containsObject:placeholderTextView]) {
            [self addSubview:placeholderTextView];
            [self sendSubviewToBack:placeholderTextView];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:placeholderTextView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:placeholderTextView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:placeholderTextView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:placeholderTextView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
        }
        return placeholderTextView;
    }
    
    placeholderTextView = [[UITextView alloc] initWithFrame:self.bounds textContainer:nil];
    placeholderTextView.userInteractionEnabled = NO;
    placeholderTextView.translatesAutoresizingMaskIntoConstraints = NO;
    placeholderTextView.scrollEnabled = NO;
    placeholderTextView.backgroundColor = [UIColor clearColor];
    placeholderTextView.alpha = UITextViewPlaceholderAlpha;
    placeholderTextView.textContainerInset = self.textContainerInset;
    placeholderTextView.textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding;
    placeholderTextView.font = self.font;
    placeholderTextView.textColor = self.textColor;
    placeholderTextView.delegate = self;
    self.placeholderTextView = placeholderTextView;
    return self.placeholderTextView;
}

#pragma mark Public Methods

- (void)showPlaceholder:(BOOL)show animated:(BOOL)animated {
    [UIView animateWithDuration:(animated ? UITextViewAnimationSpeed : 0) animations:^{
        self.placeholderTextView.alpha = show ? UITextViewPlaceholderAlpha : 0.0f;
    }];
}


#pragma mark Overwritten Methods

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    
    [self showPlaceholder:(self.text.length == 0) animated:NO];
}

@end

#pragma mark - // IMPLEMENTATION (UIView) //

@implementation UIView (KMHGenerics)

#pragma mark Setters and Getters

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

#pragma mark Public Methods

- (nullable UIView *)firstResponder {
    NSMutableArray *subviews = [NSMutableArray arrayWithArray:self.subviews];
    UIView *subview;
    while (subviews.count) {
        subview = [subviews firstObject];
        if (subview.isFirstResponder) {
            return subview;
        }
        
        [subviews addObjectsFromArray:subview.subviews];
        [subviews removeObject:subview];
    }
    
    return nil;
}

- (BOOL)isEventualSubviewOfView:(nonnull UIView *)view {
    NSMutableOrderedSet *subviews = [[NSMutableOrderedSet alloc] initWithArray:view.subviews];
    UIView *subview;
    while (subviews.count) {
        subview = [subviews firstObject];
        if ([self isEqual:subview]) {
            return YES;
        }
        
        if (subview.subviews.count) {
            [subviews addObjectsFromArray:subview.subviews];
        }
        [subviews removeObject:subview];
    }
    
    return NO;
}

- (void)setFrameWithOriginX:(nullable NSNumber *)originX originY:(nullable NSNumber *)originY width:(nullable NSNumber *)width height:(nullable NSNumber *)height {
    CGRect frame = self.frame;
    if (originX) {
        frame = CGRectMake(originX.floatValue, frame.origin.y, frame.size.width, frame.size.height);
    }
    if (originY) {
        frame = CGRectMake(frame.origin.x, originY.floatValue, frame.size.width, frame.size.height);
    }
    if (width) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, width.floatValue, frame.size.height);
    }
    if (height) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height.floatValue);
    }
    self.frame = frame;
}

- (void)setFrameWithCenterX:(nullable NSNumber *)centerX centerY:(nullable NSNumber *)centerY width:(nullable NSNumber *)width height:(nullable NSNumber *)height {
    CGRect frame = self.frame;
    if (centerX) {
        frame = CGRectMake(centerX.floatValue-0.5f*frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
    }
    if (centerY) {
        frame = CGRectMake(frame.origin.x, centerY.floatValue-0.5f*frame.size.height, frame.size.width, frame.size.height);
    }
    if (width) {
        frame = CGRectMake(frame.origin.x+(frame.size.width-width.floatValue)*0.5f, frame.origin.y, width.floatValue, frame.size.height);
    }
    if (height) {
        frame = CGRectMake(frame.origin.x, frame.origin.y+(frame.size.height-height.floatValue)*0.5f, frame.size.width, height.floatValue);
    }
    self.frame = frame;
}

- (void)addBorderWithColor:(nonnull CGColorRef)color width:(CGFloat)width {
    [self.layer setBorderColor:color];
    [self.layer setBorderWidth:width];
}

- (void)addShadowWithColor:(nonnull CGColorRef)color opacity:(float)opacity radius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius offset:(CGSize)shadowOffset {
    [self.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.bounds].CGPath];
    [self.layer setShadowRadius:radius];
    [self.layer setCornerRadius:cornerRadius];
    [self.layer setShadowOffset:shadowOffset];
    [self.layer setMasksToBounds:NO];
    [self.layer setShadowColor:color];
    [self.layer setShadowOpacity:opacity];
}

- (void)rotateFromAngle:(CGFloat)fromAngle byAngle:(CGFloat)angle withDuration:(CFTimeInterval)duration completion:(nullable void (^)(void))completion {
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, fromAngle);
    [CATransaction begin];
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:angle];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [CATransaction setCompletionBlock:completion];
    [self.layer addAnimation:rotationAnimation forKey:stringFromVariable(rotationAnimation)];
    [CATransaction commit];
}

- (void)flipHorizontally:(CGFloat)radians withAnimations:(nullable void (^)(void))animations duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(nullable void (^)(BOOL))completion {
    CGPoint rotationAxis = CGPointMake(0.0f, 1.0f);
    [self flipWithRotationAxis:rotationAxis radians:radians withAnimations:animations duration:duration options:options completion:completion];
}

- (void)flipVertically:(CGFloat)radians withAnimations:(nullable void (^)(void))animations duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(nullable void (^)(BOOL))completion {
    CGPoint rotationAxis = CGPointMake(1.0f, 0.0f);
    [self flipWithRotationAxis:rotationAxis radians:radians withAnimations:animations duration:duration options:options completion:completion];
}

#pragma mark Private Methods

- (void)flipWithRotationAxis:(CGPoint)rotationAxis radians:(CGFloat)radians withAnimations:(nullable void (^)(void))animations duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(nullable void (^)(BOOL))completion {
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = -1.0f/500.0f;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, radians, rotationAxis.x, rotationAxis.y, 0.0f);
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.layer.transform = rotationAndPerspectiveTransform;
        if (animations) {
            animations();
        }
    } completion:completion];
}

@end

#pragma mark - // IMPLEMENTATION (UIViewController) //

@implementation UIViewController (KMHGenerics)

#pragma mark Definitions (Private)

NSString * const KMHImagePickerSourceSelectorCameraPhoto = @"Take Photo";
NSString * const KMHImagePickerSourceSelectorCameraVideo = @"Take Video";
NSString * const KMHImagePickerSourceSelectorCameraPhotoOrVideo = @"Take Photo or Video";
NSString * const KMHImagePickerSourceSelectorPhotoLibrary = @"Photo Library";
NSString * const KMHImagePickerSourceSelectorCameraRoll = @"Camera Roll";

#pragma mark Setters and Getters

- (void)setInfo:(nullable NSDictionary *)info {
    objc_setAssociatedObject(self, @selector(info), info, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable NSDictionary *)info {
    return objc_getAssociatedObject(self, @selector(info));
}

- (void)setIsModal:(BOOL)isModal {
    objc_setAssociatedObject(self, @selector(isModal), @(isModal), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isModal {
    NSNumber *isModalValue = objc_getAssociatedObject(self, @selector(isModal));
    if (isModalValue) {
        return isModalValue.boolValue;
    }
    
    self.isModal = NO;
    return self.isModal;
}

#pragma mark Public Methods

- (BOOL)isForceTouchEnabled {
    if (![self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        return NO;
    }
    
    return (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable);
}

- (void)performBlockOnChildViewControllers:(void (^)(UIViewController *childViewController))block {
    NSMutableArray <UIViewController *> *childViewControllers = [NSMutableArray arrayWithArray:self.childViewControllers];
    UIViewController *childViewController;
    while (childViewControllers.count) {
        childViewController = childViewControllers[0];
        if ([childViewController isKindOfClass:[UINavigationController class]] || [childViewController isKindOfClass:[UITabBarController class]]) {
            [childViewControllers addObjectsFromArray:childViewController.childViewControllers];
        }
        else {
            block(childViewController);
        }
        [childViewControllers removeObject:childViewController];
    };
}

- (void)presentError:(nonnull NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Error %ld", error.domain, (long)error.code] message:[[NSArray arrayWithNullableObjects:error.localizedDescription, error.localizedRecoverySuggestion, nil] componentsJoinedByString:@" "] preferredStyle:UIAlertControllerStyleAlert actions:nil preferredAction:nil dismissalText:nil completion:nil];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentImageSourceSelectorWithMediaType:(KMHMediaType)mediaType cameraType:(KMHCameraType)cameraType libraryType:(KMHImageLibraryType)libraryType delegate:(nullable id <KMHImageSourceSelectorDelegate>)delegate completion:(nullable void (^)(UIAlertController * _Nonnull alertController))completionBlock {
    
    KMHMediaType availableCameraMediaTypes = [KMHGenerics returnAvailableMediaTypesForRequestedCameraType:cameraType andMediaType:mediaType];
    BOOL cameraAvailable = (availableCameraMediaTypes != KMHMediaTypeNone);
    
    KMHImageLibraryType availableImageLibraryTypes = [KMHGenerics returnAvailableImageLibraryTypesForRequestedLibraryType:libraryType];
    BOOL libraryAvailable = (availableImageLibraryTypes != KMHImageLibraryNone);
    
    UIAlertController *imageSourceSelector = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (cameraAvailable && (availableCameraMediaTypes != KMHMediaTypeNone)) {
        NSString *title = [UIViewController actionForMediaType:availableCameraMediaTypes];
        [imageSourceSelector addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (delegate && [delegate respondsToSelector:@selector(imageSourceSelectorDidSelectCamera:)]) {
                [delegate imageSourceSelectorDidSelectCamera:imageSourceSelector];
            }
        }]];
    }
    
    if (libraryAvailable && (availableImageLibraryTypes != KMHImageLibraryNone)) {
        NSString *title = [UIViewController actionForImageLibraryType:availableImageLibraryTypes];
        [imageSourceSelector addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (delegate && [delegate respondsToSelector:@selector(imageSourceSelectorDidSelectLibrary:)]) {
                [delegate imageSourceSelectorDidSelectLibrary:imageSourceSelector];
            }
        }]];
    }
    
    [imageSourceSelector addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:imageSourceSelector animated:YES completion:^{
        if (completionBlock) {
            completionBlock(imageSourceSelector);
        }
    }];
}

- (void)presentFrontCameraWithMediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull pickerController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull pickerController))completionBlock {
    [self presentCamera:UIImagePickerControllerCameraDeviceFront withMediaType:mediaType delegate:delegate setup:setupBlock completion:completionBlock];
}

- (void)presentRearCameraWithMediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull pickerController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull pickerController))completionBlock {
    [self presentCamera:UIImagePickerControllerCameraDeviceRear withMediaType:mediaType delegate:delegate setup:setupBlock completion:completionBlock];
}

- (void)presentCameraRollWithMediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull pickerController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull pickerController))completionBlock {
    [self presentImagePickerWithSource:UIImagePickerControllerSourceTypeSavedPhotosAlbum mediaType:mediaType delegate:delegate setup:setupBlock completion:completionBlock];
}

- (void)presentPhotoLibraryWithMediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull pickerController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull pickerController))completionBlock {
    [self presentImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary mediaType:mediaType delegate:delegate setup:setupBlock completion:completionBlock];
}

- (void)popOrDismissViewControllerAnimated:(BOOL)animated {
    if (self.navigationController && self.parentViewController && [self.navigationController isEqual:self.parentViewController] && ![self.navigationController.rootViewController isEqual:self]) {
        NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
        UIViewController *viewController = self.navigationController.viewControllers[index-1];
        [self.navigationController popToViewController:viewController animated:animated];
        return;
    }
    
    [self dismissViewControllerAnimated:animated completion:nil];
}

#pragma mark Private Methods

- (void)presentCamera:(UIImagePickerControllerCameraDevice)camera withMediaType:(KMHMediaType)mediaType delegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(void (^)(UIImagePickerController *cameraController))setupBlock completion:(void (^)(UIImagePickerController *cameraController))completionBlock {
    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
    cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraController.cameraDevice = camera;
    cameraController.mediaTypes = [KMHGenerics arrayForMediaType:mediaType];
    if (setupBlock) {
        setupBlock(cameraController);
    }
    cameraController.delegate = delegate;
    
    [self presentViewController:cameraController animated:YES completion:^{
        if (completionBlock) {
            completionBlock(cameraController);
        }
    }];
}

- (void)presentImagePickerWithSource:(UIImagePickerControllerSourceType)sourceType mediaType:(KMHMediaType)mediaType delegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(void (^)(UIImagePickerController *imagePickerController))setupBlock completion:(void (^)(UIImagePickerController *imagePickerController))completionBlock {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.mediaTypes = [KMHGenerics arrayForMediaType:mediaType];
    if (setupBlock) {
        setupBlock(imagePickerController);
    }
    imagePickerController.delegate = delegate;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        if (completionBlock) {
            completionBlock(imagePickerController);
        }
    }];
}

+ (NSString *)actionForMediaType:(KMHMediaType)mediaType {
    switch (mediaType) {
        case KMHMediaTypeImage:
            return KMHImagePickerSourceSelectorCameraPhoto;
        case KMHMediaTypeVideo:
            return KMHImagePickerSourceSelectorCameraVideo;
        case KMHMediaTypeImageAndVideo:
            return KMHImagePickerSourceSelectorCameraPhotoOrVideo;
        case KMHMediaTypeNone:
            return nil;
    }
}

+ (NSString *)actionForImageLibraryType:(KMHImageLibraryType)libraryType {
    switch (libraryType) {
        case KMHImageLibraryAny:
        case KMHImageLibraryPhotoLibrary:
            return KMHImagePickerSourceSelectorPhotoLibrary;
        case KMHImageLibraryCameraRoll:
            return KMHImagePickerSourceSelectorCameraRoll;
        case KMHImageLibraryNone:
            return nil;
    }
}

@end
