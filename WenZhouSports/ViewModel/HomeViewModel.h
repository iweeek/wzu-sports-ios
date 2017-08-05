//
//  HomeViewModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/7.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageModel.h"

@interface HomeViewModel : NSObject

@property (nonatomic, strong) HomePageModel *homePage;
@property (nonatomic, assign) NSInteger universityId;
@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, strong) RACCommand *cmdRunningSports;
@property (nonatomic, strong) RACCommand *cmdRuningActivitys;

@end
