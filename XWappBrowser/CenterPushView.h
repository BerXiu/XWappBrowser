//
//  CenterPushView.h
//  iAuto360
//
//  Created by Steven on 15/5/14.
//  Copyright (c) 2015年 Yamei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CenterPushView;

/**
 *  点击背景后回调
 *
 *  @param view CenterPushViewBlock
 */
typedef void (^CenterPushViewBlock)(CenterPushView * view);


/// 中间弹出视图
@interface CenterPushView : UIControl

/**
 *  底部弹出视图
 *  @param  customView          自定定义视图
 *  @param  block               回调
 *  @return
 */
+ (instancetype)showWithCustomView:(UIView *)customView backgroundTouchBlock:(CenterPushViewBlock)block;



/**
 *  中间弹出视图init
 *  @param  customView          自定定义视图
 *  @param  block               回调
 *  @return
 */
- (instancetype)initWithCustomView:(UIView *)customView backgroundTouchBlock:(CenterPushViewBlock)block;

- (void)show;
- (void)hide;

@end
