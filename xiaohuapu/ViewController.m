//
//  ViewController.m
//  xiaohuapu
//
//  Created by lulu on 14-1-2.
//  Copyright (c) 2014年 dianjoy. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "MJRefresh.h"
#import "MJRefreshFooterView.h"
#import "InfoCell.h"
#import "AdvertisementCell.h"
@interface ViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    BOOL                hasMore;
    BOOL                isLoading;
}


@end

@implementation ViewController
@synthesize dataArray;
@synthesize mytableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImageView *tab = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    tab.image = [UIImage imageNamed:@"tab.png"];
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(top)] autorelease];
    [tab addGestureRecognizer:singleTap];
    [self.view addSubview:tab];
    
    self.mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, self.view.frame.size.height-40)];
    self.mytableView.dataSource = self;
    self.mytableView.delegate = self;
    [self.view addSubview:self.mytableView];
    
    [self.mytableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    minTime = [[NSString alloc] init];
    maxTime = [[NSString alloc] init];
    
//    page = 1;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    page = [userDefaultes integerForKey:@"page"] + 1;
    NSLog(@"page===%d",page);
    order = 2;

    self.dataArray = [NSMutableArray array];
    [self getData:page andOrder:2 andtime:minTime];
    
    hasMore = YES;
    isLoading = NO;
    // 3.3行集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.mytableView;
    _header.delegate = self;
    
    // 4.3行集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.mytableView;
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        if (!hasMore) {
            return ;
        }
        if(isLoading){
            return;
        }
        page++;
        order = 2;
        [self getData:page andOrder:order andtime:maxTime];
    };
}
- (void)getData:(int)p andOrder:(int)o andtime:(NSString *)so0
{
    NSString *url = [NSString stringWithFormat:@"http://z.turbopush.com/jokelist.php?p=%d&o=%d&so=%@",page,o,so0];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:[NSNumber numberWithInteger:p] forKey:@"page"];
    [info setObject:[NSNumber numberWithInt:o] forKey:@"order"];
    [info setObject:so0 forKey:@"so"];
    [request setUserInfo:info];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)reloadData:(NSArray *)result
{
    if (result.count == 0) {
        hasMore = NO;
    }
    [self.mytableView reloadData];
    [self reloadDeals];
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    page++;
    order = 1;
    [self getData:page andOrder:order andtime:minTime];
}


- (void)reloadDeals
{
    // 结束刷新状态
    [_header endRefreshing];
    [_footer endRefreshing];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    isLoading = YES;
}

- (void)requestFinished:(ASIHTTPRequest *)httprequest
{
    NSDictionary  *info = [httprequest userInfo];
    NSNumber  *page1 = [info objectForKey:@"page"];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:httprequest.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"-=-=-=-=-=-=-=-=-%@",dic);
    if ([page1 intValue] == 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:[dic objectForKey:@"data"]];
//    for (int i = 0;i<[[dic objectForKey:@"data"] count]; i++) {
//        [self.dataArray insertObject:[[dic objectForKey:@"data"] objectAtIndex:i] atIndex:0];
//    }
    [self reloadData:self.dataArray];
    isLoading = NO;
    NSLog(@"%d",page);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:page forKey:@"page"];
    
    minTime = [[self.dataArray objectAtIndex:0] objectForKey:@"date"];
    maxTime = [[self.dataArray objectAtIndex:[self.dataArray count]-1] objectForKey:@"date"];
    NSLog(@"%@",[[self.dataArray objectAtIndex:0] objectForKey:@"date"]);
    NSLog(@"%@",[[self.dataArray objectAtIndex:[self.dataArray count]-1] objectForKey:@"date"]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    isLoading = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

//- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"cell";
//    static NSString *adCellID = @"adCell";
//    NSDictionary  *info =  [self.dataArray objectAtIndex:indexPath.row];
//    if ([info isKindOfClass:[NSString class]]) {
//        AdvertisementCell *cell = [self.mytableView dequeueReusableCellWithIdentifier:adCellID];
//        if (cell == nil) {
//            cell = [[AdvertisementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adCellID];
//        }
//        return cell;
//    }else{
//        InfoCell *cell = [self.mytableView dequeueReusableCellWithIdentifier:cellID];
//        if (cell == nil) {
//            cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        }
//        [cell setInfo:info];
//        headimage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
//        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",indexPath.row%50+1];
//        [headimage setImage:[UIImage imageNamed:imageName]];
//        [headimage setTag:10002];
//        [cell addSubview:headimage];
//        return cell;
//    }
//    return nil;
//}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
//    static NSString *adCellID = @"adCell";
    NSDictionary  *info =  [self.dataArray objectAtIndex:indexPath.row];
//    if (indexPath.row %6 == 5) {
//        AdvertisementCell *cell = [self.mytableView dequeueReusableCellWithIdentifier:adCellID];
//        if (cell == nil) {
//            cell = [[AdvertisementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adCellID];
//        }
//        [self.dataArray insertObject:@"ad" atIndex:indexPath.row];
//        return cell;
//    }else{
        InfoCell *cell = [self.mytableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell setInfo:info];
        headimage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",indexPath.row%50+1];
        [headimage setImage:[UIImage imageNamed:imageName]];
        [headimage setTag:10002];
        [cell addSubview:headimage];
        return cell;
//    }
//    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary  *info =  [self.dataArray objectAtIndex:indexPath.row];
    if ([info isKindOfClass:[NSString class]]) {
        return 200;
    }
    return [InfoCell height:info];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mytableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (BOOL)shouldAutorotate
{
    return NO;
}

//#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    //return YES;
}

- (void)dealloc
{
    [self.mytableView release];
    [self.dataArray release];
    [super dealloc];
}

-(void)top
{
    [self.mytableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

@end




















