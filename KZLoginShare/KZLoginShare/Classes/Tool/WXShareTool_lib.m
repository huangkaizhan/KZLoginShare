//
//  WXShareTool_lib.m
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/24.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import "WXShareTool_lib.h"
#import "LoginUserInfoModel_lib.h"

@interface WXShareTool_lib()

@end

@implementation WXShareTool_lib

- (instancetype)initWithConfigModel:(ShareLoginConfigModel_lib *)configModel
{
    if (self = [super initWithConfigModel:configModel]) {
        [WXApi registerApp:configModel.wxAppKey];
    }
    return self;
}

#pragma mark - 登录
- (void)loginWithType:(LoginType_lib)loginType successedBlock:(void (^)(LoginUserInfoModel_lib *, LoginType_lib))successBlock faildBlock:(void (^)(ShareErrorModel_lib *))faildBlock
{
    [super loginWithType:loginType successedBlock:successBlock faildBlock:faildBlock];
    if(![WXApi isWXAppInstalled]){
        [self loginError:@"手机未安装微信" code:NSNotFound];
        return;
    }
    if(![WXApi isWXAppSupportApi]){
        [self loginError:@"微信版本太低，暂不支持登录" code:NSNotFound];
        return;
    }
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"openapis";
    [WXApi sendReq:req];
}

#pragma mark - 分享
// 微信朋友圈、微信朋友列表分享
- (void)shareWithModel:(ShareModel_lib *)shareModel jumpSuccessedBlock:(void (^)(ShareModel_lib *))jumpSuccessedBlock backAppSuccessedBlock:(void (^)(ShareModel_lib *))backAppSuccessedBlock faildBlock:(void (^)(ShareErrorModel_lib *))faildBlock
{
    [super shareWithModel:shareModel jumpSuccessedBlock:jumpSuccessedBlock backAppSuccessedBlock:backAppSuccessedBlock faildBlock:faildBlock];
    if(![WXApi isWXAppInstalled]){
        [self shareError:@"手机未安装微信" code:NSNotFound];
        return;
    }
    if(![WXApi isWXAppSupportApi]){
        [self shareError:@"微信版本太低，暂不支持分享" code:NSNotFound];
        return;
    }
    OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
    req.url = @"https://www.baidu.com";
    [WXApi sendReq:req];
//    BOOL jumpResult = NO;
//    switch (self.shareModel.shareContentType) {
//        case ShareContentTypeImage_lib:
//            jumpResult = [self shareImage];
//            break;
//        case ShareContentTypeText_lib:
//            jumpResult = [self shareText];
//            break;
//        case ShareContentTypeMusic_lib:
//            jumpResult = [self shareMusic];
//            break;
//        case ShareContentTypeVideo_lib:
//            jumpResult = [self shareVideo];
//            break;
//        case ShareContentTypeMiniProgram_lib:
//            jumpResult = [self shareMiniProgram];
//            break;
//        case ShareContentTypeMiniProgramWake_lib:
//            jumpResult = [self wakeMiniProgram];
//            break;
//        default:
//            jumpResult = [self shareNormal];
//            break;
//    }
//    if (jumpResult) {
//        // 跳转成功
//        [self shareJumpSuccessed];
//    } else {
//        // 跳转失败
//        [self shareError:@"" code:NSNotFound];
//    }
}

// 唤起小程序
- (BOOL)wakeMiniProgram
{
    WXLaunchMiniProgramReq *obj = [WXLaunchMiniProgramReq object];
    obj.userName = self.shareModel.miniUserName;
    obj.path = self.shareModel.miniPath;
    obj.miniProgramType = WXMiniProgramTypeRelease;
    return [WXApi sendReq:obj];
}

// 分享小程序
- (BOOL)shareMiniProgram
{
    WXMiniProgramObject *obj = [WXMiniProgramObject object];
    obj.webpageUrl = self.shareModel.miniWebPageUrl;
    obj.userName = self.shareModel.miniUserName;
    obj.path = self.shareModel.miniPath;
    if (self.shareModel.miniHdImageData) {
        obj.hdImageData = self.shareModel.miniHdImageData;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareModel.title;
    message.description = self.shareModel.content;
    message.mediaObject = obj;
    //旧版本图片小于32k 新版本优先使用hdImageData,小于128k
    message.thumbData = nil;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.scene = WXSceneSession;
    return [WXApi sendReq:req];
}

// 分享图片
- (BOOL)shareImage
{
    // 分享图片
    WXMediaMessage  *message = [WXMediaMessage message];
    [message setThumbImage:[self imageScaledToMaxSize:self.shareModel.image maxSize:750]];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(self.shareModel.image, 0.8);
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = self.shareModel.shareType == ShareTypeWeiXinFriendList_lib ? WXSceneSession : WXSceneTimeline;
    return [WXApi sendReq:req];
}

// 分享文本
- (BOOL)shareText
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = YES;
    if (!self.shareModel.title.length) {
        req.text = self.shareModel.content;
    } else {
        req.text = self.shareModel.title;
    }
    req.scene = self.shareModel.shareType == ShareTypeWeiXinFriendList_lib ? WXSceneSession : WXSceneTimeline;
    return [WXApi sendReq:req];
}

// 分享视频
- (BOOL)shareVideo
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareModel.title;
    message.description = self.shareModel.content;
    if (self.shareModel.image) {
        [message setThumbImage:self.shareModel.image];
    }
    WXVideoObject *obj = [WXVideoObject object];
    obj.videoUrl = self.shareModel.videoUrl;
    obj.videoLowBandUrl = self.shareModel.videoUrl;
    message.mediaObject = obj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = self.shareModel.shareType == ShareTypeWeiXinFriendList_lib ? WXSceneSession : WXSceneTimeline;
    return [WXApi sendReq:req];
}

// 分享银屏
- (BOOL)shareMusic
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareModel.title;
    message.description = self.shareModel.content;
    if (self.shareModel.image) {
        [message setThumbImage:self.shareModel.image];
    }
    
    WXMusicObject *obj = [WXMusicObject object];
    if (self.shareModel.musicUrl.length) {
        obj.musicUrl = self.shareModel.musicUrl;
    }
    if (self.shareModel.musicDataUrl.length) {
        obj.musicDataUrl = self.shareModel.musicDataUrl;
    }
    message.mediaObject = obj;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = self.shareModel.shareType == ShareTypeWeiXinFriendList_lib ? WXSceneSession : WXSceneTimeline;
    return [WXApi sendReq:req];
}

// 普通分享
- (BOOL)shareNormal
{
    // 1.创建分享对象
    WXMediaMessage* msg = [WXMediaMessage message];
    // 1.1 分享文本
    msg.description = self.shareModel.content;
    // 1.2 分享标题
    msg.title = self.shareModel.title;
    msg.messageExt = self.shareModel.content;
    msg.messageAction = self.shareModel.content;
    // 1.3 设置图片
    NSData *imagedata = UIImageJPEGRepresentation(self.shareModel.image, 1);
    // 32K
    CGFloat imageMaxLength = 32 * 1024;
    
    if (self.shareModel.image) {
        if (imagedata.length < imageMaxLength) {
            [msg setThumbImage:self.shareModel.image];
        } else{
            UIImage *tempImge = [self getThubImage:self.shareModel.image];
            tempImge = [self imageWithOriginImage:tempImge scaledToMaxSize:tempImge.size.width * 0.9];
            [msg setThumbImage:tempImge];
        }
    }
    
    // 2.跳转网页对象
    WXWebpageObject *ext = [WXWebpageObject object];
    // 2.1 设置网页url
    ext.webpageUrl = self.shareModel.url;
    
    // 3. 设置分享对象的多媒体对象为网页
    msg.mediaObject = ext;
    
    // 4. 推送分享对象
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = msg;
    // 判断朋友圈圈分享还是好友分享
    req.scene = self.shareModel.shareType == ShareTypeWeiXinFriendList_lib ? WXSceneSession : WXSceneTimeline;
    return [WXApi sendReq:req];
}

///微信分享图片大小限制处理
- (UIImage *)getThubImage:(UIImage *)image{
    CGFloat maxImageData = 32 * 1024;
    UIImage *resultImage;
    resultImage = [self imageWithOriginImage:image scaledToMaxSize:image.size.width * 0.9];
    NSData *resultData = UIImageJPEGRepresentation(resultImage, 0.9);
    
    if (resultData.length < maxImageData) {
        return resultImage;
    }else{
        return [self getThubImage:resultImage];
    }
}

- (UIImage*)imageWithOriginImage:(UIImage *)originImage scaledToMaxSize:(CGFloat)maxSize
{
    if (!originImage) {
        return nil;
    }
    CGFloat newImageWidth;
    CGFloat newImageHeight;
    if (originImage.size.width > originImage.size.height) {
        newImageWidth = maxSize;
        newImageHeight = newImageWidth / originImage.size.width * originImage.size.height;
    }else {
        newImageHeight = maxSize;
        newImageWidth = newImageHeight / originImage.size.height * originImage.size.width;
    }
    CGSize newSize = CGSizeMake(newImageWidth, newImageHeight);
    
    // Create a graphics image context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    // new size
    [originImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

// 压缩图片尺寸
- (UIImage *)imageScaledToMaxSize:(UIImage *)image maxSize:(CGFloat)maxSize
{
    CGFloat newImageWidth;
    CGFloat newImageHeight;
    if (image.size.width > image.size.height) {
        newImageWidth = maxSize;
        newImageHeight = newImageWidth / image.size.width * image.size.height;
    } else {
        newImageHeight = maxSize;
        newImageWidth = newImageHeight / image.size.height * image.size.width;
    }
    CGSize newSize = CGSizeMake(newImageWidth, newImageHeight);
    
    // Create a graphics image context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

// 微信朋友圈，微信好友登录、分享成功后的回调
- (void)onResp:(id)resp
{
    // 微信的api
    BaseResp *respWX = (BaseResp *)resp;
    if([respWX isKindOfClass:[SendAuthResp class]]){
        if(respWX.errCode != 0 || respWX.errStr){
            // 登录失败
            NSString *errorMsg = respWX.errStr.length ? respWX.errStr : @"登录失败";
            [self loginError:errorMsg code:respWX.errCode];
        }else{
            // 开始授权登录
            [self startLoginWithSendAuthResp:(SendAuthResp *)resp];
        }
    }else{
        if(respWX.errCode != 0 || respWX.errStr){
            // 分享失败
            NSString *errorMsg = respWX.errStr ? respWX.errStr : @"分享失败";
            [self shareError:errorMsg code:respWX.errCode];
        }else{
            // 分享成功
            [self shareBackSuccessed];
        }
    }
}


/**
 *  开始授权登录
 *
 *  @param resp 授权响应对象
 */
- (void)startLoginWithSendAuthResp:(SendAuthResp *)resp
{
    NSString *urlString = [NSString stringWithFormat:@"%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code", self.configModel.wxGetTokenUrl,self.configModel.wxAppKey,self.configModel.wxAppSecret,resp.code];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"]){
                    //获取token错误
                    [self loginError:dict[@"errmsg"] code:[dict[@"errcode"] integerValue]];
                }else{
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                }
            }
        });
    });
}

/**
 *  获取用户数据
 *
 *  @param accessToken 授权token
 *  @param openId      授权openId
 */
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
{
    NSString *urlString =[NSString stringWithFormat:@"%@?access_token=%@&openid=%@", self.configModel.wxGetUserInfoUrl,accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"]){
                    //AccessToken失效
                    [self loginError:dict[@"errmsg"] code:[dict[@"errcode"] integerValue]];
                } else {
                    // 获取token
                    NSMutableDictionary *jsonMuDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
                    if(accessToken && accessToken.length > 0){
                        [jsonMuDictionary setObject:accessToken forKey:@"accessToken"];
                    }
                    LoginUserInfoModel_lib *user = [LoginUserInfoModel_lib loginUserInfoWithLoginType:LoginTypeWeiXin_lib data:jsonMuDictionary];
                    [self loginSuccessed:user];
                }
            }
        });
    });
}

@end
