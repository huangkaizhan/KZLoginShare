//
//  BaseShareTool_lib.m
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/24.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import "BaseShareTool_lib.h"

@interface BaseShareTool_lib()
/** 登录成功*/
@property (nonatomic, copy) void(^loginSuccessd)(LoginUserInfoModel_lib *userModel, LoginType_lib type);
/** 登录失败*/
@property (nonatomic, copy) void(^loginFaild)(ShareErrorModel_lib *errorModel);

/** 分享成功*/
@property (nonatomic, copy) void(^jumpSuccessedBlock)(ShareModel_lib *model);
/** 分享成功*/
@property (nonatomic, copy) void(^backAppSuccessedBlock)(ShareModel_lib *model);
/** 分享失败*/
@property (nonatomic, copy) void(^shareFaild)(ShareErrorModel_lib *errorModel);
@end

@implementation BaseShareTool_lib

- (instancetype)initWithConfigModel:(ShareLoginConfigModel_lib *)configModel
{
    if (self = [super init]) {
        self.configModel = configModel;
    }
    return self;
}

- (void)loginWithType:(LoginType_lib)loginType successedBlock:(void (^)(LoginUserInfoModel_lib *, LoginType_lib))successBlock faildBlock:(void (^)(ShareErrorModel_lib *))faildBlock
{
    _loginType = loginType;
    self.loginSuccessd = successBlock;
    self.loginFaild = faildBlock;
}

// 登录成功，给子类调用
- (void)loginSuccessed:(LoginUserInfoModel_lib *)userModel
{
    if (self.loginSuccessd) {
        self.loginSuccessd(userModel, self.loginType);
    }
}
// 登录失败，给子类调用
- (void)loginError:(NSString *)msg code:(NSInteger)code
{
    if (self.loginFaild) {
        ShareErrorModel_lib *errorModel = [[ShareErrorModel_lib alloc] init];
        if (![msg isKindOfClass:[NSString class]]) {
            errorModel.errorMsg = @"登录失败";;
        } else {
            errorModel.errorMsg = msg.length ? msg : @"登录失败";;
        }
        errorModel.code = code;
        self.loginFaild(errorModel);
    }
}

#pragma mark - 分享
// 分享
- (void)shareWithModel:(ShareModel_lib *)shareModel jumpSuccessedBlock:(void(^)(ShareModel_lib *shareModel))jumpSuccessedBlock backAppSuccessedBlock:(void(^)(ShareModel_lib *shareModel))backAppSuccessedBlock faildBlock:(void(^)(ShareErrorModel_lib *errorModel))faildBlock;
{
    _shareModel = shareModel;
    self.jumpSuccessedBlock = jumpSuccessedBlock;
    self.shareFaild = faildBlock;
    self.backAppSuccessedBlock = backAppSuccessedBlock;
}
// 分享成功
- (void)shareJumpSuccessed
{
    if (self.jumpSuccessedBlock) {
        self.jumpSuccessedBlock(self.shareModel);
    }
}
// 分享跳转回来成功
- (void)shareBackSuccessed
{
    if (self.backAppSuccessedBlock) {
        self.backAppSuccessedBlock(self.shareModel);
    }
}
// 分享失败
- (void)shareError:(NSString *)msg code:(NSInteger)code
{
    if (self.shareFaild) {
        ShareErrorModel_lib *errorModel = [[ShareErrorModel_lib alloc] init];
        errorModel.errorMsg = msg.length ? msg : @"分享失败";;
        errorModel.code = code;
        self.shareFaild(errorModel);
    }
}
@end
