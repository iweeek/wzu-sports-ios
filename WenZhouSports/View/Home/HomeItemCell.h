//
//  HomeItemCell.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "BaseCell.h"

typedef NS_ENUM(NSInteger, RunningSportsType) {
    SportsTypeJogging = 1,    // 慢跑
    SportsTypeRun,            // 快炮
    SportsTypeWalk,           // 走路
//    SportsTypeStep,           // 累计步数
    SportsTypeOutdoor         // 室外运动
};

@interface HomeItemCell : BaseCell

- (void)initWithSportsType:(RunningSportsType)type
                      data:(id)data;
- (void)setupPersonCount:(int)count;

@end
