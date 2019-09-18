//
//  ViewController.m
//  FFRouter_Test
//
//  Created by jielisong on 2019/9/17.
//  Copyright © 2019 cz10000. All rights reserved.
//

#import "ViewController.h"
#import <FFRouter.h>
#import "RouterDetailVC.h"
#import "RouterCallbackVC.h"

static NSString * const cellIdentifier = @"demoCellIdentifier";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabDemo;
@property (nonatomic, strong) NSArray *aryPage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"FFRouterDemo";
    
    [self.view addSubview:self.tabDemo];
    
    [self registerRouteURL];
    [self addRewriteMatchRules];
}

-(void)registerRouteURL{
    [FFRouter setLogEnabled:YES];
    
    //注册 protocol://page/routeDetail
    [FFRouter registerRouteURL:@"protocol://page/routeDetail" handler:^(NSDictionary *routerParameters) {
        RouterDetailVC *routeDetail = [[RouterDetailVC alloc] init];
        [FFRouterNavigation pushViewController:routeDetail animated:YES];
        
        [routeDetail addLogText:@"match --> protocol://page/routeDetail"];
        [routeDetail addLogText:[NSString stringWithFormat:@"%@",routerParameters]];
        
        if ([routerParameters objectForKey:@"img"]) {
            UIImage *img = [routerParameters objectForKey:@"img"];
            [routeDetail setLogImage:img];
        }
    }];
    
    //注册 protocol://page/routeObjectDetail
    [FFRouter registerObjectRouteURL:@"protocol://page/routeObjectDetail" handler:^id(NSDictionary *routerParameters) {
        RouterDetailVC *routeDetail = [RouterDetailVC new];
        NSString *str = [NSString stringWithFormat:@"%@",[routeDetail testDetailObjectResult]];
        return str;
    }];
    
    //注册：protocol://page/RouteCallbackDetail
    [FFRouter registerCallbackRouteURL:@"protocol://page/RouteCallbackDetail" handler:^(NSDictionary *routerParameters, FFRouterCallback targetCallback) {
        RouterCallbackVC *callback = [RouterCallbackVC new];
        callback.infoStr = [NSString stringWithFormat:@"%@",routerParameters];
        [callback testCallback:^(NSString * _Nonnull callBackStr) {
            targetCallback(callBackStr);
        }];
        [FFRouterNavigation pushViewController:callback animated:YES];
    }];
    
    //注册 wildcard://*
    [FFRouter registerRouteURL:@"wildcard://*" handler:^(NSDictionary *routerParameters) {
        RouterDetailVC *routeDetail = [RouterDetailVC new];
        [FFRouterNavigation pushViewController:routeDetail animated:YES];
        
        [routeDetail addLogText:@"match --> wildcard://*"];
        [routeDetail addLogText:[NSString stringWithFormat:@"%@",routerParameters]];
    }];
    
    //route一个未注册URL回调
    [FFRouter routeUnregisterURLHandler:^(NSString *routerURL) {
        NSLog(@"未注册的URL:\n%@",routerURL);
    }];
}

-(void)addRewriteMatchRules{
    [FFRouterRewrite addRewriteMatchRule:@"(?:https://)?www.baidu.com/wd/(\\d+)" targetRule:@"protocol://page/routeDetail?id=$1"];
    [FFRouterRewrite addRewriteMatchRule:@"(?:https://)?www.taobao.com/search/(.*)" targetRule:@"protocol://page/routeDetail?id=$$1"];
    [FFRouterRewrite addRewriteMatchRule:@"(?:https://)?www.jd.com/search/(.*)" targetRule:@"protocol://page/routeDetail?id=$#1"];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.aryPage.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.aryPage[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{ //routeURL
            [FFRouter routeURL:@"protocol://page/routeDetail?nickname=imlifengfeng&nation=中国"];
        }break;
        case 1:{ //routeURL并传递对象参数
            [FFRouter routeURL:@"protocol://page/routeDetail?nickname=imlifengfeng&nation=l中国" withParameters:@{@"img":[UIImage imageNamed:@"router_test_img"]}];
        }break;
        case 2:{ //通过routeObjectURL获取返回值
            NSString *ret = [FFRouter routeObjectURL:@"protocol://page/routeObjectDetail"];
            self.title = ret;
        }break;
        case 3:{ //通过routeCallbackURL异步回调获取返回值
            [FFRouter routeCallbackURL:@"protocol://page/RouteCallbackDetail" targetCallback:^(id callbackObjc) {
                self.title = [NSString stringWithFormat:@"%@",callbackObjc];
            }];
        }break;
        case 4:{ //通配符（*）方式注册URL
            [FFRouter routeURL:@"wildcard://path/path2/path3?nickname=imlifengfeng&nation=中国"];
        }break;
        case 5:{ //route一个未注册的URL
            [FFRouter routeURL:@"protocol://fhfhfhffhfhfhfhfhf"];
        }break;
        case 6:{ //Rewrite一个URL
            [FFRouter routeURL:@"https://www.baidu.com/wd/666"];
        }break;
        case 7:{ //Rewrite一个URL并对某值 Encode
            [FFRouter routeURL:@"https://www.taobao.com/search/原子弹"];
        }break;
        case 8:{ //Rewrite一个URL并对某值URL Decode
            [FFRouter routeURL:@"https://www.jd.com/search/%E5%8E%9F%E5%AD%90%E5%BC%B9"];
        }break;
        default:
            break;
    }
}


-(UITableView *)tabDemo{
    
    if (!_tabDemo) {
        _tabDemo = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tabDemo.delegate = self;
        _tabDemo.dataSource = self;
    }
    return _tabDemo;
}

-(NSArray *)aryPage{
    if (!_aryPage) {
        _aryPage = @[@"routeURL",
                     @"routeURL并传递对象参数",
                     @"通过routeObjectURL获取返回值",
                     @"通过routeCallbackURL异步回调获得返回值",
                     @"通配符*方式注册URL",
                     @"route一个未注册的URL",
                     @"Rewrite一个URL",
                     @"Rewrite一个URL并对某值URL Encode",
                     @"Rewrite一个URL并对某值URL Encode"];
    }
    return _aryPage;
}


@end
