//
//  ISGUserTools.h
//  ISGUserTools
//
//  Created by Isaac on 2018/5/17.
//  Copyright © 2018年 Isaac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISGUserInfo;
@interface ISGUserTools : NSObject

/*! @brief  是否记住密码 */
@property (nonatomic, assign, readonly) BOOL rememberStatus;
/*! @brief  保存的帐号 */
@property (nonatomic, copy, readonly) NSString *localAccountName;
/*! @brief  保存的明文密码 */
@property (nonatomic, copy, readonly) NSString *localAccountPwd;


/**
 *  单列创建
 *
 *  @return self
 */
+ (instancetype)sharedInstance;

/**
 *  是否保存密码
 *
 *  @param status 是否
 */
- (void)setRememberUserInfoStatus:(BOOL)status;

/**
 *  保存账号和密码
 *
 *  @param account  账号
 *  @param password 密码
 */
- (void)saveUserAccount:(NSString *)account password:(NSString *)password;

/**
 *  缓存用户信息
 *
 *  @return 用户信息
 */
- (ISGUserInfo *)localUserInfo;

/**
 *  保存用户信息
 *
 *  @param userInfo 用户信息
 */
- (void)saveUserInfoLocal:(ISGUserInfo *)userInfo;

/**
 *  清除本地数据
 */
- (void)clearLocalUserInfo;


@end
