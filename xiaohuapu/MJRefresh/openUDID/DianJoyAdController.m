//
//  DianJoyAdController.m
//  dianJoy_nativeAD_iOS_SDK
//
//  Created by Noodles Wang on 1/2/14.
//  Copyright (c) 2014 Noodles Wang. All rights reserved.
//

#import "DianJoyAdController.h"
#import "DianJoyAdControllerImpl.h"

@implementation DianJoyAdController

+ (DianJoyAdController *)sharedDianJoyAdController
{
    DianJoyAdController *adController = [DianJoyAdControllerImpl sharedAdController];
    return adController;
}

- (void)setAdDelegate:(id)delegate
{
    NSLog(@"you should never visit this method");
}


- (UIView*)getAdView
{
//    NSLog(@"you should never visit this method");
    return nil; 
}
- (void)setAppId:(NSString *)appId
{
    
}
@end
