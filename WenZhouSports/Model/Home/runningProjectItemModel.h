//
//  runningProjectItmeModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/11.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface runningProjectItemModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger qualifiedDistance;
@property (nonatomic, assign) NSInteger qualifiedCostTime;

@end
