//
//  WKWebViewController.m
//  XWappBrowser
//
//  Created by Xiu on 16/8/26.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "WKWebViewController.h"
#import "NSString+URLExtend.h"
#import "WKWebView+BarButtonExtend.h"



@interface WKWebViewController () <WKNavigationDelegate, WKUIDelegate, WKWebViewControllerDelegate>

@property (nonatomic, strong) UIProgressView * progressView;    /// 加载进度条

@property (nonatomic, strong) UIButton * maskErrorView;         /// 显示错误页面

@property (nonatomic, strong) NSString * webTitle;              ///< 页面标题

@end

@implementation WKWebViewController


+ (instancetype)getWebViewControllerWithTitle:(NSString *)title url:(NSString *)url params:(NSDictionary *)params{
    
    return [WKWebViewController getWebViewControllerWithTitle:title url:url params:params type:BrowseTypeExtern];
}

+ (instancetype)getWebViewControllerWithTitle:(NSString *)title url:(NSString *)url params:(NSDictionary *)params type:(BrowseType)type{
    
    WKWebViewController * webVC = [[self alloc] init];
    [ webVC preloadWebWithTitle:title url:url params:params type:type];
    return webVC;
}

- (void)preloadWebWithTitle:(NSString *)title url:(NSString *)url params:(NSDictionary *)params{
    
    [self preloadWebWithTitle:title url:url params:params type:BrowseTypeExtern];
}

- (void)preloadWebWithTitle:(NSString *)title url:(NSString *)url params:(NSDictionary *)params type:(BrowseType)type{
    
    self.browserType = type;
    self.webTitle = title;
    [self getBarButtonItemsWithType:type];
    [self loadWithWKWebView:nil URL:url params:params];
    
}

- (void)loadWithWKWebView:(WKWebView *)wkWeb URL:(NSString *)url params:(NSDictionary *)params {
    
    self.wkWeb = wkWeb;
    
    if (url.length == 0) {
        return;
    }
    
    if (!self.wkWeb) {
        
        self.wkWeb = [[WKWebView alloc]init];
        self.wkWeb.translatesAutoresizingMaskIntoConstraints = NO;
        self.wkWeb.backgroundColor = self.view.backgroundColor;
        self.wkWeb.navigationDelegate = self;
        self.wkWeb.UIDelegate = self;
        [self.view addSubview:self.wkWeb];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWeb
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWeb
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWeb
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWeb
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
    }
    
    //  进度条
    if (!self.progressView) {
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.userInteractionEnabled = NO;
        self.progressView.backgroundColor = [UIColor clearColor];
        self.progressView.trackTintColor = [UIColor clearColor];
        self.progressView.progressTintColor = [UIColor colorWithRed:48.0/255 green:195.0/255 blue:255.0/255 alpha:1];
        self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.progressView];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:64]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:2]];
    }
    
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.wkWeb addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self applicationWebViewUsergentModify];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == self.wkWeb ) {
            [self.progressView setProgress:self.wkWeb.estimatedProgress animated:YES];
            if(self.wkWeb.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
}

/**
 * WebView 没有提供设置user-agent 的接口，无论是设置要加载的request，还是在delegate 中设置request，都是无效的所以在此添加
 *
 */
-(void)applicationWebViewUsergentModify{
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // 获取当前项目的verison
    NSString *verison = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    
    // 获取当前语言
    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    // 将参数添加到代理
    
    NSString *newAgent = [oldAgent stringByAppendingString:[NSString stringWithFormat:@" iAuto360/%@ Language/%@ WappBrowser/1.2.6",verison,currentLanguage]];
    
    // 新的代理
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.delegate nativeControlBack];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)dealloc {
    [self.wkWeb removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - WKNavigationDelegate
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSDictionary * param = [navigationAction.request.URL.query params]; // 解析参数
    
    switch ([navigationAction.request.URL.host hostType]) {
            
    case HostPushTypeAlertWidgetNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeWidgetAlertWithParam:param];
            break;
    case HostPushTypeImgWidgetNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeWidgetImg:param];
            break;
    case HostPushTypeUserInfoFunctionNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeFunctionUserInfoWithParam:param];
            break;
    case HostPushTypeLogOutFunctionNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeFunctionLogOut];
            break;
    case HostPushTypeKickoutFunctionNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeFunctionKickoutWithParam:param];
            break;
    case HostPushTypeWXShareFunctionNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeFunctionShareWithParam:param];
            break;
    case HostPushTypeOpenControlNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeControlOpenWithParam:param];
            break;
    case HostPushTypeCloseControlNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeControlClose];
            break;
    case HostPushTypeBackControlNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeControlBack];
            break;
    case HostPushTypeHomeControlNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeControlHome];
            break;
    case HostPushTypeMapControlNative:
            
            [(id <WKWebViewControllerDelegate>)self nativeControlMapWithParam:param];
            break;
    case HostPushTypeRequestFunctionNative:  ///< request.function.native    请求数据
            
            [(id <WKWebViewControllerDelegate>)self nativeFunctionRequestWithParam:param];
            break;

    case HostPushTypeNone:
            
            [(id <WKWebViewControllerDelegate>)self notSupportWithParam:param] ? decisionHandler(WKNavigationActionPolicyAllow): decisionHandler(WKNavigationActionPolicyCancel);
            
            return ;
            break;
    }
    
    decisionHandler(WKNavigationActionPolicyCancel);

    //        // 不支持
    //    }else{
    //        BOOL isBool = [self notSupport:webView path:path param:param];
    //        //        NSString *url = [NSString stringWithFormat:@"%@",self.URLStack.lastObject];
    //        NSString *url = [NSString stringWithFormat:@"%@",self.webView.request.URL];
    //        NSArray * items = [url componentsSeparatedByString:@"?"];
    //        NSString * path = nil; // 响应标识
    //        NSDictionary * dic = nil; // 响应参数
    //        if (items.count)
    //        {
    //            path = items[0];
    //        }
    //        if (items.count >= 2)
    //        {
    //            dic =  [items[1] params];
    //        }
    //        if ([dic.allKeys containsObject:@"result"]) {
    //            NSString * jsonString = [dic[@"result"] stringByRemovingPercentEncoding];
    //            dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    //        }
    //        return isBool;
    //    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 调用SDK
    [self.wkWeb evaluateJavaScript:@"wapp.utils.readyEvent()" completionHandler:nil];
    // 禁用长按弹出框
    [self.wkWeb evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    // 禁用用户选择
    [self.wkWeb evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self showErrorMaskView];
}

- (UIButton *)maskErrorView
{
    if (!_maskErrorView)
    {
        
        NSString * imageName = @"web_image_loading_wrong";
        UIImage *img = [UIImage imageNamed:MJRefreshSrcName(imageName)] ?: [UIImage imageNamed:MJRefreshFrameworkSrcName(imageName)];
        
        _maskErrorView = [[UIButton alloc] init];
        _maskErrorView.backgroundColor = [UIColor whiteColor];
        [_maskErrorView setImage:[UIImage imageWithCGImage:img.CGImage scale:3 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [_maskErrorView addTarget:self action:@selector(maskErrorViewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskErrorView;
}

-(void)maskErrorViewClick:(UIButton *)sender {
    
    [self dismissErrorMaskView];
    
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:self.wkWeb.URL]];
}

- (void)showErrorMaskView
{
    self.progressView.progress = 0.0;
    
    UIView * superView = self.wkWeb ? self.wkWeb : self.view;
    [superView addSubview:self.maskErrorView];
    self.maskErrorView.frame = superView.frame;
}

- (void)dismissErrorMaskView
{
    [_maskErrorView removeFromSuperview];
}


#pragma mark - WKWebViewControllerDelegate

/**
 *  alert.widget.native 提示框
 *  @param  param   参数
 */
- (void)nativeWidgetAlertWithParam:(NSDictionary *)param{

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:param[@"title"] message:param[@"message"] preferredStyle:UIAlertControllerStyleAlert];
    
    NSData *data = [param[@"buttons"] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *buttons = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    

    UIAlertAction *Action = [UIAlertAction actionWithTitle:param[@"cancel"] style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:Action];
    
    for (int i = 0; i < buttons.count; i++) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:buttons[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString * callback = param[@"callback"];
            NSString *js =[callback stringByReplacingOccurrencesOfString:@"index" withString:[NSString stringWithFormat:@"'%d'",i + 1]];
            [self.wkWeb evaluateJavaScript:js completionHandler:nil];
        }];
        [alert addAction:cancelAction];

    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  img.widget.native 图片放大处理
 *  @param  param   参数
 */
- (void)nativeWidgetImg: (NSDictionary *)param{}

/**
 *  user_info.function.native   获取用户信息
 *  @return 返回一个用户信息字典
 */
- (void)nativeFunctionUserInfoWithParam:(NSDictionary *)param{
    
    NSString *callback = param[@"callback"];
    NSString *js =[callback stringByReplacingOccurrencesOfString:@"info" withString:[NSString stringWithFormat:@"'%@'",[self nativeFunctionUserInfo]]];
    [self.wkWeb evaluateJavaScript:js completionHandler:nil];
}

/**
 *  log_out.function.native web退出登陆
 */
- (void)nativeFunctionLogOut {}

/**
 *  kickout.function.native 踢出APP端用户登陆
 *  @param  param   参数
 *  @return 判断是否需要显示 错误页面按钮 默认NO
 */
- (void)nativeFunctionKickoutWithParam:(NSDictionary *)param {}

/**
 *  wx_share.function.native 分享
 *  @param  param   参数
 */
- (void)nativeFunctionShareWithParam:(NSDictionary *)param {}

/**
 * open.control.native 打开新实例页面，包括本地页面，Web页
 */
- (void)nativeControlOpenWithParam: (NSDictionary *)param {
    //打开原生页面
    if ([param[@"type"] isEqualToString:@"3"]) {
        
        //如果当前页面为
        if (self.browserType == BrowseTypeExtern ) {
            NSLog(@"你不能在BrowseTypeExtern型中打开native page");
            return;
        }
        NSString *pushKey = [[NSBundle mainBundle]pathForResource:@"PushKey" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:pushKey];
        
        if ([dic objectForKey:param[@"url"]]){
            
            NSArray *keyInfo = [dic objectForKey:param[@"url"]];
            UIStoryboard *storyboard;
            id vc;
            
            @try {
                storyboard = [UIStoryboard storyboardWithName:keyInfo.firstObject bundle:nil];
                vc = [storyboard instantiateViewControllerWithIdentifier:keyInfo.lastObject];
                
            } @catch (NSException *exception) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"对不起，< %@ > 配置的 storyboard Key 没有找到",param[@"url"]] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alertView show];
                return ;
            }
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        //打开WebView
    }else  {
        
        if (self.browserType == BrowseTypeApp) {
            NSLog(@"你不能在App Page型中打开H5 page");
            return;
        }

        [self.navigationController pushViewController:[[self class] getWebViewControllerWithTitle:param[@"title"]  url:param[@"url"] params:nil type:[param[@"type"] integerValue]] animated:YES];
        
    }
}

/**
 *  close.control.native 关闭当前实例返回上一级
 */
- (void)nativeControlClose {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  back.control.native 返回栈里的历史页面
 */
- (void)nativeControlBack{
    
    if (self.wkWeb.canGoBack) {
        
        [self.wkWeb goBack];
    }else {
        
        [self nativeControlClose];
    }
}

/**
 *  home.control.native 返回到APP 首页
 */
- (void)nativeControlHome{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  map.control.native  响应跳转外部地图
 */
- (void)nativeControlMapWithParam:(NSDictionary *)param {
    
}

/**
 * request.function.native  请求数据
 */
-(void)nativeFunctionRequestWithParam:(NSDictionary *)param {
    
}
             
/**
 *  SDK没有定义的path
 *  @param  param   参数
 *  @return BOOL    是否需要加载此连接 默认YES
 */
- (BOOL)notSupportWithParam:(NSDictionary *)param {
    
    return YES;
}

/**
 *  user_info.function.native   获取用户信息
 *  @return 返回一个用户信息字典
 */
- (NSString *)nativeFunctionUserInfo{
    return  @"APP端没有传递用户信息";
}



#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    completionHandler();
}

@end
