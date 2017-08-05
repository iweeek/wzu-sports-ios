//
//  SportsResultController.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/12.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunningActivityModel.h"
#import "AreaActivityModel.h"

@interface SportsResultController : UIViewController

@property (nonatomic, strong) AreaSportModel *areaActivity;
@property (nonatomic, strong) RunningActivityModel *RunningActivity;

@end
