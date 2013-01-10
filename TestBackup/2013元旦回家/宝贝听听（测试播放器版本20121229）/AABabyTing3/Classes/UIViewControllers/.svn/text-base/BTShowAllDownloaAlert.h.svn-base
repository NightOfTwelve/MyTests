//
//  BTShowAllDownloaAlert.h
//  AABabyTing3
//
//  Created by  on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//点UIAlertView的取消按钮的回调协议
@protocol allDownloadDelegate <NSObject>
-(void)cancelAllDownloadRequest;
@end

@interface BTShowAllDownloaAlert : NSObject{
    
    UIAlertView *_progressAlert;
    UIProgressView *_progressView;
    UILabel *_percentLabel;
    id<allDownloadDelegate> _delegate;
}
@property (nonatomic,retain) UIAlertView *progressAlert;
@property (nonatomic,retain) UIProgressView *progressView;
@property (nonatomic,retain) UILabel *percentLabel;
@property (nonatomic,assign) id<allDownloadDelegate> delegate;

+(BTShowAllDownloaAlert *)sharedInstance;
+(void)destroySharedInstance;
-(void)showAlert;
-(void)setDownloadProgress:(float)progress;
-(void)removeAlertView;

@end
