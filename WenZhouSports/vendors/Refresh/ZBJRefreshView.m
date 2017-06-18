//
//  BaseHeadView.m
//  test
//
//  Created by jia guo on 16/6/12.
//  Copyright © 2016年 jia guo. All rights reserved.
//

#import "ZBJRefreshView.h"

static NSString *const zbjScrollerViewContentOffset = @"contentOffset";
static NSString *const zbjScrollerViewContentSize = @"contentSize";
static NSString *const zbjPanGestureRecognizerState = @"state";

const NSInteger refreshViewHeight = 100;

@interface ZBJRefreshView ()

@end

@implementation ZBJRefreshView

// 父view更改后自动执行下方法
- (void) willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        [self removeAllObserver];
        self.scrollerView = (UIScrollView *)newSuperview;
        self.zbjRefreshState = RefreshStateIdle;
        [self addObservers];
    }
}

#pragma mark - KVO
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollerView addObserver:self forKeyPath:zbjScrollerViewContentOffset options:options context:nil];
    // 监听ContentSize保证footerView永远添加在最下方
    [self.scrollerView addObserver:self forKeyPath:zbjScrollerViewContentSize options:options context:nil];
    // 监听拖拽手势状态
    [self.scrollerView.panGestureRecognizer addObserver:self forKeyPath:zbjPanGestureRecognizerState options:options context:nil];
}

- (void) removeAllObserver
{
    [self.scrollerView removeObserver:self forKeyPath:zbjScrollerViewContentOffset];
    [self.scrollerView removeObserver:self forKeyPath:zbjScrollerViewContentSize];
    [self.scrollerView.panGestureRecognizer removeObserver:self forKeyPath:zbjPanGestureRecognizerState];
}

///** 结束刷新 */
//- (void) endForRefresh
//{
//    self.zbjRefreshState = RefreshStateIdle;
//    [UIView animateWithDuration:0.4 animations:^(void) {
//        self.scrollerView.contentInset = UIEdgeInsetsZero;
//    }];
//}

#pragma mark - getter and setter
- (void) setZbjRefreshState:(ZBJRefreshState)zbjRefreshState
{
    _zbjRefreshState = zbjRefreshState;
    // 下面协议必须实现，不需要判断是否有该方法
    [self.contentViewDelegate setState:zbjRefreshState withRefreshView:self];
}

- (void) dealloc
{
    [self removeAllObserver];
}


@end
