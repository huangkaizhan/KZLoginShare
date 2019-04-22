//
//  ShareTool_lib.h
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/24.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareLoginHeader_lib.h"
#import "ShareLoginConfigModel_lib.h"
#import "ShareModel_lib.h"
#import "LoginUserInfoModel_lib.h"
#import "ShareErrorModel_lib.h"

@interface ShareTool_lib : NSObject

/**
 初始化

 @return 分享工具
 */
+ (instancetype)shareTool;

/**
 初始化
 
 @param configModel 配置
 */
- (void)setupWithConfigModel:(ShareLoginConfigModel_lib *)configModel;

/**
 登录
 
 @param loginType 登录类型
 */
- (void)loginWithType:(LoginType_lib)loginType successedBlock:(void(^)(LoginUserInfoModel_lib *userModel, LoginType_lib type))successBlock faildBlock:(void(^)(ShareErrorModel_lib *errorModel))faildBlock;

/**
 分享
 
 @param shareModel 数据模型
 @param jumpSuccessedBlock 跳转到第三方成功,并不代表用户有分享
 @param backAppSuccessedBlock 跳转到第三方后，再次从第三方跳转回来，通过openurl跳转，也不知道用户是否有分享出去
 @param faildBlock 失败回调
 */
- (void)shareWithModel:(ShareModel_lib *)shareModel jumpSuccessedBlock:(void(^)(ShareModel_lib *shareModel))jumpSuccessedBlock backAppSuccessedBlock:(void(^)(ShareModel_lib *shareModel))backAppSuccessedBlock faildBlock:(void(^)(ShareErrorModel_lib *errorModel))faildBlock;

/**
 url回调，app openurl

 @param url url
 @return 是否回调成功
 */
- (BOOL)handleLoginShareUrl:(NSURL *)url;
@end
