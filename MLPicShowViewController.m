//
//  MLPicShowViewController.m
//  Huihui
//
//  Created by 伟凯   刘 on 2017/4/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "MLPicShowViewController.h"

@interface MLPicShowViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSMutableArray * imageViewArray;
@property(nonatomic,strong)UIImageView * navImageView;
@property(nonatomic,strong)NSMutableArray * refreshImageArray;
@property(nonatomic,strong)NSMutableArray * imageIdArray;
@end

@implementation MLPicShowViewController
- (NSMutableArray *)imageViewArray{
    if (!_imageViewArray){
        _imageViewArray = [NSMutableArray new];
    }
    return _imageViewArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self basisUI];
    
}
- (void)basisUI{
    [self.view addSubview:[[UIView alloc] init]];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * _imageArray.count, 1);
    [self.view addSubview:_scrollView];
}
- (void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    if (self.showDeleteBtn){
        [self addrightBackNavBtn:@"删除"];
    }
    for (UIImageView * imageView in self.imageViewArray){
        [imageView removeFromSuperview];
    }
    CGFloat picWidth = self.view.bounds.size.width ;
    for (NSInteger i  = 0; i < _imageArray.count ; i ++){
        UIImage * image = (UIImage *)_imageArray[i];
        CGFloat picHeight = image.size.height / (image.size.width/picWidth);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width) * i, self.view.bounds.size.height/2 - picHeight/2, picWidth, picHeight)];
        imageView.image = image;
        imageView.userInteractionEnabled = YES;
        [self.imageViewArray addObject:imageView];
        [_scrollView addSubview:imageView];
    }
    [self addNavTitle:[NSString stringWithFormat:@"%ld/%ld",_index + 1,_imageArray.count]];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * _imageArray.count, 1);
    _scrollView.contentOffset = CGPointMake(self.view.frame.size.width * _index, 0);
}
- (void)refreshLayout{
    NSInteger index = 0;
    CGFloat picWidth = self.view.bounds.size.width ;
    for (UIImage * image in _refreshImageArray){
        if (self.imageViewArray.count > index){
           UIImageView * imageView = self.imageViewArray[index];
            CGFloat picHeight = image.size.height / (image.size.width/picWidth);
            imageView.frame = CGRectMake((self.view.bounds.size.width) * index, self.view.bounds.size.height/2 - picHeight/2, picWidth, picHeight);
            imageView.image = image;
        }
        index ++;
    }
}
- (void)setSelectedPhssetArray:(NSMutableArray *)selectedPhssetArray{
    _selectedPhssetArray = selectedPhssetArray;
    CGSize size = PHImageManagerMaximumSize;
    dispatch_queue_t mlQueue = dispatch_queue_create("mlqueue", DISPATCH_QUEUE_SERIAL);
    
    for (PHAsset * sset in _selectedPhssetArray){
        dispatch_async(mlQueue, ^{
            [MLPhotoManager MLrequestImageForAsset:sset targetSize:size resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result){
                    if (!_refreshImageArray){
                        _refreshImageArray = [[NSMutableArray alloc] init];
                    }
                    if (!_imageIdArray){
                        _imageIdArray = [[NSMutableArray alloc] init];
                    }
                    if ([info.allKeys containsObject:PHImageResultIsDegradedKey]){
                        BOOL downloadFinined = ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                        if (downloadFinined){
                             [_refreshImageArray addObject:result];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshLayout];
                        });
                    }
                }
            }];
        });
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.view.bounds.size.width;
    _index = index ;
    [self addNavTitle:[NSString stringWithFormat:@"%ld/%ld",_index + 1,_imageArray.count]];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}
- (void)rightAction{
    NSMutableArray * subImageArray = [[NSMutableArray alloc] initWithArray:self.imageArray];
    NSLog(@"%ld === %ld ",subImageArray.count,_index)
    ;    if (subImageArray.count > _index){
         [subImageArray removeObjectAtIndex:_index];
        [self.selectedPhssetArray removeObjectAtIndex:_index];
        if (_index+ 1 >= subImageArray.count && _index != 0){
            _index = _index - 1;
        }
        self.imageArray = subImageArray;
        if (subImageArray.count == 0){
            [UIView transitionWithView:self.navigationController.view
                              duration:1.0
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                [self.navigationController popViewControllerAnimated:NO];
                            }
                            completion:nil];
            
            return;
        }
    }
   
    
}
- (void)backItemClick{
    [UIView transitionWithView:self.navigationController.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                    completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _navImageView.alpha = 1.0;
    if (self.bloack){
        self.bloack(self.imageArray,self.selectedPhssetArray);
    }
}
- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated  ];
    _navImageView = self.navigationController.navigationBar.subviews.firstObject;
    _navImageView.alpha = 0.0;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)addrightBackNavBtn:(NSString *)code {
    UIBarButtonItem * button1 = [[UIBarButtonItem alloc] initWithTitle:code style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItems = @[button1];
}

- (void)leftNavBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addNavTitle:(NSString *)title {
    UILabel * label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = self.btnColor?self.btnColor:[UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.frame = CGRectMake(0, 0, 100, 44);
    self.navigationItem.titleView = label;
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
