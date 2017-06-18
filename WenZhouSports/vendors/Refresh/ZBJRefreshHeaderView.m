//
//  ZBJRefreshHeaderView.m
//  test
//
//  Created by jia guo on 16/6/22.
//  Copyright © 2016年 jia guo. All rights reserved.
//

#import "ZBJRefreshHeaderView.h"
#import "ZBJRefreshHeaderContentView.h"
#import "UIScrollView+PullToRefresh.h"

static NSString *const zbjScrollerViewContentOffset = @"contentOffset";
static NSString *const zbjScrollerViewContentSize = @"contentSize";
static NSString *const zbjPanGestureRecognizerState = @"state";

static const NSInteger refreshViewHeight = 50;

@implementation ZBJRefreshHeaderView

+ (instancetype)headerRefreshViewWithContentView:(UIView<ZBJRefreshContentViewDelegate> *) contentView
                               refreshingBlock:(refreshingBlock)refreshingBlock
{
    ZBJRefreshHeaderView *refreshView = [[ZBJRefreshHeaderView alloc] init];
    refreshView.refreshingBlock = refreshingBlock;
    refreshView.contentView = contentView;
    refreshView.contentViewDelegate = contentView;
    return refreshView;
}

+ (instancetype)headerWithRefreshingBlock:(refreshingBlock)refreshingBlock
{
    ZBJRefreshHeaderView *refreshView = [[ZBJRefreshHeaderView alloc] init];
    refreshView.refreshingBlock = refreshingBlock;
    return refreshView;
}

// 父view更改后自动执行下方法
- (void) willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        // 设置默认大小
        self.frame = CGRectMake(newSuperview.frame.origin.x, -refreshViewHeight, newSuperview.frame.size.width, refreshViewHeight);
        // 如果有自定义contentView，根据contentView调整refreshView大小
        if (![self.contentView isMemberOfClass:[ZBJRefreshHeaderContentView class]]) {
            CGRect newFrame = self.contentView.frame;
            self.frame = newFrame;
        }
        
        [self.contentView setFrame:self.bounds];
        [self addSubview:self.contentView];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // ContentOffset改变
    if ([keyPath isEqualToString:zbjScrollerViewContentOffset]) {
        // 如果正在刷新中，直接返回
        if (self.zbjRefreshState == RefreshStateRefreshing) {
            return;
        }
        // 执行委托给contentView的方法
        if ([self.contentViewDelegate respondsToSelector:@selector(scrollViewContentOffsetDidChange:)])
            [self.contentViewDelegate scrollViewContentOffsetDidChange:change];
        
        // 根据offset大小改变刷新状态，判断松手可以刷新或是松手取消刷新
        CGFloat offsetY = self.scrollerView.contentOffset.y;
        if(self.scrollerView.isDragging){
            if (self.zbjRefreshState == RefreshStateIdle && offsetY <  - self.frame.size.height) {
                // 转为即将刷新状态
                self.zbjRefreshState = RefreshStatePulling;
            } else if (self.zbjRefreshState == RefreshStatePulling && offsetY >= 0 - self.frame.size.height) {
                // 转为普通状态
                self.zbjRefreshState = RefreshStateIdle;
            }
        }else if (self.zbjRefreshState == RefreshStatePulling){ // 松开可以刷新 && 已经松开
            [self refresh];
        }
    }
}

#pragma mark - Refresh
/** 启动刷新 */
- (void)refresh
{
    if (self.zbjRefreshState == RefreshStateRefreshing)
        return;
    
    [self willBeginRefresh];
}

/** 即将开始刷新 */
- (void)willBeginRefresh
{
    self.zbjRefreshState = RefreshStateWillRefresh;
    [self pinRefreshView];
}

/** 开始刷新 */
- (void)pinRefreshView
{
    self.zbjRefreshState = RefreshStateRefreshing;
    [UIView animateWithDuration:0.4 animations:^(void) {
        self.scrollerView.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
    }];
    
    // 执行回调
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
}

/** 结束刷新 */
- (void) endForRefresh
{
    self.zbjRefreshState = RefreshStateIdle;
    [UIView animateWithDuration:0.4 animations:^(void) {
        self.scrollerView.contentInset = UIEdgeInsetsZero;
    }];
}

- (UIView<ZBJRefreshContentViewDelegate> *) contentView
{
    if (!_contentView) {
        _contentView = [[ZBJRefreshHeaderContentView alloc] initWithFrame:self.bounds];
        // 绑定协议
        self.contentViewDelegate = _contentView;
    }
    return _contentView;
}


@end
