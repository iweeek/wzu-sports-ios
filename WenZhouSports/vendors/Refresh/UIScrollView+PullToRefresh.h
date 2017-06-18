//
//  UIScrollView+PullToRefresh.h
//  test
//
//  Created by jia guo on 16/6/16.
//  Copyright © 2016年 jia guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBJRefreshHeaderView.h"
#import "ZBJRefreshFooterView.h"

@interface UIScrollView (PullToRefresh)

@property (nonatomic, strong) ZBJRefreshHeaderView *zbjRefreshHeaderView;
@property (nonatomic, strong) ZBJRefreshFooterView *zbjRefreshFooterView;
@property (nonatomic, strong) UIView *zbjNullDataView;
@property (copy, nonatomic) void (^zbjReloadDataBlock)(NSInteger totalDataCount);

- (NSInteger)zbjTotalDataCount;
@end
