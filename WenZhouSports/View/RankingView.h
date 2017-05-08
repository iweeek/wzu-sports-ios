//
//  RankingView.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/6.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellWithCuttingLine.h"

@interface RankingView : UIView

/**
 热量排行点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *selectCalorieSignal;
/**
 时间排行点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *selectTimeSignal;

/**
 设置热量排行数据

 @param data 热量排行数据
 */
- (void)setDataWithCalorie:(id)data;

/**
 设置时间排行数据

 @param data 时间排行数据
 */
- (void)setDataWithTime:(id)data;
@end

@interface RankingHeaderView : UIView

/**
 热量排行点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *selectCalorieSignal;
/**
 时间排行点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *selectTimeSignal;

/**
 选择热量排行动画效果
 */
- (void)selectCalorieAnimate;

/**
 选择时间排行动画效果
 */
- (void)selectTimeAnimate;

@end

@interface RankingCell : CellWithCuttingLine

@end
