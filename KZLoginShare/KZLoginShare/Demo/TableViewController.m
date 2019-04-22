//
//  TableViewController.m
//  MamaShare
//
//  Created by huang kaizhan on 2019/1/18.
//  Copyright © 2019年 Shengcheng. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
/** 微信*/
@property (nonatomic, strong) NSArray *weichatArray;
/** */
@property (nonatomic, strong) NSArray *qqArray;
/** 新浪*/
@property (nonatomic, strong) NSArray *sinaArray;
/** 数据源*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 懒加载
- (NSArray *)dataArray
{
    if (!_dataArray) {
        switch (self.type) {
            case SDKTypeWeiChat:
                _dataArray = self.weichatArray;
                break;
            case SDKTypeQQ:
                _dataArray = self.qqArray;
                break;
            default:
                _dataArray = self.sinaArray;
                break;
        }
    }
    return _dataArray;
}

- (NSArray *)qqArray
{
    if (!_qqArray) {
        _qqArray = @[@"登录", @"普通分享", @"分享文本", @"分享图片", @"分享gif"];
    }
    return _qqArray;
}

- (NSArray *)weichatArray
{
    if (!_weichatArray) {
        _weichatArray = @[@"登录", @"普通分享", @"分享文本", @"分享图片", @"分享gif", @"分享音乐", @"分享视频", @"分享小程序", @"调起小程序"];
    }
    return _weichatArray;
}

- (NSArray *)sinaArray
{
    if (!_sinaArray) {
        _sinaArray = @[@"登录", @"普通分享", @"分享文本", @"分享图片"];
    }
    return _sinaArray;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.dataArray[indexPath.row];
    switch (self.type) {
        case SDKTypeWeiChat:
        {
            if ([text isEqualToString:@"登录"]) {
                [self weixinLogin];
                return;
            }
            __weak typeof (self) weakSelf = self;
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf shareWeiXinWithText:text shareType:ShareTypeWeiXinFriendQuan_lib];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"朋友列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf shareWeiXinWithText:text shareType:ShareTypeWeiXinFriendList_lib];
            }];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
            [alertVC addAction:action1];
            [alertVC addAction:action2];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 微信
- (void)weixinLogin
{
    [[ShareTool_lib shareTool] loginWithType:LoginTypeWeiXin_lib successedBlock:^(LoginUserInfoModel_lib *userModel, LoginType_lib type) {
        NSLog(@"userModel = %@", userModel);
    } faildBlock:^(ShareErrorModel_lib *errorModel) {
        NSLog(@"error = %@", errorModel.errorMsg);
    }];
}
// 分享到微信
- (void)shareWeiXinWithText:(NSString *)text shareType:(ShareType_lib)shareType
{
    if ([text isEqualToString:@"普通分享"]) {
        [self weixinShareNormalWithType:shareType];
    } else if ([text isEqualToString:@"分享文本"]) {
        [self weixinShareTextWithType:shareType];
    } else if ([text isEqualToString:@"分享图片"]) {
        [self weixinShareImageWithType:shareType];
    } else if ([text isEqualToString:@"分享gif"]) {
        
    } else if ([text isEqualToString:@"分享音乐"]) {
        [self weixinShareMusicWithType:shareType];
    }
}
// 普通分享
- (void)weixinShareNormalWithType:(ShareType_lib)shareType
{
    ShareModel_lib *model = [[ShareModel_lib alloc] init];
    model.url = @"http://www.baidu.com";
    model.shareType = shareType;
    model.image = [UIImage imageNamed:@"timg"];
    model.content = @"我就试试看~";
    model.shareContentType = ShareContentTypeNormal_lib;// 默认
    [[ShareTool_lib shareTool] shareWithModel:model jumpSuccessedBlock:^(ShareModel_lib *shareModel) {
        NSLog(@"分享跳转到第三方成功");
    } backAppSuccessedBlock:^(ShareModel_lib *shareModel) {
        NSLog(@"成功跳转回来");
    } faildBlock:^(ShareErrorModel_lib *errorModel) {
        NSLog(@"分享失败 = %@", errorModel.errorMsg);
    }];
}
// 分享图文
- (void)weixinShareTextWithType:(ShareType_lib)shareType
{
    ShareModel_lib *model = [[ShareModel_lib alloc] init];
    model.shareType = shareType;
    model.content = @"我就试试看~";
    model.shareContentType = ShareContentTypeText_lib;
    [[ShareTool_lib shareTool] shareWithModel:model jumpSuccessedBlock:^(ShareModel_lib *shareModel) {
        NSLog(@"分享跳转到第三方成功");
    } backAppSuccessedBlock:^(ShareModel_lib *shareModel) {
        NSLog(@"成功跳转回来");
    } faildBlock:^(ShareErrorModel_lib *errorModel) {
        NSLog(@"分享失败 = %@", errorModel.errorMsg);
    }];
}
// 分享图片
- (void)weixinShareImageWithType:(ShareType_lib)shareType
{
    ShareModel_lib *model = [[ShareModel_lib alloc] init];
    model.shareType = shareType;
    model.content = @"我就试试看~";
    model.shareContentType = ShareContentTypeImage_lib;
    model.image = [UIImage imageNamed:@"timg"];
    [[ShareTool_lib shareTool] shareWithModel:model jumpSuccessedBlock:^(ShareModel_lib *shareModel) {
        NSLog(@"分享跳转到第三方成功");
    } backAppSuccessedBlock:^(ShareModel_lib *shareModel) {
        NSLog(@"成功跳转回来");
    } faildBlock:^(ShareErrorModel_lib *errorModel) {
        NSLog(@"分享失败 = %@", errorModel.errorMsg);
    }];
}
// 分享音乐
- (void)weixinShareMusicWithType:(ShareType_lib)shareType
{
    
}
@end
