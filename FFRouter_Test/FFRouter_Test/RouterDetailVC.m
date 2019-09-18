//
//  RouterDetailVC.m
//  FFRouter_Test
//
//  Created by jielisong on 2019/9/17.
//  Copyright © 2019 cz10000. All rights reserved.
//

#import "RouterDetailVC.h"

@interface RouterDetailVC ()

@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UIImageView *imvContent;

@property (nonatomic, strong) NSString *strLog;
@property (nonatomic, strong) UIImage *imgLog;

@end

@implementation RouterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"RouteDetailVC";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.lblContent];
    [self.view addSubview:self.imvContent];
    
    [self showDetailData];
}

-(void)showDetailData{
    
    self.lblContent.text = self.strLog;
    self.imvContent.image = self.imgLog;
}

-(void)addLogText:(NSString *)text{
    if (self.strLog.length > 0) {
        self.strLog = [NSString stringWithFormat:@"%@\n--------------\n%@",self.strLog,text];
    }else{
        self.strLog = text;
    }
}

-(void)setLogImage:(UIImage *)image{
    self.imgLog = image;
}

-(NSString *)testDetailObjectResult{
    return @"这是来自RouteDetailVC的字符串";
}


-(UILabel *)lblContent{
    if (!_lblContent) {
        _lblContent = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, CGRectGetWidth(self.view.frame) - 20*2, 200)];
        _lblContent.font = [UIFont systemFontOfSize:16];
        _lblContent.numberOfLines = 0;
    }
    return _lblContent;
}

-(UIImageView *)imvContent{
    if (!_imvContent) {
        _imvContent = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150)/2, CGRectGetMaxY(self.lblContent.frame) + 30, 150, 150)];
    }
    return _imvContent;
}

@end
