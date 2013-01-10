
#import "BTAppDelegate.h"
#import "BTRadioPlayerController.h"
#import "BTConstant.h"
#import "BTUtilityClass.h"
#import "BTPlayerManager.h"
#import "BTListViewController.h"
#import "BTHomeListViewController.h"
#import "BTMystoriesController.h"
#import "BTRadioData.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BTDownLoadManager.h"
#import "Reachability.h"
#import "BTAlarmViewController.h"
#import "BTAlarmHelper.h"

@implementation BTRadioPlayerController
@synthesize storyPlayedAction = _storyPlayedAction;
@synthesize bIsBackToCurrentPlayingLayer = _bIsBackToCurrentPlayingLayer;
@synthesize playList = _playList;
@synthesize playingStoryIndex = _playingStoryIndex;
@synthesize playerAction;
@synthesize storyType = _storyType;
@synthesize categoryName = _categoryName;
@synthesize playButton = _playButton;
@synthesize nextButton = _nextButton;
@synthesize timeButton = _timeButton;
@synthesize radio = _radio,radioAction = _radioAction;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
	[self registerAlarmNotifications];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
    _ropeView.hidden = YES;
	self.viewTitle.text = self.radio.radioTitle;
	self.viewTitle.hidden = NO;
    self.playingButton.hidden = YES;

    bottomView.hidden = YES;

    [self performSelector:@selector(changeButtonPressFlag) withObject:nil afterDelay:1.0];

    bottomView.frame = CGRectMake(0, DIFF_HEIGHT+365 + APPEAR_MOVEDISTANT, 320, 87);
    TvView.frame = CGRectMake(-10, DIFF_HEIGHT-20 + APPEAR_MOVEDISTANT, 320, WINDOW_HEIGHT);
    [self createTimer];
}


-(void)releaseRadioAction {
    if(_radioAction){
        _radioAction.actionDelegate = nil;
        [_radioAction release];
        _radioAction = nil;
    }
}



- (void)onAction:(BTBaseAction *)action
		withData:(id)data {
    //拉取成功的回调
    NSMutableArray *requestArray = (NSMutableArray *)data;
    for(BTStory * info in requestArray){
        NSNumber *numberId = [NSNumber numberWithInt:[info.storyId intValue]];
        
        [_playList addObject:info];
        if (![[BTDataManager shareInstance].radioHistoryArray containsObject:numberId]) {
            [[BTDataManager shareInstance].radioHistoryArray addObject:numberId];
        }
    }
    
    NSArray *resultArray = [[BTDataManager shareInstance].radioHistoryArray sortedArrayUsingSelector:@selector(compare:)];
    [BTDataManager shareInstance].radioHistoryArray = [NSMutableArray arrayWithArray:resultArray];

    if (_playingStoryIndex == 0 && [_playList count] > 0) {
        if (playerAction.player) {
            [playerAction.player stop];
        }
        playerAction.playList = _playList;
        [self playStory];
    }
}

- (void)onAction:(BTBaseAction *)action
	   withError:(NSError *)error {
    if ([_playList count] == 0) {
        [_radioAction setRadioInfo:[_radio.radioID integerValue] history:nil requestCount:firstRequestRadioCount];
        [_radioAction start];
    }

}
- (void)viewDidUnload {
	[super viewDidUnload];
	[self closeAlarmView];
    [BTAlarmNotifications removeObserver:self];
}
-(void)dealloc{
	[self closeAlarmView];
	[BTAlarmNotifications removeObserver:self];
	
    [playerAction release];
    [bottomView release];
    [TvView release];
    [_radioTitle release];
    [_storyPlayedAction release];
    [pauseScreen release];
    [_dianboView release];
    [_dianboView1 release];
    [_dianboView2 release];
    //[[NSNotificationCenter defaultCenter]removeObject:self];
    [_playList release];
    [_categoryName release];
    [_radio release];
    
    [self destroyTimer];
    [self releaseRadioAction];
    [super dealloc];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.tabCtr.customTabBarView setHidden:YES];
    [delegate hideTabBar:YES];
    bottomView.hidden = NO;

//	self.viewTitle.text = @"正在播放";
//	self.title = @"正在播放";
    [UIView animateWithDuration:0.3 animations:^{ bottomView.frame = CGRectMake(0, DIFF_HEIGHT+365, 320, 87); TvView.frame = CGRectMake(-10, DIFF_HEIGHT - 20, 320, WINDOW_HEIGHT);} completion:^(BOOL finished){}];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    isInStory = NO;
    BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate hideTabBar:NO];
    [delegate.tabCtr.customTabBarView setHidden:NO];
    bottomView.hidden = YES;
    bottomView.frame = CGRectMake(0, DIFF_HEIGHT+365 + APPEAR_MOVEDISTANT, 320, 87);
    [self destroyTimer];
	
	[self closeAlarmView];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark 通知接收


- (void)playbackStateChanged:(NSNotification *)aNotification {
    
    //NSString *totalTime = [NSString stringWithFormat:@"%f",playerAction.player.duration];
    if (playerAction.player.duration > 0) {
        //[_totalTimeLabel setText:[BTUtilityClass changToTimeFormatWithString:[totalTime intValue]]];
        //_progressBar.bufferDistant = 320.0 * 5 / [totalTime intValue];
        //DLog(@"%f",_progressBar.bufferDistant);
    }
    //DLog(@"111111 %d, %d",playerAction.player.state, playerAction.player.pauseReason);
    
    if (playerAction.player.state == AS_STARTING_FILE_THREAD) {
        [BTPlayerManager sharedInstance].playList = _playList;
        [BTPlayerManager sharedInstance].playingStoryIndex = _playingStoryIndex;
        [BTPlayerManager sharedInstance].listName = _categoryName;
        [BTPlayerManager sharedInstance].storyType = _storyType;

    } else if (playerAction.player.state == AS_INITIALIZED && !playerAction.player.startPause) { 
        

    }else if (playerAction.player.state == AS_PLAYING){


        playerAction.bIsReadyToPlay = YES;
        playerAction.isFinishPlaying = NO;
        isLoading = NO;
        [_playButton setImage:[UIImage imageNamed:@"Radio_Button_pause_1.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"Radio_Button_pause_2.png"] forState:UIControlStateHighlighted];
        
        _dianboView.hidden = NO;
        //added by brown: end
    }else if (playerAction.player.state == AS_PAUSED && playerAction.player.pauseReason != AS_STOPPING_TEMPORARILY) {
        playerAction.bIsReadyToPlay = YES;
        [_playButton setImage:[UIImage imageNamed:@"Radio_Button_play_1.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"Radio_Button_play_2.png"] forState:UIControlStateHighlighted];
        pauseScreen.hidden = NO;
        //_dianboView.hidden = YES;
    } else if (playerAction.player.state == AS_PAUSED && playerAction.player.pauseReason == AS_STOPPING_TEMPORARILY) {
        isLoading = YES;
        _dianboView.hidden = YES;

    } else if (playerAction.player.state == AS_STOPPED) {
        if (playerAction.player.stopReason == AS_STOPPING_EOF) {
            
            //isDrugged = NO;
			[self currentStoryStop:nil];
            playerAction.isFinishPlaying = YES;
        }
        playerAction.bIsReadyToPlay = YES;
        [_playButton setImage:[UIImage imageNamed:@"Radio_Button_play_1.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"Radio_Button_play_2.png"] forState:UIControlStateHighlighted];
        pauseScreen.hidden = NO;
        
    }
}

-(void)initData{
    if (playerAction == nil) {
        playerAction = [[BTPlayerAction alloc] init];
    } 
    if (_radioAction == nil) {
        _radioAction = [[BTOneRadioAction alloc] init];
        _radioAction.actionDelegate = self;
    }
    playMode = PLAYBACK_IN_TURN;
    //add by vicky for timer begin
	//用户设定［定时］功能，到时自动暂停

	//add by vicky for timer end
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:ASStatusChangedNotification
                                               object:nil];
    
    //接受通知：用户切换［定量］／［定时］View
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimerSetView:)
												 name:NOTIFICATION_NUMBER_SET_VIEW_WILL_CHANGE
											   object:nil];
    
    //用户设定［定量］功能，到时自动暂停
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(startNumberToPausePlay:)
												 name:NOTIFICATION_PAUSE_BEGIN_BY_NUMBER_SET_VIEW
											   object:nil];
    
    //用户设定［定时］功能，到时自动暂停
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(startClockSetTimer:)
												 name:NOTIFICATION_TIME_START_BEGIN
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(startTimerToPausePlay:)
												 name:NOTIFICATION_PAUSE_BEGIN_BY_TIME_SET_VIEW
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timeCancel:)
                                                 name:NOTIFICATION_TIME_CANCEL
                                               object:nil];

    //锁屏的远程控制通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remoteControlNotification:) name:NOTIFICATION_REMOTE_CONTROL_CHANGED object:nil];
    _storyPlayedAction = [[BTStoryPlayedAction alloc] init];
    winsize = [UIScreen mainScreen].bounds.size;
    
    
}

-(void)initChildUI {
    
}
-(void)initUI{
    UIImageView *tengtiao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radio_tengtiao.png"]];
    tengtiao.frame = CGRectMake(0, -45, 320, 253);
    [self.view addSubview:tengtiao];
	[tengtiao release];
    
    
    TvView = [[UIView alloc] init];
    [self.view addSubview:TvView];
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 365, 320, 87)];
    [self.view addSubview:bottomView];
    

    _screenPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _screenPlayButton.frame = CGRectMake(62,215, 182, 130);
    [_screenPlayButton setImage:[UIImage imageNamed:@"Radio_Screen.png"] forState:UIControlStateNormal];
    [_screenPlayButton addTarget:self action:@selector(playItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [TvView addSubview:_screenPlayButton];

    

    _radioTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 235, 180, 20)];
    [_radioTitle setTextAlignment:UITextAlignmentCenter];
    [_radioTitle setBackgroundColor:[UIColor clearColor]];
    [_radioTitle setTextColor:[UIColor colorWithRed:115.0/255.0 green:40.0/255.0 blue:1.0/255.0 alpha:1.0]];
    [TvView addSubview:_radioTitle];
    _dianboView = [[UIImageView alloc] initWithFrame:CGRectMake(64, 260, 178, 62)];
    _dianboView.clipsToBounds=YES;
    [TvView addSubview:_dianboView];
    _dianboView1 = [[UIImageView alloc] initWithFrame:CGRectMake(3, 0, 172, 62)];
    _dianboView1.image = [UIImage imageNamed:@"Radio_dianbo.png"];
    [_dianboView addSubview:_dianboView1];
    _dianboView2 = [[UIImageView alloc] initWithFrame:CGRectMake(-172 + 3, 0, 172, 62)];
    _dianboView2.image = [UIImage imageNamed:@"Radio_dianbo.png"];
    [_dianboView addSubview:_dianboView2];
    _dianboView.hidden = YES;
    
    
    loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(123, 257, 57, 57)];
    loadingView.image = [UIImage imageNamed:@"Radio_loading.png"];
    [TvView addSubview:loadingView];
    //pauseScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radio_Tv.png"]];
    
    pauseScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radio_pauseScreen.png"]];
    pauseScreen.frame = CGRectMake(62, 215, 182, 130);
    [TvView addSubview:pauseScreen];
    
    
    pauseScreen.hidden = YES;
    
    loadingViewBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radio_loading_back.png"]];
    loadingViewBack.frame = CGRectMake(62, 215, 182, 130);
    [TvView addSubview:loadingViewBack];
    
    UIImageView *tv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radio_Tv.png"]];
    tv.frame = CGRectMake(30, 98, 280, 307);
    [TvView addSubview:tv];
	[tv release];
    
    UIImageView *bottomGreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_green.png"]];
    bottomGreen.frame = CGRectMake(0, 10, winsize.width, 86);
    [bottomView addSubview:bottomGreen];
    [bottomGreen release];
    
    UIImageView  *playingProgressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 14)];
    playingProgressView.image=[UIImage imageNamed:@"SliderBarBack.png"];
    [bottomView addSubview:playingProgressView];
    [playingProgressView release];
    
    
    
    //播放按钮相关
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(239 ,219, 52, 52);
    [_playButton setImage:[UIImage imageNamed:@"Radio_Button_play_1.png"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"Radio_Button_play_2.png"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [TvView addSubview:_playButton];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(235,265, 52, 52);
    [_nextButton setImage:[UIImage imageNamed:@"Radio_Button_next_1.png"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"Radio_Button_next_2.png"] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(forWardItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [TvView addSubview:_nextButton];
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.frame = CGRectMake(winsize.width / 2 + 105,338, 69, 72);
    [_timeButton setBackgroundImage:[UIImage imageNamed:@"Button_time.png"] forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(timingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _timeButton.transform = CGAffineTransformMakeRotation(-0.3);
	
	{
		CGRect frame = CGRectMake(8, 13, 40, 25);
		_remainsLabel = [[UILabel alloc] initWithFrame:frame];
		_remainsLabel.text = nil;
		_remainsLabel.frame = CGRectMake(12,13,40,25);//(8, 13, 40, 25);
		_remainsLabel.textColor = [UIColor colorWithRed:106.0/255.0 green:61.0/255.0 blue:4.0/255.0 alpha:1.0f];
		_remainsLabel.transform = CGAffineTransformMakeRotation(0.2);
		_remainsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.6];
		_remainsLabel.backgroundColor = [UIColor clearColor];
		
		[_timeButton addSubview:_remainsLabel];
		[_remainsLabel release];
		
		_remainsLabel.hidden = YES;
	}
	{
		//"个"
		UIImage *image = [UIImage imageNamed:@"counting_board_text_suffix"];
		_countSuffixImageView = [[UIImageView alloc] initWithImage:image];
		_countSuffixImageView.contentMode = UIViewContentModeCenter;
		_countSuffixImageView.frame = CGRectMake(27, 19, 16, 16);
		_countSuffixImageView.transform = CGAffineTransformMakeRotation(0.2);
		[_timeButton addSubview:_countSuffixImageView];
		[_countSuffixImageView release];
		
		_countSuffixImageView.hidden = YES;
	}
	
    [TvView addSubview:_timeButton];
    
    actionState = ACTION_NOTNEED;



}
#pragma mark -
#pragma mark touch事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}

-(void)playStoryAccordToMode{
    switch (playMode) {
        case PLAYBACK_SINGLE:{
            return;
        }
        case PLAYBACK_IN_TURN:{
            if (_storyType == StoryType_Radio && _playingStoryIndex == [_playList count] - 2) {
                [_radioAction cancel];
                [_radioAction setRadioInfo:[_radio.radioID integerValue]history:[BTDataManager shareInstance].radioHistoryArray requestCount:RadioRequestMinLeftNum];
                
                [_radioAction start];


            } else if(_storyType == StoryType_Radio && _playingStoryIndex == [_playList count] - 1) {
                [_radioAction cancel];
                [_radioAction setRadioInfo:[_radio.radioID integerValue]history:[BTDataManager shareInstance].radioHistoryArray requestCount:RadioRequestMinLeftNum];
                [_radioAction start];

                return;
            }
            
            if (_playingStoryIndex + 1 < [_playList count])  
            {
                _playingStoryIndex ++ ;
            }
            else {
                _playingStoryIndex =0;
            }    

            [self playStory];
            break; 
        }
        case PLAYBACK_SINGLE_CYCLE:{  
            [self playStory];
            break;
        }
        default:
            break;
    }
    
}

-(void)currentStoryStop:(id)sender{
    //给定时器发送-1通知
	BTAlarm *alarm = [BTAlarm sharedInstance];
	if (alarm.mode == eBTAlarmModeCounting && alarm.state == eBTAlarmStateRunning) {
		[alarm decreaseCount];
		
		//TODO: Zero 下面这个if为补丁，没有想出太好的办法，如果你有好的想法请联系我^_^
		if (alarm.state == eBTAlarmStateFinished) {
			[self stopPlayingStory];
			return;
		}
	}
	
    if(playerAction.player.state != AS_PLAYING){
		//这里这样写是因为ios sdk中在player播放到结束的时候，先发通知，在停止音乐。
		//在setcontentUrl前player还是playing状态，
		//setcontenturl之后又停止一次，容易调用2次。
        [self playStoryAccordToMode];
	}
}


#pragma mark -
#pragma mark 规避快速连续点击产生crash的方法
-(void)changeButtonPressFlag
{
    buttonPressFlag = YES;
}

#pragma mark -
#pragma mark selector

-(void)playItemPressed:(id)sender{
	[BTRQDReport reportUserAction:EventPlayingLayerPlayButtonClicked];
	int playTime = [playerAction.player progress];
    if ([_playList count] == 0) {
        return;
    }
    if (!playerAction.bIsReadyToPlay && playTime <= 0) {
        
        if (!playerAction.player.startPause) {
            playerAction.player.startPause = YES;
            pauseScreen.hidden = NO;
            isLoading = NO;

        } else {
            if ([playerAction.player loadingProgress]/[playerAction.player duration] > 0.9) {
                playerAction.player.startPause = NO;
                pauseScreen.hidden = YES;
                [playerAction.player start];
            } else {
                isLoading = YES;
                playerAction.player.startPause = NO;
                pauseScreen.hidden = YES;
            }

            

        }
        return;
    } 
    pauseScreen.hidden = YES;
    [playerAction playButtonPressed];

}

-(void)forWardItemPressed:(id)sender{
	[BTRQDReport reportUserAction:EventPlayingLayerNextButtonClicked];
	if(!buttonPressFlag){
		return;
	}
    if ([_playList count] == 0) {
        return;
    }
    if (_storyType == StoryType_Radio && _playingStoryIndex == [_playList count] - 2) {
        [_radioAction cancel];
        [_radioAction setRadioInfo:[_radio.radioID integerValue]history:[BTDataManager shareInstance].radioHistoryArray requestCount:RadioRequestMinLeftNum];
        [_radioAction start];

    }
    if (_storyType == StoryType_Radio && _playingStoryIndex == [_playList count] - 1) {
        [_radioAction cancel];
        [_radioAction setRadioInfo:[_radio.radioID integerValue]history:[BTDataManager shareInstance].radioHistoryArray requestCount:RadioRequestMinLeftNum];
        [_radioAction start];
        return;
    }
    buttonPressFlag = NO;
    _playingStoryIndex++ ;
    if(_playingStoryIndex > [_playList count] - 1){
        _playingStoryIndex = 0;
    }
    [_playButton setImage:[UIImage imageNamed:@"Radio_Button_play_1.png"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"Radio_Button_play_2.png"] forState:UIControlStateHighlighted];
    [self performSelector:@selector(changeButtonPressFlag) withObject:nil afterDelay:1.0];
    [self playStory];

}

#pragma mark - RemoteControl

- (void)remoteControlNotification:(NSNotification*)notification
{

     UIEvent *event = (UIEvent*)[notification object];
     
     if(event.type == UIEventTypeRemoteControl){
     
     switch (event.subtype) {
     case UIEventSubtypeRemoteControlTogglePlayPause:{   //控制音乐的播放和暂停			
     //控制音乐的播放和暂停			
     if (playerAction.player.state == AS_PLAYING) {
         [playerAction.player pause];
     }else {
         [playerAction.player start];
     }
     break;
     }
     case UIEventSubtypeRemoteControlPreviousTrack:{     //上一首
         //[self backWardItemPressed:nil];
     }
     break;
     case UIEventSubtypeRemoteControlNextTrack:{         //下一首
         [self forWardItemPressed:nil];
     }
     default:
     break;
     }
     }
     
}
#pragma mark -
#pragma mark 故事插图正在加载


-(void)startRequestRadio {
    [_radioAction cancel];
    [_playList release];
    _playList = [[NSMutableArray alloc] init];
    _playingStoryIndex = 0;
    [_radioTitle setText:@" "];
    playMode = PLAYBACK_IN_TURN;
    
    
    [[BTDataManager shareInstance].radioHistoryArray removeAllObjects];
    
    [_radioAction setRadioInfo:[_radio.radioID integerValue] history:nil requestCount:firstRequestRadioCount];
    [_radioAction start];

    playerAction.playingStoryIndex = _playingStoryIndex;
    playerAction.storyType = _storyType;
    if (playerAction.player) {
        [playerAction destroyStreamer];
    }
    pauseScreen.hidden = YES;
    _dianboView.hidden = YES;
    isLoading = YES;
}



-(void)playStory {

    dianboPoint = 0;
    BTStory *story = [_playList objectAtIndex:_playingStoryIndex];
    [BTUtilityClass setMediaInfo:nil andTitle:story.title andArtist:nil];
    [_radioTitle setText:story.title];
    storyHasRecorder = NO;
    isLoading = YES;
    _dianboView.hidden = YES;
    playerAction.playingStoryIndex = _playingStoryIndex;
    playerAction.storyType = _storyType;
    pauseScreen.hidden = YES;
    if (playerAction.player) {
        [playerAction.player stop];
    }
    if ([_playList count] > 0) {

        [playerAction playStory];
        
        
    }

}


- (void)createTimer{
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer=nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateMusicPlayer:) userInfo:nil repeats:YES];
}

- (void)destroyTimer{
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer=nil;
    }
}

-(void)updateMusicPlayer:(NSTimeInterval) delta{
    if (playerAction.player.state == AS_PLAYING) {
        dianboPoint = (dianboPoint + 2) % 172;
        pauseScreen.hidden = YES;
    }
    
    _dianboView1.frame = CGRectMake(dianboPoint + 3, 0, 172, 62);
    _dianboView2.frame = CGRectMake(-172 + 3 + dianboPoint, 0, 172, 62);
    if (isLoading) {
        loadingViewBack.hidden = NO;
        loadingView.hidden = NO;
        pauseScreen.hidden = YES;
        loadingCount = (loadingCount + 5) % 360;
        loadingView.transform = CGAffineTransformMakeRotation(loadingCount* M_PI/180);
    } else {
        loadingViewBack.hidden = YES;
        loadingView.hidden = YES;
    }
}


-(void)storyPlayOverHalf:(BTStory *)story {
    NSString *storyID = story.storyId;
    [self.storyPlayedAction start:storyID];
    storyHasRecorder = YES;
}

#pragma mark - 定时定量
//定时按钮点击事件
-(void)timingButtonPressed:(id)sender {
	[BTRQDReport reportUserAction:EventRadioScheduleButtonClicked];
	
	//弹出定时定量窗口
	BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
	if (_alarmVC == nil) {
		_alarmVC = [[BTAlarmViewController alloc] init];
	}
	if (_alarmVC.view.superview == nil) {
		[delegate.window addSubview:_alarmVC.view];
	}
	[delegate.window bringSubviewToFront:_alarmVC.view];
}

- (void)handleStartedAndValueChangedNotification:(NSNotification *)aNotif {
	BTAlarm *alarm = [aNotif.userInfo valueForKey:DICTIONARY_KEY_ALARM];
	NSString *remainsString = [BTAlarmHelper textOfAlarmRemains:alarm];
	_remainsLabel.text = remainsString;
	_remainsLabel.hidden = NO;
	_countSuffixImageView.hidden = !([BTAlarm sharedInstance].mode == eBTAlarmModeCounting);
	UIImage *image = [UIImage imageNamed:@"alarm_button_background"];
	[_timeButton setBackgroundImage:image
						   forState:UIControlStateNormal];
}

- (void)handleFinishedNotification {
	[self resetAlarmButton];
	[self stopPlayingStory];
}

- (void)stopPlayingStory {
	switch (playerAction.player.state) {
		case AS_PLAYING:
			[playerAction.player pause];
			break;
		case AS_INITIALIZED:
			[playerAction.player stop];
			break;
		default:
			break;
	}
}

- (void)resetAlarmButton {
	_remainsLabel.text = nil;
	_remainsLabel.hidden = YES;
	_countSuffixImageView.hidden = YES;
	UIImage *image = [UIImage imageNamed:@"alarm_button_text"];
	[_timeButton setBackgroundImage:image
						   forState:UIControlStateNormal];
}

- (void)handleStopedNotification {
	[self resetAlarmButton];
}
- (void)closeAlarmView {
	[_alarmVC.view removeFromSuperview];
	[_alarmVC release], _alarmVC = nil;
}

//注册通知监听
- (void)registerAlarmNotifications {
	[BTAlarmNotifications
	 addObserver:self
	 selector:@selector(handleStartedAndValueChangedNotification:)
	 object:nil
	 name:BTAlarmDidStartedNotification];
	
	[BTAlarmNotifications
	 addObserver:self
	 selector:@selector(handleStartedAndValueChangedNotification:)
	 object:nil
	 name:BTAlarmValueChangedNotification];
	
	[BTAlarmNotifications
	 addObserver:self
	 selector:@selector(handleFinishedNotification)
	 object:nil
	 name:BTAlarmDidFinishedNotification];
	
	[BTAlarmNotifications
	 addObserver:self
	 selector:@selector(handleStopedNotification)
	 object:nil
	 name:BTAlarmDidStopedNotification];
	
	[BTAlarmNotifications
	 addObserver:self
	 selector:@selector(closeAlarmView)
	 object:nil
	 name:BTAlarmViewControllerShouldDisappearNotification];
}

//取消监听
- (void)unregisterAllNotifications {
	[BTAlarmNotifications removeObserver:self
								  object:nil
									name:BTAlarmDidStartedNotification];
	[BTAlarmNotifications removeObserver:self
								  object:nil
									name:BTAlarmDidStopedNotification];
	[BTAlarmNotifications removeObserver:self
								  object:nil
									name:BTAlarmDidFinishedNotification];
	[BTAlarmNotifications removeObserver:self
								  object:nil
									name:BTAlarmValueChangedNotification];
	[BTAlarmNotifications removeObserver:self
								  object:nil
									name:BTAlarmViewControllerShouldDisappearNotification];
}

@end

