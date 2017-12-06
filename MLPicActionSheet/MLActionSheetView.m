//
//  MLActionSheetView.m
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/12/5.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import "MLActionSheetView.h"

@interface MLActionSheetView()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,weak)UIViewController * mlSend;
@end

@implementation MLActionSheetView

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self){
        [self basis];
    }
    return self;
}
- (void)basis{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    self.userInteractionEnabled = YES;
    self.maxNumber = 9;
    self.navColor = [UIColor blackColor];
    self.btnColor = [UIColor whiteColor];
}
- (void)showMLPhoto:(UIViewController *)send{
    self.mlSend = send;
    [self.mlSend.view addSubview:self];
    [self showPermissionsAlert];
}
- (void)showPermissionsAlert{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        }];
        [self showAlert];
    }else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status != PHAuthorizationStatusRestricted && status != PHAuthorizationStatusDenied){
                [self showAlert];
            }else{
                [self createErr:@"需要您在设置中打开授权才能获取多媒体资源"];
            }
        }];
    }
}
- (void)createErr:(NSString *)code{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:code preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:trueAction];
    [self.mlSend presentViewController:alertVC animated:YES completion:nil];
}
- (void)showAlert{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction * TakingAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = weakSelf;
            picker.allowsEditing = NO;
            picker.videoQuality = UIImagePickerControllerQualityTypeLow;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [weakSelf.mlSend presentViewController:picker animated:YES completion:^{
            }];
            
        }else{
            return ;
        }
        
    }];
    UIAlertAction * albumAction = [UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MLPhotoViewController * vc = [[MLPhotoViewController alloc] init];
        vc.maxIndex = self.maxNumber;
        vc.btnColor = self.btnColor;
        vc.completeBloack = ^(NSMutableArray<UIImage *> *selectedImagesArray) {
            if (self.bloack){
                self.bloack(selectedImagesArray);
            }else{
                
            }
            NSLog(@"选中的图片数量===%ld张",selectedImagesArray.count);
            [self removeFromSuperview];
        };
        vc.cancal = ^{
            [self removeFromSuperview];
        };
        vc.view.backgroundColor = [UIColor whiteColor];
        CreditNavigationController *nav=[[CreditNavigationController alloc]initWithRootViewController:vc];
        [nav navTitleColor:self.btnColor];
        [nav setNavColorStyle:self.navColor];
        nav.navigationBar.tintColor = self.btnColor;
        [self.mlSend presentViewController:nav animated:YES completion:nil];
        
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self removeFromSuperview];
    }];
    [alertVC addAction:TakingAction];
    [alertVC addAction:albumAction];
    [alertVC addAction:cancelAction];
    [self.mlSend presentViewController:alertVC animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSMutableArray * imagesArray = [NSMutableArray array];
        [imagesArray addObject:image];
        if (self.bloack){
            self.bloack(imagesArray);
            [self removeFromSuperview];
        }
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
