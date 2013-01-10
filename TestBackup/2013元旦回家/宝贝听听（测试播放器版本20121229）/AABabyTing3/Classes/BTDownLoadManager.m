//
//  BTDownLoadManager.m
//  AABabyTing3
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTDownLoadManager.h"
#import "LastSavedDateComparisonAndModification.h"
#import "BTDownLoadAlertView.h"
#import "BTConstant.h"

static BTDownLoadManager *sharedDownLoadManager = nil;
#define cleanCacheAlert   123
#define DOWNLOAD_PROGRESSE_VALUE_ICON                0.01f    //故事icon下载完成时进度条的百分比
#define DOWNLOAD_PROGRESSE_VALUE_PLAYVIEW            0.02f    //故事插图下载完成时进度条的百分比
#define DOWNLOAD_PROGRESSE_VALUE_DEFAULT             0.00f    //故事下载默认进度条的百分比

@interface BTDownLoadManager(Private)
- (void) addRequestToQueue:(BTStory*)story;
@end

@implementation BTDownLoadManager

@synthesize currentRequest = _currentRequest;
@synthesize downLoadingStorys = _downLoadingStorys;
@synthesize localStorys = _localStorys;
@synthesize progressDelegate = _progressDelegate;
@synthesize queue = _queue;
@synthesize bIsLimitDownload = _bIsLimitDownload;

-(void)dealloc{

    [_queue cancelAllOperations];
    [_queue release];
    _queue = nil;
    
    [_currentRequest release];
    
    [_downLoadingStorys release];
    [_localStorys release];
    
    [_downLoadingPlist release];
    [_localPlist release];
    
    _progressDelegate= nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

+(BTDownLoadManager *)sharedInstance{
    @synchronized(self){
        if (!sharedDownLoadManager) {
            sharedDownLoadManager = [[BTDownLoadManager alloc] init];
        }
    }
    return sharedDownLoadManager;
}

-(void)destorySharedInstance{
    [sharedDownLoadManager release];
    sharedDownLoadManager = nil;
}

-(id)init{
    self = [super init];
    if (self) {
        if (!_queue) {
            _queue = [[ASINetworkQueue alloc] init];
            [_queue cancelAllOperations];
            _queue.showAccurateProgress = YES;
            _queue.shouldCancelAllRequestsOnFailure = NO;
            _queue.maxConcurrentOperationCount = 1;
            [_queue go];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneHighQualityStoryHasBeenCached:) name:HIGH_QUALITY_AUDIO_FILE_CACHE_FINISHED_NOTIFICATION object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pauseDownloadQueue:)
                                                     name:NOTIFICATION_DOWNLOAD_PAUSE_QUEUE
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resumeDownloadQueue:)
                                                     name:NOTIFICATION_DOWNLOAD_RESUME_QUEUE
                                                   object:nil];
    }
    return self;
}

-(void)pauseDownloadQueue:(id)sender{
    self.bIsLimitDownload = YES;
}

-(void)resumeDownloadQueue:(id)sender{
    self.bIsLimitDownload = NO;
    [ASIHTTPRequest setMaxBandwidthPerSecond:0];
}

- (void)saveCacheFileToLibraryDocument:(NSString *)sourceFilePath withStory:(BTStory *)story {
	NSString *storyName = story.storyId;
	if (!sourceFilePath) {
		return;
	}
	CVLog(BTDFLAG_AudioStreamer_Download2, @"source = %@",sourceFilePath);
	NSString *folder = CACHES_DIRECTORY;
	if (folder) {
		NSString *destFilePath = [NSString stringWithFormat:@"%@/%@.mp3",folder,storyName];
		CVLog(BTDFLAG_AudioStreamer_Download2, @"dest = %@",destFilePath);
		NSError *error = nil;
		if (![[NSFileManager defaultManager] fileExistsAtPath:destFilePath]) {
			CDLog(BTDFLAG_AudioStreamer_Download2, @"Caches中不存在该mp3文件");
			if ([[NSFileManager defaultManager] copyItemAtPath:sourceFilePath toPath:destFilePath error:&error]) {
				CDLog(BTDFLAG_AudioStreamer_Download2, @"文件拷贝成功");
			} else {
				CELog(BTDFLAG_AudioStreamer_Download2, @"文件拷贝失败");
				CELog(BTDFLAG_AudioStreamer_Download2, @"错误信息：%@",error);
			}
		} else {
			CDLog(BTDFLAG_AudioStreamer_Download2, @"Caches中存在该mp3文件");
//			[self pauseRequestWithStory:story];
			if ([[NSFileManager defaultManager] removeItemAtPath:destFilePath error:&error]) {
				CDLog(BTDFLAG_AudioStreamer_Download2, @"文件删除成功");
				if ([[NSFileManager defaultManager] copyItemAtPath:sourceFilePath toPath:destFilePath error:&error]) {
					CDLog(BTDFLAG_AudioStreamer_Download2, @"文件拷贝成功");
				} else {
					CELog(BTDFLAG_AudioStreamer_Download2, @"文件拷贝失败");
					CELog(BTDFLAG_AudioStreamer_Download2, @"错误信息：%@",error);
				}
			} else {
				CELog(BTDFLAG_AudioStreamer_Download2, @"文件删除失败");
				CELog(BTDFLAG_AudioStreamer_Download2, @"错误信息：%@",error);
			}
//			[self startAllDownload];
		}
	}
}

//某个高品质音频缓冲完成后处理
- (void)oneHighQualityStoryHasBeenCached:(NSNotification *)notif {
	NSString *storyId = [notif.userInfo stringForKey:NOTIFICATION_STORY_ID];
	NSString *sourceFilePath = [notif.userInfo stringForKey:NOTIFICATION_STORY_CACHE_FILE_PATH];
	if (!storyId || !sourceFilePath) {
		return;
	}	
	BTStory *curStory = [[_currentRequest userInfo] valueForKey:@"story"];
	if ([curStory.storyId isEqualToString:storyId]) {//正在下载的故事
        [self removeRequestFromQueue:curStory];
        [self tryDownLoadCacheStory:curStory];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_MYSTORY_VIEW object:nil];
	}else{//等待和暂停的故事
        for (BTStory *story in _downLoadingStorys){
            if ([story.storyId isEqualToString:storyId]) {
                [self saveCacheFileToLibraryDocument:sourceFilePath withStory:story];
                break;
            }
        }
    }

}

- (NSMutableArray*)downLoadingStorys {
    if (_downLoadingStorys == nil) {
        _downLoadingStorys = [[NSMutableArray arrayWithCapacity:16] retain];
        NSString *downLoadPlistPath = [BTUtilityClass fileWithPath:DOWNLOAD_PLIST_NAME];
        _downLoadingPlist = [[NSMutableArray arrayWithContentsOfFile:downLoadPlistPath] retain];
        
        if (_downLoadingPlist == nil) {
            _downLoadingPlist = [[NSMutableArray arrayWithCapacity:16] retain];
        }
        
        for (NSDictionary *storyDict in _downLoadingPlist) {
			BTStory *story = [[BTStory alloc] initWithDictionary:storyDict];
            
            if (![_downLoadingStorys containsObject:story]) {
                [_downLoadingStorys addObject:story];
            }
            
            //这个方法先放这
            if (![BTUtilityClass checkIsWifiDownload]) {
//                [self addRequestToQueue:story];
                story.state = StoryStatePausing;
            }
            
            [story release];
        }
    }
    return _downLoadingStorys;
}

- (NSMutableArray*)localStorys {
    //315协议需求添加
    if (_localStorys) {
        [_localStorys release];
        _localStorys = nil;
    }
    //
    if (_localStorys == nil) {
        _localStorys = [[NSMutableArray arrayWithCapacity:16] retain];
        NSString *localPlistPath = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
        _localPlist = [[NSMutableArray arrayWithContentsOfFile:localPlistPath] retain];
        
        for (NSDictionary *storyDict in _localPlist) {
            BTStory *story = [[BTStory alloc] initWithDictionary:storyDict];
            
            [_localStorys addObject:story];
            [story release];
        }
    }
    return _localStorys;
}

- (void)saveDownLoadingPlist {
    NSString *downLoadPlistPath = [BTUtilityClass fileWithPath:DOWNLOAD_PLIST_NAME];
    [_downLoadingPlist writeToFile:downLoadPlistPath atomically:NO];
}

- (void)updateDownloadingPlist:(BTStory *)story{
    for (NSDictionary *dic in _downLoadingPlist) {
        if ([[dic objectForKey:KEY_STORY_ID] isEqualToString:story.storyId]) {
            [dic setValue:[NSNumber numberWithBool:story.iconHasExisted] forKey:KEY_STORY_ICON_HAS_EXISTED];
            [dic setValue:[NSNumber numberWithBool:story.playViewImageHasExisted] forKey:KEY_STORY_PLAYVIEW_IMAGE_HAS_EXISTED];
        }
    }
}

- (void)saveLocalPlist {
    NSString *localPlistPath = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
    [_localPlist writeToFile:localPlistPath atomically:NO];
}

- (void)addStoryToLocal:(BTStory*)story {
    //step1: add story to local plist
    NSMutableDictionary *storyDict = [story toDictionary];
    [_localPlist insertObject:storyDict atIndex:0];
    
    [self saveLocalPlist];
    //step2: add story to localStorys array
    [_localStorys addObject:story];
    
}

- (void)removeStoryFromLocal:(BTStory*)story {
    
    NSString *storyId = story.storyId;
    //step1: remove story from local plist
    NSMutableDictionary *storyDictToRemove = nil;
    for (NSMutableDictionary *storyDict in _localPlist) {
        NSString *tempId = [storyDict objectForKey:KEY_STORY_ID];
        if ([tempId isEqualToString:storyId]) {
            storyDictToRemove = storyDict;
            break;
        }
    }
    
    NSString *fileName = [storyDictToRemove objectForKey:KEY_STORY_ID];
    NSString *filePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@.mp3",fileName]];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    [_localPlist removeObject:storyDictToRemove];
    [self saveLocalPlist];
    [self removeDownloadStoryPic:story];
    [_localStorys removeObject:story];
    
}

- (void)addStoryToDownLoading:(BTStory*)story {
    
    //step1: add story to downloading plist
    //给下载的故事添加加入下载队列的时间戳
    story.downloadStamp = [[NSDate date] timeIntervalSince1970];
    story.isUpdated = YES;
    NSMutableDictionary *storyDict = [story toDictionary];
    [_downLoadingPlist addObject:storyDict];
    [self saveDownLoadingPlist];
    
    //step2: add story to downloadingStorys array
    [_downLoadingStorys addObject:story];    
}

- (void)swapLoaclStroyWithSourceIndex:(int)si andDestinationIndex:(int)di{
    
    BTStory *story = [_localStorys objectAtIndex:si];
    [story retain];
    [_localStorys removeObjectAtIndex:si];
    [_localStorys insertObject:story atIndex:di];
    [story release];
    
    NSMutableDictionary *dic = [_localPlist objectAtIndex:si];
    [dic retain];
    [_localPlist removeObjectAtIndex:si];
    [_localPlist insertObject:dic atIndex:di];
    [dic release];
    
    [self saveLocalPlist];
    
}

- (void)removeStoryFromDownLoading:(BTStory*)story {
    NSString *storyId = story.storyId;
    //step1: remove story from downloading plist
    NSMutableDictionary *storyDictToRemove = nil;
    for (NSMutableDictionary *storyDict in _downLoadingPlist) {
        NSString *tempId = [storyDict objectForKey:KEY_STORY_ID];
        if ([tempId isEqualToString:storyId]) {
            storyDictToRemove = storyDict;
            break;
        }
    }

    NSString *fileName = [storyDictToRemove objectForKey:KEY_STORY_ID];
    NSString *filePath = [CACHES_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",fileName]];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    [_downLoadingPlist removeObject:storyDictToRemove];
    [self saveDownLoadingPlist];
    
    //step2: remove story from downloadingStorys array
    [_downLoadingStorys removeObject:story];
    
}

-(NSString *)actualSavePath:(NSString*)name {
    NSString *savePath = [BTUtilityClass getBabyStoryFolderPath];
    return [savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", name]];
}

-(NSString *)cachesPath:(NSString*)name{
    NSString *tempPath = [CACHES_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", name]];
    return tempPath;
}

-(BOOL)isInMyStoryList:(BTStory*)story {
    //因为重写了BTStory的isEqual和Hash方法
    if ([_downLoadingStorys containsObject:story]) {
        return YES;
    } else if([_localStorys containsObject:story]) {
        return YES;
    }
    return NO;
}

-(BOOL)isReachMaxLocalStoryCount {
    
//    NSNumber *numMaxLocal = [BTUserDefaults valueForKey:CONFIGURATION_MAX_LOCAL_STORY];
//	if (nil == numMaxLocal) {
//		[BTUserDefaults setInteger:100
//							forKey:CONFIGURATION_MAX_LOCAL_STORY];//默认为100首上限
//	}
    
    [BTUtilityClass configeMaxLocalStoriesCount];
    
    int maxCount = [[BTUserDefaults valueForKey:CONFIGURATION_MAX_LOCAL_STORY] intValue];
    //    DLog(@"maxCount = %d",maxCount);
    
    if ([_downLoadingStorys count] + [_localStorys count] < maxCount) {
        return YES;
    }
    return NO;
}

#pragma mark ASIProgressDelegate
- (void)setProgress:(float)newProgress {
    
    float progressValue = newProgress * (1 - originalProgressValue) + originalProgressValue;

    if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(setProgress:story:)]&& _currentRequest) {
        BTStory *story = [_currentRequest.userInfo objectForKey:@"story"];
        story.tempProgress = progressValue;
        [_progressDelegate setProgress:progressValue story:story];
    }
}
#pragma mark -
   
#pragma mark ASIRequestDelegate

-(void)requestStarted:(ASIHTTPRequest *)request{
    self.currentRequest = request;
    BTStory *story = [request.userInfo objectForKey:@"story"];
    if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(storyDownloadStarted:)]) {
        story.state = StoryStateDownLoading;
        [_progressDelegate storyDownloadStarted:story];
    }
    
    
    if (request.tag == StoryPicIcon) {
        //复制故事插图到babyStroy文件夹
        NSString *picSrcFilePath = [NSString stringWithFormat:@"%@/%@%@",THREE20_DIRECTORY,story.storyId,
                                    [BTUtilityClass getPicSuffix:type_story_playView picVersion:story.picversion]];
        NSString *picDstFilePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@_storyPlayView",story.storyId]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:picSrcFilePath]) {
            BOOL flag = [[NSFileManager defaultManager] copyItemAtPath:picSrcFilePath toPath:picDstFilePath error:nil];
            if (flag) {
                [request clearDelegatesAndCancel];
                CDLog(BTDFLAG_DOWNLOAD,@"复制icon到document目录,storyId = %@",story.storyId);
            }
        }
    } else if (request.tag == StoryPicPlayView) {
        //复制故事icon到babyStroy文件夹
        NSString *iconSrcFilePath = [NSString stringWithFormat:@"%@/%@%@",THREE20_DIRECTORY,story.storyId,
                                     [BTUtilityClass getPicSuffix:type_story_icon picVersion:story.picversion]];
        NSString *iconDstFilePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@_storyIcon",story.storyId]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:iconSrcFilePath]) {
            BOOL flag = [[NSFileManager defaultManager] copyItemAtPath:iconSrcFilePath toPath:iconDstFilePath error:nil];
            if (flag) {
                [request clearDelegatesAndCancel];
                CDLog(BTDFLAG_DOWNLOAD,@"复制插图到document目录,storyId = %@",story.storyId);

            }
        }
    }

    //
    NSString *iconImagePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@_storyIcon",story.storyId]];
    NSString *playViewImagePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@_storyPlayView",story.storyId]];
    BOOL iconExist = [[NSFileManager defaultManager] fileExistsAtPath:iconImagePath];
    BOOL playViewExist = [[NSFileManager defaultManager] fileExistsAtPath:playViewImagePath];
    
    if (iconExist && !playViewExist) {
        originalProgressValue = DOWNLOAD_PROGRESSE_VALUE_ICON;
    } else if (iconExist && playViewExist){
        originalProgressValue = DOWNLOAD_PROGRESSE_VALUE_PLAYVIEW;
    } else if (!iconExist && playViewExist){
        originalProgressValue = DOWNLOAD_PROGRESSE_VALUE_PLAYVIEW - DOWNLOAD_PROGRESSE_VALUE_ICON;
    } else{
        originalProgressValue = DOWNLOAD_PROGRESSE_VALUE_DEFAULT;
    }

    if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(setProgress:story:)]&& _currentRequest) {
        story.tempProgress = originalProgressValue;
        [_progressDelegate setProgress:originalProgressValue story:story];
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    _currentRequest = nil;
    BTStory *story = [request.userInfo objectForKey:@"story"];
    
    if (request.tag == StoryPicIcon) {
        story.iconHasExisted = YES;
        [self updateDownloadingPlist:story];
        [self saveDownLoadingPlist];
    } else if (request.tag == StoryPicPlayView){
        story.playViewImageHasExisted = YES;
        [self updateDownloadingPlist:story];
        [self saveDownLoadingPlist];
    } else {
        story.state = StoryStateFinished;
        [self addStoryToLocal:story];
        [self removeStoryFromDownLoading:story];
        
        if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(storyDownloadFinished:)]) {
            [_progressDelegate storyDownloadFinished:story];
        }
        originalProgressValue = DOWNLOAD_PROGRESSE_VALUE_DEFAULT;
    }

}

-(void)requestFailed:(ASIHTTPRequest *)request{
    BTStory *story = [request.userInfo objectForKey:@"story"];
    if (request.tag == StoryPicIcon) {
        CDLog(BTDFLAG_DOWNLOAD,@"故事icon下载失败 storyId = %@,",story.storyId);
    } else if (request.tag == StoryPicPlayView){
        CDLog(BTDFLAG_DOWNLOAD,@"故事插图下载失败 storyId = %@,",story.storyId);
    } else {
        CDLog(BTDFLAG_DOWNLOAD,@"故事音频下载失败 storyId = %@,",story.storyId);
        story.state = StoryStateFailed;
        if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(storyDownloadError:)]) {
            [_progressDelegate storyDownloadError:story];
        }
    }
    _currentRequest = nil;

}
#pragma mark -

//统计下载次数 by Zero
-(void)downloadCountStatistics:(BTStory *)oneStory{
	NSString *storyId = oneStory.storyId;
	NSString *storyName = oneStory.title;
	
	//长度不合法（空），就不统计啦:P
	if ([storyId length] < 1 || [storyName length] < 1) {
		return;
	}
	
	NSString *key = [NSString stringWithFormat:@"BabyTing_S_%@_%@",storyName,storyId];
	NSString *filePath = [BTUtilityClass fileWithPath:STORY_DOWNED_COUNT_PLIST_NAME];
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	if (nil == dic) {
		//貌似是多余的，保险一下而已^_^
		dic = [NSMutableDictionary dictionary];
		[dic writeToFile:filePath atomically:YES];
	}
	int cnt = [[dic valueForKey:key] intValue];
	cnt++;
	NSNumber *value = [NSNumber numberWithInt:cnt];
	[dic setValue:value forKey:key];
	[dic writeToFile:filePath atomically:YES];
}
//下载的错误提示
-(BOOL)showDownloadAlert{
    int alertButtonNum = 0;
    BOOL bIsApearAlert = NO;
    NSString *alertString = nil;
    NSString *alertMessage = nil;
    double cacheTotalcapacity = [BTUtilityClass getCacheTotalCapacity];
    if([BTUtilityClass getFreeDiskspace] < MinDiskSpace&&cacheTotalcapacity>=cacheSpaceUpline){
        alertString = @"存储空间不足";
        alertMessage = @"您的本地存储空间已不足100MB，为保证下载，去清理一下本地缓存吧~";
        bIsApearAlert = YES;
        alertButtonNum = 2;
    }
    else if ([BTUtilityClass getFreeDiskspace] < MinDiskSpace&&cacheTotalcapacity <cacheSpaceUpline){
           // &&cacheTotalcapacity <cacheSpaceUpline) { 这个判断是为了清除缓存时候加的条件。
        alertString = @"哎呀，设备空间已满啦，删除一些内容后继续下载吧!";
        bIsApearAlert = YES;
        alertButtonNum = 1;
    } else if(![[BTDownLoadManager sharedInstance] isReachMaxLocalStoryCount]) {
        alertString = [NSString stringWithFormat:@"最多可下载%@个故事哦，删除\n一些故事后继续下载吧!",[BTUserDefaults valueForKey:CONFIGURATION_MAX_LOCAL_STORY]];
        bIsApearAlert = YES;
        alertButtonNum = 1;
    }
    
    if (bIsApearAlert) {
        if(alertButtonNum == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil,nil];
            [alert show];
            [alert release];
        }
        else if(alertButtonNum == 2){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString
                                                            message:alertMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"设置",nil];
            alert.delegate = self;
            alert.tag = cleanCacheAlert;
            [alert show];
            [alert release];
        }
    }
    return bIsApearAlert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == cleanCacheAlert){
        if(buttonIndex == 1){
            CDLog(Neoadd,@"helloworld");
            BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate jumpToSetUpController];
        }
    }
}
//无网络提示
-(void)showNoNetWorkAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络读取失败"
                                                    message:@"当前无网络，请联网后重试。"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
}
//添加一条新下载任务
-(void)addNewDownLoadTask:(BTStory *)story{
    
    BOOL isInCache = [self tryDownLoadCacheStory:story];
    
    if (![self isInMyStoryList:story]) {
        [self addStoryToDownLoading:story];
    }
    
    if (!isInCache) {
        [self downloadCountStatistics:story];
        if (![BTUtilityClass checkIsWifiDownload]) {
            [self addRequestToQueue:story];
        }
    }
    
}

//删除下载到本地的故事icon和插图
-(void)removeDownloadStoryPic:(BTStory *)story {
    NSString *iconImagePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@_storyIcon",story.storyId]];
    NSString *playViewImagePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@_storyPlayView",story.storyId]];
    [[NSFileManager defaultManager] removeItemAtPath:iconImagePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:playViewImagePath error:nil];
}

//故事图片的请求
-(void)addPicTaskToQueue:(BTStory *)story withType:(StoryPicType)type {
    NSString *picUrlString = nil;
    NSString *fileName = nil;
    
    if (type == StoryPicIcon) {
        picUrlString = story.iconURL;
        fileName = [NSString stringWithFormat:@"%@_storyIcon",story.storyId];
    } else if (type == StoryPicPlayView){
        picUrlString = [story.picDownLoadURLs objectAtIndex:0];
        fileName = [NSString stringWithFormat:@"%@_storyPlayView",story.storyId];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:[BTUtilityClass fileWithPath:fileName]]) {
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:picUrlString]];
        request.downloadDestinationPath = [BTUtilityClass fileWithPath:fileName];
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:story,@"story",nil];
        request.delegate = self;
        request.tag = type;
        [_queue addOperation:request];
    }
    
}

//向请求队列中添加一个请求
-(void)addRequestToQueue:(BTStory*)story {
    if (_bIsLimitDownload) {
        [ASIHTTPRequest setMaxBandwidthPerSecond:MAX_DOWNLOAD_BANDWIDTH_PER_SECOND];
    }
    
    [self addPicTaskToQueue:story withType:StoryPicIcon];
    [self addPicTaskToQueue:story withType:StoryPicPlayView];
    
    NSURL *url = [NSURL URLWithString:story.highAudioDownLoadUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc ] initWithURL:url];
    request.delegate = self;
    request.temporaryFileDownloadPath = [self cachesPath:story.storyId];
    request.downloadDestinationPath = [self actualSavePath:story.storyId];
    request.downloadProgressDelegate = self;
    request.allowResumeForFileDownloads = YES;
    request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:story, @"story", nil];
    [_queue addOperation:request];
    [request release];
    story.state = StoryStateWaiting;
    story.tempProgress = 0.0f;
}

//断点下载
-(void)breakPointDownLoad{
    //触发下载
    [self downLoadingStorys];
    [self localStorys];
}

//取消故事icon、插图、音频的请求
-(void)cancelStoryRequestFromQueue:(BTStory *)story{
    NSArray *operations = [[_queue operations] copy];
    NSMutableArray *cancelRequests = [NSMutableArray array];
    for (ASIHTTPRequest *request in operations) {
        BTStory *requestStory = [request.userInfo objectForKey:@"story"];
        if (requestStory == story) {
            [cancelRequests addObject:request];
        }
    }
 
    for (ASIHTTPRequest *request in cancelRequests) {
        [request clearDelegatesAndCancel];
    }
    
    [operations release];
}

//删除一条下载任务
-(void)removeRequestFromQueue:(BTStory *)story{
    
    //取消下载请求
    [self cancelStoryRequestFromQueue:story];
    
    //下载列表中删除下任务
    [self removeStoryFromDownLoading:story];
    
    //删除已下载的故事图片
    [self removeDownloadStoryPic:story];
}

//暂停一下载任务
-(void)pauseRequestWithStory:(BTStory*)story {
    [self cancelStoryRequestFromQueue:story];
}

//将缓存的文件复制到下载文件夹   目的是是否将缓存文件拷贝到本地目录
-(BOOL)tryDownLoadCacheStory:(BTStory *)story {

    if ([self isInMyStoryList:story]) {
        return NO;
    }
    
    NSString *storyID = story.storyId;
    NSString *cachefilePath = [BTUtilityClass fileWithCacheFolderPath:STORYCACHE_PLIST_NAME];
    NSMutableArray *cacheStories = [NSMutableArray arrayWithContentsOfFile:cachefilePath];
    BOOL isSuccess  = NO;
    //plist中没有该故事
    if([cacheStories containsObject:storyID]){
        NSString *cacheName = @"cache_0_";
        NSString *mp3Name = [cacheName stringByAppendingString:story.storyId];
        NSString *mp3FilePath = [NSString stringWithFormat:@"%@/%@.mp3",[BTUtilityClass getStoryCacheFolderPath],mp3Name];
        BOOL isExistFile = [[NSFileManager defaultManager] fileExistsAtPath:mp3FilePath];
        if(isExistFile){//plist中有，但是实际上文件中没有
            NSString *targetPath = [BTUtilityClass getBabyStoryFolderPath];
            targetPath = [NSString stringWithFormat:@"%@/%@.mp3",targetPath,story.storyId];
            BOOL flag = [[NSFileManager defaultManager] copyItemAtPath:mp3FilePath toPath:targetPath error:nil];
            if(flag){//copy成功，才算真正的成功
                story.downloadStamp = [[NSDate date] timeIntervalSince1970];
                [self addStoryToLocal:story];
                isSuccess = YES;
            }
        }

        //复制故事插图到babyStroy文件夹
        NSString *picSrcFilePath = [NSString stringWithFormat:@"%@/%@%@",THREE20_DIRECTORY,story.storyId,
                              [BTUtilityClass getPicSuffix:type_story_playView picVersion:story.picversion]];
        NSString *picDstFilePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@_storyPlayView",story.storyId]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:picSrcFilePath]) {
            [[NSFileManager defaultManager] copyItemAtPath:picSrcFilePath toPath:picDstFilePath error:nil];
        }
        
        //复制故事icon到babyStroy文件夹
        NSString *iconSrcFilePath = [NSString stringWithFormat:@"%@/%@%@",THREE20_DIRECTORY,story.storyId,
                                    [BTUtilityClass getPicSuffix:type_story_icon picVersion:story.picversion]];
        NSString *iconDstFilePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@_storyIcon",story.storyId]];

        if ([[NSFileManager defaultManager] fileExistsAtPath:iconSrcFilePath]) {
            [[NSFileManager defaultManager] copyItemAtPath:iconSrcFilePath toPath:iconDstFilePath error:nil];
        }
    }

    return isSuccess;
}
@end
