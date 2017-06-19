//
//  ZBJRefreshFooterContentView.h
//  ZBJKit
//
//  Created by jia guo on 16/6/22.
//  Copyright © 2016年 guo jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBJRefreshView.h"

@interface ZBJRefreshFooterContentView : UIView<ZBJRefreshContentViewDelegate>

@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end
