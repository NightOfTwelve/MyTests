//
//  RMGetUserInfoContext.h
//  RMSDK
//
//  Created by renren on 11-10-20.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMCommonContextPublic.h"

typedef enum {
    RMUserGetInfoTypeNetwork = 0x1,              ///用户所属网络列表            the list of network where user belongs to.
    RMUserGetInfoTypeGender = 0x2,               ///性别                     gender
    RMUserGetInfoTypeBirth = 0x4,                ///生日                      birthday
    RMUserGetInfoTypeHometownProvince = 0x8,     ///家乡省直辖市                hometown province or municipalities
    RMUserGetInfoTypeHometownCity = 0x10,        ///家乡城市                   hometown city
    RMUserGetInfoTypeStatus = 0x20,              ///最新状态                   lately status
    RMUserGetInfoTypeIsFriend = 0x40,            ///与登录用户是否是好友          whether on the logged-on user's friends list
    RMUserGetInfoTypeVisitorCount = 0x80,        ///访问人数                   total number of visitors
    RMUserGetInfoTypeBlogCount = 0x100,          ///日志数                     total number of blogs
    RMUserGetInfoTypeAlbumCount = 0x200,         ///照片数                     total number of photos
    RMUserGetInfoTypeFriendCount = 0x400,        ///好友数                     total number of friends
    RMUserGetInfoTypeGossipCount = 0x800,        ///留言数                     total number of messages
    RMUserGetInfoTypeShareFriendCount = 0x1000   ///与登录用户的共同好友数         total number of the same friends with the logged-on user
}RMUserGetInfoType;                              /// 用于设置开放接口profile.getInfo所需字段值   used for required field values of open interfaces profile.getInfo 
@class RMGetUserInfoResponse;
@interface RMUserGetInfoContext : RMCommonContext
{
    NSInteger userId;
    NSInteger getInfoTypes;
    RMGetUserInfoResponse *response;   ///< 返回的结果   result return
}
/**
 *User ID ，Default: the Main User ID
 */

@property(nonatomic,assign)NSInteger userId;
/**
 *zh
 *type按位设置所需的字段，type为int型，将需要的字段按位取或即可得到所需的type值
 *
 *en
 *type set up the required field based on bit, the type of 'type' is int, you can get the value of the type you needed by bitwise OR the required field.
 *Defualt:getInfoTypes = RMUserGetInfoTypeNetwork + RMUserGetInfoTypeGender + RMUserGetInfoTypeBirth + 
 * RMUserGetInfoTypeHometownProvince + RMUserGetInfoTypeHometownCity + RMUserGetInfoTypeStatus + 
 * RMUserGetInfoTypeIsFriend + RMUserGetInfoTypeFriendCount + RMUserGetInfoTypeShareFriendCount;
 */
@property(nonatomic,assign)NSInteger getInfoTypes;

-(void)asynGetUserInfo; 
-(BOOL)synGetUserInfoError:(RMError **)error;
-(RMGetUserInfoResponse *)getContextResponse;
@end
