//
//  MLPhotoViewController.h
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/5/25.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPhotoViewModel.h"
#import "MLAlbumListViewController.h"
typedef void(^complete)(NSMutableArray <UIImage *>* selectedImagesArray);
@interface MLPhotoViewController : UIViewController
@property(nonatomic,strong)MLPhotoViewModel * viewModel;
@property(nonatomic,strong)NSString * albumName;
@property(nonatomic,copy)complete completeBloack;
@property(nonatomic,assign)NSInteger maxIndex;
@property(nonatomic,strong)UIColor * btnColor;
@property(nonatomic,copy)void(^cancal)(void);
@end
