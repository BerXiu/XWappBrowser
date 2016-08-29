//
//  NSString+URLExtend.h
//  XWappBrowser
//
//  Created by Xiu on 16/8/26.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HostPushType){
    
    HostPushTypeNone,
    HostPushTypeAlertWidgetNative,      ///< alert.widget.native        信息警示框
    HostPushTypeImgWidgetNative,        ///< img.widget.native          图片放大展示
    HostPushTypeUserInfoFunctionNative, ///< user_info.function.native  获取用户信息
    HostPushTypeLogOutFunctionNative,   ///< log_out.function.native    web退出登陆
    HostPushTypeKickoutFunctionNative,  ///< kickout.function.native    踢出APP端用户登陆
    HostPushTypeWXShareFunctionNative,  ///< wx_share.function.native   分享
    HostPushTypeOpenControlNative,      ///< open.control.native        打开新的实例页面包括本地页面，web页
    HostPushTypeCloseControlNative,     ///< close.control.native       关闭当前实例返回上一级
    HostPushTypeBackControlNative,      ///< back.control.native        返回栈的历史页面
    HostPushTypeHomeControlNative,      ///< home.control.native        返回APP首页
    HostPushTypeMapControlNative,       ///< map.control.native         响应跳转外部地图
    HostPushTypeRequestFunctionNative,  ///< request.function.native    请求数据
};


@interface NSString(NSString_URLExtend)

@property (nonatomic, readonly) HostPushType  hostType;

/// 获取URL里面的参数
@property (nonatomic, readonly) NSDictionary * params;

/**
 *  给URL拼接参数，返回拼接好的URL
 */
- (NSString *)urlStringWithParams:(NSDictionary *)params;


@end
