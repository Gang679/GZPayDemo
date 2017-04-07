//
//  GZShareManage.h
//  GZPayDemo
//
//  Created by xinshijie on 2017/4/6.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
#import <MessageUI/MessageUI.h>


@protocol GZShareManageDelegate <NSObject>

/*! 返回用户信息 */
- (void)getUserData:(NSDictionary *)backUserData;

@end


typedef NS_ENUM(NSUInteger, GZUM_SHARE_TYPE)
{
    /*! 纯文本 */
    GZUM_SHARE_TYPE_TEXT = 1,
    
    /*! 纯图片：本地图片 */
    GZUM_SHARE_TYPE_IMAGE,
    
    /*! 纯图片：网络图片 URL */
    GZUM_SHARE_TYPE_IMAGE_URL,
    
    /*! 网页：一般的分享是这种，title、content、缩略图、URL */
    GZUM_SHARE_TYPE_WEB_LINK,
    
    /*! 文本 + 图片 【暂时只对新浪分享有效】 */
    GZUM_SHARE_TYPE_TEXT_IMAGE,
    
    /*! 音乐 */
    GZUM_SHARE_TYPE_MUSIC_LINK,
    
    /*! 视频 */
    GZUM_SHARE_TYPE_VIDEO_LINK,
    
    /*! gif 动图【注：目前只有微信支持动图分享，其他平台均不支持】*/
    GZUM_SHARE_TYPE_GIF,
    
    /*! 文件【注：目前只有微信支持动图分享，其他平台均不支持】 */
    GZUM_SHARE_TYPE_FILE
};


/*! 登录后返回的数据回调 */
typedef void (^GZUMLoginCallback)(UMSocialUserInfoResponse *response);


@interface GZShareManage : NSObject

/*! 登录后返回的数据回调 */
@property (nonatomic, copy) GZUMLoginCallback loginCallback;


/*! 分享标题 */
@property (nonatomic, strong) NSString *shareTitle;
/*! 分享摘要 */
@property (nonatomic, strong) NSString *shareText;
/*! 分享大图【本地 imageName】】 */
@property (nonatomic, strong) NSString *shareBigImage;
/*! 分享 URL 图片 */
@property (nonatomic, strong) NSString *shareImageUrl;
/*! 分享网页 */
@property (nonatomic, strong) NSString *shareWebpageUrl;

/*! 分享音乐 URL【必传】 */
@property (nonatomic, strong) NSString *shareMusicUrl;
/*! 分享音乐 DataUrl */
@property (nonatomic, strong) NSString *shareMusicDataUrl;
/*! 分享视频 URL */
@property (nonatomic, strong) NSString *shareVideoUrl;
/*! 分享 gif 动图路径 */
@property (nonatomic, strong) NSString *shareGifFilePath;
/*! 分享文件路径 */
@property (nonatomic, strong) NSString *shareFileFilePath;
/*! 分享文件后缀类型 */
@property (nonatomic, strong) NSString *shareFileFileExtension;


/*! 授权回调 */
@property (nonatomic, strong) void (^authOpFinish)();


@property (nonatomic, strong) id<GZShareManageDelegate> delegate;
/*! 图片数组 */
@property (nonatomic, strong) NSArray *shareImageArray;
/*! 分享的名字数组（要和图片名字一一对应哦！） */
@property (nonatomic, strong) NSArray *shareNameArray;

//// 友盟分享SDK的各种key设置【pod下来后只需调用下即可】
//@property (nonatomic, strong) NSString *GZShareUmengAppkey;
//@property (nonatomic, strong) NSString *GZShareSinaAppKey;
//@property (nonatomic, strong) NSString *GZShareWX_APP_KEY;
//@property (nonatomic, strong) NSString *GZShareWX_APP_SECRET;
//@property (nonatomic, strong) NSString *GZSharekQQKey;
//@property (nonatomic, strong) NSString *GZSharekQQAppID;



+ (GZShareManage *)shareManage;

/*!
 *  友盟分享设置
 */
- (void)gz_setupShareConfig;


/*!
 *  判断平台是否安装
 *
 *  @param platformType 平台类型 @see UMSocialPlatformType
 *
 *  @return YES 代表安装，NO 代表未安装
 *  @note 在判断QQ空间的App的时候，QQApi判断会出问题
 */
- (BOOL)gz_UMSocialIsInstall:(UMSocialPlatformType)platformType;

#pragma mark - 友盟分享 version 2.1
/*! 微信分享 */
#pragma mark 微信分享 version 2.1
- (void)gz_wechatShareWithShareType:(GZUM_SHARE_TYPE)shareType
                     viewController:(UIViewController *)viewController;

#pragma mark 微信朋友圈分享 version 2.1
- (void)gz_wechatTimeLineShareWithShareType:(GZUM_SHARE_TYPE)shareType
                             viewController:(UIViewController *)viewController;

#pragma mark 新浪微博分享 version 2.1
- (void)gz_sinaShareWithShareType:(GZUM_SHARE_TYPE)shareType
                   viewController:(UIViewController *)viewController;

#pragma mark qq分享 version 2.1
- (void)gz_qqShareWithShareType:(GZUM_SHARE_TYPE)shareType
                 viewController:(UIViewController *)viewController;

#pragma mark Qzone分享 version 2.1
- (void)gz_qZoneShareWithShareType:(GZUM_SHARE_TYPE)shareType
                    viewController:(UIViewController *)viewController;



#pragma mark - 友盟分享
/*!
 *  刚子友盟分享列表 version 2.1
 *
 *  @param shareType      分享类型，具体看枚举
 *  @param viewController viewController
 */
- (void)gz_shareListWithShareType:(GZUM_SHARE_TYPE)shareType
                   viewController:(UIViewController *)viewController;

#pragma mark - 友盟登录
#pragma mark 微信登录 version 2.1
- (void)gz_wechatLoginWithViewController:(UIViewController *)viewController
                   isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                           loginCallback:(GZUMLoginCallback)loginCallback;

#pragma mark QQ登录 version 2.1
- (void)gz_qqLoginWithViewController:(UIViewController *)viewController
               isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                       loginCallback:(GZUMLoginCallback)loginCallback;

#pragma mark QQZone登录 version 2.1
- (void)gz_qZoneLoginWithViewController:(UIViewController *)viewController
                  isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                          loginCallback:(GZUMLoginCallback)loginCallback;

#pragma mark 微博登录 version 2.1
- (void)gz_sinaLoginWithViewController:(UIViewController *)viewController
                 isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                         loginCallback:(GZUMLoginCallback)loginCallback;

#pragma mark - 友盟登录列表 version 2.1
/*!
 *  友盟登录列表 version 2.1
 *
 *  @param viewController        viewController description
 *  @param isGetAuthWithUserInfo
 YES:授权并获取用户信息(获取uid、access token及用户名等)
 NO：只需获取第三方平台token和uid，不获取用户名等用户信息，可以调用以下接口
 *  @param loginCallback         登录后返回的数据回调
 */
- (void)gz_loginListWithViewController:(UIViewController *)viewController
                 isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                         loginCallback:(GZUMLoginCallback)loginCallback;

#pragma mark - 清除授权
- (void)gz_cancelAuthWithPlatformType:(UMSocialPlatformType)platformType;

@end
