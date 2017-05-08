//
//  CellWithCuttingLine.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/8.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "CellWithCuttingLine.h"

@implementation CellWithCuttingLine

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *cuttingLine = [[UIView alloc] init];
        cuttingLine.backgroundColor = C_CUTTING_LINE;
        [self.contentView addSubview:cuttingLine];
        [cuttingLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(WIDTH - MARGIN_SCREEN, 0.67));
        }];
    }
    return self;
}

@end
