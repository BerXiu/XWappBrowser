//
//  WKWebView+BarButtonExtend.m
//  XWappBrowser
//
//  Created by Xiu on 16/8/29.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "WKWebView+BarButtonExtend.h"

@implementation WKWebViewController(WKWebView_BarButtonExtend)

- (void)getBarButtonItemsWithType:(BrowseType)type {
    
    // 根据不同类型 加载不同的导航条
    switch (type) {
        case BrowseTypeExtern:
            
            [self setBarButtonItemsWithTitle:nil normalImage:@"btn_back_N" highlightedImage:@"btn_back_H" action:@selector(onBackButtonTouch) twotitle:nil twoNormalImage:@"btn_close_N" twoHighlightedImage:@"btn_close_H" twoAction:@selector(onCloseButtonTouch) isRight:NO];
            break;
        case BrowseTypeWebApp:
            
            [self setBarButtonItemWithNormalImage:@"btn_close_N" highlightedImage:@"btn_close_H" action:@selector(onCloseButtonTouch) isRight:NO];
            break;
        case BrowseTypeApp:
            
            [self setBarButtonItemWithNormalImage:@"btn_back_N" highlightedImage:@"btn_back_H" action:@selector(onBackButtonTouch) isRight:NO];
            break;
    }
    [self setBarButtonItemWithNormalImage:@"btn_refresh_N" highlightedImage:@"btn_refresh_H" action:@selector(onRefreshButtonTouch) isRight:YES];
}


/**
 *  返回按钮
 */
- (void)onBackButtonTouch{
    
    if (self.wkWeb.canGoBack) {
        
        [self.wkWeb goBack];
    }else {
        
        [self onCloseButtonTouch];
    }
}

/**
 *  关闭按钮
 */
- (void)onCloseButtonTouch{
    [self.navigationController popViewControllerAnimated:YES];
}

/// 刷新按下
- (void)onRefreshButtonTouch
{
    [self.wkWeb reload];
}
/*
 *  设置导航按钮（图片）
 *  @param  normalImage         图标(常亮)
 *  @param  highlightedImage    图标(高亮)
 *  @param  action              回调事件
 *  @param  isRight             YES:按钮放置在右边 NO:左边
 */
- (UIButton *)setBarButtonItemWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage action:(SEL)action isRight:(BOOL)isRight{
    return  [self setBarButtonItemWithTitle:nil normalImage:normalImage highlightedImage:highlightedImage action:action isRight:isRight];
}

/*
 *  设置导航按钮（图文）
 *  @param  title               按钮标题
 *  @param  normalImage         图标(常亮)
 *  @param  highlightedImage    图标(高亮)
 *  @param  action              回调事件
 *  @param  isRight             YES:按钮放置在右边 NO:左边
 */
- (UIButton *)setBarButtonItemWithTitle:(NSString*)title normalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage action:(SEL)action isRight:(BOOL)isRight{
    return [self setBarButtonItemsWithTitle:title normalImage:normalImage highlightedImage:highlightedImage action:action twotitle:nil twoNormalImage:nil twoHighlightedImage:nil twoAction:nil isRight:isRight];
}

/**
 *  设置导航栏按钮
 *  @param normalImage      默认图片
 *  @param highlightedImage 高亮图片
 *  @param titile           标题
 *  @param action           响应事件
 *  @param isRight          YES:按钮放置在右边 NO:左边
 */
-(UIButton *)setBarButtonItemsWithTitle:(NSString *)title normalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage action:(SEL)action twotitle:(NSString *)twotitle twoNormalImage:(NSString *)twoNormalImage twoHighlightedImage:(NSString *)twoHighlightedImage twoAction:(SEL)twoAction isRight:(BOOL)isRight{
    
    UIButton * button = [self getButtonWithTitle:title normalImage:[UIImage imageNamed:MJRefreshSrcName(normalImage)] ?: [UIImage imageNamed:MJRefreshFrameworkSrcName(normalImage)] highlightedImage:[UIImage imageNamed:MJRefreshSrcName(highlightedImage)] ?: [UIImage imageNamed:MJRefreshFrameworkSrcName(highlightedImage)] action:action];
    UIButton * twoButton = [self getButtonWithTitle:twotitle normalImage:[UIImage imageNamed:MJRefreshSrcName(twoNormalImage)] ?: [UIImage imageNamed:MJRefreshFrameworkSrcName(twoNormalImage)]  highlightedImage:[UIImage imageNamed:MJRefreshSrcName(twoHighlightedImage)] ?: [UIImage imageNamed:MJRefreshFrameworkSrcName(twoHighlightedImage)]  action:twoAction];
    
    if (isRight)
    {
        UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIBarButtonItem * twoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:twoButton];
        
        self.navigationItem.rightBarButtonItems = @[buttonItem, twoButtonItem];
    }
    else
    {
        CGRect buttonRect = button.frame;
        buttonRect.size.width += 20;
        buttonRect.size.height += 10;
        buttonRect.origin.x -= 10;
        button.frame = buttonRect;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
        
        view.backgroundColor = [UIColor clearColor];
        
        [view addSubview:button];
        
        UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        
        buttonItem.width = button.frame.size.width;
        CGRect twoButtonRect = twoButton.frame;
        //        twoButtonRect.size.width += 20;
        twoButtonRect.size.height += 10;
        twoButtonRect.origin.x -= 10;
        twoButton.frame = twoButtonRect;
        
        UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width, 0, twoButton.frame.size.width, twoButton.frame.size.height)];
        
        twoView.backgroundColor = [UIColor clearColor];
        
        [twoView addSubview:twoButton];
        
        UIBarButtonItem * twobuttonItem = [[UIBarButtonItem alloc] initWithCustomView:twoView];
        
        twobuttonItem.width = twoButton.frame.size.width;
        
        self.navigationItem.leftBarButtonItems = @[buttonItem,twobuttonItem];
    }
    return button;
}

/**
 *  创建导航Button
 *  @param  title               按钮标题
 *  @param  normalImage         图标(常亮)
 *  @param  highlightedImage    图标(高亮)
 */
-(UIButton*)getButtonWithTitle:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage action:(SEL)action {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGSize size = CGSizeZero;
    
    if (title.length)
    {
        UIFont * font = [UIFont systemFontOfSize:14];
        
        size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
        
        size = CGSizeMake(size.width + 15, size.height + 15);
        
        button.titleLabel.font = font;
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        
    }
    else
    {
        size = CGSizeMake( normalImage.size.width , normalImage.size.height );
        [button setImage:normalImage forState:UIControlStateNormal];
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    
    [button setFrame:CGRectMake(0, 0, size.width, size.height)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


@end
