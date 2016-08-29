//
//  ImageTipsView.m
//  iAuto360
//
//  Created by Steven on 15/3/19.
//  Copyright (c) 2015年 YaMei. All rights reserved.
//

#import "ImageTipsView.h"
#import <NSObject+extend.h>
#import <pop/POP.h>
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface ImageTipsView()

@end

@implementation ImageTipsView

+ (void)showWithImage:(UIImage *)image
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self showWithCustomView:imageView backgroundTouchBlock:^(CenterPushView *view){}];
}

+ (void)showWithURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholder;
{
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:placeholder completed:nil];
    [self showWithCustomView:imageView backgroundTouchBlock:nil];
}

@end
