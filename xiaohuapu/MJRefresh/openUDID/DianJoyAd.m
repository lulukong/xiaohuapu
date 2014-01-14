//
//  DianJoyAd.m
//  dianJoy_nativeAD_iOS_SDK
//
//  Created by Noodles Wang on 1/8/14.
//  Copyright (c) 2014 Noodles Wang. All rights reserved.
//

#import "DianJoyAd.h"

@implementation DianJoyAd

@synthesize iconURL = _iconURL;

@synthesize name = _name;

@synthesize text = _text;

@synthesize description = _description;

@synthesize size = _size;

@synthesize version = _version;

@synthesize downloadURL = _downloadURL;

@synthesize adID = _adID;

@synthesize bannerURL = _bannerURL;

@synthesize packageName = _packageName;

@synthesize iconImgView = _iconImgView;

@synthesize bannerImgView = _bannerImgView;

@synthesize delegate = _delegate;

- (void)setIconURL:(NSString *)iconURL
{
    if (iconURL != _iconURL) {
        [_iconURL release];
        _iconURL = [iconURL retain];
    }
    //异步加载iconview,这个版本暂时用不到
//    self.iconImgView = [[DianJoyAsyncImageView alloc] initWithFrame:CGRectMake(10, 7, 300, 200)];
//    _iconImgView.delegate = self;
//    _iconImgView.cachesImage = YES;
//    _iconImgView.imageURL = [NSURL URLWithString:_iconURL];
}

- (void)setBannerURL:(NSString *)bannerURL
{
    if (bannerURL != _bannerURL) {
        [_bannerURL release];
        _bannerURL = [bannerURL retain];
    }
    //异步加载banner view
    self.bannerImgView = [[DianJoyAsyncImageView alloc] initWithFrame:CGRectMake(10, 7, 300, 200)];
    _bannerImgView.delegate = self;
    _bannerImgView.cachesImage = YES;
    _bannerImgView.imageURL = [NSURL URLWithString:_bannerURL];

}

- (void)dealloc
{
    self.iconURL = nil;
    self.name = nil;
    self.text = nil;
    self.description = nil;
    self.size = nil;
    self.version = nil;
    self.downloadURL = nil;
    self.adID = nil;
    self.bannerURL = nil;
    self.packageName = nil;
    self.iconImgView = nil;
    self.bannerImgView = nil;
    self.delegate = nil;
    [super dealloc];
}

#pragma mark - asncImage delegate
-(void)imageView:(DianJoyAsyncImageView *)sender loadedImage:(UIImage *)imageLoaded fromURL:(NSURL *)url
{
    if (_delegate && [_delegate respondsToSelector:@selector(adFinishLoad:)]) {
        [_delegate adFinishLoad:self];
    }
}

@end
