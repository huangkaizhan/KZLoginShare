//
//  WXShareTool_lib.h
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/24.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseShareTool_lib.h"
#import "WXApi.h"
#import "WXApiObject.h"

/**
 微信分享
 */
@interface WXShareTool_lib : BaseShareTool_lib<WXApiDelegate>

@end
