//
//  SportsAreaOutdoorModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/28.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaSportsOutdoorPointModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, assign) NSInteger universityId;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) BOOL isEnabled;

@end
