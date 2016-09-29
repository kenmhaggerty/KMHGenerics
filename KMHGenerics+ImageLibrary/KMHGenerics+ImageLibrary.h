//
//  KMHGenerics+ImageLibrary.h
//  KMHGenerics
//
//  Created by Ken M. Haggerty on 9/21/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import "KMHGenerics.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - // KMHGenerics //

@interface KMHGenerics (ImageLibrary)
+ (AVCaptureVideoOrientation)convertInterfaceOrientationToVideoOrientation:(UIInterfaceOrientation)interfaceOrientation;
+ (BOOL)frontCameraCanTakePhoto;
+ (BOOL)frontCameraCanTakeVideo;
+ (BOOL)frontCameraHasFlash;
+ (BOOL)rearCameraCanTakePhoto;
+ (BOOL)rearCameraCanTakeVideo;
+ (BOOL)rearCameraHasFlash;
+ (BOOL)canAccessCameraRoll;
@end

#pragma mark - // UIViewController //

#pragma mark Protocols

@protocol KMHImageSourceSelectorDelegate <NSObject>
@optional
- (void)imageSourceSelectorDidSelectCamera:(nonnull UIAlertController *)sender;
- (void)imageSourceSelectorDidSelectLibrary:(nonnull UIAlertController *)sender;
@end

#pragma mark Notifications

extern NSString * _Nonnull const ImageSourceSelectorNotificationObjectKey;

#pragma mark Constants

typedef enum : NSUInteger {
    KMHMediaTypeNone = 0,
    KMHMediaTypeImage,
    KMHMediaTypeVideo,
    KMHMediaTypeImageAndVideo,
} KMHMediaType;

typedef enum : NSUInteger {
    KMHImageLibraryNone = 0,
    KMHImageLibraryCameraRoll,
    KMHImageLibraryPhotoLibrary,
    KMHImageLibraryAny
} KMHImageLibraryType;

typedef enum : NSUInteger {
    KMHCameraTypeNone = 0,
    KMHCameraTypeFront,
    KMHCameraTypeRear,
    KMHCameraTypeFrontOrRear,
} KMHCameraType;

#pragma mark Methods

@interface UIViewController (ImageLibrary)
- (void)presentImageSourceSelectorWithMediaType:(KMHMediaType)mediaType cameraType:(KMHCameraType)cameraType libraryType:(KMHImageLibraryType)libraryType delegate:(nullable id <KMHImageSourceSelectorDelegate>)delegate completion:(nullable void (^)(UIAlertController * _Nonnull alertController))completionBlock;
- (void)presentFrontCameraWithMediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull cameraController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull cameraController))completionBlock;
- (void)presentRearCameraWithMediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull cameraController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull cameraController))completionBlock;
- (void)presentCameraRollWithMediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull imagePickerController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull imagePickerController))completionBlock;
- (void)presentPhotoLibraryWithMediaType:(KMHMediaType)mediaType delegate:(nullable id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(nullable void (^)(UIImagePickerController * _Nonnull imagePickerController))setupBlock completion:(nullable void (^)(UIImagePickerController * _Nonnull imagePickerController))completionBlock;
@end
