//
//  NSString+MLNSString.m
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/6.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import "NSString+MLNSString.h"

@implementation NSString (MLNSString)
- (NSString *)PhotoNameConversion:(NSString *)smartAlbum{
    if ([smartAlbum isEqualToString:@"Favorites"]){
        return @"我的收藏";
    }else if ([smartAlbum isEqualToString:@"Recently Added"]){
        return @"最近添加";
    }else if ([smartAlbum isEqualToString:@"Panoramas"]){
        return @"全景";
    }else if ([smartAlbum isEqualToString:@"Bursts"]){
        return smartAlbum;
    }else if ([smartAlbum isEqualToString:@"Hidden"]){
        return @"隐藏";
    }else if ([smartAlbum isEqualToString:@"Recently Deleted"]){
        return @"最近删除";
    }else if ([smartAlbum isEqualToString:@"Camera Roll"]){
        return @"相机";
    }else if ([smartAlbum isEqualToString:@"Slo-mo"]){
        return @"慢动作";
    }else if ([smartAlbum isEqualToString:@"Videos"]){
        return @"视频";
    }else if ([smartAlbum isEqualToString:@"Time-lapse"]){
        return @"延时";
    }else if ([smartAlbum isEqualToString:@"Screenshots"]){
        return @"屏幕截图";
    }else if ([smartAlbum isEqualToString:@"Selfies"]){
        return smartAlbum;
    }else if ([smartAlbum isEqualToString:@"Depth Effect"]){
        return smartAlbum;
    }else if ([smartAlbum isEqualToString:@"Live Photos"]){
        return @"生活照片";
    }
    return smartAlbum;
}
@end
