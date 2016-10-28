//
//  KMHGenerics+ImageLibrary.m
//  KMHGenerics
//
//  Created by Ken M. Haggerty on 9/21/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "KMHGenerics+ImageLibrary.h"
#import <objc/runtime.h>
//#import <QuartzCore/QuartzCore.h>

#pragma mark - // KMHGenerics (ImageLibrary) //

#pragma mark Imports

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

#pragma mark Notifications

NSString * const CameraRollNotificationObjectKey = @"object";

NSString * const CameraRollMostRecentImageDidChangeNotification = @"kCameraRollMostRecentImageDidChangeNotification";

#pragma mark Implementation

@implementation KMHGenerics (ImageLibrary)

#pragma mark // Setters and Getters (Private) //

- (void)setAssetsLibrary:(ALAssetsLibrary *)assetsLibrary {
    objc_setAssociatedObject(self, @selector(assetsLibrary), assetsLibrary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ALAssetsLibrary *)assetsLibrary {
    ALAssetsLibrary *assetsLibrary = objc_getAssociatedObject(self, @selector(assetsLibrary));
    if (assetsLibrary) {
        return assetsLibrary;
    }
    
    self.assetsLibrary = [ALAssetsLibrary new];
    return self.assetsLibrary;
}

- (void)setCameraRollMostRecentImage:(UIImage *)cameraRollMostRecentImage {
    if ([KMHGenerics object:cameraRollMostRecentImage isEqualToObject:self.cameraRollMostRecentImage]) {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(cameraRollMostRecentImage), cameraRollMostRecentImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSDictionary *userInfo = cameraRollMostRecentImage ? @{CameraRollNotificationObjectKey : cameraRollMostRecentImage} : @{};
    [NSNotificationCenter postNotificationToMainThread:CameraRollMostRecentImageDidChangeNotification object:nil userInfo:userInfo];
}

- (UIImage *)cameraRollMostRecentImage {
    return objc_getAssociatedObject(self, @selector(cameraRollMostRecentImage));;
}

#pragma mark // Public Methods //

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

+ (void)getCameraRollThumbnailWithSize:(CGSize)size completion:(void (^)(UIImage *thumbnail, NSError *error))completionBlock {
    UIImage *image = [KMHGenerics imageLibraryGenerics].cameraRollMostRecentImage;
    if (image) {
        if (completionBlock) {
            UIImage *thumbnail = [image imageWithSize:size contentMode:UIViewContentModeScaleAspectFill retina:YES];
            completionBlock(thumbnail, nil);
        }
        return;
    }
    
    void (^setAndRecurseBlock)(UIImage *, NSError *) = ^(UIImage *image, NSError *error) {
        [KMHGenerics imageLibraryGenerics].cameraRollMostRecentImage = image;
        [KMHGenerics getCameraRollThumbnailWithSize:size completion:completionBlock];
    };
    
    if ([KMHGenerics iOSVersion] < 9.0f) {
        [KMHGenerics getLastImageFromCameraRollUsingAssetsLibraryWithCompletion:setAndRecurseBlock];
        return;
    }
    
    [KMHGenerics getLastImageFromCameraRollUsingPhotosWithCompletion:setAndRecurseBlock];
}

#pragma mark // Private Methods (General) //

+ (instancetype)imageLibraryGenerics {
    static KMHGenerics *_imageLibraryGenerics = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageLibraryGenerics = [[KMHGenerics alloc] init];
        if ([KMHGenerics iOSVersion] < 9.0f) {
            [_imageLibraryGenerics addObserversToAssetsLibrary];
        }
    });
    return _imageLibraryGenerics;
}

#pragma mark // Private Methods (Observers) //

- (void)addObserversToAssetsLibrary {
    [NSNotificationCenter addObserver:self selector:@selector(assetsLibraryDidChange:) name:ALAssetsLibraryChangedNotification object:nil];
}

//- (void)removeObserversFromAssetsLibrary {
//    [NSNotificationCenter removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
//}

#pragma mark // Private Methods (Responders) //

- (void)assetsLibraryDidChange:(NSNotification *)notification {
    [KMHGenerics imageLibraryGenerics].cameraRollMostRecentImage = nil;
    [KMHGenerics getCameraRollThumbnailWithSize:CGSizeZero completion:nil];
}

#pragma mark // Private Methods (Other) //

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

+ (ALAssetsLibrary *)assetsLibrary {
    return [KMHGenerics imageLibraryGenerics].assetsLibrary;
}

+ (void)getLastImageFromCameraRollUsingAssetsLibraryWithCompletion:(void (^)(UIImage *image, NSError *error))completionBlock {
    [[KMHGenerics assetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (!group || group.numberOfAssets) {
            return;
        }
        
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets-1] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            *stop = YES;
            UIImage *image = [UIImage imageWithCGImage:result.defaultRepresentation.fullResolutionImage];
            completionBlock(image, nil);
        }];
    } failureBlock:^(NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

+ (void)getLastImageFromCameraRollUsingPhotosWithCompletion:(void (^)(UIImage *image, NSError *error))completionBlock {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    PHAsset *lastAsset = fetchResult.lastObject;
    PHImageRequestOptions *options = PHImageRequestOptionsVersionCurrent;
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:lastAsset targetSize:CGSizeMake(lastAsset.pixelWidth, lastAsset.pixelHeight) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info) {
        NSError *error = info[PHImageErrorKey];
        completionBlock(image, error);
    }];
}

@end

#pragma mark - // UIViewController (ImageLibrary) //

#pragma mark Notifications

NSString * const ImageSourceSelectorNotificationObjectKey = @"object";

#pragma mark Constants

NSString * const KMHImagePickerSourceSelectorCameraPhoto = @"Take Photo";
NSString * const KMHImagePickerSourceSelectorCameraVideo = @"Take Video";
NSString * const KMHImagePickerSourceSelectorCameraPhotoOrVideo = @"Take Photo or Video";
NSString * const KMHImagePickerSourceSelectorPhotoLibrary = @"Photo Library";
NSString * const KMHImagePickerSourceSelectorCameraRoll = @"Camera Roll";

#pragma mark Implementation

@implementation UIViewController (ImageLibrary)

#pragma mark // Public Methods //

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

#pragma mark // Private Methods //

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

- (void)presentCamera:(UIImagePickerControllerCameraDevice)camera withMediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull cameraController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull cameraController))completionBlock {
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

- (void)presentImagePickerWithSource:(UIImagePickerControllerSourceType)sourceType mediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull imagePickerController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull imagePickerController))completionBlock {
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

@end
