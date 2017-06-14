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
        
        _cmdRunActivity = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[[Dao share] runActivity:input]
                catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
                return [RACSignal error:error];
            }];
        }];
    }
    return self;
}

@end
