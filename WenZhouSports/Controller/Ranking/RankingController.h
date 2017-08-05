//
//  RankingController.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/15.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RankingType) {
    RankingTypeKcalConsumption = 0,
    RankingTypeTimeCost
};

@interface RankingController : UIViewController

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, assign) RankingType type;

@end
