//
//  ZBJRefreshFooterView.m
//  ZBJKit
//
//  Created by jia guo on 16/6/22.
//  Copyright © 2016年 guo jia. All rights reserved.
//

#import "ZBJRefreshFooterView.h"
#import "ZBJRefreshFooterContentView.h"
#import "UIScrollView+PullToRefresh.h"

static NSString *const zbjScrollerViewContentOffset = @"contentOffset";
static NSString *const zbjScrollerViewContentSize = @"contentSize";
static NSString *const zbjPanGestureRecognizerState = @"state";

static const NSInteger loadMoreViewHeight = 50;
static const NSInteger pageSize = 20;

@interface ZBJRefreshFooterView ()

@property (nonatomic, assign) NSInteger lastTotalCount;
@property (nonatomic, assign) NSInteger lastRefreshCount;//最近一次加载更多数目

@end

@implementation ZBJRefreshFooterView


+ (instancetype)footerRefreshViewWithContentView:(UIView<ZBJRefreshContentViewDelegate> *) contentView
                               refreshingBlock:(refreshingBlock)refreshingBlock
{
    ZBJRefreshFooterView *refreshView = [[ZBJRefreshFooterView alloc] init];
    refreshView.refreshingBlock = refreshingBlock;
    refreshView.contentView = contentView;
    refreshView.contentViewDelegate = contentView;
    return refreshView;
}

+ (instancetype)footerWithRefreshingBlock:(refreshingBlock)refreshingBlock
{
    ZBJRefreshFooterView *refreshView = [[ZBJRefreshFooterView alloc] init];
    refreshView.refreshingBlock = refreshingBlock;
    return refreshView;
}

// 父view更改后自动执行下方法
- (void) willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollerView.alwaysBounceVertical= YES;
        // 设置默认大小
        self.frame = CGRectMake(0, self.scrollerView.contentSize.height, newSuperview.frame.size.width, loadMoreViewHeight);
        // 如果有自定义contentView，根据contentView调整refreshView大小
        if (![self.contentView isMemberOfClass:[ZBJRefreshFooterContentView class]]) {
            CGRect newFrame = self.contentView.frame;
            self.frame = newFrame;
        }
        
        [self.contentView setFrame:self.bounds];
        [self addSubview:self.contentView];
        
        if ([newSuperview isKindOfClass:[UITableView class]] ||
            [newSuperview isKindOfClass:[UICollectionView class]]) {
            UIScrollView *scroll = (UIScrollView *)newSuperview;
            __weak typeof(self) weakSelf = self;
            [scroll setZbjReloadDataBlock:^(NSInteger totalCount) {
                if (totalCount < pageSize) {
                    weakSelf.contentView.hidden = YES;
                    weakSelf.zbjRefreshState = RefreshStateNoMoreData;
                }else{
                    weakSelf.contentView.hidden = NO;
                }
                
            }];
        }
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // ContentOffset改变
    if ([keyPath isEqualToString:zbjScrollerViewContentOffset]) {
        
        if (self.zbjRefreshState != RefreshStateIdle) return;
        
        if (self.scrollerView.contentInset.top + self.scrollerView.contentSize.height > self.scrollerView.frame.size.height) { // 内容超过一个屏幕
            if (self.scrollerView.contentOffset.y >= self.scrollerView.contentSize.height-self.scrollerView.frame.size.height - 1 + self.scrollerView.contentInset.bottom - self.frame.size.height) {
                // 防止手松开时连续调用
                CGPoint old = [change[@"old"] CGPointValue];
                CGPoint new = [change[@"new"] CGPointValue];
                if (new.y <= old.y) return;
                
                self.zbjRefreshState = RefreshStateLoadMorePulling;
                // 记录最近一次刷新条数
//                self.lastTotalCount = self.scrollerView.zbjTotalDataCount;
                [self refresh];
            }
        }
        
        
//        CGFloat scrollPosition = self.scrollerView.contentSize.height - self.scrollerView.contentOffset.y - self.scrollerView.frame.size.height;
//        // 如果正在刷新中，直接返回
//        if (self.zbjRefreshState == RefreshStateRefreshing ||
//            self.zbjRefreshState == RefreshStateNoMoreData) {
//            return;
//        }
//
//        // 执行委托给contentView的方法
//        if ([self.contentViewDelegate respondsToSelector:@selector(scrollViewContentOffsetDidChange:)])
//            [self.contentViewDelegate scrollViewContentOffsetDidChange:change];

//        NSLog(@"%f",self.scrollerView.contentOffset.y);
//        NSLog(@"%f",self.scrollerView.contentSize.height);
        
//        if (self.scrollerView.contentSize.height > self.scrollerView.frame.size.height) { // 内容超过一个屏幕
//            if (self.zbjRefreshState == RefreshStateIdle && 0 - scrollPosition > 1) {
//                // 转为即将刷新状态
//                self.zbjRefreshState = RefreshStateLoadMorePulling;
//            }else if(self.zbjRefreshState == RefreshStateLoadMorePulling){
//                // 防止手松开时连续调用
//                CGPoint old = [change[@"old"] CGPointValue];
//                CGPoint new = [change[@"new"] CGPointValue];
//                if (new.y <= old.y) return;
//
//                [self refresh];
//            }
//        }else{
//            self.contentView.hidden = YES;
//            self.zbjRefreshState = RefreshStateNoMoreData;
//        }
        
        // 拖拽状态，根据contentOffset更改当前状态
//        if (self.scrollerView.isDragging) {
//            if (self.zbjRefreshState == RefreshStateIdle && 0 - scrollPosition > self.contentView.frame.size.height / 3.0) {
//                // 转为即将刷新状态
//                self.zbjRefreshState = RefreshStateLoadMorePulling;
//            }else if (self.zbjRefreshState == RefreshStateLoadMorePulling
//                      && 0 - scrollPosition < self.contentView.frame.size.height / 3.0){
//                // 转为普通状态
//                self.zbjRefreshState = RefreshStateIdle;
//            }
//        }
//        else if(self.zbjRefreshState == RefreshStateLoadMorePulling){
//            [self refresh];
//        }
    }else if ([keyPath isEqualToString:zbjScrollerViewContentSize]){// ContentSize改变，改变自己的footerView的位置
        // 如果内容不够一屏，隐藏
        if (self.scrollerView.contentSize.height < self.scrollerView.frame.size.height) {
            self.hidden = YES;
            return;
        }
        if (self.scrollerView.contentSize.height == CGSizeZero.height) {
            self.hidden = YES;
            return;
        }
        
        self.hidden = NO;
        self.frame = CGRectMake(0, self.scrollerView.contentSize.height, self.scrollerView.frame.size.width, loadMoreViewHeight);
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
    // 执行回调
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }

    UIEdgeInsets inset = self.scrollerView.contentInset;
    if (self.scrollerView.contentInset.bottom == 0) {
        inset.bottom += loadMoreViewHeight;
        [self.scrollerView setContentInset:inset];
    }
    
    [UIView animateWithDuration:0.4 animations:^(void) {
        CGPoint scrollPoint = CGPointMake(0, self.scrollerView.contentSize.height - self.scrollerView.frame.size.height+self.frame.size.height);
        [self.scrollerView setContentOffset:scrollPoint animated:YES];
    }];
    
//    //计算滚动到露出footerView三分之一的高度
//    CGPoint scrollPoint = CGPointMake(0, self.scrollerView.contentSize.height - self.scrollerView.frame.size.height+self.frame.size.height);
//    [self.scrollerView setContentOffset:scrollPoint animated:YES];
    
}

/** 结束刷新 */
- (void) endForRefresh
{
    self.zbjRefreshState = RefreshStateIdle;
}

- (void)endRefreshingWithNoMoreData
{
    self.zbjRefreshState = RefreshStateNoMoreData;
    [UIView animateWithDuration:0.4 animations:^(void) {
        self.scrollerView.contentInset = UIEdgeInsetsZero;
    }];
}

- (UIView<ZBJRefreshContentViewDelegate> *) contentView
{
    if (!_contentView) {
        _contentView = [[ZBJRefreshFooterContentView alloc] initWithFrame:self.bounds];
        // 绑定协议
        self.contentViewDelegate = _contentView;
    }
    return _contentView;
}

@end
