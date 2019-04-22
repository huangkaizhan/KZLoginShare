//
//  BaseShareTool_lib.h
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/24.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareErrorModel_lib.h"
#import "ShareModel_lib.h"
#import "LoginUserInfoModel_lib.h"
#import "ShareLoginConfigModel_lib.h"

@interface BaseShareTool_lib : NSObject

/** 分享登录配置模型*/
@property (nonatomic, strong) ShareLoginConfigModel_lib *configModel;

#pragma mark - 分享
/** 分享信息*/
@property (nonatomic, strong) ShareModel_lib *shareModel;

#pragma mark - 初始化
/**
 初始化
 
 @param configModel 配置
 @return 分享工具
 */
- (instancetype)initWithConfigModel:(ShareLoginConfigModel_lib *)configModel;

#pragma mark - 登录

/** 登录类型*/
@property (nonatomic, assign) LoginType_lib loginType;

/**
 登录
 
 @param loginType 登录类型
 @param successBlock 成功回调
 @param faildBlock 失败回调
 */
- (void)loginWithType:(LoginType_lib)loginType successedBlock:(void(^)(LoginUserInfoModel_lib *userModel, LoginType_lib type))successBlock faildBlock:(void(^)(ShareErrorModel_lib *errorModel))faildBlock;

/**
 登录成功，给子类调用

 @param userModel 用户模型
 */
- (void)loginSuccessed:(LoginUserInfoModel_lib *)userModel;

/**
 登录错误
 
 @param msg 错误信息
 @param code 错误码
 */
- (void)loginError:(NSString *)msg code:(NSInteger)code;

#pragma mark - 分享
/**
 分享
 
 @param shareModel 数据模型
 @param jumpSuccessedBlock 跳转到第三方成功,并不代表用户有分享
 @param backAppSuccessedBlock 跳转到第三方后，再次从第三方跳转回来，通过openurl跳转，也不知道用户是否有分享出去
 @param faildBlock 失败回调
 */
- (void)shareWithModel:(ShareModel_lib *)shareModel jumpSuccessedBlock:(void(^)(ShareModel_lib *shareModel))jumpSuccessedBlock backAppSuccessedBlock:(void(^)(ShareModel_lib *shareModel))backAppSuccessedBlock faildBlock:(void(^)(ShareErrorModel_lib *errorModel))faildBlock;

/**
 分享跳转到第三方成功，给子类调用
 */
- (void)shareJumpSuccessed;

/**
 分享跳转回来成功
 */
- (void)shareBackSuccessed;

#pragma mark - 错误处理

/**
 分享错误
 
 @param msg 错误信息
 @param code 错误码
 */
- (void)shareError:(NSString *)msg code:(NSInteger)code;
@end
