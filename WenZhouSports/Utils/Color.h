//
//  Color.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/4/28.
//  Copyright © 2017年 何聪. All rights reserved.
//

#ifndef Color_h
#define Color_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//颜色值，命名统一为C_[颜色的16进制编码]
#define C_EDF0F2 UIColorFromRGB(0xedf0f2)
#define C_66A7FE UIColorFromRGB(0x66a7fe)

//像导航栏这种使用统一颜色的控件，也可以命名为C_[控件名], 方便以后做统一修改
#define C_NAVIGATION UIColorFromRGB(0xffffff)

#endif /* Color_h */
