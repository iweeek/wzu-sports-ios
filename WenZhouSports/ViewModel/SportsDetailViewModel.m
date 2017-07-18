//
//  SportsDetailViewModel.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/15.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsDetailViewModel.h"
#import "BaseDao+Category.h"
#import "Dao+Sports.h"

@interface SportsDetailViewModel ()

@property (nonatomic, strong) RACCommand *compareFaceCommand;

@end

@implementation SportsDetailViewModel

- (instancetype)init {
    if (self = [super init]) {
        _compareFaceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            return [[Dao share] compareFaceWithFace1:input[@"face1"] face2:input[@"face2"]];
        }];
        
        _cmdRunningActivityData = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[[Dao share] runningActivitysDataWithActivityId:self.runningActivityid
                                                    acquisitionTime:self.acquisitionTime
                                                          stepCount:self.stepCount
                                                           distance:self.distance
                                                          longitude:self.longitude
                                                           latitude:self.latitude
                                                       locationType:self.locationType
                                                           isNormal:self.isNormal]
                catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
                return [RACSignal error:error];
            }];
        }];
        
        _cmdRunningActivitiesStart = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[[Dao share] runningActivitysStartWithProjectId:self.projectId
                                                          sutdentId:self.sutdentId
                                                          startTime:self.starTime]
                doNext:^(id  _Nullable x) {
                    self.runningActivity = x;
                }];
        }];
        
        _cmdRunningActivitiesEnd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[[Dao share] runningActivitysEndWithId:self.runningActivityid
                                                  distance:self.distance
                                                 stepCount:self.stepCount
                                                  costTime:self.costTime
                                        targetFinishedTime:self.targetFinishedTime]
                catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
                    return [RACSignal error:error];
                }];
        }];
    }
    return self;
}

@end
