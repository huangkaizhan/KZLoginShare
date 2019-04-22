//
//  ShareLoginHeader_lib.h
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/25.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#ifndef ShareLoginHeader_lib_h
#define ShareLoginHeader_lib_h

typedef enum{
    ShareTypeQQ_lib, // QQ分享
    ShareTypeQQZone_lib, // QQ空间分享
    ShareTypeWeiXinFriendQuan_lib, // 微信朋友圈分享
    ShareTypeWeiXinFriendList_lib, // 微信朋友列表分享
    ShareTypeSina_lib, // 新浪微博分享
}ShareType_lib;

typedef enum
{
    ShareContentTypeNormal_lib,  // 普通分享类型
    ShareContentTypeImage_lib,   // 图片分享类型
    ShareContentTypeText_lib,    // 文本分享类型
    ShareContentTypeGif_lib,      // gif表情包类型
    ShareContentTypeMiniProgram_lib,       // 小程序分享类型
    ShareContentTypeMiniProgramWake_lib,    // 唤起小程序
    ShareContentTypeMusic_lib,          // 音频分享类型
    ShareContentTypeVideo_lib,          // 视频分享类型
}ShareContentType_lib;

typedef enum{
    LoginTypeQQ_lib = 0, // QQ登录
    LoginTypeWeiXin_lib = 1, // 微信登录
    LoginTypeSina_lib = 2, // 新浪登录
}LoginType_lib;

#endif /* ShareLoginHeader_lib_h */
