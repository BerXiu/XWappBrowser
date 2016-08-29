//
//  WebViewController.m
//  XWappBrowser
//
//  Created by Xiu on 16/8/29.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "WebViewController.h"
#import "ImageTipsView.h"
#import "UIViewController+HUD.h"


@implementation WebViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)nativeWidgetImg: (NSDictionary *)param {
    [ImageTipsView showWithURL:param[@"url"] placeholderImage:[UIImage imageNamed:@"icon_user"]];
}

@end
