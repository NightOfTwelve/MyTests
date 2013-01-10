//
//  RMUserObject.h
//  RMSDK
//
//  Created by Renren on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
typedef enum{
    RMGenderTyprUnknow = -1,        /// 性别未知
    RMGenderTypeWomen = 0,          /// 性别女
    RMGenderTypeMen = 1             /// 性别男
}RMGenderType;

@interface RMUserVisitors : RMItem {
    NSString *userId;               /// 用户id
    NSString *userName;             /// 用户名
    NSString *headUrl;              /// 用户头像URL地址
    NSString *time;                 /// 来访时间
    NSInteger isOnLine;             /// 用户是否在线，1表示在线
    RMGenderType gender;            /// 用户性别
    NSInteger isFriend;             /// 与登录用户是否是好友（1：是，0：不是）
    NSInteger shareFriendsCount;    /// 与登录用户的共同好友数
}
///
@property(nonatomic,readonly)NSString *userId;
@property(nonatomic,readonly)NSString *userName;
@property(nonatomic,readonly)NSString *headUrl;
@property(nonatomic,readonly)NSString *time;
@property(nonatomic,readonly)NSInteger isOnLine;
@property(nonatomic,readonly)RMGenderType gender;
@property(nonatomic,readonly)NSInteger isFriend;
@property(nonatomic,readonly)NSInteger shareFriendsCount;
@end


@interface RMUserIsOnline : RMItem {
    NSInteger isOnline;
    NSString *userId;
    
}
@property(nonatomic,readonly)NSInteger isOnline;
@property(nonatomic,readonly)NSString *userId;
@end