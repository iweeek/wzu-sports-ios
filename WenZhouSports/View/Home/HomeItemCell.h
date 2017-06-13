//
//  HomeItemCell.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "BaseCell.h"

typedef NS_ENUM(NSInteger, SportsType) {
    SportsTypeJogging = 1,    // 慢跑
    SportsTypeRun,            // 快炮
    SportsTypeWalk,           // 走路
    SportsTypeStep            // 累计步数
};

@interface HomeItemCell : BaseCell

- (void)initWithSportsType:(SportsType)type
                      data:(id)data;
- (void)setupPersonCount:(int)count;

@end
