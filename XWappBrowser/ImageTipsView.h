//
//  ImageTipsView.h
//  iAuto360
//
//  Created by Steven on 15/3/19.
//  Copyright (c) 2015年 YaMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterPushView.h"

/// 弹出提示图片
@interface ImageTipsView : CenterPushView

/**
 *  中心弹出图片
 *
 *  @param image UIImage
 */
+ (void)showWithImage:(UIImage *)image;

/**
 *  中心弹出图片，从网络获取
 *
 *  @param imageURL    图片URL
 *  @param placeholder 本地默认图片
 */
+ (void)showWithURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholder;

@end
