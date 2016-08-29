//
//  WKWebView+BarButtonExtend.h
//  XWappBrowser
//
//  Created by Xiu on 16/8/29.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWebViewController.h"

@interface WKWebViewController(WKWebView_BarButtonExtend)

/**
 *  根据框架类型定义BarButton
 *  @param  type    框架类型
 */
- (void)getBarButtonItemsWithType:(BrowseType)type;

@end
