//
//  SportsDetailView.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/8.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SportsStation) {
    SportsWillStart = 0,            //运动未开始
    SportsDidStart,                 //运动已开始
    SportsDidPause,                 //运动已暂停
    SportsDidEnd,                   //运动已结束
    SportsShare                     //分享运动结果
};


@interface SportsDetailView : UIView

/**
 运动开始点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *startSignal;
/**
 继续点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *continueSignal;
/**
 结束点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *endSignal;
/**
 分享点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *shareSignal;

/**
 改变运动状态的时候调用

 @param station 运动状态
 */
- (void)changeSportsStation: (SportsStation)station;

/**
 设置当前速度和juli

 @param speed 速度
 @param distance 距离
 */
- (void)setDataWithSpeed: (NSString *)speed distance:(NSInteger)distance stage:(NSInteger)stage;
@end
