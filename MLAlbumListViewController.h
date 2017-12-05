//
//  MLAlbumListViewController.h
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/5.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLAlbumListViewModel.h"
@interface MLAlbumListViewController : UIViewController
@property(nonatomic,strong)MLAlbumListViewModel * viewModel;
@property(nonatomic,assign)NSInteger maxIndex;
@property(nonatomic,strong)UIColor * btnColor;
@end
