//
//  MLAlbumListViewModel.m
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/5.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import "MLAlbumListViewModel.h"

@interface MLAlbumListViewModel()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * imagesArray;
@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong)NSMutableArray * iconArray;
/*
 照片ID
 */
@property(nonatomic,strong)NSMutableArray * imagesIdArray;
@end

@implementation MLAlbumListViewModel

- (NSMutableArray *)nameArray{
    if (!_nameArray){
        _nameArray = [[NSMutableArray alloc] init];
    }
    return _nameArray;
}
- (NSMutableArray *)iconArray{
    if (!_iconArray){
        _iconArray = [[NSMutableArray  alloc] init];
    }
    return _iconArray;
}
- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
//        [_tableView registerNib:[UINib nibWithNibName:@"MLAlbumListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MLAlbumListTableViewCell"];
    }
    return _tableView;
}

- (void)setSetArray:(NSMutableArray *)setArray{
    _setArray = setArray;
    dispatch_queue_t mlQueue = dispatch_queue_create("mlqueue", NULL);
    for (PHFetchResult * result in _setArray){
        dispatch_async(mlQueue, ^{
            PHAsset * sset = [result lastObject];
            PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
            //            imageOptions.version = PHImageRequestOptionsVersionUnadjusted;
            imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
            //            imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            imageOptions.synchronous = YES;
            
            CGSize size = CGSizeMake(300, 300);
            //        CGSize size = CGSizeMake(sset.pixelWidth,sset.pixelHeight);
            [[PHImageManager defaultManager] requestImageForAsset:sset targetSize:size contentMode:PHImageContentModeAspectFit options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                /*
                 别问我这里为什么没有判断返回的是什么图
                 因为同步情况下 这个回调只会被调用一次 🤣
                 If -[PHImageRequestOptions isSynchronous] returns NO (or options is nil), resultHandler may be called 1 or more times.
                 */
                if (result){
                    [self.iconArray addObject:result];
                }else{
                    [self.iconArray addObject:[UIImage imageNamed:@"a"]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        });
    }
    
}
- (UITableView *)basisUI{
    
    return self.tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.iconArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLAlbumListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MLAlbumListTableViewCell"];
    if (!cell){
        cell = [[MLAlbumListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MLAlbumListTableViewCell"];
    }
    cell.subImageView.image = self.iconArray[indexPath.section];
    cell.nameLable.text = [@"" PhotoNameConversion:self.albumArray[indexPath.section] ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate){
        [_delegate albumDetail:self.albumArray[indexPath.section]];
    }
}

@end
