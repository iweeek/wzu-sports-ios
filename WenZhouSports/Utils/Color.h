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
#define C_42CC42 UIColorFromRGB(0x42cc42)
#define C_FF0000 UIColorFromRGB(0xff0000)

#define cFFFFFF UIColorFromRGB(0xffffff)
#define cSpliteLine UIColorFromRGB(0xedf0f2)
#define c474A4F UIColorFromRGB(0x474A4F)
#define c7E848C UIColorFromRGB(0x7E848C)
#define cCCCCCC UIColorFromRGB(0xCCCCCC)
#define c66A7FE UIColorFromRGB(0x66a7fe)

//像导航栏这种使用统一颜色的控件，也可以命名为C_[控件名], 方便以后做统一修改
#define C_NAVIGATION UIColorFromRGB(0xffffff)
#define C_GRAY_TEXT UIColorFromRGB(0x7e848c)
#define C_DARK_TEXT UIColorFromRGB(0x535353)
#define C_CUTTING_LINE UIColorFromRGB(0xedeff2)

#endif /* Color_h */
