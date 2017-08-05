//
//  SportsHistoryController.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SportsHistoryType) {
    SportsHistoryTypeWeek = 0,
    SportsHistoryTypeMonth,
    SportsHistoryTypeTerm,
    SportsHistoryTypeAll
};

@interface SportsHistoryController : UIViewController

@property (nonatomic, assign) SportsHistoryType type;
@property (nonatomic, strong) UINavigationController *nav;

@end
