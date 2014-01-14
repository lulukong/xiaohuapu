//
//  DianJoyAdUtil.m
//  DianJoyAdLib
//
//  Created by kaiyang on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DianJoyAdUtil.h"
#import <AdSupport/AdSupport.h>

static DianJoyAdUtil *sharedInstance = nil;

@interface DianJoyAdUtil (Private)

- (void)updateStatus;
- (void)reachabilityChanged:(NSNotification *)note;
- (void)updateLocation;
- (NSString *) macaddressOfDianJoy;
@end

@implementation DianJoyAdUtil

@synthesize remoteHostStatus, deviceId, osVersion , model, bundleStatus, openUDID, idfa, idfv, appID;

-(id)init {
    self = [super init];
    
    self.remoteHostStatus = NotReachable;
	device = [UIDevice currentDevice];
    
    // device info, perhaps nil.
    self.deviceId = [self macaddressOfDianJoy];
    self.openUDID = [DianJoy_OpenUDID value];

    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        self.idfa = @"";
        self.idfv = @"";
    } else {
        self.idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        self.idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    self.osVersion = [[UIDevice currentDevice] systemVersion];
	self.model = [[UIDevice currentDevice] model];
	self.bundleStatus = [[NSBundle mainBundle] bundleIdentifier];
    self.macAddress = [self macaddressOfDianJoy];
    // get network status. wifi or carrier network.
    [[DianJoyReachability sharedReachability] setHostName:@"www.baidu.com"];
    [[DianJoyReachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
    
	//设备的网络连接状态
    [self updateStatus];
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:@"kNetworkReachabilityChangedNotification" object:nil];
    //NSLog(@"DianJoyAdUtil init...");
    return self;
}

#pragma mark - Network status

// callback function
- (void)reachabilityChanged:(NSNotification *)note {
    [self updateStatus];
}

- (void)updateStatus {
	//检查设备的链接情况，是否用wifi链接
    // Query the SystemConfiguration framework for the state of the device's network connections.
    self.remoteHostStatus = [[DianJoyReachability sharedReachability] remoteHostStatus];
    //NSLog(@"List value %@", (remoteHostStatus == ReachableViaCarrierDataNetwork) ? @"yes" : @"no");
}

- (BOOL)isCarrierDataNetworkActive {
    return (self.remoteHostStatus == ReachableViaCarrierDataNetwork);
}

#pragma mark - get macaddress

- (NSString *) macaddressOfDianJoy{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

#pragma mark - Singleton Methods
+ (id)singleton {
    @synchronized(self) {
        if(sharedInstance == nil)
            [[self alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if(sharedInstance == nil)  {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void)release{
    // never release
}

- (id)autorelease {
    return self;
}

@end