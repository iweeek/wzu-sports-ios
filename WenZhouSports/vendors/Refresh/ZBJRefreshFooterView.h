//
//  ZBJRefreshFooterView.h
//  ZBJKit
//
//  Created by jia guo on 16/6/22.
//  Copyright © 2016年 guo jia. All rights reserved.
//

#import "ZBJRefreshView.h"


typedef void(^refreshingBlock)();

@protocol ZBJRefreshContentViewDelegate2;

@interface ZBJRefreshFooterView : ZBJRefreshView

/** 内容视图，需实现内容视图协议 */
@property (nonatomic, strong) UIView<ZBJRefreshContentViewDelegate> *contentView;

/** 初始化 */
+ (instancetype)footerWithRefreshingBlock:(refreshingBlock)refreshingBlock;

/** 有自定义contenView的初始化 */
+ (instancetype)footerRefreshViewWithContentView:(UIView<ZBJRefreshContentViewDelegate> *) contentView
                               refreshingBlock:(refreshingBlock)refreshingBlock;

/** 没有更多 */
- (void)endRefreshingWithNoMoreData;


@end
