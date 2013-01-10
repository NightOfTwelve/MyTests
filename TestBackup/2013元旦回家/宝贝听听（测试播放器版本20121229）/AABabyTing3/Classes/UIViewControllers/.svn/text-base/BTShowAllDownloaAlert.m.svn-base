//
//  BTShowAllDownloaAlert.m
//  AABabyTing3
//
//  Created by  on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTShowAllDownloaAlert.h"

static BTShowAllDownloaAlert *sharedAlert = nil;

@implementation BTShowAllDownloaAlert
@synthesize progressView = _progressView;
@synthesize progressAlert = _progressAlert;
@synthesize percentLabel = _percentLabel;
@synthesize delegate = _delegate;


+(BTShowAllDownloaAlert *)sharedInstance{
    @synchronized(self){
        if (!sharedAlert) {
            sharedAlert = [[BTShowAllDownloaAlert alloc] init];
        }
    }
    return sharedAlert;
}

+(void)destroySharedInstance{
    if (sharedAlert) {
        [sharedAlert release];
        sharedAlert = nil;
    }
}

-(void)showAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"拉取下载信息"
                                                    message: nil
                                                   delegate: self
                                          cancelButtonTitle: @"取消"
                                          otherButtonTitles: nil];
    
    self.progressAlert = alert;
    [alert release];
    
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 50, 225.0f, 90.0f)];
    self.progressView = progress;
    [_progressAlert addSubview:_progressView];
    [_progressView setProgressViewStyle: UIProgressViewStyleBar];
    [progress release];

    UILabel *percent = [[UILabel alloc] initWithFrame:CGRectMake(220, 12, 40, 30)];
    percent.backgroundColor = [UIColor clearColor];
    percent.font = [UIFont boldSystemFontOfSize:12];
    percent.textColor = [UIColor whiteColor];
	percent.textAlignment = UITextAlignmentLeft;
    self.percentLabel = percent;
    [percent release];
    [_progressAlert addSubview:_percentLabel];
    
    [_progressAlert show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    //设置取消按钮的大小
    [[[alertView subviews] objectAtIndex:2] setFrame:CGRectMake(alertView.frame.size.width/2 - 50, 70, 100, 30)];
}
-(void)setDownloadProgress:(float)progress{
    
    [_progressView setProgress:progress];
    
    int percent = progress *100;
    _percentLabel.text = [NSString stringWithFormat:@"%d%%",percent];
    
    if (progress == 1.0) {
        [_progressAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0){
        if (_delegate && [_delegate respondsToSelector:@selector(cancelAllDownloadRequest)]) {
            [_delegate cancelAllDownloadRequest];
        }
    }
    
}

-(void)removeAlertView{
    
    [_progressAlert removeFromSuperview];
}

-(void)dealloc{
    [_progressView release];
    [_progressAlert release];
    [_percentLabel release];
    [super dealloc];
}

@end
