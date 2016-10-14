//
//  KMHGenerics+Reachability.m
//  Sandbox
//
//  Created by Ken M. Haggerty on 9/30/16.
//  Copyright © 2016 MCMDI. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "KMHGenerics+Reachability.h"
#import <objc/runtime.h>
#import "Reachability.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

#pragma mark - // KMHGenerics //

#pragma mark Notifications

NSString * const ReachabilityNotificationObjectKey = @"object";

NSString * const InternetStatusDidChangeNotification = @"kInternetStatusDidChangeNotification";
NSString * const PublicIPAddressDidChangeNotification = @"kPublicIPAddressDidChangeNotification";
NSString * const PrivateIPAddressDidChangeNotification = @"kPrivateIPAddressDidChangeNotification";

NSString * const ReachabilityDidReceiveErrorNotification = @"kReachabilityDidReceiveErrorNotification";

#pragma mark Constants

NSUInteger const INTERNET_MAX_ATTEMPTS_COUNT = 2;
NSTimeInterval const INTERNET_MAX_ATTEMPTS_TIME = 1.0f;

NSString * const PublicIPAddressURL = @"https://api.ipify.org?format=json";
NSString * const PublicIPAddressKey = @"ip";

@implementation KMHGenerics (Reachability)

#pragma mark Setters and Getters (Public)

- (void)setDomainDelegate:(id <ReachabilityDomainDelegate>)domainDelegate {
    objc_setAssociatedObject(self, @selector(domainDelegate), domainDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id <ReachabilityDomainDelegate>)domainDelegate {
    return objc_getAssociatedObject(self, @selector(domainDelegate));
}

#pragma mark Setters and Getters (Private)

- (void)setReachability:(Reachability *)reachability {
    if ([KMHGenerics object:reachability isEqualToObject:self.reachability]) {
        return;
    }
    
    if (self.reachability) {
        [self.reachability stopNotifier];
    }
    
    objc_setAssociatedObject(self, @selector(reachability), reachability, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (reachability) {
        [reachability startNotifier];
    }
}

- (Reachability *)reachability {
    Reachability *reachability = objc_getAssociatedObject(self, @selector(reachability));
    if (reachability) {
        return reachability;
    }
    
    if (![KMHGenerics domainDelegate] || ![[KMHGenerics domainDelegate] respondsToSelector:(@selector(reachabilityDomain))]) {
        return nil;
    }
    
    self.reachability = [Reachability reachabilityWithHostname:[[KMHGenerics domainDelegate] reachabilityDomain]];
    return self.reachability;
}

- (void)setUserDefaults:(NSUserDefaults *)userDefaults {
    objc_setAssociatedObject(self, @selector(userDefaults), userDefaults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUserDefaults *)userDefaults {
    NSUserDefaults *userDefaults = objc_getAssociatedObject(self, @selector(userDefaults));
    if (userDefaults) {
        return userDefaults;
    }
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    return self.userDefaults;
}

- (void)setInternetStatus:(AKInternetStatus)internetStatus {
    if (internetStatus == self.internetStatus) {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(internetStatus), @(internetStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSDictionary *userInfo = @{ReachabilityNotificationObjectKey : @(internetStatus)};
    [NSNotificationCenter postNotificationToMainThread:InternetStatusDidChangeNotification object:nil userInfo:userInfo];
}

- (AKInternetStatus)internetStatus {
    NSNumber *internetStatusValue = objc_getAssociatedObject(self, @selector(internetStatus));
    return internetStatusValue ? (AKInternetStatus)internetStatusValue.integerValue : AKInternetStatusUnknown;
}

- (void)setPublicIPAddress:(NSString *)publicIPAddress {
    if ([KMHGenerics object:publicIPAddress isEqualToObject:self.publicIPAddress]) {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(publicIPAddress), publicIPAddress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSDictionary *userInfo = publicIPAddress ? @{ReachabilityNotificationObjectKey : publicIPAddress} : @{};
    [NSNotificationCenter postNotificationToMainThread:PublicIPAddressDidChangeNotification object:nil userInfo:userInfo];
}

- (NSString *)publicIPAddress {
    return objc_getAssociatedObject(self, @selector(publicIPAddress));
}

- (void)setPrivateIPAddress:(NSString *)privateIPAddress {
    if ([KMHGenerics object:privateIPAddress isEqualToObject:self.privateIPAddress]) {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(privateIPAddress), privateIPAddress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSDictionary *userInfo = privateIPAddress ? @{ReachabilityNotificationObjectKey : privateIPAddress} : @{};
    [NSNotificationCenter postNotificationToMainThread:PrivateIPAddressDidChangeNotification object:nil userInfo:userInfo];
}

- (NSString *)privateIPAddress {
    return objc_getAssociatedObject(self, @selector(privateIPAddress));
}

- (void)setPublicIPAddressData:(NSMutableData *)publicIPAddressData {
    objc_setAssociatedObject(self, @selector(publicIPAddressData), publicIPAddressData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableData *)publicIPAddressData {
    return objc_getAssociatedObject(self, @selector(publicIPAddressData));
}

#pragma mark Public Methods (Setup)

+ (void)setDomainDelegate:(id <ReachabilityDomainDelegate>)domainDelegate {
    [KMHGenerics reachabilityGenerics].domainDelegate = domainDelegate;
}

#pragma mark Public Methods (General)

+ (AKInternetStatus)internetStatus {
    return [KMHGenerics reachabilityGenerics].internetStatus;
}

+ (BOOL)isReachable {
    return ([KMHGenerics isReachableViaWiFi] || [KMHGenerics isReachableViaWWAN]);
}

+ (BOOL)isReachableViaWiFi {
    if (![KMHGenerics wifiEnabled]) {
        return NO;
    }
    
    int attempt = 0;
    BOOL isReachable;
    NSDate *startDate = [NSDate date];
    do {
        isReachable = [KMHGenerics reachabilityGenerics].reachability.isReachableViaWiFi;
    } while (!isReachable && (!INTERNET_MAX_ATTEMPTS_COUNT || (++attempt < INTERNET_MAX_ATTEMPTS_COUNT)) && (!INTERNET_MAX_ATTEMPTS_TIME || ([[NSDate date] timeIntervalSinceDate:startDate] < INTERNET_MAX_ATTEMPTS_TIME)));
    return isReachable;
}

+ (BOOL)isReachableViaWWAN {
    if (![KMHGenerics wwanEnabled]) {
        return NO;
    }
    
    int attempt = 0;
    BOOL isReachable;
    NSDate *startDate = [NSDate date];
    do {
        isReachable = [KMHGenerics reachabilityGenerics].reachability.isReachableViaWWAN;
    } while (!isReachable && (!INTERNET_MAX_ATTEMPTS_COUNT || (++attempt < INTERNET_MAX_ATTEMPTS_COUNT)) && (!INTERNET_MAX_ATTEMPTS_TIME || ([[NSDate date] timeIntervalSinceDate:startDate] < INTERNET_MAX_ATTEMPTS_TIME)));
    return isReachable;
}

+ (BOOL)wifiEnabled {
    NSNumber *wifiEnabledValue = [[KMHGenerics userDefaults] objectForKey:NSStringFromSelector(@selector(wifiEnabled))];
    if (wifiEnabledValue) {
        return wifiEnabledValue.boolValue;
    }
    
    [KMHGenerics setWiFiEnabled:YES];
    return [KMHGenerics wifiEnabled];
}

+ (void)setWiFiEnabled:(BOOL)wifiEnabled {
    NSUserDefaults *userDefaults = [KMHGenerics userDefaults];
    [userDefaults setBool:wifiEnabled forKey:NSStringFromSelector(@selector(wifiEnabled))];
    [userDefaults synchronize];
    [KMHGenerics updateInternetStatus];
}

+ (BOOL)wwanEnabled {
    NSNumber *wwanEnabledValue = [[KMHGenerics userDefaults] objectForKey:NSStringFromSelector(@selector(wwanEnabled))];
    if (wwanEnabledValue) {
        return wwanEnabledValue.boolValue;
    }
    
    [KMHGenerics setWWANEnabled:YES];
    return [KMHGenerics wwanEnabled];
}

+ (void)setWWANEnabled:(BOOL)wwanEnabled {
    NSUserDefaults *userDefaults = [KMHGenerics userDefaults];
    [userDefaults setBool:wwanEnabled forKey:NSStringFromSelector(@selector(wwanEnabled))];
    [userDefaults synchronize];
    [KMHGenerics updateInternetStatus];
}

+ (NSString *)publicIPAddress {
    return [KMHGenerics reachabilityGenerics].publicIPAddress;
}

+ (NSString *)privateIPAddress {
    return [KMHGenerics reachabilityGenerics].privateIPAddress;
}

+ (void)refreshInternetStatus {
    [KMHGenerics updateInternetStatus];
    [KMHGenerics fetchPublicIPAddress];
    [KMHGenerics fetchPrivateIPAddress];
}

#pragma mark Delegated Methods (NSURLConnectionDelegate)

#pragma mark Delegated Methods (NSURLConnectionDataDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.publicIPAddressData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.publicIPAddressData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.publicIPAddressData options:0 error:&error];
    if (error) {
        NSDictionary *userInfo = @{ReachabilityNotificationObjectKey : error};
        [NSNotificationCenter postNotificationToMainThread:ReachabilityDidReceiveErrorNotification object:nil userInfo:userInfo];
    }
    self.publicIPAddress = jsonObject[PublicIPAddressKey];
}

#pragma mark Private Methods (General)

+ (instancetype)reachabilityGenerics {
    static KMHGenerics *_reachabilityGenerics = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachabilityGenerics = [[KMHGenerics alloc] init];
        [_reachabilityGenerics addObserversToReachability];
    });
    return _reachabilityGenerics;
}

#pragma mark Private Methods (Convenience)

+ (id <ReachabilityDomainDelegate>)domainDelegate {
    return [KMHGenerics reachabilityGenerics].domainDelegate;
}

+ (NSUserDefaults *)userDefaults {
    return [KMHGenerics reachabilityGenerics].userDefaults;
}

#pragma mark Private Methods (Observers)

- (void)addObserversToReachability {
    [NSNotificationCenter addObserver:self selector:@selector(internetStatusDidChange:) name:kReachabilityChangedNotification object:self.reachability];
}

#pragma mark Private Methods (Responders)

- (void)internetStatusDidChange:(NSNotification *)notification {
    [KMHGenerics refreshInternetStatus];
}

#pragma mark Private Methods (Other)

+ (void)updateInternetStatus {
    if ([KMHGenerics isReachableViaWiFi]) {
        [KMHGenerics setInternetStatus:AKInternetConnectedViaWiFi];
    }
    else if ([KMHGenerics isReachableViaWWAN]) {
        [KMHGenerics setInternetStatus:AKInternetConnectedViaWWAN];
    }
    else {
        [KMHGenerics setInternetStatus:AKInternetDisconnected];
    }
}

+ (void)setInternetStatus:(AKInternetStatus)internetStatus {
    [KMHGenerics reachabilityGenerics].internetStatus = internetStatus;
}

+ (void)fetchPublicIPAddress {
    if (![KMHGenerics isReachable]) {
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:PublicIPAddressURL]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:[KMHGenerics reachabilityGenerics]];
    [connection start];
}

// SOURCE: http://stackoverflow.com/questions/15693556/how-to-get-the-cellular-ip-address-in-ios-app
+ (void)fetchPrivateIPAddress {
    if (![KMHGenerics isReachable]) {
        return;
    }
    
    NSString *privateIPAddress = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    privateIPAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    [KMHGenerics reachabilityGenerics].privateIPAddress = privateIPAddress;
}

@end
