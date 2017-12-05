//
//  MLPhotoManager.m
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/6.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import "MLPhotoManager.h"

@implementation MLPhotoManager

+ (void)MLrequestImageForAsset:(PHAsset *_Nullable)asset targetSize:(CGSize)targetSize resultHandler:(void (^_Nullable)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler{
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    imageOptions.synchronous = NO;
    CGSize size = targetSize;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (resultHandler){
                resultHandler(result,info);
            }
        }];
}

@end
