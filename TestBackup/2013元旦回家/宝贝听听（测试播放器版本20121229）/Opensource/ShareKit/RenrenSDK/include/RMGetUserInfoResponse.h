//
//  RMGetUserInfoResponse.h
//  RMSDK
//
//  Created by Renren-inc on 11-10-26.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMObject.h"
@class RMUser;
@interface RMGetUserInfoResponse : RMResponse{
    RMUser *user;
}
@property(nonatomic,readonly)RMUser *user;
@end
