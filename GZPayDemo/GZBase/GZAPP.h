//  GZAPP
//  GZPayDemo
//
//  Created by xinshijie on 2017/4/6.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//


#import <Foundation/Foundation.h>


/*! 1、获取APP的名字 */
#define GZ_APP_Name [[[NSBundle mainBundle] infoDictionary] objectForKey:GZBundleName]

/*! 2、获取APP的版本号 */
#define GZ_APP_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:GZBundleVersion]

/*! 3、获取App短式版本号 */
#define GZ_APP_VersionShort [[[NSBundle mainBundle] infoDictionary] objectForKey:GZBundleShortVersionString]

/*! 4、使用GZLocalizedString检索本地化字符串 */
//#define GZLocalizedString(key, comment) \
//[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"GZKit"]

#define GZLocalizedString(key, comment) NSLocalizedString(key, comment)


/*! 5、获取AppDelegate */
#define APPDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

/*! 6、获取sharedApplication */
#define GZSharedApplication [UIApplication sharedApplication]

FOUNDATION_EXPORT NSString * _Nonnull const GZBundleName;
FOUNDATION_EXPORT NSString * _Nonnull const GZBundleVersion;
FOUNDATION_EXPORT NSString * _Nonnull const GZBundleShortVersionString;

@interface GZAPP : NSObject

// TODO:下面的方法还没有验证

/**
 *  Executes a block on first start of the App for current version.
 *  Remember to execute UI instuctions on main thread
 *
 *  @param block The block to execute, returns isFirstStartForCurrentVersion
 */
+ (void)onFirstStart:(void (^ _Nullable)(BOOL isFirstStart))block;

/**
 *  Executes a block on first start of the App.
 *  Remember to execute UI instuctions on main thread
 *
 *  @param block The block to execute, returns isFirstStart
 */
+ (void)onFirstStartForCurrentVersion:(void (^ _Nullable)(BOOL isFirstStartForCurrentVersion))block;

/**
 *  Executes a block on first start of the App for current given version.
 *  Remember to execute UI instuctions on main thread
 *
 *  @param version Version to be checked
 *  @param block   The block to execute, returns isFirstStartForVersion
 */
+ (void)onFirstStartForVersion:(NSString * _Nonnull)version
                         block:(void (^ _Nullable)(BOOL isFirstStartForCurrentVersion))block;

/**
 *  Returns if is the first start of the App
 *
 *  @return Returns if is the first start of the App
 */
+ (BOOL)isFirstStart;

/**
 *  Returns if is the first start of the App for current version
 *
 *  @return Returns if is the first start of the App for current version
 */
+ (BOOL)isFirstStartForCurrentVersion;

/**
 *  Returns if is the first start of the App for the given version
 *
 *  @param version Version to be checked
 *
 *  @return Returns if is the first start of the App for the given version
 */
+ (BOOL)isFirstStartForVersion:(NSString * _Nonnull)version;


@end
