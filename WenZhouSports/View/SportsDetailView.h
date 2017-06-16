//
//  SportsDetailView.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/8.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "runningProjectItemModel.h"

typedef NS_ENUM(NSInteger, SportsStation) {
    SportsWillStart = 0,            //运动未开始
    SportsDidStart,                 //运动已开始
    SportsDidPause,                 //运动已暂停
    SportsDidEnd,                   //运动已结束
    SportsShare                     //分享运动结果
};

@interface SportsDetailView : UIView <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) runningProjectItemModel *runningProject;
// 地图方向箭头
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

///地图View的Delegate
@property (nonatomic, weak) id<MAMapViewDelegate> mapDelegate;
/**
 运动开始点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *startSignal;
/**
 运动暂停滑动事件
 */
@property (nonatomic, strong) RACSubject *pauseSignal;
/**
 继续点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *continueSignal;
/**
 结束点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *endSignal;
/**
 分享点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *shareSignal;

/**
 改变运动状态的时候调用

 @param station 运动状态
 */
- (void)changeSportsStation: (SportsStation)station;

/**
 设置当前速度和距离

 @param speed 速度
 @param distance 距离
 */
- (void)setDataWithDistance:(double)distance
                       time:(NSInteger)time
                      speed:(float)speed;

// 设置“合格”数据
- (void)setQualifiedData;

/**
 设置运动结果

 @param calorie 卡路里
 @param time 时间
 */
- (void)setDataWithCalorie:(int)calorie time:(NSInteger)time;

/**
 添加滑动事件
 */
- (void)addPauseGestureEvent;

/**
 在地图上绘制折线

 */
//- (void)addPolygonLine:(CLLocation *)location;

- (void)setDelete:(id<MAMapViewDelegate>)delegate;

@end
