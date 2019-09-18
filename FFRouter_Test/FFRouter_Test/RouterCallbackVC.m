//
//  RouterCallbackVC.m
//  FFRouter_Test
//
//  Created by jielisong on 2019/9/17.
//  Copyright © 2019 cz10000. All rights reserved.
//

#import "RouterCallbackVC.h"

@interface RouterCallbackVC ()

@property (nonatomic, copy) CallBack callback;

@property (nonatomic, strong) UILabel *lblInfo;

@property (nonatomic, strong) UIButton *btnCallBack;

@end

@implementation RouterCallbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.btnCallBack];
    [self.view addSubview:self.lblInfo];
    
    self.lblInfo.text = self.infoStr;
}

-(void)testCallback:(CallBack)callback{
    self.callback = callback;
}

-(void)callBackClick:(UIButton *)sender{
    if (self.callback) {
        NSString *callbackStr = [NSString stringWithFormat:@"我是回调过来的字符串 %@",[self getCurrentTime]];
        self.callback(callbackStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:dateNow];
    
    return currentTimeString;
}

-(UIButton *)btnCallBack{
    if (!_btnCallBack) {
        _btnCallBack = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 120)/2, 0, 120, 40)];
        [_btnCallBack setTitle:@"回调并返回" forState:UIControlStateNormal];
        [_btnCallBack setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _btnCallBack.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnCallBack addTarget:self action:@selector(callBackClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCallBack;
}

-(UILabel *)lblInfo{
    if (!_lblInfo) {
        _lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.btnCallBack.frame) + 30, CGRectGetWidth(self.view.frame) - 50*2, 50)];
        _lblInfo.textAlignment = NSTextAlignmentCenter;
        _lblInfo.font = [UIFont systemFontOfSize:14];
        _lblInfo.numberOfLines = 0;
        
        CGRect crect = self.btnCallBack.frame;
        crect.origin.y = (CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_lblInfo.frame))/2;
        self.btnCallBack.frame = crect;
        
        CGRect irect = self.lblInfo.frame;
        irect.origin.y = CGRectGetMaxY(self.btnCallBack.frame) + 30;
        self.lblInfo.frame = irect;
    }
    return _lblInfo;
}

@end
