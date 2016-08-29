//
//  WKWebViewController.h
//  XWappBrowser
//
//  Created by Xiu on 16/8/26.
//  Copyright © 2016年 Xiu. All rights reserved.
//

@import WebKit;
@import WebKit.WKUIDelegate;
@import UIKit.UIViewController;

// 图片路径
#define MJRefreshSrcName(file) [@"WebBase.bundle" stringByAppendingPathComponent:file]
#define MJRefreshFrameworkSrcName(file) [@"Frameworks/BaseClass.framework/WebBase.bundle" stringByAppendingPathComponent:file]

__TVOS_PROHIBITED @protocol WKWebViewControllerDelegate <NSObject>

@required

@optional

/**
 *  alert.widget.native 提示框
 *  @param  param   参数
 */
- (void)nativeWidgetAlertWithParam:(NSDictionary *)param;

/**
 *  img.widget.native 图片放大处理
 *  @param  param   参数
 */
- (void)nativeWidgetImg: (NSDictionary *)param;

/**
 *  user_info.function.native   获取用户信息
 *  @return 返回一个用户信息字典
 */
- (void)nativeFunctionUserInfoWithParam:(NSDictionary *)param;

/**
 *  log_out.function.native web退出登陆
 */
- (void)nativeFunctionLogOut;

/**
 *  kickout.function.native 踢出APP端用户登陆
 *  @param  param   参数
 *  @return 判断是否需要显示 错误页面按钮 默认NO
 */
- (void)nativeFunctionKickoutWithParam:(NSDictionary *)param;

/**
 *  wx_share.function.native 分享
 *  @param  param   参数
 */
- (void)nativeFunctionShareWithParam:(NSDictionary *)param;

/**
 * open.control.native 打开新实例页面，包括本地页面，Web页
 */
- (void)nativeControlOpenWithParam: (NSDictionary *)param;

/**
 *  close.control.native 关闭当前实例返回上一级
 */
- (void)nativeControlClose;

/**
 *  back.control.native 返回栈里的历史页面
 */
- (void)nativeControlBack;

/**
 *  home.control.native 返回到APP 首页
 */
- (void)nativeControlHome;

/**
 *  map.control.native  响应跳转外部地图
 */
- (void)nativeControlMapWithParam:(NSDictionary *)param;

/**
 * request.function.native  请求数据
 */
-(void)nativeFunctionRequestWithParam:(NSDictionary *)param;

/**
 *  SDK没有定义的path
 *  @param  param   参数
 *  @return BOOL    是否需要加载此连接 默认YES
 */
- (BOOL)notSupportWithParam:(NSDictionary *)param;

@end


/**
 *  H5框架类型
 */
typedef NS_ENUM(NSInteger,BrowseType) {
    BrowseTypeExtern    = 0,    ///< 网页浏览型
    BrowseTypeWebApp    = 1,    ///< webApp型
    BrowseTypeApp       = 2     ///< App型
};

@interface WKWebViewController : UIViewController

@property (nonatomic, assign) BrowseType browserType;                       ///< 浏览器类型

@property (nonatomic, assign) id <WKWebViewControllerDelegate> delegate;    ///< WKWeb协议

@property (nonatomic, strong) IBOutlet WKWebView *wkWeb;


/**
 *  打开新的WebView
 *
 *  @param title          标题
 *  @param url            链接
 *  @param params  参数
 */
+ (instancetype)getWebViewControllerWithTitle:(NSString *)title url:(NSString *)url params:(NSDictionary *)params;

/**
 *  打开新的WebView
 *
 *  @param title          标题
 *  @param url            链接
 *  @param params  参数
 */
+ (instancetype)getWebViewControllerWithTitle:(NSString *)title url:(NSString *)url params:(NSDictionary *)params type:(BrowseType)type;

/**
 *  web预加载处理
 *  @param  title   导航标题
 *  @param  type    H5的框架类型
 *  @param  url     请求连接地址
 *  @param  params  参数
 */
- (void)preloadWebWithTitle:(NSString *)title url:(NSString *)url params:(NSDictionary *)params ;

/**
 *  web预加载处理
 *  @param  title   导航标题
 *  @param  type    H5的框架类型
 *  @param  url     请求连接地址
 *  @param  params  参数
 */
- (void)preloadWebWithTitle:(NSString *)title url:(NSString *)url params:(NSDictionary *)params type:(BrowseType)type;


/**
 *  加载URL
 *  @param  wkWeb
 *  @param  url     请求地址
 *  @param  params  请求参数
 */
- (void)loadWithWKWebView:(WKWebView *)wkWeb URL:(NSString *)url params:(NSDictionary *)params;


@end
