//
//  DianJoyAdView.h
//  dianJoy_nativeAD_iOS_SDK
//
//  Created by Noodles Wang on 1/9/14.
//  Copyright (c) 2014 Noodles Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DianJoyAd.h"

@interface DianJoyAdView : UIView
{
    DianJoyAd *_adObj;
}

- (id)initWithFrame:(CGRect)frame ad:(DianJoyAd *)adObj;
@end
