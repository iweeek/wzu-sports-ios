//
//  ZBJRefreshHeaderView.h
//  test
//
//  Created by jia guo on 16/6/22.
//  Copyright © 2016年 jia guo. All rights reserved.
//

#import "ZBJRefreshView.h"

@interface ZBJRefreshHeaderView : ZBJRefreshView

/** 内容视图，需实现内容视图协议 */
@property (nonatomic, strong) UIView<ZBJRefreshContentViewDelegate> *contentView;

+ (instancetype)headerRefreshViewWithContentView:(UIView<ZBJRefreshContentViewDelegate> *) contentView
                               refreshingBlock:(refreshingBlock)refreshingBlock;
+ (instancetype)headerWithRefreshingBlock:(refreshingBlock)refreshingBlock;

/** 启动刷新 */
- (void)refresh;

@end
