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

#pragma mark - // KMHGenerics (ImageLibrary) //

#pragma mark Notifications

extern NSString * const CameraRollMostRecentImageDidChangeNotification;

#pragma mark Public Interface

@interface KMHGenerics (ImageLibrary)
+ (AVCaptureVideoOrientation)convertInterfaceOrientationToVideoOrientation:(UIInterfaceOrientation)interfaceOrientation;
+ (BOOL)frontCameraCanTakePhoto;
+ (BOOL)frontCameraCanTakeVideo;
+ (BOOL)frontCameraHasFlash;
+ (BOOL)rearCameraCanTakePhoto;
+ (BOOL)rearCameraCanTakeVideo;
+ (BOOL)rearCameraHasFlash;
+ (BOOL)canAccessCameraRoll;
+ (BOOL)canAccessPhotoLibrary;
+ (void)getCameraRollThumbnailWithSize:(CGSize)size completion:(void (^)(UIImage *thumbnail, NSError *error))completionBlock;
@end

#pragma mark - // UIViewController (ImageLibrary) //

#pragma mark Protocols

@protocol KMHImageSourceSelectorDelegate <NSObject>
@optional
- (void)imageSourceSelectorDidSelectCamera:(UIAlertController *)sender;
- (void)imageSourceSelectorDidSelectLibrary:(UIAlertController *)sender;
@end

#pragma mark Notifications

extern NSString * const ImageSourceSelectorNotificationObjectKey;

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

#pragma mark Public Interface

@interface UIViewController (ImageLibrary)
- (void)presentImageSourceSelectorWithMediaType:(KMHMediaType)mediaType cameraType:(KMHCameraType)cameraType libraryType:(KMHImageLibraryType)libraryType delegate:(id <KMHImageSourceSelectorDelegate>)delegate completion:(void (^)(UIAlertController * alertController))completionBlock;
- (void)presentFrontCameraWithMediaType:(KMHMediaType)mediaType delegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(void (^)(UIImagePickerController * cameraController))setupBlock completion:(void (^)(UIImagePickerController * cameraController))completionBlock;
- (void)presentRearCameraWithMediaType:(KMHMediaType)mediaType delegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(void (^)(UIImagePickerController * cameraController))setupBlock completion:(void (^)(UIImagePickerController * cameraController))completionBlock;
- (void)presentCameraRollWithMediaType:(KMHMediaType)mediaType delegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(void (^)(UIImagePickerController * imagePickerController))setupBlock completion:(void (^)(UIImagePickerController * imagePickerController))completionBlock;
- (void)presentPhotoLibraryWithMediaType:(KMHMediaType)mediaType delegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate setup:(void (^)(UIImagePickerController * imagePickerController))setupBlock completion:(void (^)(UIImagePickerController * imagePickerController))completionBlock;
@end
