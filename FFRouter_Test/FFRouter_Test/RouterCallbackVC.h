//
//  RouterCallbackVC.h
//  FFRouter_Test
//
//  Created by jielisong on 2019/9/17.
//  Copyright © 2019 cz10000. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CallBack)(NSString *callBackStr);

@interface RouterCallbackVC : UIViewController

@property (nonatomic, strong) NSString *infoStr;


-(void)testCallback:(CallBack)callback;

@end

NS_ASSUME_NONNULL_END
