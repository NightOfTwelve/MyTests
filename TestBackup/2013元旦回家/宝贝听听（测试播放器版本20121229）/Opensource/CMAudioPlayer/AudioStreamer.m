//
//  AudioStreamer.m
//  StreamingAudioPlayer
//
//  Created by Matt Gallagher on 27/09/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

//static int idx = 0;
//#define Log DLog(@"th = %d, idx=%d, fun:%s",[NSThread isMainThread],idx++,__FUNCTION__);
#define Log ((void)0);
#import "BTConstant.h"
#import "AudioStreamer.h"
#if TARGET_OS_IPHONE
#import <CFNetwork/CFNetwork.h>
#import "UIDevice+Hardware.h"
#define kCFCoreFoundationVersionNumber_MIN 550.32
#else
#define kCFCoreFoundationVersionNumber_MIN 550.00
#endif

#define BitRateEstimationMaxPackets 5000
#define BitRateEstimationMinPackets 50

NSString * const ASStatusChangedNotification = @"ASStatusChangedNotification";
NSString * const ASPresentAlertWithTitleNotification = @"ASPresentAlertWithTitleNotification";
#ifdef SHOUTCAST_METADATA
NSString * const ASUpdateMetadataNotification = @"ASUpdateMetadataNotification";
#endif


#if TARGET_OS_IPHONE
static AudioStreamer *__streamer = nil;
#endif

NSString * const AS_NO_ERROR_STRING = @"No error.";
NSString * const AS_FILE_STREAM_GET_PROPERTY_FAILED_STRING = @"File stream get property failed.";   //文件流属性失败
NSString * const AS_FILE_STREAM_SEEK_FAILED_STRING = @"File stream seek failed.";                   //文件流寻找失败
NSString * const AS_FILE_STREAM_PARSE_BYTES_FAILED_STRING = @"Parse bytes failed.";                 //解析字节失败
NSString * const AS_FILE_STREAM_OPEN_FAILED_STRING = @"Open audio file stream failed.";             //打开音频文件流失败
NSString * const AS_FILE_STREAM_CLOSE_FAILED_STRING = @"Close audio file stream failed.";           //关闭音频文件流失败
NSString * const AS_AUDIO_QUEUE_CREATION_FAILED_STRING = @"Audio queue creation failed.";           //音频队列创建失败
NSString * const AS_AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED_STRING = @"Audio buffer allocation failed.";   //音频缓冲区分配失败
NSString * const AS_AUDIO_QUEUE_ENQUEUE_FAILED_STRING = @"Queueing of audio buffer failed.";        //音频缓冲排队的失败
NSString * const AS_AUDIO_QUEUE_ADD_LISTENER_FAILED_STRING = @"Audio queue add listener failed.";   //音频队列添加侦听器失败
NSString * const AS_AUDIO_QUEUE_REMOVE_LISTENER_FAILED_STRING = @"Audio queue remove listener failed."; //音频队列中删除监听器失败
NSString * const AS_AUDIO_QUEUE_START_FAILED_STRING = @"Audio queue start failed.";                 //音频队列启动失败
NSString * const AS_AUDIO_QUEUE_BUFFER_MISMATCH_STRING = @"Audio queue buffers don't match.";       //音频队列缓冲区不匹配
NSString * const AS_AUDIO_QUEUE_DISPOSE_FAILED_STRING = @"Audio queue dispose failed.";             //音频队列处理失败
NSString * const AS_AUDIO_QUEUE_PAUSE_FAILED_STRING = @"Audio queue pause failed.";                 //音频队列暂停失败
NSString * const AS_AUDIO_QUEUE_STOP_FAILED_STRING = @"Audio queue stop failed.";                   //音频队列停止失败
NSString * const AS_AUDIO_DATA_NOT_FOUND_STRING = @"No audio data found.";                          //没有音频数据
NSString * const AS_AUDIO_QUEUE_FLUSH_FAILED_STRING = @"Audio queue flush failed.";                 //音频队列刷新失败
NSString * const AS_GET_AUDIO_TIME_FAILED_STRING = @"Audio queue get current time failed.";         //音频队列中获取当前时间失败
NSString * const AS_AUDIO_STREAMER_FAILED_STRING = @"Audio playback failed";                        //音频回放失败
NSString * const AS_NETWORK_CONNECTION_FAILED_STRING = @"Network connection failed";                //网络连接失败
NSString * const AS_AUDIO_BUFFER_TOO_SMALL_STRING = @"Audio packets are larger than kAQDefaultBufSize.";    //音频的数据包大于kAQDefaultBufSize




@interface AudioStreamer ()
@property (nonatomic, readwrite) AudioStreamerState state;

- (void)handlePropertyChangeForFileStream:(AudioFileStreamID)inAudioFileStream
                     fileStreamPropertyID:(AudioFileStreamPropertyID)inPropertyID
                                  ioFlags:(UInt32 *)ioFlags;
- (void)handleAudioPackets:(const void *)inInputData
               numberBytes:(UInt32)inNumberBytes
             numberPackets:(UInt32)inNumberPackets
        packetDescriptions:(AudioStreamPacketDescription *)inPacketDescriptions;
- (void)handleBufferCompleteForQueue:(AudioQueueRef)inAQ
                              buffer:(AudioQueueBufferRef)inBuffer;
- (void)handlePropertyChangeForQueue:(AudioQueueRef)inAQ
                          propertyID:(AudioQueuePropertyID)inID;

#if TARGET_OS_IPHONE
- (void)handleInterruptionChangeToState:(AudioQueuePropertyID)inInterruptionState;
#endif

- (void)internalSeekToTime:(double)newSeekTime;
- (void)enqueueBuffer;



@end

#pragma mark Audio Callback Function Prototypes

void MyAudioQueueOutputCallback(void* inClientData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer);
void MyAudioQueueIsRunningCallback(void *inUserData, AudioQueueRef inAQ, AudioQueuePropertyID inID);
void MyPropertyListenerProc(	void *							inClientData,
                            AudioFileStreamID				inAudioFileStream,
                            AudioFileStreamPropertyID		inPropertyID,
                            UInt32 *						ioFlags);
void MyPacketsProc(				void *							inClientData,
                   UInt32							inNumberBytes,
                   UInt32							inNumberPackets,
                   const void *					inInputData,
                   AudioStreamPacketDescription	*inPacketDescriptions);
OSStatus MyEnqueueBuffer(AudioStreamer* myData);

#if TARGET_OS_IPHONE
void MyAudioSessionInterruptionListener(void *inClientData, UInt32 inInterruptionState);
#endif

#pragma mark Audio Callback Function Implementations

//
// MyPropertyListenerProc
//
// Receives notification when the AudioFileStream has audio packets to be
// played. In response, this function creates the AudioQueue, getting it
// ready to begin playback (playback won't begin until audio packets are
// sent to the queue in MyEnqueueBuffer).
//
// This function is adapted from Apple's example in AudioFileStreamExample with
// kAudioQueueProperty_IsRunning listening added.
//
void MyPropertyListenerProc(	void *							inClientData,
                            AudioFileStreamID				inAudioFileStream,
                            AudioFileStreamPropertyID		inPropertyID,
                            UInt32 *						ioFlags)
{
	ZLog(@"MyPropertyListenerProc");
	// this is called by audio file stream when it finds property values
	AudioStreamer* streamer = (AudioStreamer *)inClientData;
	[streamer
     handlePropertyChangeForFileStream:inAudioFileStream
     fileStreamPropertyID:inPropertyID
     ioFlags:ioFlags];
}

//
// MyPacketsProc
//
// When the AudioStream has packets to be played, this function gets an
// idle audio buffer and copies the audio packets into it. The calls to
// MyEnqueueBuffer won't return until there are buffers available (or the
// playback has been stopped).
//
// This function is adapted from Apple's example in AudioFileStreamExample with
// CBR functionality added.
//AudioFileStream有音频数据包
//函数创建的AudioQueue，得到它准备开始播放
void MyPacketsProc(				void *							inClientData,
                   UInt32							inNumberBytes,
                   UInt32							inNumberPackets,
                   const void *					inInputData,
                   AudioStreamPacketDescription	*inPacketDescriptions)
{
	ZLog(@"MyPacketsProc");
	// this is called by audio file stream when it finds packets of audio
	AudioStreamer* streamer = (AudioStreamer *)inClientData;
	[streamer
     handleAudioPackets:inInputData
     numberBytes:inNumberBytes
     numberPackets:inNumberPackets
     packetDescriptions:inPacketDescriptions];
}

//
// MyAudioQueueOutputCallback
//
// Called from the AudioQueue when playback of specific buffers completes. This
// function signals from the AudioQueue thread to the AudioStream thread that
// the buffer is idle and available for copying data.
//
// This function is unchanged from Apple's example in AudioFileStreamExample.
//播放特定的缓冲区完成后调用
void MyAudioQueueOutputCallback(	void*					inClientData,
                                AudioQueueRef			inAQ,
                                AudioQueueBufferRef		inBuffer)
{
	ZLog(@"MyAudioQueueOutputCallback");
	// this is called by the audio queue when it has finished decoding our data.
	// The buffer is now free to be reused.
	AudioStreamer* streamer = (AudioStreamer*)inClientData;
	[streamer handleBufferCompleteForQueue:inAQ buffer:inBuffer];
}

//
// MyAudioQueueIsRunningCallback
//
// Called from the AudioQueue when playback is started or stopped. This
// information is used to toggle the observable "isPlaying" property and
// set the "finished" flag.
//调用AudioQueue时开始或停止播放
void MyAudioQueueIsRunningCallback(void *inUserData, AudioQueueRef inAQ, AudioQueuePropertyID inID)
{
	ZLog(@"MyAudioQueueIsRunningCallback");
	AudioStreamer* streamer = (AudioStreamer *)inUserData;
	[streamer handlePropertyChangeForQueue:inAQ propertyID:inID];
}

#if TARGET_OS_IPHONE
//
// MyAudioSessionInterruptionListener
//
// Invoked if the audio session is interrupted (like when the phone rings)
//音频会话被中断时调用
void MyAudioSessionInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	ZLog(@"MyAudioSessionInterruptionListener");
	//AudioStreamer* streamer = (AudioStreamer *)inClientData;
	//[streamer handleInterruptionChangeToState:inInterruptionState];
	[__streamer handleInterruptionChangeToState:inInterruptionState];
}
#endif

#pragma mark CFReadStream Callback Function Implementations

//
// ReadStreamCallBack
//
// This is the callback for the CFReadStream from the network connection. This
// is where all network data is passed to the AudioFileStream.
//
// Invoked when an error occurs, the stream ends or we have data to read.
//
//void ASReadStreamCallBack
//(
//   CFReadStreamRef aStream,
//   CFStreamEventType eventType,
//   void* inClientInfo
//)
//{
//	AudioStreamer* streamer = (AudioStreamer *)inClientInfo;
//	[streamer handleReadFromStream:aStream eventType:eventType];
//}

@implementation AudioStreamer

@synthesize errorCode;
@synthesize state;
@synthesize stopReason;
@synthesize pauseReason;
@synthesize bitRate;
@synthesize httpHeaders;
@synthesize numberOfChannels;
@synthesize vbr;
@synthesize tempAudioData = _tempAudioData;
@synthesize isLowStory;
//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
	[self stop];
#ifdef SHOUTCAST_METADATA
	[metaDataString release];
#endif
	[super dealloc];
}

//
// bufferFillPercentage
//
// returns a value between 0 and 1 that represents how full the buffer is
//
-(double)bufferFillPercentage
{
//    Log
	return (double)buffersUsed/(double)(kNumAQBufs - 1);
}


//
// isFinishing
//
// returns YES if the audio has reached a stopping condition.
//如果音频已达到停止状态，返回YES
- (BOOL)isFinishing
{
//    Log
	@synchronized (self)
	{
		if ((errorCode != AS_NO_ERROR && state != AS_INITIALIZED) ||
			((state == AS_STOPPING || state == AS_STOPPED) &&
             stopReason != AS_STOPPING_TEMPORARILY))
		{
			return YES;
		}
	}
	
	return NO;
}

//
// runLoopShouldExit
//
// returns YES if the run loop should exit.
//如果运行循环退出，返回YES，
- (BOOL)runLoopShouldExit
{
//    Log
    
	@synchronized(self)
	{
        
		if (errorCode != AS_NO_ERROR ||
			(state == AS_STOPPED &&
             stopReason != AS_STOPPING_TEMPORARILY))
		{
			return YES;
		}
	}
	
	return NO;
}

//
// stringForErrorCode:
//
// Converts an error code to a string that can be localized or presented
// to the user.
//
// Parameters:
//    anErrorCode - the error code to convert
//
// returns the string representation of the error code
//
+ (NSString *)stringForErrorCode:(AudioStreamerErrorCode)anErrorCode
{
	switch (anErrorCode)
	{
		case AS_NO_ERROR:
			return AS_NO_ERROR_STRING;
		case AS_FILE_STREAM_GET_PROPERTY_FAILED:
			return AS_FILE_STREAM_GET_PROPERTY_FAILED_STRING;
		case AS_FILE_STREAM_SEEK_FAILED:
			return AS_FILE_STREAM_SEEK_FAILED_STRING;
		case AS_FILE_STREAM_PARSE_BYTES_FAILED:
			return AS_FILE_STREAM_PARSE_BYTES_FAILED_STRING;
		case AS_AUDIO_QUEUE_CREATION_FAILED:
			return AS_AUDIO_QUEUE_CREATION_FAILED_STRING;
		case AS_AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED:
			return AS_AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED_STRING;
		case AS_AUDIO_QUEUE_ENQUEUE_FAILED:
			return AS_AUDIO_QUEUE_ENQUEUE_FAILED_STRING;
		case AS_AUDIO_QUEUE_ADD_LISTENER_FAILED:
			return AS_AUDIO_QUEUE_ADD_LISTENER_FAILED_STRING;
		case AS_AUDIO_QUEUE_REMOVE_LISTENER_FAILED:
			return AS_AUDIO_QUEUE_REMOVE_LISTENER_FAILED_STRING;
		case AS_AUDIO_QUEUE_START_FAILED:
			return AS_AUDIO_QUEUE_START_FAILED_STRING;
		case AS_AUDIO_QUEUE_BUFFER_MISMATCH:
			return AS_AUDIO_QUEUE_BUFFER_MISMATCH_STRING;
		case AS_FILE_STREAM_OPEN_FAILED:
			return AS_FILE_STREAM_OPEN_FAILED_STRING;
		case AS_FILE_STREAM_CLOSE_FAILED:
			return AS_FILE_STREAM_CLOSE_FAILED_STRING;
		case AS_AUDIO_QUEUE_DISPOSE_FAILED:
			return AS_AUDIO_QUEUE_DISPOSE_FAILED_STRING;
		case AS_AUDIO_QUEUE_PAUSE_FAILED:
			return AS_AUDIO_QUEUE_DISPOSE_FAILED_STRING;
		case AS_AUDIO_QUEUE_FLUSH_FAILED:
			return AS_AUDIO_QUEUE_FLUSH_FAILED_STRING;
		case AS_AUDIO_DATA_NOT_FOUND:
			return AS_AUDIO_DATA_NOT_FOUND_STRING;
		case AS_GET_AUDIO_TIME_FAILED:
			return AS_GET_AUDIO_TIME_FAILED_STRING;
		case AS_NETWORK_CONNECTION_FAILED:
			return AS_NETWORK_CONNECTION_FAILED_STRING;
		case AS_AUDIO_QUEUE_STOP_FAILED:
			return AS_AUDIO_QUEUE_STOP_FAILED_STRING;
		case AS_AUDIO_STREAMER_FAILED:
			return AS_AUDIO_STREAMER_FAILED_STRING;
		case AS_AUDIO_BUFFER_TOO_SMALL:
			return AS_AUDIO_BUFFER_TOO_SMALL_STRING;
		default:
			return AS_AUDIO_STREAMER_FAILED_STRING;
	}
	
	return AS_AUDIO_STREAMER_FAILED_STRING;
}

//
// presentAlertWithTitle:message:
//
// Common code for presenting error dialogs
//
// Parameters:
//    title - title for the dialog
//    message - main test for the dialog
//
- (void)presentAlertWithTitle:(NSString*)title message:(NSString*)message
{
//    Log
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", message, @"message", nil];
	NSNotification *notification =
	[NSNotification
	 notificationWithName:ASPresentAlertWithTitleNotification
	 object:self
	 userInfo:userInfo];
	[[NSNotificationCenter defaultCenter]
	 postNotification:notification];
}

//
// failWithErrorCode:
//
// Sets the playback state to failed and logs the error.
//
// Parameters:
//    anErrorCode - the error condition
//
- (void)failWithErrorCode:(AudioStreamerErrorCode)anErrorCode
{
//    Log
	@synchronized(self)
	{
		if (errorCode != AS_NO_ERROR)
		{
			// Only set the error once.
			return;
		}
		
		errorCode = anErrorCode;
        
        //		if (err)
        //		{
        //			char *errChars = (char *)&err;
        //
        //		}
        
        
		if (state == AS_PLAYING ||
			state == AS_PAUSED ||
			state == AS_BUFFERING)
		{
			self.state = AS_STOPPING;
			stopReason = AS_STOPPING_ERROR;
			AudioQueueStop(audioQueue, true);
		}
        
		[self presentAlertWithTitle:NSLocalizedStringFromTable(@"File Error", @"Errors", nil)
							message:NSLocalizedStringFromTable(@"Unable to configure network read stream.", @"Errors", nil)];
	}
}

//
// mainThreadStateNotification
//
// Method invoked on main thread to send notifications to the main thread's
// notification center.
//
- (void)mainThreadStateNotification
{
//    Log
	NSNotification *notification =
    [NSNotification
     notificationWithName:ASStatusChangedNotification
     object:self];
	[[NSNotificationCenter defaultCenter]
     postNotification:notification];
}

//
// setState:
//
// Sets the state and sends a notification that the state has changed.
//
// This method
//
// Parameters:
//    anErrorCode - the error condition
//
- (void)setState:(AudioStreamerState)aStatus
{
	@synchronized(self)
	{
		if (state != aStatus)
		{
			state = aStatus;
			
			if ([[NSThread currentThread] isEqual:[NSThread mainThread]])
			{
				[self mainThreadStateNotification];
			}
			else
			{
				[self
                 performSelectorOnMainThread:@selector(mainThreadStateNotification)
                 withObject:nil
                 waitUntilDone:NO];
			}
		}
	}
}
//
// isStopping
//
// returns YES if the audio currently stopping.
//
- (BOOL)isStopping
{
	if (state == AS_STOPPING)
	{
		return YES;
	}
	
	return NO;
}

//
// isStoped
//
// returns YES if the audio currently stoped.
//
- (BOOL)isStopped
{
	if (state == AS_STOPPED)
	{
		return YES;
	}
	
	return NO;
}

//
// isPlaying
//
// returns YES if the audio currently playing.
//
- (BOOL)isPlaying
{
	if (state == AS_PLAYING)
	{
		return YES;
	}
	
	return NO;
}

//
// isPaused
//
// returns YES if the audio currently playing.
//
- (BOOL)isPaused
{
	if (state == AS_PAUSED)
	{
		return YES;
	}
	
	return NO;
}

//
// isWaiting
//
// returns YES if the AudioStreamer is waiting for a state transition of some
// kind.
//
- (BOOL)isWaiting
{
	@synchronized(self)
	{
		if ([self isFinishing] ||
			state == AS_STARTING_FILE_THREAD||
			state == AS_WAITING_FOR_DATA ||
			state == AS_WAITING_FOR_QUEUE_TO_START ||
			state == AS_BUFFERING)
		{
			return YES;
		}
	}
	
	return NO;
}

//
// isIdle
//
// returns YES if the AudioStream is in the AS_INITIALIZED state (i.e.
// isn't doing anything).
//
- (BOOL)isIdle
{
	if (state == AS_INITIALIZED)
	{
		return YES;
	}
	
	return NO;
}

//
// hintForFileExtension:
//
// Generates a first guess for the file type based on the file's extension
//
// Parameters:
//    fileExtension - the file extension
//
// returns a file type hint that can be passed to the AudioFileStream
//
+ (AudioFileTypeID)hintForFileExtension:(NSString *)fileExtension
{
	AudioFileTypeID fileTypeHint = kAudioFileMP3Type;
	if ([fileExtension isEqual:@"mp3"])
	{
		fileTypeHint = kAudioFileMP3Type;
	}
	else if ([fileExtension isEqual:@"wav"])
	{
		fileTypeHint = kAudioFileWAVEType;
	}
	else if ([fileExtension isEqual:@"aifc"])
	{
		fileTypeHint = kAudioFileAIFCType;
	}
	else if ([fileExtension isEqual:@"aiff"])
	{
		fileTypeHint = kAudioFileAIFFType;
	}
	else if ([fileExtension isEqual:@"m4a"])
	{
		fileTypeHint = kAudioFileM4AType;
	}
	else if ([fileExtension isEqual:@"mp4"])
	{
		fileTypeHint = kAudioFileMPEG4Type;
	}
	else if ([fileExtension isEqual:@"caf"])
	{
		fileTypeHint = kAudioFileCAFType;
	}
	else if ([fileExtension isEqual:@"aac"])
	{
		fileTypeHint = kAudioFileAAC_ADTSType;
	}
	return fileTypeHint;
}

//
// hintForMIMEType
//
// Make a more informed guess on the file type based on the MIME type
//
// Parameters:
//    mimeType - the MIME type
//
// returns a file type hint that can be passed to the AudioFileStream
//
+ (AudioFileTypeID)hintForMIMEType:(NSString *)mimeType
{
	AudioFileTypeID fileTypeHint = kAudioFileMP3Type;
	if ([mimeType isEqual:@"audio/mpeg"])
	{
		fileTypeHint = kAudioFileMP3Type;
	}
	else if ([mimeType isEqual:@"audio/x-wav"])
	{
		fileTypeHint = kAudioFileWAVEType;
	}
	else if ([mimeType isEqual:@"audio/x-aiff"])
	{
		fileTypeHint = kAudioFileAIFFType;
	}
	else if ([mimeType isEqual:@"audio/x-m4a"])
	{
		fileTypeHint = kAudioFileM4AType;
	}
	else if ([mimeType isEqual:@"audio/mp4"])
	{
		fileTypeHint = kAudioFileMPEG4Type;
	}
	else if ([mimeType isEqual:@"audio/x-caf"])
	{
		fileTypeHint = kAudioFileCAFType;
	}
	else if ([mimeType isEqual:@"audio/aac"] || [mimeType isEqual:@"audio/aacp"])
	{
		fileTypeHint = kAudioFileAAC_ADTSType;
	}
	return fileTypeHint;
}

//
// startInternal
//
// This is the start method for the AudioStream thread. This thread is created
// because it will be blocked when there are no audio buffers idle (and ready
// to receive audio data).
//
// Activity in this thread:
//	- Creation and cleanup of all AudioFileStream and AudioQueue objects
//	- Receives data from the CFReadStream
//	- AudioFileStream processing
//	- Copying of data from AudioFileStream into audio buffers
//  - Stopping of the thread because of end-of-file
//	- Stopping due to error or failure
//
// Activity *not* in this thread:
//	- AudioQueue playback and notifications (happens in AudioQueue thread)
//  - Actual download of NSURLConnection data (NSURLConnection's thread)
//	- Creation of the AudioStreamer (other, likely "main" thread)
//	- Invocation of -start method (other, likely "main" thread)
//	- User/manual invocation of -stop (other, likely "main" thread)
//
// This method contains bits of the "main" function from Apple's example in
// AudioFileStreamExample.
//



//活动在此线程：
// - 创建和清理所有AudioFileStream，AudioQueue对象
// - 从CFReadStream接收数据
// - AudioFileStream处理
// - 复制数据从AudioFileStream到音频缓冲区
// - 停止的线程，因为端文件
// - 由于错误或失败而停止
//
//活动不在这个线程：
// - AudioQueue播放和通知（发生在AudioQueue线程）
// - ，实际下载NSURLConnection的数据（NSURLConnection的线程）
// - （其他可能的“主”线程创建的AudioStreamer）
// - 调用start方法（其他可能的“主”线程）
// - 用户/手动调用的一站式（其他可能的“主”线程）
- (void)startInternal
{
//    Log
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	@synchronized(self)
	{
		if (state != AS_STARTING_FILE_THREAD)
		{
			if (state != AS_STOPPING &&
				state != AS_STOPPED)
			{
				DLog(@"### Not starting audio thread. State code is: %u", state);
			}
			self.state = AS_INITIALIZED;
            
			[pool release];
			return;
		}
		
#if TARGET_OS_IPHONE
		//
		// Set the audio session category so that we continue to play if the
		// iPhone/iPod auto-locks.
		//
		AudioSessionInitialize (
                                NULL,                          // 'NULL' to use the default (main) run loop
                                NULL,                          // 'NULL' to use the default run loop mode
                                MyAudioSessionInterruptionListener,  // a reference to your interruption callback
                                self                       // data to pass to your interruption listener callback
                                );
		UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty (
                                 kAudioSessionProperty_AudioCategory,
                                 sizeof (sessionCategory),
                                 &sessionCategory
                                 );
		AudioSessionSetActive(true);
		__streamer = self;
#endif
        
		// initialize a mutex and condition so that we can block on buffers in use.
		pthread_mutex_init(&queueBuffersMutex, NULL);
		pthread_cond_init(&queueBufferReadyCondition, NULL);
	}
    
    self.state = AS_WAITING_FOR_DATA;
    
    if (!timer) {
        //bird修改
        if (!audioFileStream){
            //
            // Attempt to guess the file type from the httpHeaders MIME type value.
            //
            // If you have a fixed file-type, you may want to hardcode this.
            //
            AudioFileTypeID fileTypeHint = kAudioFileMP3Type;
            
            // create an audio file stream parser
            err = AudioFileStreamOpen(self, MyPropertyListenerProc, MyPacketsProc,
                                      fileTypeHint, &audioFileStream);
            if (err) {
                [self failWithErrorCode:AS_FILE_STREAM_OPEN_FAILED];
                //return;
            }
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(writeData) userInfo:nil repeats:YES];
    }
    
	//
	// Process the run loop until playback is finished or failed.
	//
	BOOL isRunning = YES;
	do
	{
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];
        
        
		@synchronized(self) {
			if (seekWasRequested) {
                if (requestedSeekTime >= self.duration - 0.1) {
                    seekWasRequested = NO;
                    self.state = AS_STOPPING;
                    stopReason = AS_STOPPING_EOF;
                    err = AudioQueueStop(audioQueue, true);  ///没有进入回调
                    if (err)
                    {
                        [self failWithErrorCode:AS_AUDIO_QUEUE_STOP_FAILED];
                        return;
                    }
                } else {
                    
                    [self internalSeekToTime:requestedSeekTime];
                    seekWasRequested = NO;
                    
                }
			}
		}
		
        if (self.state == AS_PLAYING && _byteIndex >= fileLength) {
            if (self.progress >= self.duration - 0.1) {
                self.state = AS_STOPPING;
                stopReason = AS_STOPPING_EOF;
                err = AudioQueueStop(audioQueue, true);
                if (err)
                {
                    [self failWithErrorCode:AS_AUDIO_QUEUE_STOP_FAILED];
                    return;
                }
            }
        }
        
		//
		// If there are no queued buffers, we need to check here since the
		// handleBufferCompleteForQueue:buffer: should not change the state
		// (may not enter the synchronized section).
		//
		if (buffersUsed == 0 && self.state == AS_PLAYING && _byteIndex < fileLength)
		{
			err = AudioQueuePause(audioQueue);
			if (err)
			{
				[self failWithErrorCode:AS_AUDIO_QUEUE_PAUSE_FAILED];
				return;
			}
		}
	} while (isRunning && ![self runLoopShouldExit]);
	
cleanup:
    
	@synchronized(self)
	{
        [timer invalidate];
        timer = nil;
        
        if (_tempAudioData) {
            [_tempAudioData release];
            _tempAudioData = nil;
        }
		
		//
		// Close the audio file strea,
		//
		if (audioFileStream)
		{
			err = AudioFileStreamClose(audioFileStream);
			audioFileStream = nil;
			if (err)
			{
				[self failWithErrorCode:AS_FILE_STREAM_CLOSE_FAILED];
			}
		}
		
		//
		// Dispose of the Audio Queue
		//
		if (audioQueue)
		{
			err = AudioQueueDispose(audioQueue, true);
			audioQueue = nil;
			if (err)
			{
				[self failWithErrorCode:AS_AUDIO_QUEUE_DISPOSE_FAILED];
			}
		}
        
		pthread_mutex_destroy(&queueBuffersMutex);
		pthread_cond_destroy(&queueBufferReadyCondition);
        
#if TARGET_OS_IPHONE
		AudioSessionSetActive(false);////////
#endif
        
		[httpHeaders release];
		httpHeaders = nil;
        
		bytesFilled = 0;
		packetsFilled = 0;
		seekByteOffset = 0;
		packetBufferSize = 0;
		self.state = AS_STOPPED;
		[internalThread release];
		internalThread = nil;
	}
    
	[pool release];
}

//
// start
//
// Calls startInternal in a new thread.
//
- (void)start
{
//    Log
	@synchronized (self)
	{
		if (state == AS_PAUSED) {
			[self goAndPlay];
        } else if (state == AS_INITIALIZED) {
			NSAssert([[NSThread currentThread] isEqual:[NSThread mainThread]],
                     @"Playback can only be started from the main thread.");
			notificationCenter =
            [[NSNotificationCenter defaultCenter] retain];
			self.state = AS_STARTING_FILE_THREAD;
			internalThread =
            [[NSThread alloc]
             initWithTarget:self
             selector:@selector(startInternal)
             object:nil];
			[internalThread setName:@"InternalThread"];
			[internalThread start];
		}
        
	}
}


// internalSeekToTime:
//
// Called from our internal runloop to reopen the stream at a seeked location
//
- (void)internalSeekToTime:(double)newSeekTime
{
//    Log
	if ([self calculatedBitRate] == 0.0 || fileLength <= 0)
	{
		return;
	}
	
	//
	// Calculate the byte offset for seeking
	//
	seekByteOffset = dataOffset +
    (newSeekTime / self.duration) * (fileLength - dataOffset);
    
	//
	// Attempt to leave 1 useful packet at the end of the file (although in
	// reality, this may still seek too far if the file has a long trailer).
	//
	if (seekByteOffset > fileLength - 2 * packetBufferSize)
	{
		seekByteOffset = fileLength - 2 * packetBufferSize;
	}
	
	//
	// Store the old time from the audio queue and the time that we're seeking
	// to so that we'll know the correct time progress after seeking.
	//
	seekTime = newSeekTime;
	
	//
	// Attempt to align the seek with a packet boundary
	//
	double calculatedBitRate = [self calculatedBitRate];
	if (packetDuration > 0 &&
		calculatedBitRate > 0)
	{
        
		UInt32 ioFlags = 0;
		SInt64 packetAlignedByteOffset;
		SInt64 seekPacket = floor(newSeekTime / packetDuration);
        
		err = AudioFileStreamSeek(audioFileStream, seekPacket, &packetAlignedByteOffset, &ioFlags);
        
		if (!err && !(ioFlags & kAudioFileStreamSeekFlag_OffsetIsEstimated))
		{
            
			seekTime -= ((seekByteOffset - dataOffset) - packetAlignedByteOffset) * 8.0 / calculatedBitRate;
			seekByteOffset = packetAlignedByteOffset + dataOffset;
            
		}
	}
    
	//
	// Stop the audio queue
	//
	self.state = AS_STOPPING;
	stopReason = AS_STOPPING_TEMPORARILY;
    if (newSeekTime >= self.duration - 4.0) { //最后16个buffer是4秒钟
        stopReason = AS_STOPPING_EOF;
    }
	err = AudioQueueStop(audioQueue, true);
	if (err)
	{
		[self failWithErrorCode:AS_AUDIO_QUEUE_STOP_FAILED];
		return;
	}
}

//
// seekToTime:
//
// Attempts to seek to the new time. Will be ignored if the bitrate or fileLength
// are unknown.
//
// Parameters:
//    newTime - the time to seek to
//
- (void)seekToTime:(double)newSeekTime
{
//    Log
	@synchronized(self)
	{
		seekWasRequested = YES;
		requestedSeekTime = newSeekTime;
       CDLog(BTDFLAG_AudioStreamer,@"seekWasRequested = YES");
	}
}

//
// progress
//
// returns the current playback progress. Will return zero if sampleRate has
// not yet been detected.
//
- (double)progress
{
//    Log
	@synchronized(self)
	{
		if (sampleRate > 0)
		{
            
			if (state != AS_PLAYING && state != AS_PAUSED && state != AS_BUFFERING && ![self isFinishing])
			{
				return 0.0;
			}
            
			AudioTimeStamp queueTime;
			Boolean discontinuity;
			err = AudioQueueGetCurrentTime(audioQueue, NULL, &queueTime, &discontinuity);
            
			const OSStatus AudioQueueStopped = 0x73746F70; // 0x73746F70 is 'stop'
			if (err == AudioQueueStopped)
			{
				return 0.0;
			}
			else if (err)
			{
                return 0.0;
			}
            
			double progress = seekTime + queueTime.mSampleTime / sampleRate;
            
			if (progress < 0.0)
			{
				progress = 0.0;
			}
			
			lastProgress = progress;
            
			return progress;
		}
	}
	return 0.0;
}

//
// calculatedBitRate
//
// returns the bit rate, if known. Uses packet duration times running bits per
//   packet if available, otherwise it returns the nominal bitrate. Will return
//   zero if no useful option available.
//
- (double)calculatedBitRate
{
//    Log
	if (vbr)
	{
		if (packetDuration && processedPacketsCount > BitRateEstimationMinPackets)
		{
			double averagePacketByteSize = (double)processedPacketsSizeTotal / processedPacketsCount;
			return 8.0 * averagePacketByteSize / packetDuration;
		}
        
		if (bitRate)
		{
			return (double)bitRate;
		}
	}
	else
	{
		bitRate = 8.0 * asbd.mSampleRate * asbd.mBytesPerPacket * asbd.mFramesPerPacket;
		return bitRate;
	}
    
	return 0;
}

//
// duration
//
// Calculates the duration of available audio from the bitRate and fileLength.
//
// returns the calculated duration in seconds.
//
- (double)duration
{
//    Log
	double calculatedBitRate = [self calculatedBitRate];
	CDLog(BTDFLAG_AudioStreamer,@"bitRate=%f",calculatedBitRate);
	if (calculatedBitRate == 0 || fileLength == 0)
	{
		//return 0.0;
        if (isLowStory) {
            calculatedBitRate = 32000;
        } else {
            calculatedBitRate = 64000;
        }
	}
	CDLog(BTDFLAG_AudioStreamer,@"fileLength=%d",fileLength);
	CDLog(BTDFLAG_AudioStreamer,@"dataOffset=%d",dataOffset);
	CDLog(BTDFLAG_AudioStreamer,@"duration=%f",(fileLength - dataOffset) / (calculatedBitRate * 0.125));
	return (fileLength - dataOffset) / (calculatedBitRate * 0.125);
}


//
// isMeteringEnabled
//

- (BOOL)isMeteringEnabled {
//    Log
	UInt32 enabled;
	UInt32 propertySize = sizeof(UInt32);
	OSStatus status = AudioQueueGetProperty(audioQueue, kAudioQueueProperty_EnableLevelMetering, &enabled, &propertySize);
	if(!status) {
		return (enabled == 1);
	}
	return NO;
}


//
// setMeteringEnabled
//

- (void)setMeteringEnabled:(BOOL)enable {
//    Log
	if(enable == [self isMeteringEnabled])
		return;
	UInt32 enabled = (enable ? 1 : 0);
	OSStatus status = AudioQueueSetProperty(audioQueue, kAudioQueueProperty_EnableLevelMetering, &enabled, sizeof(UInt32));
	// do something if failed?
	if(status)
		return;
}


// level metering
- (float)peakPowerForChannel:(NSUInteger)channelNumber {
//    Log
	if(![self isMeteringEnabled] || channelNumber >= [self numberOfChannels])
		return 0;
	float peakPower = 0;
	UInt32 propertySize = [self numberOfChannels] * sizeof(AudioQueueLevelMeterState);
	AudioQueueLevelMeterState *audioLevels = calloc(sizeof(AudioQueueLevelMeterState), [self numberOfChannels]);
	OSStatus status = AudioQueueGetProperty(audioQueue, kAudioQueueProperty_CurrentLevelMeter, audioLevels, &propertySize);
	if(!status) {
		peakPower = audioLevels[channelNumber].mPeakPower;
	}
	free(audioLevels);
	return peakPower;
}


- (float)averagePowerForChannel:(NSUInteger)channelNumber {
//    Log
	if(![self isMeteringEnabled] || channelNumber >= [self numberOfChannels])
		return 0;
	float peakPower = 0;
	UInt32 propertySize = [self numberOfChannels] * sizeof(AudioQueueLevelMeterState);
	AudioQueueLevelMeterState *audioLevels = calloc(sizeof(AudioQueueLevelMeterState), [self numberOfChannels]);
	OSStatus status = AudioQueueGetProperty(audioQueue, kAudioQueueProperty_CurrentLevelMeter, audioLevels, &propertySize);
	if(!status) {
		peakPower = audioLevels[channelNumber].mAveragePower;
	}
	free(audioLevels);
	return peakPower;
}


//
// pause
//
// A togglable pause function.
//
- (void)pause
{
//    Log
	@synchronized(self)
	{
        
		if (state == AS_PLAYING)
		{
            
			err = AudioQueuePause(audioQueue);
			if (err)
			{
				[self failWithErrorCode:AS_AUDIO_QUEUE_PAUSE_FAILED];
				return;
			}
            //bird Add
            pauseReason = AS_STOPPING_USER_ACTION;
			self.state = AS_PAUSED;
            
		}
		else if (state == AS_PAUSED && pauseReason != AS_STOPPING_TEMPORARILY)
		{
            
            [self goAndPlay];
            
		} else if (state == AS_PAUSED && pauseReason == AS_STOPPING_TEMPORARILY) {
            
            err = AudioQueuePause(audioQueue);
			if (err)
			{
				[self failWithErrorCode:AS_AUDIO_QUEUE_PAUSE_FAILED];
				return;
			}
            //bird Add
            pauseReason = AS_STOPPING_USER_ACTION;
			self.state = AS_PAUSED;
            
        }
        interruptByPhone = NO;
	}
}
- (void)goAndPlay {
    err = AudioQueueStart(audioQueue, NULL);
#if TARGET_OS_IPHONE
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        if (bgTaskId != UIBackgroundTaskInvalid) {
            bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
        }
    }
#endif
    
    if (err)
    {
        [self failWithErrorCode:AS_AUDIO_QUEUE_START_FAILED];
        return;
    }
    self.state = AS_PLAYING;
    
}
//
// stop
//
// This method can be called to stop downloading/playback before it completes.
// It is automatically called when an error occurs.
//
// If playback has not started before this method is called, it will toggle the
// "isPlaying" property so that it is guaranteed to transition to true and
// back to false
//
- (void)stop
{
//    Log
    
	@synchronized(self)
	{
		if (state == AS_WAITING_FOR_DATA || state == AS_STARTING_FILE_THREAD){
			self.state = AS_STOPPED;
			stopReason = AS_STOPPING_USER_ACTION;
			return;
		}
		if (audioQueue &&
			(state == AS_PLAYING || state == AS_PAUSED ||
             state == AS_BUFFERING || state == AS_WAITING_FOR_QUEUE_TO_START))
		{
            
			self.state = AS_STOPPING;
			stopReason = AS_STOPPING_USER_ACTION;
			err = AudioQueueStop(audioQueue, true);
			if (err)
			{
				[self failWithErrorCode:AS_AUDIO_QUEUE_STOP_FAILED];
				return;
			}
		}
		else
		{
			self.state = AS_STOPPED;
			stopReason = AS_STOPPING_USER_ACTION;
		}
		seekWasRequested = NO;
	}
	
	while (state != AS_STOPPED && state != AS_INITIALIZED)
	{
		[NSThread sleepForTimeInterval:0.1];
	}
}

#ifdef SHOUTCAST_METADATA
- (void)updateMetaData:(NSString *)metaData
{
//    Log
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:metaData, @"metadata", nil];
	NSNotification *notification =
	[NSNotification
	 notificationWithName:ASUpdateMetadataNotification
	 object:self
	 userInfo:userInfo];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}
#endif

//
// enqueueBuffer
//
// Called from MyPacketsProc and connectionDidFinishLoading to pass filled audio
// bufffers (filled by MyPacketsProc) to the AudioQueue for playback. This
// function does not return until a buffer is idle for further filling or
// the AudioQueue is stopped.
//
// This function is adapted from Apple's example in AudioFileStreamExample with
// CBR functionality added.
//
- (void)enqueueBuffer
{
//    Log
	@synchronized(self)
	{
		if ([self isFinishing])
		{
			return;
		}
		
		inuse[fillBufferIndex] = true;		// set in use flag
		buffersUsed++;
        
		// enqueue buffer
		AudioQueueBufferRef fillBuf = audioQueueBuffer[fillBufferIndex];
		fillBuf->mAudioDataByteSize = bytesFilled;
		
		if (packetsFilled)
		{
			err = AudioQueueEnqueueBuffer(audioQueue, fillBuf, packetsFilled, packetDescs);
		}
		else
		{
			err = AudioQueueEnqueueBuffer(audioQueue, fillBuf, 0, NULL);
		}
		
		if (err)
		{
			[self failWithErrorCode:AS_AUDIO_QUEUE_ENQUEUE_FAILED];
			return;
		}
        
		
		if (state == AS_BUFFERING ||
			state == AS_WAITING_FOR_DATA ||
			state == AS_FLUSHING_EOF ||
			(state == AS_STOPPED && stopReason == AS_STOPPING_TEMPORARILY))
		{
			//
			// Fill all the buffers before starting. This ensures that the
			// AudioFileStream stays a small amount ahead of the AudioQueue to
			// avoid an audio glitch playing streaming files on iPhone SDKs < 3.0
			//
			if (state == AS_FLUSHING_EOF || buffersUsed == kNumAQBufs - 1)
			{
				if (self.state == AS_BUFFERING)
				{
					err = AudioQueueStart(audioQueue, NULL);
#if TARGET_OS_IPHONE
					if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
						bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
					}
#endif
					if (err)
					{
						[self failWithErrorCode:AS_AUDIO_QUEUE_START_FAILED];
						return;
					}
					self.state = AS_PLAYING;
                    
				}
				else
				{
					self.state = AS_WAITING_FOR_QUEUE_TO_START;
                    
                    
					err = AudioQueueStart(audioQueue, NULL);
#if TARGET_OS_IPHONE
					if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
						bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
					}
#endif
					if (err)
					{
						[self failWithErrorCode:AS_AUDIO_QUEUE_START_FAILED];
						return;
					}
				}
			}
		}
        
		// go to next buffer
		if (++fillBufferIndex >= kNumAQBufs) fillBufferIndex = 0;
		bytesFilled = 0;		// reset bytes filled
		packetsFilled = 0;		// reset packets filled
	}
    
	// wait until next buffer is not in use
	pthread_mutex_lock(&queueBuffersMutex);
	while (inuse[fillBufferIndex])
	{
        if (self.state == AS_PAUSED) {
            break;
        }
		pthread_cond_wait(&queueBufferReadyCondition, &queueBuffersMutex);
	}
	pthread_mutex_unlock(&queueBuffersMutex);
}

//
// createQueue
//
// Method to create the AudioQueue from the parameters gathered by the
// AudioFileStream.
//
// Creation is deferred to the handling of the first audio packet (although
// it could be handled any time after kAudioFileStreamProperty_ReadyToProducePackets
// is true).
//
- (void)createQueue
{
//    Log
	sampleRate = asbd.mSampleRate;
	packetDuration = asbd.mFramesPerPacket / sampleRate;
	
	numberOfChannels = asbd.mChannelsPerFrame;
	
	// create the audio queue
	err = AudioQueueNewOutput(&asbd, MyAudioQueueOutputCallback, self, NULL, NULL, 0, &audioQueue);
	if (err)
	{
		[self failWithErrorCode:AS_AUDIO_QUEUE_CREATION_FAILED];
		return;
	}else {
        // set the software codec too on the queue.
        UInt32 val = kAudioQueueHardwareCodecPolicy_PreferSoftware;
        OSStatus ignorableError;
        ignorableError = AudioQueueSetProperty(audioQueue, kAudioQueueProperty_HardwareCodecPolicy, &val, sizeof(UInt32));
        if (ignorableError){
           CDLog(BTDFLAG_AudioStreamer,@"set kAudioQueueProperty_HardwareCodecPolicy failed");
        }
    }
    
	
	// start the queue if it has not been started already
	// listen to the "isRunning" property
	err = AudioQueueAddPropertyListener(audioQueue, kAudioQueueProperty_IsRunning, MyAudioQueueIsRunningCallback, self);
	if (err)
	{
		[self failWithErrorCode:AS_AUDIO_QUEUE_ADD_LISTENER_FAILED];
		return;
	}
	
	// get the packet size if it is available
	if (vbr)
	{
		UInt32 sizeOfUInt32 = sizeof(UInt32);
		err = AudioFileStreamGetProperty(audioFileStream, kAudioFileStreamProperty_PacketSizeUpperBound, &sizeOfUInt32, &packetBufferSize);
		if (err || packetBufferSize == 0)
		{
			err = AudioFileStreamGetProperty(audioFileStream, kAudioFileStreamProperty_MaximumPacketSize, &sizeOfUInt32, &packetBufferSize);
			if (err || packetBufferSize == 0)
			{
				// No packet size available, just use the default
				packetBufferSize = kAQDefaultBufSize;
			}
		}
	}
	else
	{
		packetBufferSize = kAQDefaultBufSize;
	}
    
    
	// allocate audio queue buffers
	for (unsigned int i = 0; i < kNumAQBufs; ++i)
	{
		err = AudioQueueAllocateBuffer(audioQueue, packetBufferSize, &audioQueueBuffer[i]);
		if (err)
		{
			[self failWithErrorCode:AS_AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED];
			return;
		}
	}
    
	// get the cookie size
	UInt32 cookieSize;
	Boolean writable;
	OSStatus ignorableError;
	ignorableError = AudioFileStreamGetPropertyInfo(audioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, &writable);
	if (ignorableError)
	{
		return;
	}
    
	// get the cookie data
	void* cookieData = calloc(1, cookieSize);
	ignorableError = AudioFileStreamGetProperty(audioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, cookieData);
	if (ignorableError)
	{
		return;
	}
    
	// set the cookie on the queue.
	ignorableError = AudioQueueSetProperty(audioQueue, kAudioQueueProperty_MagicCookie, cookieData, cookieSize);
	free(cookieData);
	if (ignorableError)
	{
		return;
	}
}

//
// handlePropertyChangeForFileStream:fileStreamPropertyID:ioFlags:
//
// Object method which handles implementation of MyPropertyListenerProc
//
// Parameters:
//    inAudioFileStream - should be the same as self->audioFileStream
//    inPropertyID - the property that changed
//    ioFlags - the ioFlags passed in
//
- (void)handlePropertyChangeForFileStream:(AudioFileStreamID)inAudioFileStream
                     fileStreamPropertyID:(AudioFileStreamPropertyID)inPropertyID
                                  ioFlags:(UInt32 *)ioFlags
{
//    Log
	@synchronized(self)
	{
		if ([self isFinishing])
		{
			return;
		}
		
		if (inPropertyID == kAudioFileStreamProperty_ReadyToProducePackets)
		{
			discontinuous = true;
		}
		else if (inPropertyID == kAudioFileStreamProperty_DataOffset)
		{
			SInt64 offset;
			UInt32 offsetSize = sizeof(offset);
			err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_DataOffset, &offsetSize, &offset);
			if (err)
			{
				[self failWithErrorCode:AS_FILE_STREAM_GET_PROPERTY_FAILED];
				return;
			}
			dataOffset = offset;
			
			if (audioDataByteCount)
			{
				fileLength = dataOffset + audioDataByteCount;
			}
		}
		else if (inPropertyID == kAudioFileStreamProperty_AudioDataByteCount)
		{
			UInt32 byteCountSize = sizeof(UInt64);
			err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_AudioDataByteCount, &byteCountSize, &audioDataByteCount);
			if (err)
			{
				[self failWithErrorCode:AS_FILE_STREAM_GET_PROPERTY_FAILED];
				return;
			}
			fileLength = dataOffset + audioDataByteCount;
		}
		else if (inPropertyID == kAudioFileStreamProperty_DataFormat)
		{
			if (asbd.mSampleRate == 0)
			{
				UInt32 asbdSize = sizeof(asbd);
				
				// get the stream format.
				err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_DataFormat, &asbdSize, &asbd);
				if (err)
				{
					[self failWithErrorCode:AS_FILE_STREAM_GET_PROPERTY_FAILED];
					return;
				}
			}
		}
		else if (inPropertyID == kAudioFileStreamProperty_FormatList)
		{
			Boolean outWriteable;
			UInt32 formatListSize;
			err = AudioFileStreamGetPropertyInfo(inAudioFileStream, kAudioFileStreamProperty_FormatList, &formatListSize, &outWriteable);
			if (err)
			{
				[self failWithErrorCode:AS_FILE_STREAM_GET_PROPERTY_FAILED];
				return;
			}
			
			AudioFormatListItem *formatList = malloc(formatListSize);
	        err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_FormatList, &formatListSize, formatList);
			if (err)
			{
				[self failWithErrorCode:AS_FILE_STREAM_GET_PROPERTY_FAILED];
				if (formatList) {
					free(formatList);
					formatList = nil;
				}
				return;
			}
            
			for (int i = 0; i * sizeof(AudioFormatListItem) < formatListSize; i += sizeof(AudioFormatListItem))
			{
#warning 这里formatList[i]是不是应该改成formatList[i/sizeof(AudioFormatListItem)]
				AudioStreamBasicDescription pasbd = formatList[i].mASBD;
                
				if(pasbd.mFormatID == kAudioFormatMPEG4AAC_HE_V2 &&
#if TARGET_OS_IPHONE
				   [[UIDevice currentDevice] platformHasCapability:(UIDeviceSupportsARMV7)] &&
#endif
				   kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_MIN)
				{
					// We found HE-AAC v2 (SBR+PS), but before trying to play it
					// we need to make sure that both the hardware and software are
					// capable of doing so...
#if !TARGET_IPHONE_SIMULATOR
					asbd = pasbd;
#endif
					break;
				} else if (pasbd.mFormatID == kAudioFormatMPEG4AAC_HE)
				{
					//
					// We've found HE-AAC, remember this to tell the audio queue
					// when we construct it.
					//
#if !TARGET_IPHONE_SIMULATOR
					asbd = pasbd;
#endif
					break;
				}
			}
			if (formatList) {
				free(formatList);
				formatList = nil;
			}
		}
        
	}
}

//
// handleAudioPackets:numberBytes:numberPackets:packetDescriptions:
//
// Object method which handles the implementation of MyPacketsProc
//
// Parameters:
//    inInputData - the packet data
//    inNumberBytes - byte size of the data
//    inNumberPackets - number of packets in the data
//    inPacketDescriptions - packet descriptions
//
- (void)handleAudioPackets:(const void *)inInputData
               numberBytes:(UInt32)inNumberBytes
             numberPackets:(UInt32)inNumberPackets
        packetDescriptions:(AudioStreamPacketDescription *)inPacketDescriptions;
{
//    Log
	@synchronized(self)
	{
		if ([self isFinishing])
		{
			return;
		}
		
		if (bitRate == 0)
		{
			//
			// m4a and a few other formats refuse to parse the bitrate so
			// we need to set an "unparseable" condition here. If you know
			// the bitrate (parsed it another way) you can set it on the
			// class if needed.
			//
			bitRate = ~0;
		}
        
		// we have successfully read the first packests from the audio stream, so
		// clear the "discontinuous" flag
		if (discontinuous)
		{
			discontinuous = false;
		}
		
		if (!audioQueue)
		{
			vbr = (inPacketDescriptions != nil);
			[self createQueue];
		}
	}
    
	// the following code assumes we're streaming VBR data. for CBR data, the second branch is used.
	if (inPacketDescriptions)
	{
		for (int i = 0; i < inNumberPackets; ++i)
		{
			SInt64 packetOffset = inPacketDescriptions[i].mStartOffset;
			SInt64 packetSize   = inPacketDescriptions[i].mDataByteSize;
			size_t bufSpaceRemaining;
			
			if (processedPacketsCount < BitRateEstimationMaxPackets)
			{
				processedPacketsSizeTotal += packetSize;
				processedPacketsCount += 1;
			}
			
			@synchronized(self)
			{
				// If the audio was terminated before this point, then
				// exit.
				if ([self isFinishing])
				{
					return;
				}
				
				if (packetSize > packetBufferSize)
				{
					[self failWithErrorCode:AS_AUDIO_BUFFER_TOO_SMALL];
				}
                
				bufSpaceRemaining = packetBufferSize - bytesFilled;
			}
            
			// if the space remaining in the buffer is not enough for this packet, then enqueue the buffer.
			if (bufSpaceRemaining < packetSize)
			{
				[self enqueueBuffer];
			}
			
			@synchronized(self)
			{
				// If the audio was terminated while waiting for a buffer, then
				// exit.
				if ([self isFinishing])
				{
					return;
				}
				
				//
				// If there was some kind of issue with enqueueBuffer and we didn't
				// make space for the new audio data then back out
				//
                //http://github.com/mattgallagher/AudioStreamer/issues/#issue/22
				if (bytesFilled + packetSize > packetBufferSize)
				{
					return;
				}
				
				// copy data to the audio queue buffer
				AudioQueueBufferRef fillBuf = audioQueueBuffer[fillBufferIndex];
				memcpy((char*)fillBuf->mAudioData + bytesFilled, (const char*)inInputData + packetOffset, packetSize);
                
				// fill out packet description
				packetDescs[packetsFilled] = inPacketDescriptions[i];
				packetDescs[packetsFilled].mStartOffset = bytesFilled;
				// keep track of bytes filled and packets filled
				bytesFilled += packetSize;
				packetsFilled += 1;
			}
			
			// if that was the last free packet description, then enqueue the buffer.
			size_t packetsDescsRemaining = kAQMaxPacketDescs - packetsFilled;
			if (packetsDescsRemaining == 0) {
				[self enqueueBuffer];
			}
		}
	}
	else
	{
		size_t offset = 0;
		while (inNumberBytes)
		{
			// if the space remaining in the buffer is not enough for this packet, then enqueue the buffer.
			size_t bufSpaceRemaining = kAQDefaultBufSize - bytesFilled;
			if (bufSpaceRemaining < inNumberBytes)
			{
				[self enqueueBuffer];
			}
			
			@synchronized(self)
			{
				// If the audio was terminated while waiting for a buffer, then
				// exit.
				if ([self isFinishing])
				{
					return;
				}
				
				bufSpaceRemaining = kAQDefaultBufSize - bytesFilled;
				size_t copySize;
				if (bufSpaceRemaining < inNumberBytes)
				{
					copySize = bufSpaceRemaining;
				}
				else
				{
					copySize = inNumberBytes;
				}
                
				//
				// If there was some kind of issue with enqueueBuffer and we didn't
				// make space for the new audio data then back out
				//
				if (bytesFilled >= packetBufferSize)
				{
					return;
				}
				
				// copy data to the audio queue buffer
				AudioQueueBufferRef fillBuf = audioQueueBuffer[fillBufferIndex];
				memcpy((char*)fillBuf->mAudioData + bytesFilled, (const char*)(inInputData + offset), copySize);
                
                
				// keep track of bytes filled and packets filled
				bytesFilled += copySize;
				packetsFilled = 0;
				inNumberBytes -= copySize;
				offset += copySize;
			}
		}
	}
}

//
// handleBufferCompleteForQueue:buffer:
//
// Handles the buffer completetion notification from the audio queue
//
// Parameters:
//    inAQ - the queue
//    inBuffer - the buffer
//
- (void)handleBufferCompleteForQueue:(AudioQueueRef)inAQ
                              buffer:(AudioQueueBufferRef)inBuffer
{
//    Log
	unsigned int bufIndex = -1;
	for (unsigned int i = 0; i < kNumAQBufs; ++i)
	{
		if (inBuffer == audioQueueBuffer[i])
		{
			bufIndex = i;
			break;
		}
	}
	
	if (bufIndex == -1)
	{
		[self failWithErrorCode:AS_AUDIO_QUEUE_BUFFER_MISMATCH];
		pthread_mutex_lock(&queueBuffersMutex);
		pthread_cond_signal(&queueBufferReadyCondition);
		pthread_mutex_unlock(&queueBuffersMutex);
		return;
	}
	
	// signal waiting thread that the buffer is free.
	pthread_mutex_lock(&queueBuffersMutex);
	inuse[bufIndex] = false;
	buffersUsed--;
    
    //
    //  Enable this logging to measure how many buffers are queued at any time.
    //
#if LOG_QUEUED_BUFFERS
	DLog(@"Queued buffers: %ld", buffersUsed);
#endif
	
	pthread_cond_signal(&queueBufferReadyCondition);
	pthread_mutex_unlock(&queueBuffersMutex);
}

//
// handlePropertyChangeForQueue:propertyID:
//
// Implementation for MyAudioQueueIsRunningCallback
//
// Parameters:
//    inAQ - the audio queue
//    inID - the property ID
//
- (void)handlePropertyChangeForQueue:(AudioQueueRef)inAQ
                          propertyID:(AudioQueuePropertyID)inID
{
//    Log
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	@synchronized(self)
	{
		if (inID == kAudioQueueProperty_IsRunning)
		{
			if (state == AS_STOPPING)
			{
				self.state = AS_STOPPED;
			}
			else if (state == AS_WAITING_FOR_QUEUE_TO_START)
			{
				//
				// Note about this bug avoidance quirk:
				//
				// On cleanup of the AudioQueue thread, on rare occasions, there would
				// be a crash in CFSetContainsValue as a CFRunLoopObserver was getting
				// removed from the CFRunLoop.
				//
				// After lots of testing, it appeared that the audio thread was
				// attempting to remove CFRunLoop observers from the CFRunLoop after the
				// thread had already deallocated the run loop.
				//
				// By creating an NSRunLoop for the AudioQueue thread, it changes the
				// thread destruction order and seems to avoid this crash bug -- or
				// at least I haven't had it since (nasty hard to reproduce error!)
				//
				
				[NSRunLoop currentRunLoop];
                
				self.state = AS_PLAYING;
                
                
#if TARGET_OS_IPHONE
				if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
					if (bgTaskId != UIBackgroundTaskInvalid) {
						[[UIApplication sharedApplication] endBackgroundTask: bgTaskId];
					}
					
					bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
				}
#endif
			}
		}
	}
	
	[pool release];
}

#if TARGET_OS_IPHONE
//
// handleInterruptionChangeForQueue:propertyID:
//
// Implementation for MyAudioQueueInterruptionListener
//
// Parameters:
//    inAQ - the audio queue
//    inID - the property ID
//
- (void)handleInterruptionChangeToState:(AudioQueuePropertyID)inInterruptionState
{
//    Log
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
        if(state == AS_PLAYING){
            [self pause];
            interruptByPhone = YES;
        }
	}
	else if (inInterruptionState == kAudioSessionEndInterruption)
	{
        if(interruptByPhone) {
            AudioSessionSetActive( true );
            [self start];
            interruptByPhone = NO;
            
        }
	}
}
#endif

- (void)writeData {
	ZLog("writeData");
//    Log
    if (buffersUsed >= kNumAQBufs) {
		ZLog(@"if (buffersUsed >= kNumAQBufs) {");
        return;
    }
    
    UInt8 bytes[kAQWriteSize];
    CFIndex length = 0;
    if ([self isFinishing]) {
		ZLog(@"if ([self isFinishing]) {");
        return;
    }
    
    //@synchronized (self)   {
    //        if (_tempAudioData) {
    
    //            if (!audioFileStream){
    //                //
    //                // Attempt to guess the file type from the httpHeaders MIME type value.
    //                //
    //                // If you have a fixed file-type, you may want to hardcode this.
    //                //
    //                AudioFileTypeID fileTypeHint = kAudioFileMP3Type;
    //
    //                // create an audio file stream parser
    //                err = AudioFileStreamOpen(self, MyPropertyListenerProc, MyPacketsProc,
    //                                          fileTypeHint, &audioFileStream);
    //                if (err) {
    //                    [self failWithErrorCode:AS_FILE_STREAM_OPEN_FAILED];
    //                    return;
    //                }
    //            }
    
    //
    // Read the bytes from the stream
    //
    
    int data_len = [_tempAudioData length];
    _byteIndex = seekByteOffset;
    if (_byteIndex >= data_len) {
		ZLog(@"_byteIndex:%d,data_len:%d",_byteIndex,data_len);
        if (_byteIndex < fileLength && state == AS_PLAYING) {
            @synchronized(self) {
                
                err = AudioQueuePause(audioQueue);
                if (err) {
                    [self failWithErrorCode:AS_AUDIO_QUEUE_PAUSE_FAILED];
                    return;
                }
                
                pauseReason = AS_STOPPING_TEMPORARILY;
                self.state = AS_PAUSED;
                
            }
        }
        return;
    }
    if (data_len <= 0) {
		ZLog(@"if (data_len <= 0) {");
        return;
    }
    
    _byteIndex = seekByteOffset;
    
    length = ((data_len - _byteIndex >= kAQWriteSize) ? kAQWriteSize : (data_len-_byteIndex));

    @synchronized (self)   {
        uint8_t *readBytes = (uint8_t *)[_tempAudioData mutableBytes];
        readBytes += _byteIndex; // instance variable to move pointer
        (void)memcpy(bytes, readBytes, length);
        
    }
    
    _byteIndex += length;
    seekByteOffset = _byteIndex;
    
    if (length == -1) {
		ZLog(@"if (length == -1) {");
        [self failWithErrorCode:AS_AUDIO_DATA_NOT_FOUND];
        return;
    }
    
    if (length == 0) {
		ZLog(@"if (length == 0) {");
        return;
    }
    //        }

    if (discontinuous) {
		ZLog(@"if (discontinuous) {");
        err = AudioFileStreamParseBytes(audioFileStream, length, bytes, kAudioFileStreamParseFlag_Discontinuity);
        if (err)
        {
            [self failWithErrorCode:AS_FILE_STREAM_PARSE_BYTES_FAILED];
            return;
        }
    } else {
        err = AudioFileStreamParseBytes(audioFileStream, length, bytes, 0);
        if (err) {
            [self failWithErrorCode:AS_FILE_STREAM_PARSE_BYTES_FAILED];
            return;
        }
    }

}
@end


