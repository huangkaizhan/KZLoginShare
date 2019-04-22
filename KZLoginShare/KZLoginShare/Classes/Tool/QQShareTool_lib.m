//
//  QQShareTool_lib.m
//  MamaShare
//
//  Created by huang kaizhan on 2019/1/17.
//  Copyright © 2019年 Shengcheng. All rights reserved.
//

#import "QQShareTool_lib.h"

@interface QQShareTool_lib()<TencentSessionDelegate>

@end

@implementation QQShareTool_lib

- (instancetype)initWithConfigModel:(ShareLoginConfigModel_lib *)configModel
{
    if (self = [super initWithConfigModel:configModel]) {
        // 注册腾讯sdk
        self.tcOAuth = [[TencentOAuth alloc] initWithAppId:configModel.qqAppId andDelegate:self];
    }
    return self;
}
- (BOOL)qqInstalled
{
    return [TencentOAuth iphoneQQInstalled];
}

#pragma mark - QQ好友分享、QQ空间分享,QQ登录

// 登录成功
- (void)tencentDidLogin
{
    // 获取用户数据
    if(![self.tcOAuth getUserInfo]){
        // 获取失败
        [self loginError:nil code:NSNotFound];
    }
}
// 取消登录
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [self loginError:@"已取消登录" code:NSNotFound];
}

- (void)tencentDidNotNetWork
{
    // 登录失败
    [self loginError:@"网络不给力，请重新登录" code:NSNotFound];
}

#pragma TencentSessionDelegate

- (void)tencentDidLogout
{
    
}

- (void)responseDidReceived:(APIResponse*)response forMessage:(NSString *)message
{
    
}

//- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth
//                   withPermissions:(NSArray *)permissions
//{
//    // incrAuthWithPermissions是增量授权时需要调用的登录接口
//    // permissions是需要增量授权的权限列表
//    [tencentOAuth incrAuthWithPermissions:permissions];
//    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
//    // 否则可以返回YES
//}

// 获取QQ用户数据成功回调
- (void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSMutableDictionary * QQLoginInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
        [QQLoginInfo addEntriesFromDictionary:response.jsonResponse];
        [QQLoginInfo setObject:[self.tcOAuth openId] forKey:@"openid"];
        [QQLoginInfo setObject:[self.tcOAuth accessToken] forKey:@"accessToken"];
        // 登录成功
        LoginUserInfoModel_lib *userInfo = [LoginUserInfoModel_lib loginUserInfoWithLoginType:LoginTypeQQ_lib data:QQLoginInfo];
        [self loginSuccessed:userInfo];
    }
    else {
        // 登录失败
        [self loginError:nil code:response.retCode];
    }
}

// 处理来至QQ的请求
- (void)onReq:(id)req
{
    
}

// QQ空间，QQ好友分享成功后的回调
- (void)onResp:(id)resp
{
    if([resp isKindOfClass:[QQBaseResp class] ]){
        // QQ的api
        QQBaseResp *respQQ = (QQBaseResp *)resp;
        if(![respQQ.result isEqualToString:@"0"] || respQQ.errorDescription){
            // 分享失败
            NSString *errorMsg = respQQ.errorDescription ? respQQ.errorDescription : @"分享失败";
            [self shareError:errorMsg code:NSNotFound];
        } else {
            // 分享成功
            [self shareBackSuccessed];
        }
    }
}

#pragma mark - 分享
// QQ好友、QQ空间分享
- (void)shareWithModel:(ShareModel_lib *)shareModel jumpSuccessedBlock:(void (^)(ShareModel_lib *))jumpSuccessedBlock backAppSuccessedBlock:(void (^)(ShareModel_lib *))backAppSuccessedBlock faildBlock:(void (^)(ShareErrorModel_lib *))faildBlock
{
    [super shareWithModel:shareModel jumpSuccessedBlock:jumpSuccessedBlock backAppSuccessedBlock:backAppSuccessedBlock faildBlock:faildBlock];
    // 结果码
    QQApiSendResultCode sent = EQQAPISENDSUCESS;
    switch (self.shareModel.shareContentType) {
        case ShareContentTypeImage_lib:
            sent = [self shareImage];
            break;
        case ShareContentTypeText_lib:
            sent = [self shareText];
            break;
        case ShareContentTypeGif_lib:
            sent = [self shareGif];
            break;
        default:
            sent = [self shareNormal];
            break;
    }
    // 判断sent后的操作
    [self handleSendResult:sent];
}
// 普通分享
- (QQApiSendResultCode)shareNormal
{
    QQApiSendResultCode sent = EQQAPISENDSUCESS;
    // 1.图片数据
    NSData *data = UIImagePNGRepresentation(self.shareModel.image);
    // 2.分享模型对象
    QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.shareModel.url] title:self.shareModel.title description:self.shareModel.content previewImageData:data];
    // 3.分享操作,sent为连接是否成功，不是分享成功哦
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    if(self.shareModel.shareType == ShareTypeQQ_lib){
        // 唤起QQ
        sent = [QQApiInterface sendReq:req];
    }else{
        sent = [QQApiInterface SendReqToQZone:req];
        // 分享到qq空间标记
        [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    }
    return sent;
}
// 分享文本
- (QQApiSendResultCode)shareText
{
    QQApiSendResultCode sent = EQQAPISENDSUCESS;
    NSData *data = UIImagePNGRepresentation(self.shareModel.image);
    // 2.分享模型对象
    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.shareModel.url] title:self.shareModel.title description:self.shareModel.content previewImageData:data];
    // 3.分享操作,sent为连接是否成功，不是分享成功哦
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    if(self.shareModel.shareType == ShareTypeQQ_lib){
        // 唤起QQ
        sent = [QQApiInterface sendReq:req];
    }else{
        sent = [QQApiInterface SendReqToQZone:req];
        // 分享到qq空间标记
        [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    }
    return sent;
}
// 分享图片
- (QQApiSendResultCode)shareImage
{
    QQApiSendResultCode sent = EQQAPISENDSUCESS;
    // 1.图片数据
    NSData *imgData =  UIImageJPEGRepresentation(self.shareModel.image, 0.7);
    // 2.分享图片数据
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:imgData
                                                          title:self.shareModel.title
                                                   description :self.shareModel.description];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    if(self.shareModel.shareType == ShareTypeQQ_lib){
        // 唤起QQ
        sent = [QQApiInterface sendReq:req];
    }else{
        sent = [QQApiInterface SendReqToQZone:req];
        // 分享到qq空间标记
        [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    }
    return sent;
}
// 分享gif
- (QQApiSendResultCode)shareGif
{
    QQApiSendResultCode sent = EQQAPISENDSUCESS;
//    // 1.图片数据
//    NSData *imgData = nil;
//    YYImage *image = ((YYImage *)(self.item.image));
//    if ([image isKindOfClass:[YYImage class]]) {
//        imgData = image.animatedImageData;
//    } else {
//        imgData = UIImageJPEGRepresentation(image, 0.7);
//    }
//    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
//                                               previewImageData:imgData
//                                                          title:self.item.title
//                                                   description :self.item.description];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    return sent;
}

// 处理QQ在线状态的回调
- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

// qqApi分享前的回调
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            [self shareError:@"App未注册" code:NSNotFound];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            [self shareError:@"发送参数错误" code:NSNotFound];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            [self shareError:@"未安装QQ" code:NSNotFound];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            [self shareError:@"API接口不支持" code:NSNotFound];
            break;
        }
        case EQQAPISENDFAILD:
        {
            [self shareError:@"发送失败" code:NSNotFound];
            break;
        }
        default:
            break;
    }
}

@end
