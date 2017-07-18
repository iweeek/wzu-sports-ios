//
//  RankingViewModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/19.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageModel.h"

@interface RankingViewModel : NSObject

@property (nonatomic, strong) HomePageModel *homePage;
@property (nonatomic, assign) NSInteger universityId;

@property (nonatomic, strong) RACCommand *cmdGetRanking;
@property (nonatomic, strong) RACCommand *cmdLoadMoreRanking;

@end
