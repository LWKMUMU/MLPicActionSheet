//
//  MLPhotoViewController.m
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/5/25.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import "MLPhotoViewController.h"
#import "MLPicShowViewController.h"
@interface MLPhotoViewController ()<MLPhotoViewModelDelegate>

@end

@implementation MLPhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.title = @"选取图片";
    [self createBtns];
    [self.view addSubview:[self.viewModel basisUI]];
    [self.view addSubview:[self.viewModel createFooterView]];
}
- (void)createBtns{
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(photoAlbum)];
    self.navigationItem.leftBarButtonItems = @[button];
    UIBarButtonItem * button1 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItems = @[button1];
    self.viewModel = [[MLPhotoViewModel alloc] init];
    self.viewModel.maxIndex = self.maxIndex ? self.maxIndex: 9;
    self.viewModel.btnColor = self.btnColor?self.btnColor:[UIColor whiteColor];
    self.viewModel.delegate = self;
    if (self.albumName){
        self.viewModel.albumName = self.albumName;
        self.title = [@"" PhotoNameConversion:self.albumName];
    }
    
}
- (void)complete{
       if (self.viewModel.selectedPhssetArray.count != 0){
        NSMutableArray * imagesArray = [[NSMutableArray alloc] init];
       
           CGSize size = PHImageManagerMaximumSize;
           dispatch_group_t mlgroup = dispatch_group_create();
           dispatch_queue_t mlQueue = dispatch_queue_create("mlqueue", NULL);
           for (PHAsset * sset in self.viewModel.selectedPhssetArray){
               dispatch_async(mlQueue, ^{
                   dispatch_group_enter(mlgroup);
                   [MLPhotoManager MLrequestImageForAsset:sset targetSize:size resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                       
                       if ([info.allKeys containsObject:PHImageResultIsDegradedKey]){
                           BOOL downloadFinined = ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                           if (downloadFinined){
                               [imagesArray addObject:result];
                           }
                       }
                       dispatch_group_leave(mlgroup);
                   }];
               });
               
           }

        dispatch_group_notify(mlgroup, dispatch_get_main_queue(), ^{
            if (self.completeBloack){
                self.completeBloack(self.viewModel.selectedImageArray);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
    else{
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)preview{
    
    MLPicShowViewController * vc = [[MLPicShowViewController alloc] init];
    vc.btnColor = self.btnColor;
    vc.view.backgroundColor = [UIColor blackColor];
    vc.showDeleteBtn = YES;
    vc.index = 0 ;
    vc.imageArray = self.viewModel.selectedImageArray;
    vc.selectedPhssetArray = self.viewModel.selectedPhssetArray;
    __weak typeof(self) weakSelf = self;
    vc.bloack = ^(NSMutableArray *imageArray,NSMutableArray *PhssetArray){
        weakSelf.viewModel.selectedImageArray = imageArray;
        weakSelf.viewModel.selectedPhssetArray = PhssetArray;
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = YES;
}
- (void)createAlert:(NSString *)code{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:code preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)photoAlbum{
    if (self.albumName){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        MLAlbumListViewController * vc = [[MLAlbumListViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.viewModel.selectedPhssetArray = self.viewModel.selectedPhssetArray;
        vc.viewModel.selectedImageArray = self.viewModel.selectedImageArray;
        vc.maxIndex = self.maxIndex ? self.maxIndex : 9;
        vc.viewModel.albumArray = self.viewModel.albumArray;
        vc.viewModel.setArray = self.viewModel.setArray ;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController  pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
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
