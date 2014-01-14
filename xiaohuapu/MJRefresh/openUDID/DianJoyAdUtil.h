//
//  DianJoyAdUtil.h
//  DianJoyAdLib
//
//  Created by kaiyang on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "DianJoyReachability.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#import "DianJoy_OpenUDID.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface NSString(MD5Addition)

- (NSString *) stringFromMD5;

@end
@implementation NSString(MD5Addition)

- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}
@end

@interface UIDevice (Jailbroken)
/**
 *  判断是否是越狱用户
 *
 *  @return 1,是越狱用户 0，不是
 */
- (BOOL)isJailbroken;
/**
 *  是否是手机
 *
 *  @return iphone：1，ipad：0
 */
-(BOOL) isPhone;
@end

@implementation UIDevice (Jailbroken)

- (BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}
- (BOOL)isPhone
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}
@end

@interface DianJoyAdUtil : NSObject {
    DianJoyNetworkStatus remoteHostStatus;
    // keep the current location.
    NSString *deviceId; //设备信息
    NSString *osVersion;//系统版本
	NSString *model;
    NSString *_macAddress;
    NSString *_openUDID;
    NSString *_idfv;
    NSString *_idfa;
    
	NSString *bundleStatus;
    
	UIDevice *device;
}

@property DianJoyNetworkStatus remoteHostStatus;
@property (nonatomic, retain) NSString *deviceId;
@property (nonatomic, retain) NSString *osVersion;
@property (nonatomic, retain) NSString *model;
@property (nonatomic, retain) NSString *bundleStatus;
@property (nonatomic, retain) NSString *macAddress;
@property (nonatomic, retain) NSString *openUDID;
@property (nonatomic, retain) NSString *idfv;
@property (nonatomic, retain) NSString *idfa;
@property (nonatomic, retain) NSString *appID;
+ (id)singleton;
- (BOOL)isCarrierDataNetworkActive;

@end
