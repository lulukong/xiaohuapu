//
//  DianJoyAdRequest.m
//  dianJoy_nativeAD_iOS_SDK
//
//  Created by Noodles Wang on 1/2/14.
//  Copyright (c) 2014 Noodles Wang. All rights reserved.
//

#import "DianJoyAdRequest.h"
#import "DianJoyAd.h"

#define DianJoy_AdList @"http://n.dianjoy.com/dev/api/lobster/adlist.php?"

@implementation DianJoyAdRequest

- (id)initWithDelegate:(id)aDelegate onResult:(SEL)onResultCallback onError:(SEL)onErrorCallback
{

    self = [super init];
    _aDdelegate = aDelegate;
    _onResultCallback = onResultCallback;
    _onErrorCallback = onErrorCallback;
    return self;
}

- (void)requestAd
{
    DianJoyAjaxClient *ajax = [[DianJoyAjaxClient alloc] init];
    [ajax setDelegate:self onSuccess:@selector(receiveAd:) onFail:@selector(failedReceiveAd:)];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    DianJoyAdUtil *adUtil = [DianJoyAdUtil singleton];
    [data setValue:adUtil.appID forKey:@"app_id"];
    [data setValue:@"JSON" forKey:@"output"];
    [data setValue:adUtil.idfa forKey:@"device_id"];
    [data setValue:adUtil.osVersion forKey:@"os_version"];
    [data setValue:@"1" forKey:@"fromios"]; // 分辨是ios广告还是android广告
    [ajax doAjaxWithURL:DianJoy_AdList type:@"POST" data:data];
    [ajax release];
    [data release];
}

#pragma mark - request ad delegate

- (void)receiveAd:(NSDictionary*)data
{
    NSArray *adArray = [[data objectForKey:@"data"] objectForKey:@"offers"];
    //todo：记录这次请求成功的事件
    if (adArray == nil || adArray.count == 0) {
        return;
    }
    NSMutableArray *adArray0 = [[NSMutableArray alloc] init];
    for (NSDictionary *data0 in adArray) {
        DianJoyAd *ad = [[DianJoyAd alloc] init];
        ad.delegate = _aDdelegate;
        ad.packageName = [data0 objectForKey:@"pack_name"];
        ad.bannerURL = [data0 objectForKey:@"banner_url"];
        ad.adID = [data0 objectForKey:@"ad_id"];
        ad.downloadURL = [data0 objectForKey:@"href"];
        [adArray0 addObject:ad];
    }
    if (_aDdelegate && [_aDdelegate respondsToSelector:_onResultCallback]) {
        [_aDdelegate performSelector:_onResultCallback withObject:[adArray0 autorelease]];
    }
}

- (void)failedReceiveAd:(NSError *)error
{
    if (_aDdelegate && [_aDdelegate respondsToSelector:_onErrorCallback]) {
        [_aDdelegate performSelector:_onErrorCallback withObject:error];
    }
}

@end
