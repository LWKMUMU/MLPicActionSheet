//
//  MLPicShowViewController.h
//  Huihui
//
//  Created by 伟凯   刘 on 2017/4/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MLPhotoManager.h"
typedef void(^ShowBlack)(NSMutableArray * imageArray,NSMutableArray *PhssetArray);
@interface MLPicShowViewController : UIViewController

@property(nonatomic,assign)BOOL showDeleteBtn;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray * imageArray;
@property(nonatomic,strong)NSMutableArray * selectedPhssetArray;
@property(nonatomic,copy)ShowBlack bloack;
@property(nonatomic,strong)UIColor * btnColor;
@end
