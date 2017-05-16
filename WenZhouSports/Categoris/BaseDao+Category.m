//
//  BaseDao+Category.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/15.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "BaseDao+Category.h"

@implementation BaseDao (Category)

- (RACSignal *)compareFaceWithFace1:(UIImage *)face1 face2:(UIImage *)face2 {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:FACEPP_API_KEY forKey:@"api_key"];
    [dic setObject:FACEPP_API_SECRET forKey:@"api_secret"];
    NSData *face1File = UIImageJPEGRepresentation(face1, 1.0);
    NSData *face2File = UIImageJPEGRepresentation(face2, 1.0);
    [dic setObject:face1File forKey:@"image_file1"];
    [dic setObject:face2File forKey:@"image_file2"];
    return [[[self RAC_POST:COMPARE_FACE_PATH parameters:nil postParameters:dic]
            map:^id _Nullable(id  _Nullable value) {
                if ([value objectForKey:@"error_message"]) {
                    DDLogError(@"error_message:%@",[value objectForKey:@"error_message"]);
                }
                return [value objectForKey:@"confidence"];
            }] doError:^(NSError * _Nonnull error) {
                DDLogError(@"%@", error.description);
            }];
}

@end
