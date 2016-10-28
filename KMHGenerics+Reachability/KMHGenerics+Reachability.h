//
//  KMHGenerics+Reachability.h
//  Sandbox
//
//  Created by Ken M. Haggerty on 9/30/16.
//  Copyright © 2016 MCMDI. All rights reserved.
//

#import "KMHGenerics.h"

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#pragma mark - // KMHGenerics (Reachability) //

#pragma mark Notifications

extern NSString * const ReachabilityNotificationObjectKey;
extern NSErrorDomain const ReachabilityErrorDomain;

extern NSString * const InternetStatusDidChangeNotification;
extern NSString * const PublicIPAddressDidChangeNotification;
extern NSString * const PrivateIPAddressDidChangeNotification;
extern NSString * const ReachabilityDidReceiveErrorNotification;

#pragma mark Protocols

@protocol ReachabilityDomainDelegate <NSObject>
- (NSString *)reachabilityDomain;
@end

#pragma mark Constants

typedef enum {
    AKInternetDisconnected,
    AKInternetConnectedViaWWAN,
    AKInternetConnectedViaWiFi,
    AKInternetStatusUnknown,
} AKInternetStatus;

#pragma mark Public Interface

@interface KMHGenerics (Reachability) // <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

// SETUP //

+ (void)setDomainDelegate:(id <ReachabilityDomainDelegate>)domainDelegate;

// GENERAL //

+ (AKInternetStatus)internetStatus;
+ (BOOL)isReachable;
+ (BOOL)isReachableViaWiFi;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)wifiEnabled;
+ (void)setWiFiEnabled:(BOOL)wifiEnabled;
+ (BOOL)wwanEnabled;
+ (void)setWWANEnabled:(BOOL)wwanEnabled;
+ (NSString *)publicIPAddress;
+ (NSString *)privateIPAddress;
+ (void)refreshInternetStatus:(void (^)(NSError *error))completionBlock;

@end
