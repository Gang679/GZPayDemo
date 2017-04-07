//
//  ImageTask.h
//  MeiChou
//
//  Created by xinshijie on 16/8/30.
//  Copyright © 2016年 Mr.quan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GZNetManager.h"

#define GZNetManagerShare [GZNetManager sharedGZNetManager]

/*! 定义请求成功的block */
typedef void( ^ GZResponseSuccess)(id response);
/*! 定义请求失败的block */
typedef void( ^ GZResponseFail)(NSError *error);
/*! 定义上传进度block */
typedef void( ^ GZUploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);

typedef NSURLSessionTask GZURLSessionTask;

@interface ImageTask : NSObject
/*! 获取当前网络状态 */
@property (nonatomic, assign) GZNetworkStatus   netWorkStatus;


/*!
 *  上传图片(多图)
 *
 *  @param operations   上传图片预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @param urlString    上传的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 */
+ (GZURLSessionTask *)Only_uploadImageWithUrlString:(NSString *)urlString
                                       parameters:(NSDictionary *)parameters
                                   withImageArray:(NSArray *)imageArray
                                 withSuccessBlock:(GZResponseSuccess)successBlock
                                  withFailurBlock:(GZResponseFail)failureBlock
                               withUpLoadProgress:(GZUploadProgress)progress;


@end
