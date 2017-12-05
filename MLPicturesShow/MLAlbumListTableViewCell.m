//
//  MLAlbumListTableViewCell.m
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/5.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import "MLAlbumListTableViewCell.h"



@implementation MLAlbumListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self basisUI];
    }
    return self;
}
- (void)basisUI{
    self.subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    self.subImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.subImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.subImageView];
    
    self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.subImageView.frame) + 10, 5, self.bounds.size.width - 130, 100)];
    self.nameLable.textAlignment = NSTextAlignmentLeft;
    self.nameLable.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.nameLable.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
    self.nameLable.numberOfLines = 0;
    [self.contentView addSubview:self.nameLable];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
