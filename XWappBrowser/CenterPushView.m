//
//  CenterPushView.m
//  iAuto360
//
//  Created by Steven on 15/5/14.
//  Copyright (c) 2015年 Yamei. All rights reserved.
//

#import "CenterPushView.h"
#import <NSObjectExtend.h>
#import <POP.h>
#import <ReactiveCocoa.h>
#import <Masonry.h>

@interface CenterPushView()
@property (nonatomic, copy) CenterPushViewBlock bottomPushViewBlock;
@property (nonatomic, strong) UIControl * backgroundView;
@property (nonatomic, strong) UIView * customView;
@end


@implementation CenterPushView

+ (instancetype)showWithCustomView:(UIView *)customView backgroundTouchBlock:(CenterPushViewBlock)block;
{
    CenterPushView * view = [[self.class alloc] initWithCustomView:customView backgroundTouchBlock:block];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view show];
    });
    return view;
}

- (instancetype)initWithCustomView:(UIView *)customView backgroundTouchBlock:(CenterPushViewBlock)block;
{
    if (self = [self init])
    {
        self.bottomPushViewBlock = block;
        
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.backgroundView = [[UIControl alloc] init];
        self.backgroundView.backgroundColor = [UIColor colorWithHexCode:@"#00000080"];
        [self.backgroundView addTarget:self action:@selector(onBackgroundTouch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backgroundView];
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            // 设置背景按钮的约束
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        self.customView = customView;
        [self addSubview:customView];
        customView.translatesAutoresizingMaskIntoConstraints = NO;
        [customView mas_makeConstraints:^(MASConstraintMaker *make) {
            // 设置自定义View的约束
            make.center.equalTo(@0);
            make.left.greaterThanOrEqualTo(@0);
            make.top.greaterThanOrEqualTo(@0);
        }];
    }
    return self;
}

- (void)setIsShow:(BOOL)isShow
{
    if (isShow)
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.removeExisting = YES;
            make.edges.equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }
    
    [self.customView.layer pop_removeAllAnimations];
    [self.backgroundView.layer pop_removeAllAnimations];
    
    id value1 = [NSValue valueWithCGPoint:CGPointMake(0.3, 0.3)];
    id value2 = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    
    // customView弹簧动画
    if ([UIDevice iOSVersion] >= 8.0f)
    {
        POPSpringAnimation *scaleAnimation  = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.springBounciness     = isShow ? 16 : 0;
        scaleAnimation.springSpeed          = isShow ? 15 : 20;
        scaleAnimation.fromValue            = isShow ? value1 : value2;
        scaleAnimation.toValue              = isShow ? value2 : value1;
        [self.customView.layer pop_addAnimation:scaleAnimation forKey:@"CenterPushView.spring"];
    }
    
    // customView 渐变动画
    POPBasicAnimation * baseAnimation   = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    baseAnimation.fromValue             = isShow ? @(0.f) : @(1.f);
    baseAnimation.toValue               = isShow ? @(1.f) : @(0.f);
    [baseAnimation setCompletionBlock:^(POPAnimation *p, BOOL c)
     {
         if (!isShow)
         {
             [self removeFromSuperview];
         }
     }];
    [self.customView pop_addAnimation:baseAnimation forKey:@"CenterPushView.base"];
    
    
    // 背景渐变
    value1 = @(0.0);
    value2 = @(1.0);
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue          = isShow ? value1 : value2;
    opacityAnimation.toValue            = isShow ? value2 : value1;
    [self.backgroundView.layer pop_addAnimation:opacityAnimation forKey:@"CenterPushView.opacity"];
    
}

- (void)show
{
    // 退出登录时，隐藏
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:NOTIFICATION_OTHER_WAY_LOGIN object:nil];
    [self setIsShow:YES];
}

- (void)hide
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_OTHER_WAY_LOGIN object:nil];
    [self setIsShow:NO];
}

- (void)onBackgroundTouch
{
    [self hide];
    if (self.bottomPushViewBlock)
    {
        self.bottomPushViewBlock(self);
    }
}


@end
