//
//  CLCacheCell.m
//  CacheDemo
//
//  Created by sks on 16/7/9.
//  Copyright © 2016年 CL. All rights reserved.
//

#import "CLCacheCell.h"
#import "NSString+Extension.h"
#import "SVProgressHUD.h"

@implementation CLCacheCell

/** 缓存路径 */
#define CLCacheFile [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"缓存"]

static NSString * const CLDefaultText = @"清除缓存";


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.text = CLDefaultText;
        
        // 禁止点击事件
        self.userInteractionEnabled = NO;
        
        // 右边显示圈圈
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;
        
        // 计算大小
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            // 计算缓存大小
            NSInteger size = CLCacheFile.fileSize;
            //缓存路径
            NSLog(@"%@",CLCacheFile);


            NSString *sizeText = nil;
            if (size >= pow(10, 9)) { // >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // >= 1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB", size /pow(10, 6)];
            } else if (size >= pow(10, 3)) { // >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // >= 0B
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            NSString *text = [NSString stringWithFormat:@"%@(%@)", CLDefaultText, sizeText];
            
            // 回到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.textLabel.text = text;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.accessoryView = nil;
                // 允许点击事件
                self.userInteractionEnabled = YES;
                
                
            }];
        }];
    }
    return self;
}

- (void)updateStatus
{
    if (self.accessoryView == nil) return;
    
    // 让圈圈继续旋转
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
    
    self.textLabel.text = @"正在计算缓存大小...";

}
//清理缓存
- (void)clearCache
{
    [SVProgressHUD showWithStatus:@"正在清除缓存"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [[NSFileManager defaultManager] removeItemAtPath:CLCacheFile error:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
            self.textLabel.text = CLDefaultText;
            
            // 禁止点击事件
            self.userInteractionEnabled = NO;
        }];
    }];
}


@end
