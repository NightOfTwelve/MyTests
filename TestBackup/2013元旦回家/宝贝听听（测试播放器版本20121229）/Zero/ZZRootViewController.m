//
//  ZZRootViewController.m
//  AABabyTing3
//
//  Created by Song Zhipeng on 12/30/12.
//
//

#import "ZZRootViewController.h"

@interface ZZRootViewController ()

@end

@implementation ZZRootViewController

- (IBAction)onClickedPauseButton:(UIButton *)sender {
	[_player pause];
}

- (IBAction)onClickedStopButton:(UIButton *)sender {
	[_player stop];
}

- (IBAction)onClickedPlayButton:(UIButton *)sender {
//	if (_player == nil) {
//		_player = [[AudioModel alloc] init];
//		_player.allowCache = NO;
//		_player.encryptClass = nil;
//		_player.encryptMethod = nil;
//		_player.savingPath = DOCUMENTS_DIRECTORY;
//	}
	if (_player != nil) {
		[_player pause];
		[_player stop];
		[_player release];
		_player = nil;
	}
	_player = [[AudioModel alloc] init];
	
	//@"/Library/WebServer/Documents/music/dujiajiyi.mp3"
	[_player setURLString:@"http://127.0.0.1/music/dujiajiyi.mp3"
				 fileName:nil];
}

#pragma mark -
- (void)dealloc {
	[_player release];
    [_currentTimeLabel release];
    [_totalTimeLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCurrentTimeLabel:nil];
    [self setTotalTimeLabel:nil];
    [super viewDidUnload];
}
@end
