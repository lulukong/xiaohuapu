//
//  DianJoyAd.h
//  dianJoy_nativeAD_iOS_SDK
//
//  Created by Noodles Wang on 1/8/14.
//  Copyright (c) 2014 Noodles Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DianJoyAsyncImageView.h"

@interface DianJoyAd : NSObject<DianJoyAsyncImageViewDelegate>

@property (nonatomic, retain) NSString *iconURL;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *text;

@property (nonatomic, retain) NSString *description;

@property (nonatomic, retain) NSString *size;

@property (nonatomic, retain) NSString *version;

@property (nonatomic, retain) NSString *downloadURL;

@property (nonatomic, retain) NSString *adID;

@property (nonatomic, retain) NSString *bannerURL;

@property (nonatomic, retain) NSString *packageName;

@property (nonatomic, retain) DianJoyAsyncImageView  *iconImgView;

@property (nonatomic, retain) DianJoyAsyncImageView  *bannerImgView;

@property (nonatomic, assign) id delegate;

@end

@protocol DianJoyAdDelegate <NSObject>

- (void)adFinishLoad:(DianJoyAd *) ad;

@end