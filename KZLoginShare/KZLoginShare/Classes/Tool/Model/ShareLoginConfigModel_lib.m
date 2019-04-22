//
//  ShareLoginConfigModel_lib.m
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/25.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import "ShareLoginConfigModel_lib.h"

@implementation ShareLoginConfigModel_lib

- (NSString *)wxUrlSchemes
{
    if (!_wxUrlSchemes) {
        _wxUrlSchemes = self.wxAppKey;
    }
    return _wxUrlSchemes;
}

@end
