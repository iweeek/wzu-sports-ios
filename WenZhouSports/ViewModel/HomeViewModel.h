//
//  HomeViewModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/7.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "runningProjectsModel.h"

@interface HomeViewModel : NSObject

@property (nonatomic, strong) runningProjectsModel *runningProjects;

@property (nonatomic, strong) RACCommand *cmdRunningProjects;
@property (nonatomic, strong) RACCommand *cmdRuningActivitys;

@end
