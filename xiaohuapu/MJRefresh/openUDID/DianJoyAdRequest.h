//
//  DianJoyAdRequest.h
//  dianJoy_nativeAD_iOS_SDK
//
//  Created by Noodles Wang on 1/2/14.
//  Copyright (c) 2014 Noodles Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DianJoyAjaxClient.h"
#import "DianJoyAdUtil.h"

@interface DianJoyAdRequest : NSObject
{
    id _aDdelegate;
    SEL _onResultCallback;
    SEL _onErrorCallback;
}

- (id)initWithDelegate:(id)aDelegate onResult:(SEL)onResultCallback onError:(SEL)onErrorCallback;

- (void)requestAd;

@end
