//
//  ZBJRefreshContentView.m
//  test
//
//  Created by jia guo on 16/6/20.
//  Copyright © 2016年 jia guo. All rights reserved.
//

#import "ZBJRefreshHeaderContentView.h"


@implementation ZBJRefreshHeaderContentView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews
{
//    [self addSubview:self.lab];
    [self addSubview:self.activityView];
}

- (UILabel *)lab
{
    if (!_lab) {
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2)];
        _lab.text = @"世界的另一边，心之神往";
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.textColor = [UIColor grayColor];
        _lab.backgroundColor = [UIColor clearColor];
        _lab.font = [UIFont systemFontOfSize:12.0];
    }
    return _lab;
}

- (UIActivityIndicatorView *) activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];//指定进度轮中心点
        _activityView.hidesWhenStopped = NO;
    }
    return _activityView;
}

- (void) setState:(ZBJRefreshState)state withRefreshView:(ZBJRefreshView *)refreshView
{
    switch (state) {
        case RefreshStateIdle: {
//            self.lab.text = @"世界那么大，一定要去看看";
            [self.activityView stopAnimating];
            break;
        }
        case RefreshStatePulling: {
//            self.lab.text = @"松开可以刷新";
            [self.activityView stopAnimating];
            break;
        }
        case RefreshStateLoadMorePulling: {
//            self.lab.text = @"努力加载中....";
            [self.activityView startAnimating];
            break;
        }
        case RefreshStateRefreshing: {
//            self.lab.text = @"请稍候...";
            [self.activityView startAnimating];
            break;
        }
        case RefreshStateWillRefresh: {
            [self.activityView stopAnimating];
            break;
        }
        case RefreshStateNoMoreData: {
//            self.lab.text = @"没有更多了";
            [self.activityView stopAnimating];
            break;
        }

    }
    
}

- (void) scrollViewContentOffsetDidChange:(NSDictionary *)change
{
//    CGPoint point = [change[@"new"] CGPointValue];
//    NSLog(@"%f",point.y);
}


@end
