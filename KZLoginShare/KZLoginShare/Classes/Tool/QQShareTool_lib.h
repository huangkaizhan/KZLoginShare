//
//  QQShareTool_lib.h
//  MamaShare
//
//  Created by huang kaizhan on 2019/1/17.
//  Copyright © 2019年 Shengcheng. All rights reserved.
//

#import "BaseShareTool_lib.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"

@interface QQShareTool_lib : BaseShareTool_lib
/***  qqApi*/
@property (nonatomic , strong) TencentOAuth *tcOAuth;
/** 是否安装了QQ*/
@property (nonatomic, assign) BOOL qqInstalled;
@end
