//
//  ViewController.h
//  xiaohuapu
//
//  Created by lulu on 14-1-2.
//  Copyright (c) 2014年 dianjoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataArray;
    NSInteger page;
    NSInteger order;
    UITableView *mytableView;
    UIImageView *headimage;
    NSString *minTime;
    NSString *maxTime;
}

@property (retain, nonatomic) NSMutableArray *dataArray;
@property (retain, nonatomic) UITableView *mytableView;


@end
