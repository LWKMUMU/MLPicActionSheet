//
//  MLPhotoManager.h
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/6.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface MLPhotoManager : NSObject
+ (void)MLrequestImageForAsset:(PHAsset *_Nullable)asset targetSize:(CGSize)targetSize resultHandler:(void (^_Nullable)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;

@end
