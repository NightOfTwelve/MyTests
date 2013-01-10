//
//  RMHeartbeatNewMessage.h
//  RMTinyClient
//
//  Created by renren on 12-4-28.
//  Copyright (c) 2012年 人人网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMHeartbeatNewMessage : NSObject {
    NSInteger gossipReplyCount;  ///留言回复数，未登录返回0
    NSInteger friendRequestCount;///好友请求数，未登录返回0
    NSInteger appInviteCount;    ///应用邀请数，未登录返回0
    NSInteger appPageFeedCount;  ///当前app的公共主页的是否有新的新鲜事，1是，0否
    NSInteger homeFeedCount;     ///当前用户是否有新的新鲜事，1是，0否
    NSInteger appActivityCount;     ///当前app是否有新的活动，1是，0否
    NSInteger appOfficialFeedCount;     ///当前app是否有新的新鲜事，1是，0否
}
@property (nonatomic ,assign) NSInteger gossipReplyCount;
@property (nonatomic ,assign) NSInteger friendRequestCount;
@property (nonatomic ,assign) NSInteger newsCount;
@property (nonatomic ,assign) NSInteger appInviteCount;
@property (nonatomic ,assign) NSInteger appPageFeedCount;
@property (nonatomic ,assign) NSInteger homeFeedCount;
@property (nonatomic ,assign) NSInteger appActivityCount;
@property (nonatomic ,assign) NSInteger appOfficialFeedCount;

@end
