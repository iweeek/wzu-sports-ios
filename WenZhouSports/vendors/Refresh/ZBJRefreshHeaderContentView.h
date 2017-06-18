//
//  ZBJRefreshContentView.h
//  test
//
//  Created by jia guo on 16/6/20.
//  Copyright © 2016年 jia guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBJRefreshView.h"

@interface ZBJRefreshHeaderContentView : UIView<ZBJRefreshContentViewDelegate>

@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end
