//
//  DianJoyAdView.m
//  dianJoy_nativeAD_iOS_SDK
//
//  Created by Noodles Wang on 1/9/14.
//  Copyright (c) 2014 Noodles Wang. All rights reserved.
//

#import "DianJoyAdView.h"

@implementation DianJoyAdView

- (id)initWithFrame:(CGRect)frame ad:(DianJoyAd *)adObj
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _adObj = adObj;
        [self initGUI:frame];
    }
    return self;
}

- (void)initGUI:(CGRect)frame
{
//    UIImageView *imgView = [_adObj.bannerImgView copy];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = _adObj.bannerImgView.frame;
    imgView.image = [_adObj.bannerImgView.image copy];
    [self addSubview:imgView];
    [imgView release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"ad View was touched");
    NSString *adURL = _adObj.downloadURL;
    [self launchITunes:adURL];
}

- (void)launchITunes:(NSString*)finalURL
{
    NSURL *myURL = [NSURL URLWithString:finalURL];
    NSURLRequest *clickRequest = [NSURLRequest requestWithURL:myURL];
    [NSURLConnection connectionWithRequest:clickRequest delegate:nil];
    [[UIApplication sharedApplication] openURL:myURL];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
