//
//  AreaActivityData.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaActivityDataModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, assign) NSTimeInterval acquisitionTime;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) NSInteger locationType;
@property (nonatomic, assign) BOOL isNormal;

@end
