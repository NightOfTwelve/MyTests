//
//  BTSplashAction.m
//  闪屏相关文件。
//
//  Created by vicky on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
// =========================================
//  ** Import **
// =========================================
#import "BTSplashAction.h"
#import "BTCheckinManager.h"

// =========================================
//  ** BTSplashAction（Private） **
// =========================================
@interface BTSplashAction(){
}
@property(nonatomic, retain)	NSMutableDictionary *downloadSuccessDic;
- (NSArray *)needDownLoadSplashs:(NSArray *)allSplashInfos;	//筛选闪屏信息
@end

// =========================================
//  ** BTSplashAction **
// =========================================
@implementation BTSplashAction
/**
 * 初始化
 */
- (id)init{
    self= [super init];
    if(self){
        _splashService = [[BTSplashService alloc] init];	//初始化Service
		
		//监听service的requestFinished响应事件
		_splashService.requestCID = DOWNLOAD_SPLASH_NOTIFICATION;
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didFinishSplashDownload:) 
                                                     name:DOWNLOAD_SPLASH_NOTIFICATION 
                                                   object:_splashService];
		
        _splashInfos = [[BTCheckinManager shareInstance].splashs retain];	//获取checkin信息
        _downloadSplashIndex  = 0;											//初始默认获取闪屏为第一张图片
    }
    return self;
}

- (void)cancel{
    if(_splashService){
        _splashService.serviceDelegate = nil;
        [_splashService cancel];
        [_splashService release];
        _splashService = nil;
    }
}

/**
 * 监听service的requestFinished响应事件，下载图片，多张时发送第二张请求。
 */
- (void)didFinishSplashDownload:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSError *error		   = [super onError:userInfo];
    if(!error){
        NSData *imgData = [userInfo objectForKey:NOTIFICATION_PICDATA];
        NSMutableDictionary *splashInfo			 = [NSMutableDictionary dictionaryWithCapacity:0];
		NSString *plistFilePath = [BTUtilityClass fileWithPath:@"splash.plist"];
        if (!_downloadSuccessDic) {
			self.downloadSuccessDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistFilePath];
			if (!_downloadSuccessDic) {
				self.downloadSuccessDic = [NSMutableDictionary dictionary];
			}
		}
        [splashInfo setObject:[[_splashInfos objectAtIndex:_downloadSplashIndex] objectForKey:SPLASH_DOWNLOAD_URL]	forKey:SPLASH_DOWNLOAD_URL];
        [splashInfo setObject:[[_splashInfos objectAtIndex:_downloadSplashIndex] objectForKey:SPLASH_START_TIME]	forKey:SPLASH_START_TIME];
        [splashInfo setObject:[[_splashInfos objectAtIndex:_downloadSplashIndex] objectForKey:SPLASH_END_TIME]		forKey:SPLASH_END_TIME];
        NSString *key = [[[_splashInfos objectAtIndex:_downloadSplashIndex] objectForKey:SPLASH_ID] stringValue];
        [_downloadSuccessDic setObject:splashInfo forKey:key];
		NSString *splashId = [[[_splashInfos objectAtIndex:_downloadSplashIndex] objectForKey:SPLASH_ID] stringValue];
		
        NSString *fileName = [NSString stringWithFormat:@"splash/%@_splash.png",splashId];
        NSString *filePath = [BTUtilityClass fileWithPath:fileName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [imgData writeToFile:filePath atomically:YES];			//下载图片到splash文件夹
        }     
        
        _downloadSplashIndex++;
        if (_downloadSplashIndex < [_needDownloadSplashs count]) {	//多张图片情况
            [self downloadSplash];									//发送多张请求
        } else {
            NSString *plistPath = [BTUtilityClass fileWithPath:@"splash/splash.plist"];
            if ([_downloadSuccessDic writeToFile:plistPath atomically:YES]) {	//把请求到的闪屏信息写回到plist里
                //DLog(@"success");
            }else {
                //DLog(@"failing");
            }
            [(id)_actionDelegate didFinishGetSplashAction:nil];
        }   
    } else {
        [(id)_actionDelegate didGetSplashError:nil];
    }
}

/**
 * 多张闪屏时，向service发送多张请求。
 */
- (void)downloadSplash{
    //2012.12.03 nate add 函数多次调用造成内存泄漏
    //_needDownloadSplashs = [[NSArray alloc] initWithArray:[self needDownLoadSplashs:_splashInfos]];
    if (_needDownloadSplashs == nil) {
        _needDownloadSplashs = [[NSArray alloc] initWithArray:[self needDownLoadSplashs:_splashInfos]];
    }
    //2012.12.03 nate end
    if(_downloadSplashIndex < [_needDownloadSplashs count]){
        NSDictionary *splashInfo = [_needDownloadSplashs objectAtIndex:_downloadSplashIndex];
        [_splashService downloadSplash:splashInfo];
    }
}

/**
 * 筛选需要的闪屏信息。
 */
- (NSArray *)needDownLoadSplashs:(NSArray *)allSplashInfos{
    NSString *folderPath = [BTUtilityClass fileWithPath:@"splash"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [BTUtilityClass fileWithPath:@"splash/splash.plist"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		[dict writeToFile:plistPath atomically:YES];
	}
	//获取本地plist
	NSMutableDictionary *localSplashDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableArray *needDownloadSplashs = [NSMutableArray array];
    //本地有，服务器无：删除本地
	//本地有，服务器有：-
	//本地无，服务器无：-
	//本地无，服务器有：拉取
	//DLog(@"---local splash dic:%@",localSplashDic);
    //DLog(@"+++all splash info:%@",allSplashInfos);
	//本地无，服务器有：拉取
	for (int i = 0; i < [allSplashInfos count]; i ++) {//服务器
		NSDictionary *serverSplashItem = [allSplashInfos objectAtIndex:i];
		NSString *serverSplashId = [serverSplashItem objectForKey:@"id"];
		NSDictionary *localSplashItem = [localSplashDic objectForKey:serverSplashId];
		if (!localSplashItem) {//本地无，服务器有：拉取
			[needDownloadSplashs addObject:serverSplashItem];
		} else {
			NSString *filePath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"splash/%@_splash.png",serverSplashId]];
			if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {//本地plist里有记录，但图片文件不存在：拉取
				[needDownloadSplashs addObject:serverSplashItem];
			}
		}
	}
    
    //本地有，服务器无：删除本地
	for (NSString *localKey in [localSplashDic allKeys]) {
		BOOL hasRepeat = NO;
		for (NSDictionary *serverItem in allSplashInfos) {
			NSString *serverId = [[serverItem objectForKey:@"id"] stringValue];
			if ([serverId isEqualToString:localKey]) {
				hasRepeat = YES;
				break;
			}
		}
        
		if (!hasRepeat) {
			//删除本地对应的闪屏图片
			NSString *deleteFileName = [NSString stringWithFormat:@"splash/%@_splash.png",localKey];
			NSString *deletePath = [BTUtilityClass fileWithPath:deleteFileName];
			NSError *error = nil;
			[[NSFileManager defaultManager] removeItemAtPath:deletePath error:&error];
		}
	}
    return needDownloadSplashs;
}

/**
 * 从splashPlist里获取图片资源。
 */
+ (UIImage *)getSplashImage{
    NSDate *nowDate = [[NSDate alloc] init];
    double nowTimeDouble= [nowDate timeIntervalSince1970];
    [nowDate release];
    
    NSString *fileName  = @"splash/splash.plist";
    NSString *plistPath = [BTUtilityClass fileWithPath:fileName];
    NSString *picName = nil;
    NSDictionary *splashInfoDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *allkeys = [splashInfoDic allKeys];
	for(NSString *splashID in allkeys){
		NSDictionary *dic = [splashInfoDic objectForKey:splashID];
		NSString *startTime = [dic objectForKey:SPLASH_START_TIME];
		NSString *endTime = [dic objectForKey:SPLASH_END_TIME];
		double startTimeDouble = [startTime doubleValue];
		double endTimeDouble = [endTime doubleValue];
		if(nowTimeDouble >= startTimeDouble && nowTimeDouble <= endTimeDouble){
            NSString *fileName  = [NSString stringWithFormat:@"splash/%@_splash.png",splashID];
            picName = [BTUtilityClass fileWithPath:fileName];
			break;
		}
	}
    CDLog(BTDFLAG_SPLASH, @"splash file path = %@",picName);
	return [UIImage imageWithContentsOfFile:picName];	
}

// =========================================
//  ** 析构 **
// =========================================
/**
 * 析构。
 */
- (void)dealloc{
	self.downloadSuccessDic = nil;
    [_needDownloadSplashs	release];
    [_splashInfos			release];
    //2012.12.03 nate add 内存泄漏 类成员没有释放
    [_splashService release];
    [super					dealloc];
}
@end

