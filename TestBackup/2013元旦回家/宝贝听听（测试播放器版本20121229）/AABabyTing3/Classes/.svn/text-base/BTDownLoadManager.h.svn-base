//
//  BTDownLoadManager.h
//  AABabyTing3
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "BTProgressIndicator.h"
#import "BTDownLoadData.h"
#import "BTStory.h"


@protocol BTStroyProgressDelegate <NSObject>

- (void)setProgress:(float)newProgress story:(BTStory*)story;
- (void)storyDownloadStarted:(BTStory*)story;
- (void)storyDownloadFinished:(BTStory*)story;
- (void)storyDownloadError:(BTStory*)story;

@end

@interface BTDownLoadManager : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate,UIAlertViewDelegate>{
    
    ASIHTTPRequest *_currentRequest;
    ASINetworkQueue *_queue;
    //存放Story对象
    NSMutableArray *_downLoadingStorys;
    NSMutableArray *_localStorys;
    //End
    //存放Story对应的字典对象
    NSMutableArray *_downLoadingPlist;
    NSMutableArray *_localPlist;
    //End
    id<BTStroyProgressDelegate> _progressDelegate;
    BOOL _bIsLimitDownload;
    float originalProgressValue;            //进度条的起始值
}

@property(nonatomic,retain)ASIHTTPRequest *currentRequest;
@property(nonatomic,readonly)NSMutableArray *downLoadingStorys;
@property(nonatomic,readonly)NSMutableArray *localStorys;
@property(nonatomic,retain)ASINetworkQueue *queue;
@property(nonatomic,assign)id<BTStroyProgressDelegate> progressDelegate;
@property(nonatomic,assign)BOOL bIsLimitDownload;

+(BTDownLoadManager *)sharedInstance;
-(void)destorySharedInstance;
-(void)removeRequestFromQueue:(BTStory *)story;
-(void)addNewDownLoadTask:(BTStory *)story;
-(void)breakPointDownLoad;
-(void)pauseRequestWithStory:(BTStory *)story;
-(void)removeStoryFromLocal:(BTStory*)story;
-(void)swapLoaclStroyWithSourceIndex:(int)si andDestinationIndex:(int)di;
-(BOOL)isInMyStoryList:(BTStory*)story;
-(BOOL)isReachMaxLocalStoryCount;
-(BOOL)showDownloadAlert;
-(void)showNoNetWorkAlert;
-(BOOL)tryDownLoadCacheStory:(BTStory *)story;
@end
