//
//  ShareModel_lib.h
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/24.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShareLoginHeader_lib.h"

@interface ShareModel_lib : NSObject

/** 分享类型*/
@property (nonatomic, assign) ShareType_lib shareType;

/** 分享子类型，内容类型*/
@property (nonatomic, assign) ShareContentType_lib shareContentType;

/** 分享图片*/
@property (nonatomic, strong) UIImage *image;

/** 标题*/
@property (nonatomic, copy) NSString *title;

/** 内容*/
@property (nonatomic, copy) NSString *content;

/** 网页链接*/
@property (nonatomic, copy) NSString *url;

#pragma mark - 音乐
/** 音乐url*/
@property (nonatomic, copy) NSString *musicUrl;
/** 音乐数据url地址,长度不能超过10K*/
@property (nonatomic, copy) NSString *musicDataUrl;

#pragma mark - 小程序
/** 低版本网页链接*/
@property (nonatomic, copy) NSString *miniWebPageUrl;
/** 小程序username*/
@property (nonatomic, copy) NSString *miniUserName;
/** 小程序页面的路径*/
@property (nonatomic, copy) NSString *miniPath;
/** 小程序新版本的预览图 128k*/
@property (nonatomic, strong) NSData *miniHdImageData;

#pragma mark - 视频
/** 视频链接*/
@property (nonatomic, copy) NSString *videoUrl;

@end
