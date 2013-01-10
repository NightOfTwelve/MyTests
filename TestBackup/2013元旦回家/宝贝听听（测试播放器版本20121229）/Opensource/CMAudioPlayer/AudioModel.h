//
//  AudioModel.h
//  iPhoneStreamingPlayer
//
//  Created by RainMac on 12-3-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioStreamer.h"


typedef enum{
    Buffer_Complete,
    Buffer_Break
}savingReason;
@interface AudioModel : AudioStreamer {
    NSString            *url;
    NSMutableURLRequest *request;
	NSURLConnection     *connection;
    
    BOOL                isSavingWhenPlaying;
    NSString            *savingPath;
    Class               decryptClass;           //解密方法的类 如[DecryptClass class];如果没有加密，该参数填写 nil
    SEL                 decryptMethod;          //decryptClass中用于解密的类方法名 如@selector(decrypt:)
    Class               encryptClass;           //加密方法的类 如[DecryptClass class];如果没有加密，该参数填写 nil
    SEL                 encryptMethod;          //encryptClass中用于解密的类方法名 如@selector(encrypt:)
    BOOL                isFinishLoading;
    NSMutableData       *cacheData;
    BOOL                dataReceive;
    BOOL                startPause;
    NSTimer             *retryTimer;
    NSMutableDictionary *algorithmDic;
    
    BOOL                isBrokenDownloads;          //判断是否支持断点续传
    
    NSUInteger          tmpDataLength;              //用于计算节省的流量
    
    BOOL                _allowCache;                //用于区别故事是否允许缓存
}

@property (assign) BOOL     isSavingWhenPlaying;
@property (retain) NSString *savingPath;
@property (assign) Class    decryptClass; 
@property (assign) SEL      decryptMethod;
@property (assign) Class    encryptClass; 
@property (assign) SEL      encryptMethod;
@property (readonly) BOOL   isFinishLoading;
@property (retain) NSMutableData   *cacheData;
@property (assign) BOOL     dataReceive;
@property (assign) BOOL     startPause;
@property (retain) NSMutableDictionary *algorithmDic;
@property (assign) BOOL     allowCache;

- (void)setURLString:(NSString *)urlString fileName:(NSString *)name;
- (void)savingPath:(NSString *)path;            //Add for saving when playing is YES
- (float)loadingProgress;
-(void)saveDataToFile:(savingReason)reason;
- (void)reAskConnect;
- (void)playWithStoryData:(NSData *) data;

- (NSUInteger )getTmpDataLength;
extern NSString *AudioStreamPlayerAudioDidFinishLoadingNotification;

@end
