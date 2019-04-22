//
//  ShareTool_lib.m
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/24.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import "ShareTool_lib.h"
#import "WXShareTool_lib.h"

@interface ShareTool_lib()
/** 配置*/
@property (nonatomic, strong) ShareLoginConfigModel_lib *configModel;
/** 微信*/
@property (nonatomic, strong) WXShareTool_lib *wxLoginShareTool;
@end

@implementation ShareTool_lib

/**
 初始化
 
 @return 分享工具
 */
+ (instancetype)shareTool
{
    // 单例对象
    static ShareTool_lib *shareApi = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareApi = [[ShareTool_lib alloc] init];
        
//        // 注册腾讯sdk
//        shareApi.tcOAuth = [[TencentOAuth alloc] initWithAppId:TencentAppKey andDelegate:shareApi];
//        // 注册新浪sdk
//        [WeiboSDK registerApp:SinaAppKey];
    });
    return shareApi;
}

- (void)setupWithConfigModel:(ShareLoginConfigModel_lib *)configModel
{
    _configModel = configModel;
}

/**
 登录
 
 @param loginType 登录类型
 */
- (void)loginWithType:(LoginType_lib)loginType successedBlock:(void (^)(LoginUserInfoModel_lib *, LoginType_lib))successBlock faildBlock:(void (^)(ShareErrorModel_lib *))faildBlock
{
    switch (loginType) {
        case LoginTypeWeiXin_lib:
            [self.wxLoginShareTool loginWithType:loginType successedBlock:successBlock faildBlock:faildBlock];
            break;
            
        default:
            break;
    }
}

/**
 分享
 
 @param shareModel 数据模型
 @param jumpSuccessedBlock 跳转到第三方成功
 @param faildBlock 失败回调
 */
- (void)shareWithModel:(ShareModel_lib *)shareModel jumpSuccessedBlock:(void(^)(ShareModel_lib *shareModel))jumpSuccessedBlock backAppSuccessedBlock:(void(^)(ShareModel_lib *shareModel))backAppSuccessedBlock faildBlock:(void(^)(ShareErrorModel_lib *errorModel))faildBlock
{
    switch (shareModel.shareType) {
            // 微信分享
        case ShareTypeWeiXinFriendList_lib:
        case ShareTypeWeiXinFriendQuan_lib:
            [self.wxLoginShareTool shareWithModel:shareModel jumpSuccessedBlock:jumpSuccessedBlock backAppSuccessedBlock:backAppSuccessedBlock faildBlock:faildBlock];
            break;
        default:
            break;
    }
    
}

#pragma mark - 懒加载
// 微信
- (WXShareTool_lib *)wxLoginShareTool
{
    if (!_wxLoginShareTool) {
        _wxLoginShareTool = [[WXShareTool_lib alloc] initWithConfigModel:self.configModel];
    }
    return _wxLoginShareTool;
}

- (BOOL)handleLoginShareUrl:(NSURL *)url
{
    // 微信
    if ([url.absoluteString hasPrefix:self.configModel.wxUrlSchemes]) {
        return [WXApi handleOpenURL:url delegate:self.wxLoginShareTool];
    }
//    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[QQAp
//                                                                         iShareEntry class]];
//    if (YES == [TencentOAuth CanHandleOpenURL:url])
//    {
//        return [TencentOAuth HandleOpenURL:url];
//    }
    return NO;
}
@end
