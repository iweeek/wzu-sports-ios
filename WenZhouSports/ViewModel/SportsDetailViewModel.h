//
//  SportsDetailViewModel.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/15.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportsDetailViewModel : NSObject

//人脸比较
@property (nonatomic, strong, readonly) RACCommand *compareFaceCommand;
@property (nonatomic, strong) RACCommand *cmdRunActivity;


@end
