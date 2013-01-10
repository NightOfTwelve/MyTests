//
//  BTDownLoadData.h
//  AABabyTing3
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTProgressIndicator.h"
#import "ASIHTTPRequest.h"
#import "BTStory.h"

@interface BTDownLoadData : NSObject{
    
}

@property (nonatomic,copy) NSString *downLoadName;
@property (nonatomic,copy) NSString *downLoadUrl;
@property (nonatomic,copy) NSString *albumName;
@property (nonatomic,copy) NSString *announcer;
@property (nonatomic,copy) NSString *length;
@property (nonatomic,retain) BTProgressIndicator *indicator;
@property (nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic,retain) BTStory *storyData;

@end
