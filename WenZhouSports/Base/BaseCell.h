//
//  BaseCell.h
//  Lvka
//
//  Created by iOSDev1 on 17/3/1.
//  Copyright © 2017年 iOSDev1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

- (void)createUI;
- (void)layout;
- (void)setupWithData:(id)data;

@end
