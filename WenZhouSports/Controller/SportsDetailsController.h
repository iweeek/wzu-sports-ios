//
//  SportsDetailsController.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/10.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "BaseViewController.h"
#import "RunningProjectItemModel.h"

@interface SportsDetailsController : BaseViewController

@property (nonatomic, strong) RunningProjectItemModel *runningProject;
@property (nonatomic, assign) NSInteger acquisitionInterval;//采集间隔

@end
