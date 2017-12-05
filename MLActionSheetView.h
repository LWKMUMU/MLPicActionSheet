//
//  MLActionSheetView.h
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/12/5.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPhotoViewController.h"
#import "CreditNavigationController.h"
typedef void(^selectedImages)(NSMutableArray * imagesArray);

@interface MLActionSheetView : UIView

@property(nonatomic,copy)selectedImages bloack;
@property(nonatomic,assign)NSInteger maxNumber;
@property(nonatomic,strong)UIColor * navColor;
@property(nonatomic,strong)UIColor * btnColor;
- (void)showMLPhoto:(UIViewController *)send;
@end
