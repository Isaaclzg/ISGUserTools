//
//  ISGUserTools.m
//  ISGUserTools
//
//  Created by Isaac on 2018/5/17.
//  Copyright © 2018年 Isaac. All rights reserved.
//

#import "ISGUserTools.h"
#import "ISGUserInfo.h"
#import <SAMKeychain.h>

@interface ISGUserTools()

/*! @brief  是否记住密码 */
@property (nonatomic, strong, readwrite) NSNumber *userId;
/*! @brief  保存的帐号 */
@property (nonatomic, copy, readwrite) NSString *localAccountName;
/*! @brief  保存的明文密码 */
@property (nonatomic, copy, readwrite) NSString *localAccountPwd;
/*! @brief  user */
@property (nonatomic, strong) ISGUserInfo *user;

@end

@implementation ISGUserTools

static id _instance = nil;
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
    
}

- (void)setRememberUserInfoStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:@""];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveUserAccount:(NSString *)account password:(NSString *)password {
    NSArray *accounts = [SAMKeychain accountsForService:[self getBundleId]];
    for (NSDictionary *dictionary in accounts) {
        NSString *account = [dictionary objectForKey:@"acct"];
        [SAMKeychain deletePasswordForService:[self getBundleId] account:account];
    }
    [SAMKeychain setPassword:password forService:[self getBundleId] account:account];
}

- (ISGUserInfo *)localUserInfo {
    if (!self.user) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *path = [docPath stringByAppendingPathComponent:@"user_tp.tmp"];
        self.user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    return self.user;
}

- (void)saveUserInfoLocal:(ISGUserInfo *)userInfo {
    [self clearLocalUserInfo];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"user_tp.tmp"];
    [NSKeyedArchiver archiveRootObject:userInfo toFile:path];
}
#pragma mark - 读取账号
- (NSString *)localAccountName {
    if (_localAccountName == nil) {
        NSArray *accounts = [SAMKeychain accountsForService:[self getBundleId]];
        NSDictionary *dictionary = [accounts firstObject];
        NSString *name = [dictionary objectForKey:@"acct"];
        if (!name || name.length == 0) {
            _localAccountName = @"";
        } else {
            _localAccountName = name;
        }
    }
    return _localAccountName;
}

#pragma mark - 读取密码
- (NSString *)localAccountPwd {
    if (_localAccountPwd == nil) {
        _localAccountPwd = [[SAMKeychain passwordForService:[self getBundleId] account:self.localAccountName] copy];
    }
    return _localAccountPwd;
}

- (void)clearLocalUserInfo {
    self.user = nil;
    self.localAccountName = nil;
    self.localAccountPwd = nil;
}

#pragma mark - 获取Bundle ID
#pragma mark - private method
- (NSString *)getBundleId {
    
    NSString *bundleId = nil;
    bundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    return bundleId;
}
@end
