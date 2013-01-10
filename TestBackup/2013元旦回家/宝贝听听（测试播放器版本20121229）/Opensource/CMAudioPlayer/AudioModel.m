//
//  AudioModel.m
//  iPhoneStreamingPlayer
//
//  Created by RainMac on 12-3-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioModel.h"
#import "BTUtilityClass.h"
#import "BTConstant.h"
#import "BTStoryEncryAndDec.h"

NSString *AudioStreamPlayerAudioDidFinishLoadingNotification = @"AudioStreamPlayerAudioDidFinishLoadingNotification";

#define THREAD_CACHEPROCESS @"cacheProcess"

@interface AudioModel(Private)

-(BOOL)isNetUrl:(NSString *)urlString;
- (BOOL)isNewDesAlgorithm:(NSData *)data;
- (NSMutableDictionary *)composeDicWithData:(NSData *)data;

- (NSMutableDictionary *)transportWithDic:(NSMutableDictionary *)dic length:(int)length;

@end

@implementation AudioModel

@synthesize isSavingWhenPlaying;
@synthesize savingPath;
@synthesize decryptClass;
@synthesize decryptMethod;
@synthesize encryptClass;
@synthesize encryptMethod;
@synthesize isFinishLoading;
@synthesize cacheData;
@synthesize dataReceive;
@synthesize startPause;
@synthesize algorithmDic;
@synthesize allowCache = _allowCache;
- (float)loadingProgress {
    float prg;
    @synchronized (self) {
        prg =  (float)[_tempAudioData length]/fileLength*[self duration];
    }
    return prg;
}

- (void)savingPath:(NSString *)path {
    if (isSavingWhenPlaying) {
        savingPath = path;
    }
}

- (NSMutableDictionary *)transportWithDic:(NSMutableDictionary *)dic length:(int)length{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [resultDic setObject:[NSNumber numberWithInt:length] forKey:@"length"];
    return resultDic;
}

- (NSMutableDictionary *)composeDicWithData:(NSData *)data{
    int algorithm;
    int a ;
    int b ;
    int c ;
    if([self isNewDesAlgorithm:data]){
        Byte *dataByte = (Byte *)[data bytes];
        algorithm = dataByte[16];
        a = dataByte[17];
        b = dataByte[18];
        c = dataByte[19];
    }else{
        algorithm=0;
        a=0;
        b=0;
        c=0;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:a],
                                                                           [NSNumber numberWithInt:b],[NSNumber numberWithInt:c],[NSNumber numberWithInt:algorithm],nil]
                                                                  forKeys:[NSArray arrayWithObjects:@"a",@"b",@"c",@"algorithm", nil]];
    return  dic;
}

- (void)setURLString:(NSString *)urlString fileName:(NSString *)name {
    url = [urlString retain];
    dataReceive = NO;
    BOOL bIsNeedPauseDownloadQueue = NO;
    
    if ([self isNetUrl:url]) {
        self.cacheData = [[[NSMutableData alloc] init] autorelease];
        if (name != nil) {
            if (decryptClass && decryptMethod){
                _tempAudioData = [[NSMutableData alloc] initWithData:[decryptClass performSelector:decryptMethod withObject:[NSData dataWithContentsOfFile:name] withObject:[self composeDicWithData:[NSData dataWithContentsOfFile:name]]]];
            }else{
                _tempAudioData = [[NSMutableData alloc] initWithData:[NSData dataWithContentsOfFile:name]];
            }
            
            tmpDataLength = [_tempAudioData length];
            
            [cacheData initWithData:[NSData dataWithContentsOfFile:name]];
            
            self.algorithmDic = [self composeDicWithData:[NSData dataWithContentsOfFile:name]];
            
            int cacheDataSize = [cacheData length];
            
            //            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            //            NSString *documentsDirectory = [paths objectAtIndex:0];
            //            NSString *cacheFolder = @"cacheFolder/cache_";
            //            NSString *tempFilePath = [documentsDirectory stringByAppendingPathComponent:cacheFolder];
            
            NSString *tempFilePath = [BTUtilityClass fileWithCacheFolderPath:@"cache_"];
            NSString *fileTypeString = [name stringByReplacingOccurrencesOfString:tempFilePath withString:@""];
            fileTypeString = [fileTypeString substringToIndex:1];
            int fileType = [fileTypeString intValue];
            
            switch (fileType) {
                case High_Complete:{
                    fileLength = [_tempAudioData length];
                    [self start];
                }
                    break;
                case High_Incomplete:{
                    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
                    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
                    NSString *contentRange = [NSString stringWithFormat:@"bytes=%d-",cacheDataSize];
                    [request setValue:contentRange forHTTPHeaderField:@"Range"];
                    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                    bIsNeedPauseDownloadQueue = YES;
                }
                    break;
                case Low_Complete:{
                    fileLength = [_tempAudioData length];
                    [self start];
                }
                    break;
                case Low_Incomplete:{
                    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
                    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
                    NSString *contentRange = [NSString stringWithFormat:@"bytes=%d-",cacheDataSize];
                    [request setValue:contentRange forHTTPHeaderField:@"Range"];
                    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                    bIsNeedPauseDownloadQueue = YES;
                }
                    break;
                default:
                    break;
            }
            
        } else {
            
            _tempAudioData = [[NSMutableData alloc] init];
            
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                   timeoutInterval:20.0];
            
            connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            bIsNeedPauseDownloadQueue = YES;
        }
        
        
        
    } else {
        if (decryptClass && decryptMethod) {//如果传入类及方法，则进行解密处理]
            NSData *sourceData = [NSData dataWithContentsOfFile:urlString];
            _tempAudioData = [[NSMutableData alloc] initWithData:[decryptClass performSelector:decryptMethod withObject:sourceData withObject:[self transportWithDic:[self composeDicWithData:sourceData] length:0]]];
        } else {
            _tempAudioData = [[NSMutableData alloc] initWithContentsOfFile:urlString];
        }
        fileLength = [_tempAudioData length];
        isFinishLoading = YES;
        [self start];
    }
    
    
    if (bIsNeedPauseDownloadQueue) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_PAUSE_QUEUE object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_RESUME_QUEUE object:nil];
        
    }
}
//此处给录音用
- (void)playWithStoryData:(NSData *)data {
    _tempAudioData = [[NSMutableData alloc] initWithData:data];
    fileLength = [_tempAudioData length];
    isFinishLoading = YES;
    [self start];
}

-(void)stop{
	[super stop];
	[connection cancel];
}

- (void)dealloc {
    
    [cacheData release];
    [savingPath release];
	[url release];
    [algorithmDic release];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_RESUME_QUEUE object:nil];
	[super dealloc];
}

-(BOOL)isNetUrl:(NSString *)urlString {
    if ([urlString hasPrefix:@"http"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isNewDesAlgorithm:(NSData *)data{
    
    if (!data || [data length] == 0) {
        return NO;
    }
    
    Byte desTag[16] = {157,22,50,175,80,191,115,27,174,84,189,102,25,153,36,216};
    BOOL isNew = YES;
    Byte *dataByte = (Byte *)[data bytes];
    
    for(int i = 0;i<16; i++){
        if(dataByte[i]!=desTag[i]){
            isNew = NO;
        }
    }
    
    return isNew;
}

- (void)saveToFile {
    if (isSavingWhenPlaying) {
        @synchronized (self) {
            [[encryptClass performSelector:encryptMethod withObject:_tempAudioData] writeToFile:savingPath atomically:YES];
        }
    }
}

//故事缓存完成后重新命名
- (void)reNameCacheFile{
    
    NSString *src = savingPath;
	CDLog(BTDFLAG_AudioStreamer_Download, @"savingPath = %@",savingPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:src]) {
        return;
    }
    NSString *dest = nil;
    NSArray * components = [savingPath componentsSeparatedByString:@"_"];
	if (components.count < 3) {
		return;
	}
	
	//判断音频品质：1高品质未完成0高品质完成3低品质未完成2低品质完成
	
    NSString *typeString = components[1];
	NSArray *tmpArr = [components[2] componentsSeparatedByString:@"."];
	CDLog(BTDFLAG_AudioStreamer_Download,@"components[2]=%@,tmpArr=%@",components[2],tmpArr);
	if (tmpArr.count < 1) {
		return;
	}
	NSString *idString = tmpArr[0];
    int type = [typeString intValue];
	BOOL bNotif = NO;
    switch (type) {
        case 1:
            dest = [savingPath stringByReplacingOccurrencesOfString:@"_1_" withString:@"_0_"];
			bNotif = YES;
            break;
        case 3:
            dest = [savingPath stringByReplacingOccurrencesOfString:@"_3_" withString:@"_2_"];
            break;
        default:
            break;
    }
    NSData *srcData = [NSData dataWithContentsOfFile:src];
    if ([srcData length] >= fileLength && fileLength > 0&& isFinishLoading) {
        
        //        BOOL flag =
		BOOL bMove = [[NSFileManager defaultManager] moveItemAtPath:src toPath:dest error:nil];
#warning 给DownloadManager发通知
		if (bNotif && bMove) {
			[[NSNotificationCenter defaultCenter] postNotificationName:HIGH_QUALITY_AUDIO_FILE_CACHE_FINISHED_NOTIFICATION object:nil userInfo:@{	NOTIFICATION_STORY_ID : idString,
								   NOTIFICATION_STORY_CACHE_FILE_PATH : dest
			 }];
		}
        //        if (flag) {
        //            DLog(@"文件重命名成功 = %@",dest);
        //        }else{
        //            DLog(@"文件重命名失败 = %@",src);
        //        }
    }
    
}

#pragma mark Connection delegates

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    if (decryptClass && decryptMethod) {//如果传入类及方法，则进行解密处理
        if(!dataReceive){
            if(!self.algorithmDic){
                self.algorithmDic = [self composeDicWithData:data];
            }
        }
        @synchronized (self) {
            NSMutableDictionary *dic = [self transportWithDic:self.algorithmDic length:[cacheData length]];
            NSData *resultData = [decryptClass performSelector:decryptMethod withObject:data withObject:dic];
            [cacheData appendData:data];
            [_tempAudioData appendData:resultData];
        }
        
        
    }else {
        @synchronized (self) {
            //如果没有，则直接播放
            [_tempAudioData appendData:[NSData dataWithData:data]];
            NSData *newData = nil;
            if (encryptClass && encryptMethod) {
                newData = [encryptClass performSelector:encryptMethod withObject:data];
            } else {
                newData = data;
            }
            [cacheData appendData:newData];
        }
    }
    
    double calculatedBitRate = [self calculatedBitRate];
    if (calculatedBitRate <= 0.0 || calculatedBitRate > 128000) {
        calculatedBitRate = 64000;
    }
    
    if (startPause) {
        //DLog(@"duration:%f",self.duration);
        return;
    }

#warning 没看懂
    //DLog(@"HASStart");
    if (!dataReceive && [data length] > 0) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        dataReceive = YES;
    }
    
#warning 没看懂
    if (state == AS_PAUSED && pauseReason == AS_STOPPING_TEMPORARILY) {
        @synchronized (self) {
            if ((float)([_tempAudioData length] - _byteIndex) / calculatedBitRate > 0.62  || [_tempAudioData length] >= fileLength) {
                [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
            }
        }
    }
}


//- (void)removecacheStory:(NSString *)storyID cacheArr:(NSMutableArray *)cacheArr{
////    NSString *filepath = [BTUtilityClass fileWithCacheFolderPath:STORYCACHE_PLIST_NAME];
////    NSMutableArray *cacheStories = [NSMutableArray arrayWithContentsOfFile:filepath];
//    NSArray* files  = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[BTUtilityClass getStoryCacheFolderPath] error:nil]
//                       pathsMatchingExtensions:[NSArray arrayWithObject:@"mp3"]];
//    for (int i = 0;i < [files count]; i++){
//        NSString *fileName =[files objectAtIndex:i];
//        if([fileName hasSuffix:[NSString stringWithFormat:@"%@.mp3",storyID]]){
//
//            BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:[BTUtilityClass fileWithCacheFolderPath:fileName] error:nil];
//            if(flag&&[cacheArr count]>0){
//                [cacheArr removeObject:storyID];
//                return;
//                //[cacheStories writeToFile:filepath atomically:YES];
//            }
//        }
//    }
//}


// ****目的是把该ID的故事从缓存文件夹中删掉 （保证没有。）
- (BOOL)removecacheStory:(NSString *)storyID{
    //此处需要遍历，原因是只拿到故事的ID，文件系统中可能存在4种文件
    //分别是cache_0_id.mp3,cache_1_id.mp3,cache_2_id.mp3,cache_3_id.mp3.
    
    //1.先得到文件夹下所有mp3后缀的文件
    NSArray* files  = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[BTUtilityClass getStoryCacheFolderPath] error:nil]
                       pathsMatchingExtensions:[NSArray arrayWithObject:@"mp3"]];
    BOOL isSuccess = NO;
    //2.遍历找到后缀是storyID.mp3的故事.
    
    NSMutableArray *arr = [NSMutableArray array];
#warning 可能同时存在2个故事。。。
    for(int i = 0; i<[files count]; i++){
        NSString *fileName = [files objectAtIndex:i];
        if([fileName hasSuffix:[NSString stringWithFormat:@"_%@.mp3",storyID]]){
            NSString *willRemoveFileName = [NSString stringWithString:fileName];
            [arr addObject:willRemoveFileName];
        }
    }
    for(NSString *willRemoveFileName in arr){
        //3.删除对应的故事。 各种情况返回正确还是失败。
        if(willRemoveFileName != nil){
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[BTUtilityClass fileWithCacheFolderPath:willRemoveFileName]];
            if(isExist){
                BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:[BTUtilityClass fileWithCacheFolderPath:willRemoveFileName] error:nil];
                if(flag){//删除成功啦。
                    isSuccess = YES;
                }else{//删除失败。
                    isSuccess = NO;
                    break;
                }
            }else{//也是不存在
                isSuccess = YES;
            }
        }else{//不存在这个故事，自然认为删除成功
            isSuccess = YES;
        }
    }
    return isSuccess;
}


//BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[BTUtilityClass fileWithCacheFolderPath:fileName]];
//if(isExist){
//    
//}else{
//    
//}


- (void)addCacheStory:(NSString *)storyID cacheData:(NSData *)data filePath:(NSString *)savePath{
    NSString *filepath = [BTUtilityClass fileWithCacheFolderPath:STORYCACHE_PLIST_NAME];
    NSMutableArray *cacheStories = [NSMutableArray arrayWithContentsOfFile:filepath];
    if(!cacheStories){
        cacheStories = [NSMutableArray array];
    }
    BOOL flag = [data writeToFile:savePath atomically:YES];
    if(flag&&![cacheStories containsObject:storyID]){
        [cacheStories  addObject:storyID];
        [cacheStories writeToFile:filepath atomically:YES];
    }
}


//存储故事的缓存文件
-(void)saveDataToFile:(savingReason)reason{
    
    if(!self.allowCache){//不允许缓存
        return;
    }
    //尝试用大小比对来判断是缓冲完成还是切换故事来停止缓冲，但是失败，，，总是差28字节，，Neo
    if(!savingPath||savingPath == nil){
        return;
    }
    if(!isBrokenDownloads&&reason != Buffer_Complete){
        return;
    }
    //写缓存文件
    if (cacheData != nil) {
        //得到当前故事Id
        NSArray * components = [savingPath componentsSeparatedByString:@"_"];
        NSString *typeString = [components objectAtIndex:2];
        typeString = [typeString stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
        
        //本地缓存故事的plist
        NSString *filepath = [BTUtilityClass fileWithCacheFolderPath:STORYCACHE_PLIST_NAME];
        //需要写的文件的大小
        NSUInteger cacheDataLength = [cacheData length];
        NSMutableArray *cacheStories = [NSMutableArray arrayWithContentsOfFile:filepath];
        
        //如果本地空间小于100M的时候,清除前面的缓存故事
//        while ([BTUtilityClass getFreeDiskspace] - cacheDataLength<cacheDiskSpace) {
//            if([cacheStories count]==0){
//                break;
//            }else{
//                needUpadatePlist = YES;
//            
//                
//                if([self removecacheStory:[cacheStories objectAtIndex:0]]){
//                    [cacheStories removeObjectAtIndex:0];
//                }else{
//                    //会死循环？
//                    return;
//                }
//            }
//        }
//        if(needUpadatePlist){
//            [cacheStories writeToFile:filepath atomically:YES];
//        }
        //该变量表示删除失败的文件个数。  删除第一个失败之后，下次遍历的时候会删除第二个。删除成功后，该值保持不变。      ＊＊＊＊＊该值不可改为I
        int failCount = 0;
        BOOL needUpdatePlist = NO;
        for(int i = 0; i <MAX_CACHE_STORY_COUNT; i++){
            if([BTUtilityClass getFreeDiskspace] - cacheDataLength > cacheDiskSpace){
                break;
            }
            if([cacheStories count]>failCount){
                if([self removecacheStory:[cacheStories objectAtIndex:failCount]]){
                    needUpdatePlist = YES;
                    [cacheStories removeObjectAtIndex:failCount];
                }else{
                    failCount++;
                }
            }
        }
        
        if(needUpdatePlist){
            [cacheStories writeToFile:filepath atomically:YES];
        }
        
        

        
        //本地写数据
        if(!([BTUtilityClass getFreeDiskspace] - cacheDataLength<cacheDiskSpace)){
            
            //在plist中得到缓存的故事                                                                                                             量
            NSMutableArray *cacheStories = [NSMutableArray arrayWithContentsOfFile:filepath];
            
            if(![cacheStories containsObject:typeString]){
                if([cacheStories count]>=MAX_CACHE_STORY_COUNT){
                    //先删除第一个
                    NSString *delId = [cacheStories objectAtIndex:0];
                    BOOL flag = [self removecacheStory:delId];
                    if(flag){
                        [cacheStories removeObject:delId];
                    }else{
                        //会导致超出MAX_CACHE_STORY_COUNT。
                        //出问题了，那就不缓存了？？？
                        return;
                    }
                    [cacheStories writeToFile:filepath atomically:YES];
                }
                
            }
            [self addCacheStory:typeString cacheData:cacheData filePath:savingPath];
        }
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    dataReceive = NO;
    isFinishLoading = YES;
    [self saveDataToFile:Buffer_Complete];
    [self reNameCacheFile];
    [connection release];
	connection = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_RESUME_QUEUE object:nil];
    
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (error != nil) {
        [self performSelector:@selector(reAskConnect) withObject:self afterDelay:2.0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    self.httpHeaders = httpResponse.allHeaderFields;
    //DLog(@"Neo:add:%@",self.httpHeaders);
    @synchronized (self) {
        fileLength = [[httpHeaders objectForKey:@"Content-Length"] integerValue] + [_tempAudioData length];
        if([httpHeaders objectForKey:@"Content-Range"]){
            isBrokenDownloads = YES;
        }else{
            isBrokenDownloads = NO;
        }
    }
    
}
- (void)reAskConnect {
    @synchronized (self) {
        int cacheDataSize = [_tempAudioData length];
        [connection release];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        NSString *contentRange = [NSString stringWithFormat:@"bytes=%d-",cacheDataSize];
        [request setValue:contentRange forHTTPHeaderField:@"Range"];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}


- (NSUInteger)getTmpDataLength{
    return tmpDataLength;
}
@end
