//
//  DianJoyAdControllerImpl.m
//  dianJoy_nativeAD_iOS_SDK
//
//  Created by Noodles Wang on 1/2/14.
//  Copyright (c) 2014 Noodles Wang. All rights reserved.
//

#import "DianJoyAdControllerImpl.h"

#define adViewFrame CGRectMake(0,0,320,214)

static DianJoyAdControllerImpl *sharedInstance = nil;

@implementation DianJoyAdControllerImpl

#pragma mark - Singleton methods

+ (id)sharedAdController
{
    @synchronized(self) {
        if(sharedInstance == nil)
            [[self alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initParameters];
    }
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
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

- (void)initParameters
{
    _adRequest = [[DianJoyAdRequest alloc] initWithDelegate:self onResult:@selector(receiveAds:) onError:@selector(failedWithError:)];
    _adUtil = [DianJoyAdUtil singleton];
    _adList = [[NSMutableArray alloc] init];
    _finishLoading = NO;
    _adIndex = 0;
}

- (oneway void)release
{
    // never release
}

- (id)autorelease
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;
}

#pragma mark - public api

- (void)setAdDelegate:(id)delegate
{
    _adDelegate = delegate;
}

- (UIView *)getAdView
{
    @synchronized(self)
    {
        if (_adList.count <= _adIndex) { //广告数组取完了最后一个，从第一个重新开始
            _adIndex = 0;
        }
        DianJoyAdView *adView = [[DianJoyAdView alloc] initWithFrame:adViewFrame ad:[_adList objectAtIndex:_adIndex]];
        _adIndex++;
        return [adView autorelease];
    }
}
- (void)setAppId:(NSString *)appId
{
    _adUtil.appID = appId;
    [self refreshAdList];     //只有设置appID以后才能请求广告列表
}
#pragma mark - DianJoy request callback

- (void)receiveAds:(NSArray *)adList
{
    // 暂时不需要做任何事情。
}
- (void)failedWithError:(NSError *)error
{
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(failToReceiveAdWithError:)]) {
        [_adDelegate failToReceiveAdWithError:error];
    }
}

#pragma mark - DianJoyAd delegate

- (void)adFinishLoad:(DianJoyAd *)ad
{
    @synchronized(self)
    {
        [_adList addObject:ad];
        if (!_finishLoading) {
            if (_adDelegate && [_adDelegate respondsToSelector:@selector(didFinishLoadAd:)]) {
                [_adDelegate didFinishLoadAd:self];
        }
            _finishLoading = YES;
        }
    }
}

#pragma mark - self methods

- (void)refreshAdList
{
    [_adRequest requestAd];
}

@end
