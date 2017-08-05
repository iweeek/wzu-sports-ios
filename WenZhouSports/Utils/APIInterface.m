//
//  LNDAPIInterface.m
//  lnd
//
//  Created by wanggang on 6/30/16.
//  Copyright © 2016 zhubaijia. All rights reserved.
//

#import "APIInterface.h"

#ifdef DEBUG

NSString *const Server = @"http://120.77.72.16:8080/api/%@";
//NSString *const Server = @"http://192.168.1.102:8080/api/%@";
NSString *const AMapKey = @"b308932d17ffdfe0badb45817677b50c";

#else

NSString *const Server = @"http://120.77.72.16:8080/api/%@";
NSString *const AMapKey = @"b308932d17ffdfe0badb45817677b50c";

#endif

NSInteger const pageSize = 20;

//NSString *const APPUpdateUrl = @"https://itunes.apple.com/cn/app/id1218112200?ls=1&mt=8";






