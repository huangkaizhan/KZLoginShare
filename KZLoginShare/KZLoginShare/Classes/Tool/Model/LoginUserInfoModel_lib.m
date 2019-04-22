//
//  LoginUserInfoModel_lib.m
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/25.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import "LoginUserInfoModel_lib.h"

@implementation LoginUserInfoModel_lib

+ (instancetype)loginUserInfoWithLoginType:(LoginType_lib)loginType data:(NSDictionary *)data
{
    LoginUserInfoModel_lib *user = [[LoginUserInfoModel_lib alloc] init];
    user.sourceData = data;
    switch (loginType) {
        case LoginTypeQQ_lib: // QQ登录
        {
            /*
             is_lost = 0;
             figureurl = http://qzapp.qlogo.cn/qzapp/1104599224/FF7BB0DEF5AE94AF1999059E2EDF0E43/30;
             vip = 0;
             accessToken = 472208C5E2952761AB3A69BC30C0FB31;
             is_yellow_year_vip = 0;
             is_yellow_vip = 0;
             ret = 0;
             province = 广东;
             figureurl_qq_1 = http://q.qlogo.cn/qqapp/1104599224/FF7BB0DEF5AE94AF1999059E2EDF0E43/40;
             yellow_vip_level = 0;
             level = 0;
             openid = FF7BB0DEF5AE94AF1999059E2EDF0E43;
             figureurl_1 = http://qzapp.qlogo.cn/qzapp/1104599224/FF7BB0DEF5AE94AF1999059E2EDF0E43/50;
             city = 广州;
             figureurl_2 = http://qzapp.qlogo.cn/qzapp/1104599224/FF7BB0DEF5AE94AF1999059E2EDF0E43/100;
             nickname = 还远远;
             msg = ;
             gender = 男;
             figureurl_qq_2 = http://q.qlogo.cn/qqapp/1104599224/FF7BB0DEF5AE94AF1999059E2EDF0E43/100;
             */
            
            user.userName = [data objectForKey:@"nickname"];
            // 性别：1 为男  0为女
            user.gender = [[data objectForKey:@"gender"] isEqualToString:@"男"];
            user.birthCity = [data objectForKey:@"city"];
            user.birthProvince = [data objectForKey:@"province"];
            // 头像
            user.avartar = [data objectForKey:@"figureurl_qq_2"];
            // openid
            user.uid = [data objectForKey:@"openid"];
            // accessToken
            user.accessToken = [data objectForKey:@"accessToken"];
        }
            break;
        case LoginTypeWeiXin_lib: // 微信
        {
            /*
             29      city = ****;
             30      country = CN;
             31      headimgurl = "http://wx.qlogo.cn/mmopen/q9UTH59ty0K1PRvIQkyydYMia4xN3gib2m2FGh0tiaMZrPS9t4yPJFKedOt5gDFUvM6GusdNGWOJVEqGcSsZjdQGKYm9gr60hibd/0";
             32      language = "zh_CN";
             33      nickname = “****";
             34      openid = oo*********;
             35      privilege =     (
             36      );
             37      province = *****;
             38      sex = 1;
             39      unionid = “o7VbZjg***JrExs";
             40      */
            /*
             43      错误代码
             44      errcode = 42001;
             45      errmsg = "access_token expired";
             46      */
            
            user.userName = [data objectForKey:@"nickname"];
            // 性别：1 为男  0为女
            user.gender = [[data objectForKey:@"sex"] boolValue];
            user.birthCity = [data objectForKey:@"city"];
            user.birthProvince = [data objectForKey:@"province"];
            // 头像
            user.avartar = [data objectForKey:@"headimgurl"];
            // openid
            user.uid = [data objectForKey:@"openid"];
            // accessToken
            user.accessToken = [data objectForKey:@"accessToken"];
        }
            break;
        case LoginTypeSina_lib: // 新浪
        {
            // 昵称
            user.userName = [data objectForKey:@"screen_name"];
            // 出生省份城市
            NSString *location = [data objectForKey:@"location"];
            if(location && ![location isEqualToString:@""]){
                NSArray *locationArr = [location componentsSeparatedByString:@" "];
                if(locationArr.count > 0 && locationArr.count < 3){
                    user.birthCity = [locationArr objectAtIndex:1];
                    user.birthProvince = locationArr.firstObject;
                }
            }
            // 性别：1 为男  0为女
            user.gender = [[data objectForKey:@"gender"] isEqualToString:@"m"] ? 1 : 0;
            // 头像
            user.avartar = [data objectForKey:@"profile_image_url"];
            // id
            user.uid = [data objectForKey:@"id"];
            // accessToken
            user.accessToken = [data objectForKey:@"accessToken"];
        }
            break;
    }
    return user;
}
@end
