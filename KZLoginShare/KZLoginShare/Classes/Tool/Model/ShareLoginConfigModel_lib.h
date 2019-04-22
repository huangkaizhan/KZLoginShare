//
//  ShareLoginConfigModel_lib.h
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/25.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareLoginConfigModel_lib : NSObject

#pragma mark - 微信
/** 微信appkey*/
@property (nonatomic, copy) NSString *wxAppKey;

/** 微信秘钥*/
@property (nonatomic, copy) NSString *wxAppSecret;

/** 微信获取用户url*/
@property (nonatomic, copy) NSString *wxGetUserInfoUrl;

/** 微信获取token，openid的Url*/
@property (nonatomic, copy) NSString *wxGetTokenUrl;

/** 微信的url Schemes,对应info.plsit的url types*/
@property (nonatomic, copy) NSString *wxUrlSchemes;

#pragma mark - QQ
/** QQappid*/
@property (nonatomic, copy) NSString *qqAppId;
/** QQ秘钥*/
@property (nonatomic, copy) NSString *qqAppSecret;
/** QQ的url Schemes,对应info.plsit的url types*/
@property (nonatomic, copy) NSString *qqUrlSchemes;

/** 重定向url*/
@property (nonatomic, copy) NSString *redirectUrl;

@end
