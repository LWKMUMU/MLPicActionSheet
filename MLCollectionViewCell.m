//
//  MLCollectionViewCell.m
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/5/25.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import "MLCollectionViewCell.h"


@interface MLCollectionViewCell()

@end

@implementation MLCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _subImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _selecedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 30, 5, 25, 25)];
        _selecedImageView.image = [UIImage imageNamed:@"未选中"];
        [self.contentView addSubview:_subImageView];
        [self.contentView addSubview:_selecedImageView];
        _subImageView.userInteractionEnabled = YES;
        _selecedImageView.userInteractionEnabled  = YES;
        self.subImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.subImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagAction:)];
        self.selecedImageView.userInteractionEnabled = YES;
        [self.selecedImageView addGestureRecognizer:tap];
    }
    return self;
}
- (void)tagAction:(UIGestureRecognizer *)ges{
    if (_delegate){
        if (self.isSelected){
            [_delegate deleteImage:self.subImageView.image andCell:self];
        }else{
            [_delegate selectedImage:self.subImageView.image andCell:self];
        }
    }
    
}
@end
