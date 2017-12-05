//
//  CreditNavigationController.m
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-5-16.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import "CreditNavigationController.h"


@interface CreditNavigationController ()


@end

@implementation CreditNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
}
- (void)navTitleColor:(UIColor *)color{
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, nil]];
}
-(void)setNavColorStyle:(UIColor *)color{
    
    if([self.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        self.navigationBar.barTintColor=color;
        self.navigationBar.tintColor=[UIColor whiteColor];
    }else{
        self.navigationBar.tintColor=color;
    }
    
}

-(BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}@end
