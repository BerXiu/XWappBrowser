//
//  NSString+URLExtend.m
//  XWappBrowser
//
//  Created by Xiu on 16/8/26.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "NSString+URLExtend.h"

@implementation NSString(NSString_URLExtend)

- (HostPushType)hostType {

    NSDictionary *dic = @{
                          @"alert.widget.native":       @(HostPushTypeAlertWidgetNative),       // 信息警示框
                          @"img.widget.native":         @(HostPushTypeImgWidgetNative),         // 图片放大展示
                          @"user_info.function.native": @(HostPushTypeUserInfoFunctionNative),  // 获取用户信息
                          @"log_out.function.native":   @(HostPushTypeLogOutFunctionNative),    // web退出登陆
                          @"kickout.function.native":   @(HostPushTypeKickoutFunctionNative),   // 踢出APP端用户登陆
                          @"wx_share.function.native":  @(HostPushTypeWXShareFunctionNative),   // 分享
                          @"open.control.native":       @(HostPushTypeOpenControlNative),       // 打开新的实例
                          @"close.control.native":      @(HostPushTypeCloseControlNative),      // 关闭当前实例返回上一级
                          @"back.control.native":       @(HostPushTypeBackControlNative),       // 返回栈的历史页面
                          @"home.control.native":       @(HostPushTypeHomeControlNative),       // 返回APP首页
                          @"map.control.native":        @(HostPushTypeMapControlNative),        // 响应跳转外部地图
                          @"request.function.native":   @(HostPushTypeRequestFunctionNative),   // 请求数据
                          };
    NSNumber *type = [dic objectForKey:self];

    if (type) {
        return [type integerValue];
    }
    return HostPushTypeNone;
}

// 给URL拼接参数，返回拼接好的URL
- (NSString *)urlStringWithParams:(NSDictionary *)params
{
    if (params != nil) {
        NSString * s = nil;
        if ([self rangeOfString:@"?"].location == NSNotFound)
        {
            s = @"?";
        }
        else
        {
            s = @"&";
        }
        NSMutableArray * array = [NSMutableArray array];
        for (NSString * key in params.allKeys)
        {
            [array addObject:[NSString stringWithFormat:@"%@=%@", key, params[key]]];
        }
        return [NSString stringWithFormat:@"%@%@%@", self, s, [array componentsJoinedByString:@"&"]];
    }else{
        return self;
    }
}


// 读取URL的参数 如: @"status=2&tag=3" ==> 返回: @{@"status": @"2", @"tag": @"3"}
- (NSDictionary *)params
{
    NSString *str = [self stringByRemovingPercentEncoding];
    NSArray * items = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSArray * tmp = nil;
    NSString * value = nil;
    for (NSString * p in items)
    {
        NSRange range= [p rangeOfString:@"="];
        
        if(range.location!=NSNotFound)
        {
            NSString *rul1 = [p substringWithRange: NSMakeRange(range.location + 1, p.length-range.location - 1)];
            NSString *rul2= [p substringWithRange: NSMakeRange(0, range.location)];
            if (rul1) {
                tmp = @[rul2,rul1];
            }else{
                tmp = @[rul2];
            }
        }else{
            tmp = @[p];
        }
        value = @"";
        if (tmp.count == 2)
        {
            value = tmp[1];
        }
        [params setObject:value forKey:tmp[0]];
    }
    return [NSDictionary dictionaryWithDictionary:params];
}



@end
