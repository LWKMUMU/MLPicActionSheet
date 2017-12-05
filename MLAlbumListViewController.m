//
//  MLAlbumListViewController.m
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/5.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import "MLAlbumListViewController.h"
#import "MLPhotoViewController.h"
@interface MLAlbumListViewController ()<MLAlbumListViewModelDelegate>


@end

@implementation MLAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择相册";
    self.viewModel = [[MLAlbumListViewModel alloc] init];
    self.viewModel.delegate = self;
    [self.view addSubview:[self.viewModel basisUI]];
}
- (void)albumDetail:(NSString *)albumName{
    MLPhotoViewController * vc = [[MLPhotoViewController alloc] init];
    
    vc.albumName = albumName;
    vc.maxIndex = self.maxIndex ? self.maxIndex : 9;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.viewModel.selectedPhssetArray = self.viewModel.selectedPhssetArray;
    vc.viewModel.selectedImageArray = self.viewModel.selectedImageArray;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
