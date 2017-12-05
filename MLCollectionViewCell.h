//
//  MLCollectionViewCell.h
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/5/25.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@protocol MLCollectionViewCellDelegate <NSObject>

- (void)selectedImage:(UIImage *)image andCell:(id)cell;
- (void)deleteImage:(UIImage * )image andCell:(id)cell;
@end

@interface MLCollectionViewCell : UICollectionViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *subImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *selecedImageView;
@property(nonatomic,strong)UIImageView * subImageView;
@property(nonatomic,strong)UIImageView * selecedImageView;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,weak)id<MLCollectionViewCellDelegate>delegate;
@property(nonatomic,strong)PHAsset * sset;
@end
