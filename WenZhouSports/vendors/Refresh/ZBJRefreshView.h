//
//  BaseHeadView.h
//  test
//
//  Created by jia guo on 16/6/12.
//  Copyright © 2016年 jia guo. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, ZBJRefreshState) {
    /** 普通闲置状态 */
    RefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    RefreshStatePulling,
    /** 松开就加载更多的状态 */
    RefreshStateLoadMorePulling,
    /** 正在刷新中的状态 */
    RefreshStateRefreshing,
    /** 即将刷新的状态 */
    RefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    RefreshStateNoMoreData
};

typedef void(^refreshingBlock)();

@protocol ZBJRefreshContentViewDelegate;

@interface ZBJRefreshView : UIView

/** 刷新中的回调方法 */
@property (nonatomic, copy) refreshingBlock refreshingBlock;
/** 刷新状态 */
@property (nonatomic, assign) ZBJRefreshState zbjRefreshState;
/** 父View */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 内容视图协议 */
@property (nonatomic, weak) id<ZBJRefreshContentViewDelegate> contentViewDelegate;
///** 内容视图，需实现内容视图协议 */
//@property (nonatomic, strong) UIView<ZBJRefreshContentViewDelegate> *contentView;

/** 结束刷新 */
- (void) endForRefresh;

- (void) addObservers;
- (void) removeAllObserver;

@end

/** 内容视图协议 */
@protocol ZBJRefreshContentViewDelegate <NSObject>

@required
- (void) setState:(ZBJRefreshState) state withRefreshView:(ZBJRefreshView *)refreshView;

@optional
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
@end







