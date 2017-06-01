//
//  Configs.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/4/28.
//  Copyright © 2017年 何聪. All rights reserved.
//

#ifndef Configs_h
#define Configs_h

//屏幕高宽
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define WIDTH [[UIScreen mainScreen] bounds].size.width

#define FIT_LENGTH(num) ((num) * WIDTH/414.0)
#define FIX(num) ((num) * WIDTH/375)

//控件距离
#define MARGIN_SCREEN FIT_LENGTH(18.0)

//face++ api key
#define FACEPP_API_KEY @"urUktpqNurMzkX_DN-oRa9GnWapAiltI"
#define FACEPP_API_SECRET @"vuVdYWy7_L4GgJJ5rFIrBpHv_1CTwrGC"
//人脸比较地址
#define COMPARE_FACE_PATH @"https://api-cn.faceplusplus.com/facepp/v3/compare"

#endif /* Configs_h */
