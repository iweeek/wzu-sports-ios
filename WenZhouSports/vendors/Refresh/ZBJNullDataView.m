//
//  ZBJNullDataView.m
//  ZBJKit
//
//  Created by jia guo on 16/6/23.
//  Copyright © 2016年 guo jia. All rights reserved.
//

#import "ZBJNullDataView.h"

@implementation ZBJNullDataView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor yellowColor];
        
        [self initSubViews];
    }
    return self;
}

- (void) hiddenView
{
    self.hidden = YES;
}

- (void) initSubViews
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 90)/2, [UIScreen mainScreen].bounds.size.width, 50)];
    lab.text = @"没有数据，请刷新";
    lab.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:lab];
}


@end
