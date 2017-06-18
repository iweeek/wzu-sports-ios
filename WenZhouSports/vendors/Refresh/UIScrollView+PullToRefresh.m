//
//  UIScrollView+PullToRefresh.m
//  test
//
//  Created by jia guo on 16/6/16.
//  Copyright © 2016年 jia guo. All rights reserved.
//

#import "UIScrollView+PullToRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (PullToRefresh)

#pragma mark - getter and setter
- (ZBJRefreshHeaderView *) zbjRefreshHeaderView
{
    return objc_getAssociatedObject(self, @selector(zbjRefreshHeaderView));
}
- (void) setZbjRefreshHeaderView:(ZBJRefreshHeaderView *)zbjRefreshHeaderView
{
    if (zbjRefreshHeaderView != self.zbjRefreshHeaderView) {
        // 删除旧的，添加新的
        [self.zbjRefreshHeaderView removeFromSuperview];
        [self addSubview:zbjRefreshHeaderView];
        
        objc_setAssociatedObject(self, @selector(zbjRefreshHeaderView),
                                 zbjRefreshHeaderView, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (ZBJRefreshFooterView *) zbjRefreshFooterView
{
    return objc_getAssociatedObject(self, @selector(zbjRefreshFooterView));
}

- (void) setZbjRefreshFooterView:(ZBJRefreshFooterView *)zbjRefreshFooterView
{
    if (zbjRefreshFooterView != self.zbjRefreshFooterView) {
        // 删除旧的，添加新的
        [self.zbjRefreshFooterView removeFromSuperview];
        [self addSubview:zbjRefreshFooterView];
        
        objc_setAssociatedObject(self, @selector(zbjRefreshFooterView),
                                 zbjRefreshFooterView, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (UIView *) zbjNullDataView
{
    return objc_getAssociatedObject(self, @selector(zbjNullDataView));
}

- (void) setZbjNullDataView:(UIView *)zbjNullDataView
{
    if (zbjNullDataView != self.zbjNullDataView) {
        [self.zbjNullDataView removeFromSuperview];
        [zbjNullDataView setFrame:self.bounds];
        [self addSubview:zbjNullDataView];
        
        [self willChangeValueForKey:@"zbjNullDataView"];
        objc_setAssociatedObject(self, @selector(zbjNullDataView),
                                 zbjNullDataView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"zbjNullDataView"];
    }
}

static const char ZBJRefreshReloadDataBlockKey = '\0';
- (void)setZbjReloadDataBlock:(void (^)(NSInteger))zbjReloadDataBlock
{
    objc_setAssociatedObject(self, &ZBJRefreshReloadDataBlockKey, zbjReloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSInteger))zbjReloadDataBlock
{
    return objc_getAssociatedObject(self, &ZBJRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.zbjReloadDataBlock ? : self.zbjReloadDataBlock(self.zbjTotalDataCount);
}


// 获取总数
- (NSInteger)zbjTotalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

@end


// 要解决LoadMore到noMoreData后，再refresh，这时loadMore的状态依然是noMoreData的问题
@implementation UITableView(PullToRefresh)

+ (void)load
{
    // 用zbj_reloadData替换reloadData
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(reloadData)), class_getInstanceMethod(self,@selector(zbj_reloadData)));
}

- (void) zbj_reloadData
{
    // 因为已经替换了，执行zbj_reloadData实际执行的是reload，不是死循环
    [self zbj_reloadData];
    [self resetRefreshState];
    [self zbjNullDataViewVisible];
    [self executeReloadDataBlock];
}

- (void) resetRefreshState
{
    // 有footer且state==noMore
    if (self.zbjRefreshFooterView
        && self.zbjRefreshFooterView.zbjRefreshState == RefreshStateNoMoreData) {
        self.zbjRefreshFooterView.zbjRefreshState = RefreshStateIdle;
    }
}

// 根据总条数判断是否显示nullDataView
- (void) zbjNullDataViewVisible
{
    if (self.zbjNullDataView) {
        self.zbjNullDataView.hidden = [self zbjTotalDataCount] > 0 ? YES : NO;;
    }
}

@end


// 同tableView
@implementation UICollectionView(PullToRefresh)

+ (void)load
{
    // 用zbj_reloadData替换reloadData
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(reloadData)), class_getInstanceMethod(self,@selector(zbj_reloadData)));
}

- (void) zbj_reloadData
{
    // 因为已经替换了，执行zbj_reloadData实际执行的是reload，不是死循环
    [self zbj_reloadData];
    [self resetRefreshState];
}

- (void) resetRefreshState
{
    // 有footer且state==noMore
    if (self.zbjRefreshFooterView
        && self.zbjRefreshFooterView.zbjRefreshState == RefreshStateNoMoreData) {
        self.zbjRefreshFooterView.zbjRefreshState = RefreshStateIdle;
    }
}

@end
















