//
//  BaseCell.m
//  Lvka
//
//  Created by iOSDev1 on 17/3/1.
//  Copyright © 2017年 iOSDev1. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
        [self layout];
    }
    return self;
}

- (void)createUI {
    NSAssert(NO, @"createUI这个方法必须添加");
}

- (void)layout {
    NSAssert(NO, @"layout这个方法必须添加");
}

- (void)setupWithData:(id)data {
    NSAssert(NO, @"setupWithData这个方法需要重写");
}

@end
