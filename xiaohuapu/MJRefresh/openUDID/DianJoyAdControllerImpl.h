//
//  DianJoyAdControllerImpl.h
//  dianJoy_nativeAD_iOS_SDK
//
//  Created by Noodles Wang on 1/2/14.
//  Copyright (c) 2014 Noodles Wang. All rights reserved.
//

#import "DianJoyAdController.h"
#import "DianJoyAdRequest.h"
#import "DianJoyAd.h"
#import "DianJoyAdUtil.h"
#import "DianJoyAdView.h"

#define DIANJOY_REFRESH_TIME @"dianJoy_refresh_time.plist"

/**
 *  DianJoyAdController具体实现
 */
@interface DianJoyAdControllerImpl : DianJoyAdController
{
    id<DianJoyAdControllerDelegate> _adDelegate;
    NSMutableArray *_adList; // 广告列表，存储每个封装好的DianJoyAd对象
    bool _finishLoading;    
    DianJoyAdRequest *_adRequest;
    DianJoyAdUtil *_adUtil;
    int _adIndex;
}
+ (id)sharedAdController;

@end
