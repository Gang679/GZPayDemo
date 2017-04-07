//
//  GZShareManage.m
//  GZPayDemo
//
//  Created by xinshijie on 2017/4/6.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//


#import "GZShareManage.h"
#import <UShareUI/UShareUI.h>


#define GZUMSocialData     [UMSocialManager defaultManager]
#define GZUMSocialConfig  [UMSocialShareUIConfig shareInstance]


@interface GZShareManage()

@property (nonatomic, strong) UMSocialUserInfoResponse *responseDic;

@property (nonatomic, strong) GZURLSessionTask  *TaskTask;

@end


@implementation GZShareManage

static GZShareManage *shareManage;

+ (GZShareManage *)shareManage
{
    static GZShareManage *gz_shareManage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gz_shareManage = [[GZShareManage alloc] init];
    });
    return gz_shareManage;
}
#pragma mark - 判断平台是否安装
- (BOOL)gz_UMSocialIsInstall:(UMSocialPlatformType)platformType
{
    return [GZUMSocialData isInstall:platformType];
}

#pragma mark - share type
#pragma mark 分享纯文本
- (void)gz_shareTextToPlatformType:(UMSocialPlatformType)platformType
                         shareText:(NSString *)shareText
                    viewController:(UIViewController *)viewController
{
    /*! 创建分享消息对象 */
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    /*! 设置文本 */
    messageObject.text = shareText;
    
    /*! 调用分享接口 */
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                /*! 分享结果消息 */
                UMSocialLogInfo(@"response message is %@",resp.message);
                /*! 第三方原始返回的数据 */
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

#pragma mark 分享纯图片
- (void)gz_shareImageToPlatformType:(UMSocialPlatformType)platformType
                         thumbImage:(NSString *)thumbImage
                           bigImage:(NSString *)bigImage
                     viewController:(UIViewController *)viewController
{
    /*! 创建分享消息对象 */
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    /*! 创建图片内容对象 */
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    /*! 如果有缩略图，则设置缩略图本地 */
    shareObject.thumbImage = [UIImage imageNamed:thumbImage];
    
    [shareObject setShareImage:[UIImage imageNamed:bigImage]];
    
    /*! 设置Pinterest参数 */
    if (platformType == UMSocialPlatformType_Pinterest) {
        [self setPinterstInfo:messageObject];
    }
    
    /*! 设置Kakao参数 */
    if (platformType == UMSocialPlatformType_KakaoTalk) {
        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    }
    
    /*! 分享消息对象设置分享内容对象 */
    messageObject.shareObject = shareObject;
    
    /*! 调用分享接口 */
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                /*! 分享结果消息 */
                UMSocialLogInfo(@"response message is %@",resp.message);
                /*! 第三方原始返回的数据 */
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

#pragma mark 分享网络图片
- (void)gz_shareImageURLToPlatformType:(UMSocialPlatformType)platformType
                            thumbImage:(NSString *)thumbImage
                              imageUrl:(NSString *)imageUrl
                        viewController:(UIViewController *)viewController
{
    /*! 创建分享消息对象 */
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    /*! 创建图片内容对象 */
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    /*! 如果有缩略图，则设置缩略图，此处为 URL */
    //    shareObject.thumbImage = thumbImage;
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [shareObject setShareImage:image];
        
        /*! 设置Pinterest参数 */
        if (platformType == UMSocialPlatformType_Pinterest) {
            [self setPinterstInfo:messageObject];
        }
        
        /*! 设置Kakao参数 */
        if (platformType == UMSocialPlatformType_KakaoTalk) {
            messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
        }
        
        /*! 分享消息对象设置分享内容对象 */
        messageObject.shareObject = shareObject;
        
        /*! 调用分享接口 */
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    /*! 分享结果消息 */
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    /*! 第三方原始返回的数据 */
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            [self alertWithError:error];
        }];
        
    }];
    
}

#pragma mark 网页分享
- (void)gz_shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                                title:(NSString *)title
                            shareText:(NSString *)shareText
                             imageUrl:(NSString *)imageUrl
                           webpageUrl:(NSString *)webpageUrl
                       viewController:(UIViewController *)viewController
{
    /*! 创建分享消息对象 */
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    GZWeakSelf;
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        /*! 创建网页内容对象 */
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:shareText thumImage:image];
        /*! 设置网页地址 */
        shareObject.webpageUrl = webpageUrl;
        
        /*! 分享消息对象设置分享内容对象 */
        messageObject.shareObject = shareObject;
        
        /*! 调用分享接口 */
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    /*! 分享结果消息 */
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    /*! 第三方原始返回的数据 */
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            [weakSelf alertWithError:error];
        }];
        
    }];
}

#pragma mark 分享图片和文字
- (void)gz_shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
                                 shareText:(NSString *)shareText
                                thumbImage:(NSString *)thumbImage
                                  imageUrl:(NSString *)imageUrl
                            viewController:(UIViewController *)viewController

{
    /*! 创建分享消息对象 */
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    /*! 设置文本 */
    messageObject.text = shareText;
    
    /*! 创建图片内容对象 */
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    /*! 如果有缩略图，则设置缩略图 */
    //    if (platformType == UMSocialPlatformType_Linkedin) {
    //        /*! linkedin仅支持URL图片 */
    ////        shareObject.thumbImage = thumbImage;
    //        [shareObject setShareImage:imageUrl];
    //    } else {
    /*! 这里设置默认图片 */
    //        shareObject.thumbImage = [UIImage imageNamed:@"icon2.jpg"];
    GZWeakSelf;
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        shareObject.shareImage = image;
        
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    /*! 分享结果消息 */
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    /*! 第三方原始返回的数据 */
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            [weakSelf alertWithError:error];
        }];
        
    }];
    
}

#pragma mark 音乐分享
- (void)gz_shareMusicToPlatformType:(UMSocialPlatformType)platformType
                              title:(NSString *)title
                          shareText:(NSString *)shareText
                           imageUrl:(NSString *)imageUrl
                           musicUrl:(NSString *)musicUrl
                       musicDataUrl:(NSString *)musicDataUrl
                     viewController:(UIViewController *)viewController
{
    /*! 创建分享消息对象 */
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    /*! 创建音乐内容对象 */
    UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:shareText thumImage:imageUrl];
    /*! 设置音乐网页播放地址 */
    shareObject.musicUrl = musicUrl;
    shareObject.musicDataUrl = musicDataUrl;
    /*! 分享消息对象设置分享内容对象 */
    messageObject.shareObject = shareObject;
    
    /*! 调用分享接口 */
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                /*! 分享结果消息 */
                UMSocialLogInfo(@"response message is %@",resp.message);
                /*! 第三方原始返回的数据 */
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
    
}

#pragma mark 视频分享
- (void)gz_shareVedioToPlatformType:(UMSocialPlatformType)platformType
                              title:(NSString *)title
                          shareText:(NSString *)shareText
                           imageUrl:(NSString *)imageUrl
                           videoUrl:(NSString *)videoUrl
                     viewController:(UIViewController *)viewController
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:shareText thumImage:imageUrl];
    /*! 设置视频网页播放地址 */
    shareObject.videoUrl = videoUrl;
    
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                /*! 分享结果消息 */
                UMSocialLogInfo(@"response message is %@",resp.message);
                /*! 第三方原始返回的数据 */
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

#pragma mark gif 动图分享
- (void)gz_shareEmoticonToPlatformType:(UMSocialPlatformType)platformType
                                 title:(NSString *)title
                             shareText:(NSString *)shareText
                              imageUrl:(NSString *)imageUrl
                           gifFilePath:(NSString *)gifFilePath
                        viewController:(UIViewController *)viewController
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    GZWeakSelf;
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UMShareEmotionObject *shareObject = [UMShareEmotionObject shareObjectWithTitle:title descr:shareText thumImage:image];
        
        //        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gif3" ofType:@"gif"];
        NSData *emoticonData = [NSData dataWithContentsOfFile:gifFilePath];
        shareObject.emotionData = emoticonData;
        
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    /*! 分享结果消息 */
                    NSLog(@"response message is %@",resp.message);
                    /*! 第三方原始返回的数据 */
                    NSLog(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    NSLog(@"response data is %@",data);
                }
            }
            [weakSelf alertWithError:error];
        }];
    }];
}

#pragma mark 文件分享
- (void)gz_shareFileToPlatformType:(UMSocialPlatformType)platformType
                             title:(NSString *)title
                         shareText:(NSString *)shareText
                          imageUrl:(NSString *)imageUrl
                      fileFilePath:(NSString *)fileFilePath
                 fileFileExtension:(NSString *)fileFileExtension
                    viewController:(UIViewController *)viewController
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareFileObject *shareObject = [UMShareFileObject shareObjectWithTitle:title descr:shareText thumImage:imageUrl];
    
    NSString *kFileExtension = fileFileExtension;
    //    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"umengFile"
    //                                                         ofType:kFileExtension];
    NSData *fileData = [NSData dataWithContentsOfFile:fileFilePath];
    shareObject.fileData = fileData;
    shareObject.fileExtension = kFileExtension;
    
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                /*! 分享结果消息 */
                NSLog(@"response message is %@",resp.message);
                /*! 第三方原始返回的数据 */
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
    
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"刚子分享demo"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    if ([result isEqualToString:@"分享成功"]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *url = @"http://www.88meichou.com/api/user/getUserShare.php";
        NSDictionary *parma = @{@"user_id":@"836"
                                        };
        self.TaskTask = [GZNetManager gz_requestWithType:GZHttpRequestTypeGet withUrlString:url withParameters:parma withSuccessBlock:^(id response) {
                } withFailureBlock:^(NSError *error) {
                } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                }];
    }
    [alert show];
}

- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj
{
    messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
                            @"app_name": @"U-Share",
                            @"suggested_board_name": @"UShareProduce",
                            @"description": @"U-Share: best social bridge"};
}


- (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

#pragma mark - 友盟分享
#pragma mark 注册友盟分享微信
- (void)gz_setupShareConfig
{
    [GZUMSocialData setUmSocialAppkey:GZUmengAppkey];
    /*! 打开调试log的开关 */
    [GZUMSocialData openLog:YES];
    
    /*! 获取友盟social版本号 */
//    NSLog(@"获取友盟social版本号: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    /*! 如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向 */
    //    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
    
    /*! 苹果审核要求,隐藏未安装的应用 的分享选项 */
    //    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToSina, UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    /*! 设置新浪的appKey和appSecret */
    [GZUMSocialData setPlaform:UMSocialPlatformType_Sina
                           appKey:GZSinaAppKey
                        appSecret:GZSinaAppSecret
                      redirectURL:@"http://sns.whalecloud.com/sin"];
    
    /*! 设置微信的appKey和appSecret */
    [GZUMSocialData setPlaform:UMSocialPlatformType_WechatSession
                           appKey:GZWX_APP_KEY
                        appSecret:GZWX_APP_SECRET
                      redirectURL:@"https://github.com/Gang679"];
    
    /*! 设置分享到QQ互联的 appID */
    [GZUMSocialData setPlaform:UMSocialPlatformType_QQ
                           appKey:GZQQAppID
                        appSecret:nil
                      redirectURL:@"https://github.com/Gang679"];
    
    /*! 这段代码是用友盟自带的自定义分享的时候打开！ */
    /*
     * 添加某一平台会加入平台下所有分享渠道，如微信：好友、朋友圈、收藏，QQ：QQ和QQ空间
     * 以下接口可移除相应平台类型的分享，如微信收藏，对应类型可在枚举中查找
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    //    UMSocialSnsPlatform *copyPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"copy"];
    //    copyPlatform.displayName = @"复制";
    //    copyPlatform.smallImageName = @"icon"; //用于tableView样式的分享列表
    //    copyPlatform.bigImageName = @"icon"; //用于actionsheet样式的分享列表
    //    copyPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){ NSLog(@"copy!"); };                                                                                                                                                                                                          [UMSocialConfig addSocialSnsPlatform:@[copyPlatform]];                                                                                                                                                                                                        [UMSocialConfig setSnsPlatformNames:@[UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToQzone]];
}

#pragma mark 微信分享
- (void)gz_wechatShareWithShareType:(GZUM_SHARE_TYPE)shareType
                     viewController:(UIViewController *)viewController
{
    switch (shareType) {
        case GZUM_SHARE_TYPE_TEXT:
            [self gz_shareTextToPlatformType:UMSocialPlatformType_WechatSession
                                   shareText:_shareText
                              viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE:
            [self gz_shareImageToPlatformType:UMSocialPlatformType_WechatSession
                                   thumbImage:nil
                                     bigImage:_shareBigImage
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE_URL:
            [self gz_shareImageURLToPlatformType:UMSocialPlatformType_WechatSession
                                      thumbImage:nil
                                        imageUrl:_shareImageUrl
                                  viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_WEB_LINK:
            [self gz_shareWebPageToPlatformType:UMSocialPlatformType_WechatSession
                                          title:_shareTitle
                                      shareText:_shareText
                                       imageUrl:_shareImageUrl
                                     webpageUrl:_shareWebpageUrl
                                 viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_TEXT_IMAGE:
             [self gz_shareImageAndTextToPlatformType:UMSocialPlatformType_WechatSession
                                           shareText:_shareText
                                          thumbImage:nil
                                            imageUrl:_shareImageUrl
                                      viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_MUSIC_LINK:
            [self gz_shareMusicToPlatformType:UMSocialPlatformType_WechatSession
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     musicUrl:_shareMusicUrl
                                 musicDataUrl:_shareMusicDataUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_VIDEO_LINK:
            [self gz_shareVedioToPlatformType:UMSocialPlatformType_WechatSession
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     videoUrl:_shareVideoUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_GIF:
            [self gz_shareEmoticonToPlatformType:UMSocialPlatformType_WechatSession
                                           title:_shareTitle
                                       shareText:_shareText
                                        imageUrl:_shareImageUrl
                                     gifFilePath:_shareGifFilePath
                                  viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_FILE:
            [self gz_shareFileToPlatformType:UMSocialPlatformType_WechatSession
                                       title:_shareTitle
                                   shareText:_shareText
                                    imageUrl:_shareImageUrl
                                fileFilePath:_shareFileFilePath
                           fileFileExtension:_shareFileFileExtension
                              viewController:viewController];
            break;
            
        default:
            break;
    }
}

#pragma mark 微信朋友圈分享
- (void)gz_wechatTimeLineShareWithShareType:(GZUM_SHARE_TYPE)shareType
                             viewController:(UIViewController *)viewController
{
    switch (shareType) {
        case GZUM_SHARE_TYPE_TEXT:
            [self gz_shareTextToPlatformType:UMSocialPlatformType_WechatTimeLine
                                   shareText:_shareText
                              viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE:
            [self gz_shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine
                                   thumbImage:nil
                                     bigImage:_shareBigImage
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE_URL:
            [self gz_shareImageURLToPlatformType:UMSocialPlatformType_WechatTimeLine
                                      thumbImage:nil
                                        imageUrl:_shareImageUrl
                                  viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_WEB_LINK:
            [self gz_shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine
                                          title:_shareTitle
                                      shareText:_shareText
                                       imageUrl:_shareImageUrl
                                     webpageUrl:_shareWebpageUrl
                                 viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_TEXT_IMAGE:
            [self gz_shareImageAndTextToPlatformType:UMSocialPlatformType_WechatTimeLine
                                           shareText:_shareText
                                          thumbImage:nil
                                            imageUrl:_shareImageUrl
                                      viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_MUSIC_LINK:
            [self gz_shareMusicToPlatformType:UMSocialPlatformType_WechatTimeLine
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     musicUrl:_shareMusicUrl
                                 musicDataUrl:_shareMusicDataUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_VIDEO_LINK:
            [self gz_shareVedioToPlatformType:UMSocialPlatformType_WechatTimeLine
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     videoUrl:_shareVideoUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_GIF:
            break;
        case GZUM_SHARE_TYPE_FILE:
            break;
            
        default:
            break;
    }
}

#pragma mark 新浪微博分享
- (void)gz_sinaShareWithShareType:(GZUM_SHARE_TYPE)shareType
                   viewController:(UIViewController *)viewController
{
    shareType = GZUM_SHARE_TYPE_TEXT_IMAGE;
    if (_shareText && _shareWebpageUrl)
    {
        _shareText = [NSString stringWithFormat:@"%@，分享自：@四美坊，详见链接：%@", _shareText, _shareWebpageUrl];
    }
    switch (shareType) {
        case GZUM_SHARE_TYPE_TEXT:
            [self gz_shareTextToPlatformType:UMSocialPlatformType_Sina
                                   shareText:_shareText
                              viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE:
            [self gz_shareImageToPlatformType:UMSocialPlatformType_Sina
                                   thumbImage:nil
                                     bigImage:_shareBigImage
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE_URL:
            [self gz_shareImageURLToPlatformType:UMSocialPlatformType_Sina
                                      thumbImage:nil
                                        imageUrl:_shareImageUrl
                                  viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_WEB_LINK:
            [self gz_shareWebPageToPlatformType:UMSocialPlatformType_Sina
                                          title:_shareTitle
                                      shareText:_shareText
                                       imageUrl:_shareImageUrl
                                     webpageUrl:_shareWebpageUrl
                                 viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_TEXT_IMAGE:
            [self gz_shareImageAndTextToPlatformType:UMSocialPlatformType_Sina
                                           shareText:_shareText
                                          thumbImage:nil
                                            imageUrl:_shareImageUrl
                                      viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_MUSIC_LINK:
            [self gz_shareMusicToPlatformType:UMSocialPlatformType_Sina
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     musicUrl:_shareMusicUrl
                                 musicDataUrl:_shareMusicDataUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_VIDEO_LINK:
            [self gz_shareVedioToPlatformType:UMSocialPlatformType_Sina
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     videoUrl:_shareVideoUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_GIF:
            break;
        case GZUM_SHARE_TYPE_FILE:
            break;
            
        default:
            break;
    }
}

#pragma mark qq分享
- (void)gz_qqShareWithShareType:(GZUM_SHARE_TYPE)shareType
                 viewController:(UIViewController *)viewController
{
    switch (shareType) {
        case GZUM_SHARE_TYPE_TEXT:
            [self gz_shareTextToPlatformType:UMSocialPlatformType_QQ
                                   shareText:_shareText
                              viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE:
            [self gz_shareImageToPlatformType:UMSocialPlatformType_QQ
                                   thumbImage:nil
                                     bigImage:_shareBigImage
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE_URL:
            [self gz_shareImageURLToPlatformType:UMSocialPlatformType_QQ
                                      thumbImage:nil
                                        imageUrl:_shareImageUrl
                                  viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_WEB_LINK:
            [self gz_shareWebPageToPlatformType:UMSocialPlatformType_QQ
                                          title:_shareTitle
                                      shareText:_shareText
                                       imageUrl:_shareImageUrl
                                     webpageUrl:_shareWebpageUrl
                                 viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_TEXT_IMAGE:
            [self gz_shareImageAndTextToPlatformType:UMSocialPlatformType_QQ
                                           shareText:_shareText
                                          thumbImage:nil
                                            imageUrl:_shareImageUrl
                                      viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_MUSIC_LINK:
            [self gz_shareMusicToPlatformType:UMSocialPlatformType_QQ
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     musicUrl:_shareMusicUrl
                                 musicDataUrl:_shareMusicDataUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_VIDEO_LINK:
            [self gz_shareVedioToPlatformType:UMSocialPlatformType_QQ
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     videoUrl:_shareVideoUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_GIF:
            break;
        case GZUM_SHARE_TYPE_FILE:
            break;
            
        default:
            break;
    }
}

#pragma mark Qzone分享
- (void)gz_qZoneShareWithShareType:(GZUM_SHARE_TYPE)shareType
                    viewController:(UIViewController *)viewController
{
    switch (shareType) {
        case GZUM_SHARE_TYPE_TEXT:
            [self gz_shareTextToPlatformType:UMSocialPlatformType_Qzone
                                   shareText:_shareText
                              viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE:
            [self gz_shareImageToPlatformType:UMSocialPlatformType_Qzone
                                   thumbImage:nil
                                     bigImage:_shareBigImage
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_IMAGE_URL:
            [self gz_shareImageURLToPlatformType:UMSocialPlatformType_Qzone
                                      thumbImage:nil
                                        imageUrl:_shareImageUrl
                                  viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_WEB_LINK:
            [self gz_shareWebPageToPlatformType:UMSocialPlatformType_Qzone
                                          title:_shareTitle
                                      shareText:_shareText
                                       imageUrl:_shareImageUrl
                                     webpageUrl:_shareWebpageUrl
                                 viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_TEXT_IMAGE:
            [self gz_shareImageAndTextToPlatformType:UMSocialPlatformType_Qzone
                                           shareText:_shareText
                                          thumbImage:nil
                                            imageUrl:_shareImageUrl
                                      viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_MUSIC_LINK:
            [self gz_shareMusicToPlatformType:UMSocialPlatformType_Qzone
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     musicUrl:_shareMusicUrl
                                 musicDataUrl:_shareMusicDataUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_VIDEO_LINK:
            [self gz_shareVedioToPlatformType:UMSocialPlatformType_Qzone
                                        title:_shareTitle
                                    shareText:_shareText
                                     imageUrl:_shareImageUrl
                                     videoUrl:_shareVideoUrl
                               viewController:viewController];
            break;
        case GZUM_SHARE_TYPE_GIF:
            break;
        case GZUM_SHARE_TYPE_FILE:
            break;
            
        default:
            break;
    }
}

#pragma mark - 分享列表
- (void)gz_shareListWithShareType:(GZUM_SHARE_TYPE)shareType
                   viewController:(UIViewController *)viewController
{
    GZWeakSelf ;
    GZUMSocialConfig.sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    GZUMSocialConfig.sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    GZUMSocialConfig.shareTitleViewConfig.shareTitleViewTitleString = @"四美坊分享";
    GZUMSocialConfig.shareTitleViewConfig.shareTitleViewTitleColor = [UIColor purpleColor];
    GZUMSocialConfig.shareCancelControlConfig.shareCancelControlText = @"取消分享";
    /*! 在这里预设自己需要分享的平台 */
    [UMSocialUIManager setPreDefinePlatforms:@[
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sina)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        if (platformType == UMSocialPlatformType_QQ)
        {
            [weakSelf gz_qqShareWithShareType:shareType
                               viewController:viewController];
        }
        else if (platformType == UMSocialPlatformType_Qzone)
        {
            [weakSelf gz_qZoneShareWithShareType:shareType
                                  viewController:viewController];
        }
        else if (platformType == UMSocialPlatformType_WechatSession)
        {
            [weakSelf gz_wechatShareWithShareType:shareType
                                   viewController:viewController];
        }
        else if (platformType == UMSocialPlatformType_WechatTimeLine)
        {
            [weakSelf gz_wechatTimeLineShareWithShareType:shareType
                                           viewController:viewController];
        }
        else if (platformType == UMSocialPlatformType_Sina)
        {
            [weakSelf gz_sinaShareWithShareType:shareType
                                 viewController:viewController];
        }
    }];
}

#pragma mark - 友盟登录

#pragma mark 微信登录
- (void)gz_wechatLoginWithViewController:(UIViewController *)viewController
                   isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                           loginCallback:(GZUMLoginCallback)loginCallback
{
    [self gz_UMLoginWithPlatformType:UMSocialPlatformType_WechatSession
                      viewController:viewController
               isGetAuthWithUserInfo:isGetAuthWithUserInfo
                       loginCallback:loginCallback];
}

#pragma mark QQ登录
- (void)gz_qqLoginWithViewController:(UIViewController *)viewController
               isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                       loginCallback:(GZUMLoginCallback)loginCallback
{
    [self gz_UMLoginWithPlatformType:UMSocialPlatformType_QQ
                      viewController:viewController
               isGetAuthWithUserInfo:isGetAuthWithUserInfo
                       loginCallback:loginCallback];
}

#pragma mark QZone登录
- (void)gz_qZoneLoginWithViewController:(UIViewController *)viewController
                  isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                          loginCallback:(GZUMLoginCallback)loginCallback
{
    [self gz_UMLoginWithPlatformType:UMSocialPlatformType_Qzone
                      viewController:viewController
               isGetAuthWithUserInfo:isGetAuthWithUserInfo
                       loginCallback:loginCallback];
}

#pragma mark 微博登录
- (void)gz_sinaLoginWithViewController:(UIViewController *)viewController
                 isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                         loginCallback:(GZUMLoginCallback)loginCallback
{
    [self gz_UMLoginWithPlatformType:UMSocialPlatformType_Sina
                      viewController:viewController
               isGetAuthWithUserInfo:isGetAuthWithUserInfo
                       loginCallback:loginCallback];
}

#pragma mark - 友盟登录列表
- (void)gz_loginListWithViewController:(UIViewController *)viewController
                 isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                         loginCallback:(GZUMLoginCallback)loginCallback
{
    GZWeakSelf;
    GZUMSocialConfig.sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    GZUMSocialConfig.sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    GZUMSocialConfig.shareTitleViewConfig.shareTitleViewTitleString = @"四美坊登录";
    GZUMSocialConfig.shareTitleViewConfig.shareTitleViewTitleColor = [UIColor redColor];
    GZUMSocialConfig.shareCancelControlConfig.shareCancelControlText = @"取消登录";
    /*! 在这里预设自己需要登录的平台 */
    [UMSocialUIManager setPreDefinePlatforms:@[
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sina)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        if (platformType == UMSocialPlatformType_QQ)
        {
            [weakSelf gz_qqLoginWithViewController:viewController
                             isGetAuthWithUserInfo:isGetAuthWithUserInfo
                                     loginCallback:loginCallback];
        }
        else if (platformType == UMSocialPlatformType_Qzone)
        {
            [weakSelf gz_qZoneLoginWithViewController:viewController
                                isGetAuthWithUserInfo:isGetAuthWithUserInfo
                                        loginCallback:_loginCallback];
        }
        else if (platformType == UMSocialPlatformType_WechatSession)
        {
            [weakSelf gz_wechatLoginWithViewController:viewController
                                 isGetAuthWithUserInfo:isGetAuthWithUserInfo
                                         loginCallback:_loginCallback];
        }
        else if (platformType == UMSocialPlatformType_Sina)
        {
            [weakSelf gz_sinaLoginWithViewController:viewController
                               isGetAuthWithUserInfo:isGetAuthWithUserInfo
                                       loginCallback:_loginCallback];
        }
    }];
}

- (void)gz_UMLoginWithPlatformType:(UMSocialPlatformType)platformType
                    viewController:(UIViewController *)viewController
             isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                     loginCallback:(GZUMLoginCallback)loginCallback
{
    GZWeakSelf;
    if (isGetAuthWithUserInfo)
    {
        [GZUMSocialData getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
            
            [weakSelf callbackWithResult:result
                                   error:error
                           loginCallback:loginCallback];
        }];
    }
    else
    {
        [GZUMSocialData authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
            [weakSelf callbackWithResult:result
                                   error:error
                           loginCallback:loginCallback];
        }];
    }
}

- (void)callbackWithResult:(id)result
                     error:(NSError *)error
             loginCallback:(GZUMLoginCallback)loginCallback
{
    NSString *message = nil;
    
    if (error) {
        message = @"登录失败，获取用户信息失败！";
        UMSocialLogInfo(@"登录失败，获取用户信息失败！error %@",error);
    }else{
        if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
            
            UMSocialUserInfoResponse *resp = result;
            self.responseDic = resp;
            if (loginCallback)
            {
                loginCallback(resp);
            }
        }else{
            message = @"登录失败，获取用户信息失败！";
        }
    }
    
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UserInfo"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - 清除授权
- (void)gz_cancelAuthWithPlatformType:(UMSocialPlatformType)platformType
{
    GZWeakSelf;
    if (self.responseDic)
    {
        [GZUMSocialData cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
            self.responseDic = nil;
            if (weakSelf.authOpFinish)
            {
                weakSelf.authOpFinish();
            }
        }];
    }
    else
    {
//        NSLog(@"您还没有授权信息，不能清除授权！");
//        [self GZ_showAlertWithTitle:@"您还没有授权信息，不能清除授权！"];
    }
}

- (NSString *)authInfoString:(UMSocialUserInfoResponse *)resp
{
    NSMutableString *string = [NSMutableString new];
    if (resp.uid) {
        [string appendFormat:@"uid = %@\n", resp.uid];
    }
    if (resp.openid) {
        [string appendFormat:@"openid = %@\n", resp.openid];
    }
    if (resp.accessToken) {
        [string appendFormat:@"accessToken = %@\n", resp.accessToken];
    }
    if (resp.refreshToken) {
        [string appendFormat:@"refreshToken = %@\n", resp.refreshToken];
    }
    if (resp.expiration) {
        [string appendFormat:@"expiration = %@\n", resp.expiration];
    }
    if (resp.name) {
        [string appendFormat:@"name = %@\n", resp.name];
    }
    if (resp.iconurl) {
        [string appendFormat:@"iconurl = %@\n", resp.iconurl];
    }
    if (resp.gender) {
        [string appendFormat:@"gender = %@\n", resp.gender];
    }
    return string;
}

@end




//友盟5.2.2
//#pragma mark - 友盟分享
//#pragma mark 注册友盟分享微信
//- (void)shareConfig
//{
//    // ************* 友盟分享 *************
//    [UMSocialData setUmSocialAppkey:GZUmengAppkey];
//    //打开调试log的开关
//    [UMSocialData openLog:YES];
//    
//    /*! 获取友盟social版本号 */
//    NSLog(@"获取友盟social版本号: %@", [UMSocialGloGZl umSocialSDKVersion]);
//    // 如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
////        [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
//    //    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina,UMShareToTencent,UMShareToQzone]];
//    
//    /*苹果审核要求,隐藏未安装的应用 的分享选项 */
////    [UMSocialShareObjectConfig hiddenNotInstallPlatforms:@[UMShareToSina, UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline,UMShareToAlipaySession]];
//    
//    // 打开新浪微博的SSO开关
//    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3112175844"，详情请参考官方文档。
//    
//    [UMSocialData setPlaform:UMSocialPlatformType_Sina
//                           appKey:kSinaAppKey
//                        appSecret:kSinaAppSecret
//                      redirectURL:@"http://sns.whalecloud.com/sin"];
////    [UMSocialData openNewSinaSSOWithAppKey:kSinaAppKey
////                                              secret:kSinaAppSecret
////                                         RedirectURL:@"http://www.umeng.com/social"];
//    //  添加微信分享授权
//    //设置微信AppId、appSecret，分享url
//    
//    [UMSocialData setPlaform:UMSocialPlatformType_WechatSession
//                           appKey:WX_APP_KEY
//                        appSecret:WX_APP_SECRET
//                      redirectURL:@"http://www.umeng.com/social"];
//    
////    [UMSocialWechatHandler setWXAppId:WX_APP_KEY appSecret:WX_APP_SECRET url:@"http://www.umeng.com/social"];
//    
//    // 设置分享到QQ空间的应用Id，和分享url 链接
//    [UMSocialData setPlaform:UMSocialPlatformType_QQ
//                           appKey:kQQAppID
//                        appSecret:kQQKey
//                      redirectURL:@"http://mobile.umeng.com/social"];
//
//    
////    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQKey url:@"http://mobile.umeng.com/social"];
//    // 设置支持没有客户端情况下使用SSO授权
////    [UMSocialQQHandler setSupportWebView:YES];
//    
//    // 设置支付宝分享的appId
//    //    [UMSocialAlipayShareHandler setAlipayShareAppId:@"2016092201949956"];
//    
//    
//    //    UMSocialSnsPlatform *copyPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"copy"];
//    //    copyPlatform.displayName = @"复制";
//    //    copyPlatform.smallImageName = @"icon"; //用于tableView样式的分享列表
//    //    copyPlatform.bigImageName = @"icon"; //用于actionsheet样式的分享列表
//    //    copyPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){ NSLog(@"copy!");
//    //    };                                                                                                                                                                                                          [UMSocialConfig addSocialSnsPlatform:@[copyPlatform]];                                                                                                                                                                                                        [UMSocialConfig setSnsPlatformNames:@[UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToQzone,UMShareToTencent]];
//}
//
//#pragma mark 微信分享
//- (void)GZ_wxShareWithViewControll:(UIViewController *)viewC
//                             title:(NSString *)shareTitle
//                     withShareText:(NSString *)shareText
//                             image:(UIImage *)shareImage
//                               url:(NSString *)shareURLString{
//    _viewC = viewC;
//    
//    [self GZ_wxShareWithViewControll:_viewC title:shareTitle withShareText:shareText image:shareImage url:shareURLString];
//    
////    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
////    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURLString;
////    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
////
////    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
//}
//
//#pragma mark 新浪微博分享
//- (void)GZ_wbShareWithViewControll:(UIViewController *)viewC
//                             title:(NSString *)shareTitle
//                     withShareText:(NSString *)shareText
//                             image:(UIImage *)shareImage
//                               url:(NSString *)shareURLString{
//    _viewC = viewC;
//    
////    [self gz];
////    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil] ;
////    
////
////    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
//}
//
//#pragma mark 微信朋友圈分享
//- (void)GZ_wxpyqShareWithViewControll:(UIViewController *)viewC
//                                title:(NSString *)shareTitle
//                        withShareText:(NSString *)shareText
//                                image:(UIImage *)shareImage
//                                  url:(NSString *)shareURLString
//{
//    _viewC = viewC;
//    
//    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
//    [UMSocialWechatHandler setWXAppId:WX_APP_KEY appSecret:WX_APP_SECRET url:shareURLString];
//    
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURLString;
//    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
//
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
//}
//
//#pragma mark qq分享
//- (void)GZ_qqShareWithViewControll:(UIViewController *)viewC
//                             title:(NSString *)shareTitle
//                     withShareText:(NSString *)shareText
//                             image:(UIImage *)shareImage
//                               url:(NSString *)shareURLString{
//    _viewC = viewC;
////    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
////    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQKey url:shareURLString];
//
//    
//    [UMSocialData defaultData].extConfig.qqData.url = shareURLString;
//    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
//    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
//}
//
//#pragma mark qqzone分享
//- (void)GZ_qqzoneShareWithViewControll:(UIViewController *)viewC
//                                 title:(NSString *)shareTitle
//                         withShareText:(NSString *)shareText
//                                 image:(UIImage *)shareImage
//                                   url:(NSString *)shareURLString{
//    _viewC = viewC;
//    
//    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
//    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.qzoneData.url = shareURLString;
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);}
//
//
////#pragma mark 支付宝分享
////- (void)GZ_AlipayShareWithViewControll:(UIViewController *)viewC
////                                 title:(NSString *)shareTitle
////                         withShareText:(NSString *)shareText
////                                 image:(UIImage *)shareImage
////                                   url:(NSString *)shareURLString{
////    _viewC = viewC;
////    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
////    
////    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToAlipaySession  ].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
////    
////    
//////    _viewC = viewC;
//////    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
//////    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
////}
////
////#pragma mark 短信分享
////- (void)GZ_smsShareWithViewControll:(UIViewController *)viewC withShareText:shareText image:shareImage
////{
////    _viewC = viewC;
////    
////    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
////    if (messageClass != nil) {
////        if ([messageClass canSendText]) {
////            [self displaySMSComposerSheetWithShareText:(NSString *)shareText];
////        }
////        else {
////            //@"设备没有短信功能"
////        }
////    }
////    else {
////        //@"iOS版本过低,iOS4.0以上才支持程序内发送短信"
////    }
////}
////
////#pragma mark 短信的代理方法
////- (void)GZ_messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
////    [_viewC dismissViewControllerAnimated:YES completion:nil];
////    switch (result)
////    {
////        case MessageComposeResultCancelled:
////            
////            break;
////        case MessageComposeResultSent:
////            //@"感谢您的分享!"
////            break;
////        case MessageComposeResultFailed:
////            
////            break;
////        default:
////            break;
////    }
////}
//
//#pragma mark 分享列表
//- (void)GZ_UMshareListWithViewControll:(UIViewController *)viewC
//                                 title:(NSString *)shareTitle
//                         withShareText:(NSString *)shareText
//                                 image:(UIImage *)shareImage
//                                   url:(NSString *)shareURLString
//{
//    
//    NSArray *titarray = nil;
//    NSArray *picarray = nil;
//    if ([WXApi isWXAppInstalled] && [TencentOAuth iphoneQQInstalled])
//    {
//    titarray = @[@"微信好友", @"微信朋友圈", @"新浪微博", @"QQ好友",  @"QQ空间"];
//    picarray = @[@"分享微信", @"朋友圈", @"分享微博", @"分享QQ", @"空间"];
//    }
//    else if (![WXApi isWXAppInstalled] && [TencentOAuth iphoneQQInstalled])
//    {
//        titarray = @[@"新浪微博", @"QQ好友",@"QQ空间"];
//        picarray = @[@"分享微博", @"分享QQ", @"空间"];
//    }
//    else if ([WXApi isWXAppInstalled] && ![TencentOAuth iphoneQQInstalled])
//    {
//        titarray = @[@"微信",@"朋友圈",@"微博",];
//        picarray = @[@"分享微信",@"朋友圈", @"分享微博"];
//    }
//    else if (![WXApi isWXAppInstalled] && ![TencentOAuth iphoneQQInstalled])
//    {
//        titarray = @[@"微博",];
//        picarray = @[@"分享微博"];
//    }
//
//    GZShareAnimationView *animationView = [[GZShareAnimationView alloc]initWithTitleArray:titarray picarray:picarray title:@"第三方分享"];
//    
//    GZWeakSelf ;
//    [animationView selectedWithIndex:^(NSInteger index,id shareType) {
//        
//        
////        NSLog(@"你选择的index ＝＝ %ld",(long)index);
////        NSLog(@"要分享到的平台%@",titarray[(long)index - 1]);
//        
//        if ([WXApi isWXAppInstalled] && [TencentOAuth iphoneQQInstalled])
//        {
//        switch (index)
//        {
//            case 1:
//                [weakSelf GZ_wxShareWithViewControll:(UIViewController *)viewC
//                                               title:(NSString *)shareTitle
//                                       withShareText:(NSString *)shareText
//                                               image:(UIImage *)shareImage
//                                                 url:(NSString *)shareURLString];
//                break;
//            case 2:
//                [weakSelf GZ_wxpyqShareWithViewControll:(UIViewController *)viewC
//                                                  title:(NSString *)shareTitle
//                                          withShareText:(NSString *)shareText
//                                                  image:(UIImage *)shareImage
//                                                    url:(NSString *)shareURLString];
//                break;
//            case 3:
//                [weakSelf GZ_wbShareWithViewControll:(UIViewController *)viewC
//                                               title:(NSString *)shareTitle
//                                       withShareText:(NSString *)shareText
//                                               image:(UIImage *)shareImage
//                                                 url:(NSString *)shareURLString];
//                break;
//            case 4:
//                [weakSelf GZ_qqShareWithViewControll:(UIViewController *)viewC
//                                               title:(NSString *)shareTitle
//                                       withShareText:(NSString *)shareText
//                                               image:(UIImage *)shareImage
//                                                 url:(NSString *)shareURLString];
//                break;
//            case 5:
//                [weakSelf GZ_qqzoneShareWithViewControll:(UIViewController *)viewC
//                                                   title:(NSString *)shareTitle
//                                           withShareText:(NSString *)shareText
//                                                   image:(UIImage *)shareImage
//                                                     url:(NSString *)shareURLString];
//                break;
//    
//            default:
//                break;
//            }
//        }
//        else if (![WXApi isWXAppInstalled] && [TencentOAuth iphoneQQInstalled])
//        {
//            switch (index)
//            {
//                case 1:
//                    [weakSelf GZ_wbShareWithViewControll:(UIViewController *)viewC
//                                                   title:(NSString *)shareTitle
//                                           withShareText:(NSString *)shareText
//                                                   image:(UIImage *)shareImage
//                                                     url:(NSString *)shareURLString];
//                    break;
//                case 2:
//                    [weakSelf GZ_qqShareWithViewControll:(UIViewController *)viewC
//                                                   title:(NSString *)shareTitle
//                                           withShareText:(NSString *)shareText
//                                                   image:(UIImage *)shareImage
//                                                     url:(NSString *)shareURLString];
//                    break;
//                case 3:
//                    [weakSelf GZ_qqzoneShareWithViewControll:(UIViewController *)viewC
//                                                       title:(NSString *)shareTitle
//                                               withShareText:(NSString *)shareText
//                                                       image:(UIImage *)shareImage
//                                                         url:(NSString *)shareURLString];
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//        else if ([WXApi isWXAppInstalled] && ![TencentOAuth iphoneQQInstalled])
//        {
//            switch (index)
//            {
//                case 1:
//                    [weakSelf GZ_wxShareWithViewControll:(UIViewController *)viewC
//                                                   title:(NSString *)shareTitle
//                                           withShareText:(NSString *)shareText
//                                                   image:(UIImage *)shareImage
//                                                     url:(NSString *)shareURLString];
//                    break;
//                case 2:
//                    [weakSelf GZ_wxpyqShareWithViewControll:(UIViewController *)viewC
//                                                      title:(NSString *)shareTitle
//                                              withShareText:(NSString *)shareText
//                                                      image:(UIImage *)shareImage
//                                                        url:(NSString *)shareURLString];
//                    break;
//                case 3:
//                    [weakSelf GZ_wbShareWithViewControll:(UIViewController *)viewC
//                                                   title:(NSString *)shareTitle
//                                           withShareText:(NSString *)shareText
//                                                   image:(UIImage *)shareImage
//                                                     url:(NSString *)shareURLString];
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//        else if (![WXApi isWXAppInstalled] && ![TencentOAuth iphoneQQInstalled])
//        {
//            switch (index)
//            {
//                case 1:
//                    [weakSelf GZ_wbShareWithViewControll:(UIViewController *)viewC
//                                                   title:(NSString *)shareTitle
//                                           withShareText:(NSString *)shareText
//                                                   image:(UIImage *)shareImage
//                                                     url:(NSString *)shareURLString];
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//    }];
//    [animationView CLBtnBlock:^(UIButton *btn) {
//        
////        NSLog(@"你点了选择/取消按钮");
//    }];
//    [animationView show];
//}
//
//
//// 实现回调方法：
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if (response.responseCode == UMSResponseCodeSuccess) {
//        
//        // 得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//        
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//        
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        NSString *url = @"http://www.88meichou.com/api/user/getUserShare.php";
//      //  NSLog(@"~~~~%@",appDelegate.user_Id);
//        NSDictionary *parma = @{@"user_id":appDelegate.user_Id
//                                };
//        self.TaskTask = [GZNetManager gz_requestWithType:GZHttpRequestTypeGet withUrlString:url withParameters:parma withSuccessBlock:^(id response) {
//          //  NSLog(@"~~~~~~!!!!!~~~~~~%@",response);
//        } withFailureBlock:^(NSError *error) {
//        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//        }];
//
//        
//            [alertView show];
//        
//    } else if(response.responseCode != UMSResponseCodeCancel) {
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        }
//    }
//
//    // 根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        // 得到分享到的微博平台名
//      //  NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}
//
//#pragma mark - 友盟登录
///**友盟 QQ 登录**/
//- (void)GZ_QQLogin:(UIViewController *)viewController
//{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//    
//    snsPlatform.loginClickHandler(viewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        //          获取微博用户名、uid、token等
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
//            
////            NSDictionary *dict = [NSDictionary dictionary];
//            NSDictionary *dict = @{
//                     @"userName" : snsAccount.userName,
//                     @"usid" : snsAccount.usid,
//                     @"accessToken" : snsAccount.accessToken,
//                     @"iconURL" : snsAccount.iconURL
//                     };
//            // delegate
//            [self.delegate getUserData:dict];
//
//          //  NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//        }});
//}
//
///**友盟 Qzone 登录**/
//- (void)GZ_QzoneLogin:(UIViewController *)viewController
//{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
//    
//    snsPlatform.loginClickHandler(viewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        // 获取微博用户名、uid、token等
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQzone];
//            
//            NSDictionary *dict = [NSDictionary dictionary];
//            dict = @{
//                     @"userName" : snsAccount.userName,
//                     @"usid" : snsAccount.usid,
//                     @"accessToken" : snsAccount.accessToken,
//                     @"iconURL" : snsAccount.iconURL
//                     };
//            // delegate
//            [self.delegate getUserData:dict];
//
////            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//            
//        }});
//}
//
///**友盟 新浪微博 登录**/
//- (void)GZ_SinaLogin:(UIViewController *)viewController
//{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    
//    snsPlatform.loginClickHandler(viewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        // 获取微博用户名、uid、token等
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
//            
//            NSDictionary *dict = [NSDictionary dictionary];
//            dict = @{
//                     @"userName" : snsAccount.userName,
//                     @"usid" : snsAccount.usid,
//                     @"accessToken" : snsAccount.accessToken,
//                     @"iconURL" : snsAccount.iconURL
//                     };
//            // delegate
//            [self.delegate getUserData:dict];
//
////            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//            
//        }});
//}
//
///**删除新浪微博登陆授权调用下面的方法**/
//- (void)deleteSinaLogin
//{
//    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//        NSLog(@"response is %@",response);
//    }];
//}
//
///**友盟 微信 登录**/
//- (void)GZ_WechatSessionLogin:(UIViewController *)viewController
//{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//    
//    snsPlatform.loginClickHandler(viewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
//            
//            NSDictionary *dict = [NSDictionary dictionary];
//            dict = @{
//                     @"userName" : snsAccount.userName,
//                     @"usid" : snsAccount.usid,
//                     @"accessToken" : snsAccount.accessToken,
//                     @"iconURL" : snsAccount.iconURL
//                     };
//
//            // delegate
//            [self.delegate getUserData:dict];
//
////            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//        }
//    });
//}
//
///**友盟登录列表**/
//- (void)GZ_UMLoginListWithViewControll:(UIViewController *)viewController
//{
//    NSMutableArray *titarray = [NSMutableArray arrayWithObjects:@"微信",@"微博", @"QQ",@"空间",nil];
//    NSMutableArray *picarray = [NSMutableArray arrayWithObjects:@"wechat",@"weibo", @"qq",@"zone",nil];
//    GZShareAnimationView *animationView = [[GZShareAnimationView alloc]initWithTitleArray:titarray picarray:picarray title:@"第三方登录"];
//    [animationView selectedWithIndex:^(NSInteger index,id shareType) {
////        NSLog(@"你选择的index ＝＝ %ld",(long)index);
////        NSLog(@"要登录的平台");
//        
//        switch (index)
//        {
//            case 1:
//                [self GZ_WechatSessionLogin:viewController];
//                break;
//            case 2:
//                [self GZ_SinaLogin:viewController];
//                break;
//            case 3:
//                [self GZ_QQLogin:viewController];
//                break;
//            case 4:
//                [self GZ_QzoneLogin:viewController];
//                break;
//
//            default:
//                break;
//        }
//    }];
//    [animationView CLBtnBlock:^(UIButton *btn) {
//        
////        NSLog(@"你点了选择/取消按钮");
//    }];
//    [animationView show];
//}
//
//@end
