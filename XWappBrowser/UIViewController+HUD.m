//
//  UIViewController+HUD.m
//  iAuto360
//
//  Created by Steven on 15/1/12.
//  Copyright (c) 2015年 YaMei. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "SVProgressHUD.h"
#import <objc/runtime.h>
#import "UINavigationController+extend.h"

static const char* popWhileHUDDissmissKey = "popWhileDissmiss";

@implementation UIViewController (UIViewController_HUD)

-(void)setPopWhileHUDDismiss:(BOOL)popWhileHUDDismiss{
    objc_setAssociatedObject(self, popWhileHUDDissmissKey, @(popWhileHUDDismiss),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)popWhileHUDDismiss{
    return [objc_getAssociatedObject(self, popWhileHUDDissmissKey) boolValue];
}


- (void)addNotification
{
    self.view.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNotification) name:SVProgressHUDDidDisappearNotification object:nil];
}
- (void)hideNotification
{
    self.view.userInteractionEnabled = YES;
    if (self.popWhileHUDDismiss) {
        [self.navigationController popAnimated];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SVProgressHUDDidDisappearNotification object:nil];
}




- (void)HUDsetOffsetFromCenter:(UIOffset)offset
{
    [SVProgressHUD setOffsetFromCenter:offset];
}
- (void)HUDresetOffsetFromCenter
{
    [SVProgressHUD resetOffsetFromCenter];
}

- (void)HUDshow
{
    [SVProgressHUD show];
    [self addNotification];
}
- (void)HUDshowWithMaskType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD showWithMaskType:maskType];
    [self addNotification];
}
- (void)HUDshowWithStatus:(NSString*)status
{
    [SVProgressHUD showWithStatus:status];
    [self addNotification];
}
- (void)HUDshowWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD showWithStatus:status maskType:maskType];
    [self addNotification];
}

- (void)HUDshowProgress:(float)progress
{
    [SVProgressHUD showProgress:progress];
    [self addNotification];
}
- (void)HUDshowProgress:(float)progress status:(NSString*)status
{
    [SVProgressHUD showProgress:progress status:status];
    [self addNotification];
}
- (void)HUDshowProgress:(float)progress status:(NSString*)status maskType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD showProgress:progress status:status maskType:maskType];
    [self addNotification];
}

- (void)HUDsetStatus:(NSString*)string
{
    [SVProgressHUD setStatus:string];
}

- (void)HUDshowSuccessWithStatus:(NSString*)string
{
    [SVProgressHUD showSuccessWithStatus:string];
}
- (void)HUDshowErrorWithStatus:(NSString *)string
{
    [SVProgressHUD showErrorWithStatus:string];
}

-(void)HUDshowSuccessWithStatus:(NSString *)string popAfterDissmiss:(BOOL)shouldpop{
    self.popWhileHUDDismiss = shouldpop;
    [self HUDshowSuccessWithStatus:string];
}

-(void)HUDshowErrorWithStatus:(NSString *)string popAfterDissmiss:(BOOL)shouldpop{
    self.popWhileHUDDismiss = shouldpop;
    [self HUDshowErrorWithStatus:string];
}

- (void)HUDshowImage:(UIImage*)image status:(NSString*)status
{
    [SVProgressHUD showImage:image status:status];
}

- (void)HUDpopActivity
{
    [SVProgressHUD popActivity];
}
- (void)HUDdismiss
{
    [SVProgressHUD dismiss];
//    [self hideNotification];
}

- (BOOL)HUDisVisible
{
    return [SVProgressHUD isVisible];
}

@end
