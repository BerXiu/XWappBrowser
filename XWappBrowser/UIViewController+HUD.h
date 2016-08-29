//
//  UIViewController+HUD.h
//  iAuto360
//
//  Created by Steven on 15/1/12.
//  Copyright (c) 2015年 YaMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>


/// 弹出等待指示, 自动处理用户响应
@interface UIViewController (UIViewController_HUD)

- (void)HUDsetOffsetFromCenter:(UIOffset)offset;
- (void)HUDresetOffsetFromCenter;

- (void)HUDshow;
- (void)HUDshowWithMaskType:(SVProgressHUDMaskType)maskType;
- (void)HUDshowWithStatus:(NSString*)status;
- (void)HUDshowWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType;

- (void)HUDshowProgress:(float)progress;
- (void)HUDshowProgress:(float)progress status:(NSString*)status;
- (void)HUDshowProgress:(float)progress status:(NSString*)status maskType:(SVProgressHUDMaskType)maskType;

- (void)HUDsetStatus:(NSString*)string; // change the HUD loading status while it's showing

// stops the activity indicator, shows a glyph - status, and dismisses HUD 1s later
- (void)HUDshowSuccessWithStatus:(NSString*)string;
- (void)HUDshowErrorWithStatus:(NSString *)string;
- (void)HUDshowSuccessWithStatus:(NSString*)string popAfterDissmiss:(BOOL)shouldpop;
- (void)HUDshowErrorWithStatus:(NSString *)string popAfterDissmiss:(BOOL)shouldpop;
- (void)HUDshowImage:(UIImage*)image status:(NSString*)status; // use 28x28 white pngs

- (void)HUDpopActivity;
- (void)HUDdismiss;

- (BOOL)HUDisVisible;

@end
