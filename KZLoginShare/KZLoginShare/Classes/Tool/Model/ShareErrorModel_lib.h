//
//  ShareErrorModel_lib.h
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/24.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareErrorModel_lib : NSObject

/** 错误信息*/
@property (nonatomic, copy) NSString *errorMsg;

/** 错误码*/
@property (nonatomic, assign) NSInteger code;

@end
