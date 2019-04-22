//
//  LoginUserInfoModel_lib.h
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/25.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareLoginHeader_lib.h"

/**
 第三方登录成功用户信息数据
 */
@interface LoginUserInfoModel_lib : NSObject

/***  出生省份*/
@property (nonatomic, copy) NSString *birthProvince;
/***  出生城市*/
@property (nonatomic, copy) NSString *birthCity;
/***  用户名*/
@property (nonatomic, copy) NSString *userName;
/***  头像*/
@property (nonatomic, copy) NSString *avartar;
/***  性别 1 为男  0为女 */
@property (nonatomic, assign) BOOL gender;
/***  新浪：id  QQ：openid 微信：uid*/
@property (nonatomic, copy) NSString *uid;
/***  第三方返回accessToken*/
@property (nonatomic, copy) NSString *accessToken;

/** 元数据*/
@property (nonatomic, strong) NSDictionary *sourceData;

+ (instancetype)loginUserInfoWithLoginType:(LoginType_lib)loginType data:(NSDictionary *)data;
@end
