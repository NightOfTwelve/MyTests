    
#import "BTAppDelegate.h"
#import "BTStoryPlayerController.h"
#import "BTConstant.h"
#import "BTUtilityClass.h"
#import "BTPlayerManager.h"
#import "BTDownLoadAlertView.h"
#import "SHK.h"
#import "BTListViewController.h"
#import "BTHomeListViewController.h"
#import "BTMystoriesController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BTDownLoadManager.h"
#import "Reachability.h"
#import "BTStoryCell.h"
#import "BTAlarmViewController.h"
#import "BTAlarmHelper.h"

@implementation BTStoryPlayerController
@synthesize storyPlayedAction = _storyPlayedAction;
@synthesize bIsBackToCurrentPlayingLayer = _bIsBackToCurrentPlayingLayer;
@synthesize playList = _playList;
@synthesize playingStoryIndex = _playingStoryIndex;
@synthesize progressBar=_progressBar;
@synthesize storyType = _storyType;
@synthesize categoryName = _categoryName;
@synthesize currentTimeLabel = _currentTimeLabel;
@synthesize totalTimeLabel = _totalTimeLabel;
@synthesize playProgressSlider = _playProgressSlider;
@synthesize playButton = _playButton;
@synthesize prevButton = _prevButton;
@synthesize nextButton = _nextButton;
@synthesize styleButton =_styleButton;
@synthesize timeButton = _timeButton;
@synthesize shareButton = _shareButton;
@synthesize downloadButton = _downloadButton;
@synthesize playerAction;


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
	[self registerAlarmNotifications];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	[self closeAlarmView];
    [BTAlarmNotifications removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView removeFromSuperview];
    [self.view insertSubview:self.tableView belowSubview:bottomView];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height) animated:NO];
    
    _ropeView.hidden = YES;
	self.viewTitle.text = @"正在播放";
	self.viewTitle.hidden = NO;
	self.title = @"正在播放";
    playViewType = VIEWTYPE_IMG;
    if (_storyType == StoryType_Radio) {
        self.playingButton.hidden = YES;
        functionButtonView.hidden = YES;
        listButton.hidden = YES;
        self.tableView.frame = CGRectMake(0, -450-DIFF_HEIGHT, 320, DIFF_HEIGHT+400);
    } else {
        if (playViewType == VIEWTYPE_IMG) {
            if (functionButtonShow) {
                functionButtonView.hidden = NO;
            }
            self.tableView.frame = CGRectMake(0, -450-DIFF_HEIGHT, 320, DIFF_HEIGHT+400);
            self.playingButton.hidden = YES;
            listButton.hidden = NO;
            //[self loadImageWithStory:[_playList objectAtIndex:_playingStoryIndex]];
        } else {
            playViewType = VIEWTYPE_LIST;
            self.playingButton.hidden = NO;
            listButton.hidden = YES;
        }
    }
    if (!_bIsBackToCurrentPlayingLayer) {
        _playProgressSlider.value = 0.0;
        
    }
    if (appearByFinishShare) {
        BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.tabCtr.customTabBarView setHidden:YES];
        [delegate hideTabBar:YES]; 
    } else {
        bottomView.hidden = YES;
    }

    [self performSelector:@selector(changeButtonPressFlag) withObject:nil afterDelay:1.0];
    functionButtonMoving = YES;
    
    bottomView.frame = CGRectMake(0, DIFF_HEIGHT+365 + APPEAR_MOVEDISTANT, 320, 87);
    picImageComboView.frame = CGRectMake(0, 0, 320, WINDOW_HEIGHT);

    if (_storyType == StoryType_Radio) {
        functionButtonMoving = NO;
    }
    if (functionButtonShow && (_storyType != StoryType_Radio)) {
        picImageComboView.frame = PIC_COMBO_RECT_HIGH;
        functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+ APPEAR_MOVEDISTANT, winsize.width, winsize.height);

    } else {
        picImageComboView.frame = PIC_COMBO_RECT;
        functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+BUTTON_FUNCTION_HEIGHT + APPEAR_MOVEDISTANT, winsize.width, winsize.height);
    }
    
    isPicDragging = NO;
    appearByFinishShare = NO;
    [self.tableView reloadData];
    

    if ([_playList count] == 1) {
        _prevButton.enabled = NO;
        _nextButton.enabled = NO;
    } else {
        _prevButton.enabled = YES;
        _nextButton.enabled = YES;
    }
	
    [picImageView reload];
}


-(void)dealloc{
	[self closeAlarmView];
	[BTAlarmNotifications removeObserver:self];
	
    [playerAction release];
    [picImageBack release];
    [_progressBar release];
    [_currentTimeLabel release];
    [_totalTimeLabel release];
    [bottomView release];
    [functionButtonView release];
    [_storyPlayedAction release];
    
    [_playList release];
    [_categoryName release];

    [self destroyTimer];
    [super dealloc];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.tabCtr.customTabBarView setHidden:YES];
    [delegate hideTabBar:YES];
    bottomView.hidden = NO;
    if (functionButtonShow && _storyType != StoryType_Radio) {
        [UIView animateWithDuration:0.3 animations:^{functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+0, winsize.width, winsize.height);} completion:^(BOOL finished){ functionButtonMoving = NO;}];
    } else {
        [UIView animateWithDuration:0.3 animations:^{functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+BUTTON_FUNCTION_HEIGHT, winsize.width, winsize.height);} completion:^(BOOL finished){ functionButtonMoving = NO;}];
    }
	self.viewTitle.text = @"正在播放";
	self.title = @"正在播放";
    [UIView animateWithDuration:0.3 animations:^{ bottomView.frame = CGRectMake(0, DIFF_HEIGHT+365, 320, 87);} completion:^(BOOL finished){}];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    isInStory = NO;
    if (!appearByFinishShare) {
        BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate hideTabBar:NO];
        [delegate.tabCtr.customTabBarView setHidden:NO];
        bottomView.hidden = YES;
    }

    bottomView.frame = CGRectMake(0, DIFF_HEIGHT+365 + APPEAR_MOVEDISTANT, 320, 87);
    if (functionButtonShow && _storyType != StoryType_Radio) {
        functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+APPEAR_MOVEDISTANT, winsize.width, winsize.height);
    } else {
        functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+BUTTON_FUNCTION_HEIGHT + APPEAR_MOVEDISTANT, winsize.width, winsize.height);
        
    }
    listButton.hidden = YES;
     [picImageView stopLoading];
	
	[self closeAlarmView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark 通知接收
-(void)comeNoWeiXin:(NSNotification *)notification {
    appearByFinishShare = NO;
}

//砸蛋View出现，定时、定量界面消失
-(void)eggViewWillAppear:(NSNotification *)notification{
	//TODO: 以前的一个砸蛋的BUG，目前木有再现
	[self closeAlarmView];
}
- (void)playbackStateChanged:(NSNotification *)aNotification {
    NSString *totalTime = [NSString stringWithFormat:@"%f",playerAction.player.duration];
    if (playerAction.player.duration > 0) {
        [_totalTimeLabel setText:[BTUtilityClass changToTimeFormatWithString:[totalTime intValue]]];
        _progressBar.bufferDistant = 320.0 * 5 / [totalTime intValue];
    }
    
    if (playerAction.player.state == AS_STARTING_FILE_THREAD) {
        [BTPlayerManager sharedInstance].playList = _playList;
        [BTPlayerManager sharedInstance].playingStoryIndex = _playingStoryIndex;
        [BTPlayerManager sharedInstance].listName = _categoryName;
        [BTPlayerManager sharedInstance].storyType = _storyType;

    } else if (playerAction.player.state == AS_INITIALIZED && !playerAction.player.startPause) { 
        [self setButtonType:BUTTON_LOADING];

    }else if (playerAction.player.state == AS_PLAYING){

        isDrugged = NO;
        playerAction.bIsReadyToPlay = YES;
        playerAction.isFinishPlaying = NO;
        [self setButtonType:BUTTON_PAUSE];
        _progressBar.seeking = NO;
    }else if (playerAction.player.state == AS_PAUSED && playerAction.player.pauseReason != AS_STOPPING_TEMPORARILY) {
        playerAction.bIsReadyToPlay = YES;
		isDrugged = NO;
        [self setButtonType:BUTTON_PLAY];
    } else if (playerAction.player.state == AS_PAUSED && playerAction.player.pauseReason == AS_STOPPING_TEMPORARILY) {
        isDrugged = NO;
        [self setButtonType:BUTTON_LOADING];
    } else if (playerAction.player.state == AS_STOPPED) {
        if (playerAction.player.stopReason == AS_STOPPING_EOF) {
            
            isDrugged = NO;
			[self currentStoryStop:nil];
            playerAction.isFinishPlaying = YES;
        }
        [self setButtonType:BUTTON_PLAY];
        playerAction.bIsReadyToPlay = YES;
            
        
    }
}

-(void)modifyPlayStoryPlayingStatus:(NSNotification *)sender {
    [self.tableView reloadData];
}

-(void)initData{
    if (playerAction == nil) {
        playerAction = [[BTPlayerAction alloc] init];
    } 

    playMode = PLAYBACK_IN_TURN;
    playViewType = VIEWTYPE_IMG;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eggViewWillAppear:)
                                                 name:NOTIFICATION_EGG_VIEW_WILL_APPEAR
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:ASStatusChangedNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(comeNoWeiXin:)
                                                 name:NOTIFICATION_NO_WEIXIN
                                               object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyPlayStoryPlayingStatus:) name:NOTIFICATION_PLAY_STORY object:nil];
    //锁屏的远程控制通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remoteControlNotification:) name:NOTIFICATION_REMOTE_CONTROL_CHANGED object:nil];
    _storyPlayedAction = [[BTStoryPlayedAction alloc] init];
    winsize = [UIScreen mainScreen].bounds.size;
}

-(void)initChildUI {
    
}

-(void)initUI{
    picImageComboView = [[UIView alloc] initWithFrame:PIC_COMBO_RECT];
    [self.view addSubview:picImageComboView];
    
    picImageView = [[BTNetImageView alloc] initWithFrame:PIC_IMAGE_RECT];
    [picImageComboView addSubview:picImageView];
    picImageBack = [[UIImageView alloc] initWithFrame:PIC_BACK_RECT];
    UIImage *image = [UIImage imageNamed:@"blackboard.png"];
    picImageBack.image = image;
    [picImageComboView addSubview:picImageBack];
    
    picImageBack.hidden = YES;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 365, 320, 87)];
    [self.view addSubview:bottomView];
    
    _progressBar=[[BTPlayerProgressView alloc] initWithFrame:CGRectMake(-10, -10, 340, 50)];
    _progressBar.target = self;
    [bottomView addSubview:_progressBar];
    
    
    //播放按钮相关
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(winsize.width / 2 - BUTTON_AUDIO_WIDTH /2 ,BUTTON_AUDIO_Y, BUTTON_AUDIO_WIDTH, BUTTON_AUDIO_HEIGHT);
    [self setButtonType:BUTTON_PLAY];
    [_playButton addTarget:self action:@selector(playItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_playButton];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(winsize.width / 2 - BUTTON_AUDIO_WIDTH /2 + 80,BUTTON_AUDIO_Y, BUTTON_AUDIO_WIDTH, BUTTON_AUDIO_HEIGHT);
    [_nextButton setImage:[UIImage imageNamed:@"Button_fastforward.png"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(forWardItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_nextButton];

    _prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _prevButton.frame = CGRectMake(winsize.width / 2 - BUTTON_AUDIO_WIDTH /2 - 80,BUTTON_AUDIO_Y, BUTTON_AUDIO_WIDTH, BUTTON_AUDIO_HEIGHT);
    [_prevButton setImage:[UIImage imageNamed:@"Button_rewind.png"] forState:UIControlStateNormal];
    [_prevButton addTarget:self action:@selector(backWardItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_prevButton];
    

    //功能按钮
    functionButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height)];
    functionButtonShow = YES;
    
    [self.view insertSubview:functionButtonView belowSubview:bottomView];
    
    
    _styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _styleButton.frame = CGRectMake(winsize.width / 2 - BUTTON_FUNCTION_WIDTH /2 - 120,BUTTON_FUNCTION_Y - 3, BUTTON_FUNCTION_WIDTH, BUTTON_FUNCTION_HEIGHT);
    [_styleButton setImage:[UIImage imageNamed:@"Button_style_3.png"] forState:UIControlStateNormal];
    [_styleButton addTarget:self action:@selector(modeSwitchItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [functionButtonView addSubview:_styleButton];
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.frame = CGRectMake(winsize.width / 2 - BUTTON_FUNCTION_WIDTH /2 - 40,BUTTON_FUNCTION_Y, BUTTON_FUNCTION_WIDTH, BUTTON_FUNCTION_HEIGHT);
    [_timeButton setBackgroundImage:[UIImage imageNamed:@"Button_time.png"] forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(timingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
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
    
    [functionButtonView addSubview:_timeButton];

    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(winsize.width / 2 - BUTTON_FUNCTION_WIDTH /2 + 40,BUTTON_FUNCTION_Y, BUTTON_FUNCTION_WIDTH, BUTTON_FUNCTION_HEIGHT);
    [_shareButton setImage:[UIImage imageNamed:@"Button_share.png"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [functionButtonView addSubview:_shareButton];  
    
    _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadButton.frame = CGRectMake(winsize.width / 2 - BUTTON_FUNCTION_WIDTH /2 + 120,BUTTON_FUNCTION_Y, BUTTON_FUNCTION_WIDTH, BUTTON_FUNCTION_HEIGHT);
    [_downloadButton setImage:[UIImage imageNamed:@"Button_download.png"] forState:UIControlStateNormal];
    [_downloadButton addTarget:self action:@selector(cacheItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [functionButtonView addSubview:_downloadButton];
    
    
    //时间显示
    _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 18, 100, 20)];
    [_currentTimeLabel setTextAlignment:UITextAlignmentLeft];
    [_currentTimeLabel setText:@"00:00"];
    [_currentTimeLabel setBackgroundColor:[UIColor clearColor]];
    [_currentTimeLabel setTextColor:[UIColor colorWithRed:33.0/255.0 green:82.0/255.0 blue:53.0/255.0 alpha:1.0]];
    _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 18, 100, 20)];
    [_totalTimeLabel setTextAlignment:UITextAlignmentRight];
	[_totalTimeLabel setText:@"00:00"];
    [_totalTimeLabel setBackgroundColor:[UIColor clearColor]];
    [_totalTimeLabel setTextColor:[UIColor colorWithRed:33.0/255.0 green:82.0/255.0 blue:53.0/255.0 alpha:1.0]];
    [bottomView addSubview:_currentTimeLabel];
    [bottomView addSubview:_totalTimeLabel];
    
    

    BTAppDelegate *appDelegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
    listButton = appDelegate.navView.playListButton;
    [listButton addTarget:self action:@selector(listButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    actionState = ACTION_NOTNEED;
    _loadMoreFooterView.visible = NO;
    [self.view insertSubview:_ropeView aboveSubview:self.tableView];
    _ropeView.hidden = YES;

}
#pragma mark -
#pragma mark touch事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (functionButtonMoving || playViewType == VIEWTYPE_CONVERT) {
        return;
    }
    UITouch *touch=[touches anyObject];
    CGPoint touchInComboView = [touch locationInView:picImageComboView];
    if (!isPicDragging) {
        isPicMoved = NO;
        
        if (CGRectContainsPoint(picImageView.frame, touchInComboView)) {
            isPicDragging=YES;
            
        }
        
    }




}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint lastLocation = [touch previousLocationInView:self.view];
    CGPoint currentLocation = [touch locationInView:self.view];
    if (isPicDragging) {
        isPicMoved = YES;
        CGFloat offsetY = currentLocation.y-lastLocation.y;
        CGPoint center = picImageComboView.center;
        if ( center.y+offsetY < IMG_MOVE_Y_MIN) {
            center.y = IMG_MOVE_Y_MIN;
        } else if ( center.y+offsetY > IMG_MOVE_Y_MAX + DIFF_HEIGHT / 2) {
            center.y = IMG_MOVE_Y_MAX+ DIFF_HEIGHT / 2;
        } else { 
            center.y += offsetY;
        }
        picImageComboView.center = center;
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (playViewType == VIEWTYPE_CONVERT) {
        return;
    }
    if (isPicDragging) {
        if (functionButtonShow && _storyType != StoryType_Radio) {
            [UIView animateWithDuration:0.5 animations:^{picImageComboView.frame = PIC_COMBO_RECT_HIGH;} completion:^(BOOL finished){}];
        } else {
                [UIView animateWithDuration:0.5 animations:^{picImageComboView.frame = PIC_COMBO_RECT;} completion:^(BOOL finished){}];
        }
        isPicDragging = NO;
    } 
    UITouch *touch=[touches anyObject];
    CGPoint touchInComboView = [touch locationInView:picImageComboView];
    if (!isPicMoved && CGRectContainsPoint(picImageView.frame, touchInComboView)) {

        if (functionButtonMoving) {
            return;
        }
        if (_storyType == StoryType_Radio ) {
            return;
        }
        functionButtonMoving = YES;
        if (functionButtonShow) {
            
            [UIView animateWithDuration:0.5 animations:^{functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+BUTTON_FUNCTION_HEIGHT, winsize.width, winsize.height);} completion:^(BOOL finished){functionButtonView.hidden = YES; functionButtonMoving = NO;}];
              [UIView animateWithDuration:0.5 animations:^{picImageComboView.frame = PIC_COMBO_RECT;} completion:^(BOOL finished){}];
            
            
        } else {
            functionButtonView.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+0, winsize.width, winsize.height);} completion:^(BOOL finished){ functionButtonMoving = NO;}];
            [UIView animateWithDuration:0.5 animations:^{picImageComboView.frame = PIC_COMBO_RECT_HIGH;} completion:^(BOOL finished){}];
            
        }
        
        functionButtonShow = !functionButtonShow;
    }
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
            if (_playingStoryIndex+1 < [_playList count]) {
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
     //这里这样写是因为ios sdk中在player播放到结束的时候，先发通知，在停止音乐。在setcontentUrl前player还是playing状态，
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
-(void)modeSwitchItemPressed:(id)sender{
    [BTRQDReport reportUserAction:EventPlayingLayerPlayingModeButtonClicked];
	
	BOOL isAlarmRunning = ([BTAlarm sharedInstance].state == eBTAlarmStateRunning);
	
    if(isAlarmRunning){
		switch (playMode) {
            case PLAYBACK_SINGLE_CYCLE:{
                playMode=PLAYBACK_IN_TURN;
                bIsSingleCycle=NO;
                break;
            }
            case PLAYBACK_IN_TURN:{
                playMode=PLAYBACK_SINGLE_CYCLE;
                bIsSingleCycle=YES;
                break;
            }
            default:
                playMode=PLAYBACK_IN_TURN;
                break;
        }
    }else {
        switch (playMode) {
            case PLAYBACK_SINGLE_CYCLE:{
                playMode=PLAYBACK_SINGLE;
                bIsSingleCycle=NO;
                break;
            }
            case PLAYBACK_SINGLE:{
                playMode=PLAYBACK_IN_TURN;
                bIsSingleCycle=NO;
                break;
            }
            case PLAYBACK_IN_TURN:{
                playMode=PLAYBACK_SINGLE_CYCLE;
                bIsSingleCycle=YES;
                break;
            }
            default:
                break;
        }
    }

    [self setPlayModeLabelContent];
    
}

-(void)backWardItemPressed:(id)sender{
    [BTRQDReport reportUserAction:EventPlayingLayerPreButtonClicked];

     if(!buttonPressFlag){
         return;
     }
    if ([_playList count] == 0) {
        return;
    }
    if (_storyType == StoryType_Radio && _playingStoryIndex == 0) {
        return;
    }
     buttonPressFlag = NO;
     
     [self performSelector:@selector(changeButtonPressFlag) withObject:nil afterDelay:1.0];
    _playingStoryIndex--;
    if (_playingStoryIndex < 0) {
        _playingStoryIndex = [_playList count] - 1;
    }
    [self playStory];

}

-(void)playItemPressed:(id)sender{
	[BTRQDReport reportUserAction:EventPlayingLayerPlayButtonClicked];

	int playTime = [playerAction.player progress];
    if ([_playList count] == 0) {
        return;
    }
    if (!playerAction.bIsReadyToPlay && playTime <= 0) {
        
        if (!playerAction.player.startPause) {
            playerAction.player.startPause = YES;
            [self setButtonType:BUTTON_PLAY];
            _progressBar.currentPlayingProgress = 0;
        } else {
            if (_progressBar.actualCacheProgress >= 0.9) {
                playerAction.player.startPause = NO;
                [playerAction.player start];
            } else {
                playerAction.player.startPause = NO;
                [self setButtonType:BUTTON_LOADING];
            }

        }
        return;
    }
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
    buttonPressFlag = NO;
    _playingStoryIndex++ ;
    if(_playingStoryIndex > [_playList count] - 1){
        _playingStoryIndex = 0;
    }
    [self performSelector:@selector(changeButtonPressFlag)
			   withObject:nil
			   afterDelay:1.0];
    [self playStory];
}

-(void)cacheItemPressed:(id)sender{
    
    if ([BTUtilityClass isNetWorkNotAvailable]) {
        [[BTDownLoadManager sharedInstance] showNoNetWorkAlert];
        return;
    }
    
    if ([[BTDownLoadManager sharedInstance] showDownloadAlert]) {
        return;
    }
    
	[BTRQDReport reportUserAction:EventPlayingLayerDownloadButtonClicked];
	
    BTStory *story = [_playList objectAtIndex:_playingStoryIndex];
    
    NSString *storyName = story.title;
    NSString *alertStr = nil;
    story.bIsInLocal = YES;
    if (![[BTDownLoadManager sharedInstance] isInMyStoryList:story]) {
        alertStr = [NSString stringWithFormat:@"%@开始下载",storyName];
        
        if (![[BTDownLoadManager sharedInstance] isInMyStoryList:story]) {
            [[BTDownLoadManager sharedInstance] addNewDownLoadTask:story];
            [BTUtilityClass setTabBarBadgeNumber:1];
        }
    }else{
        alertStr = [NSString stringWithFormat:@"%@已下载",storyName];
    }

    [[BTDownLoadAlertView sharedAlertView] showDownLoadCompleteAlertWithString:alertStr];
    [BTDownLoadAlertView showAlert];
	
}



- (void)clickShareBtn:(id)sender {
	[BTRQDReport reportUserAction:EventPlayingLayerShareButtonClicked];
	
	
    [[SHK currentHelper] setRootViewController:self];
	NSArray *itemArray = [NSArray arrayWithObjects:@"腾讯微博",@"新浪微博",@"微信好友",@"人人网", @"取消", nil];	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for(NSString *t in itemArray){
		[actionSheet addButtonWithTitle:t];
	}
    //2012.11.27 nate Add Start
    //经过和产品商定--此功能暂时取消
    //[self initSheetData:actionSheet SheetItemCount:([itemArray count])];
    //2012.11.27 nate Add Edd
    
	actionSheet.cancelButtonIndex = [itemArray count] - 1;
    
	actionSheet.delegate = self;
	[actionSheet showInView:self.view.window];
	[actionSheet release];
    appearByFinishShare = YES;
}

- (void)tapGes:(UITapGestureRecognizer *)tap {
    UIButton *button = (UIButton *)tap.view.superview;
    [button actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
}

//2012.11.27 nate add
//分享界面item追加图片
-(void) initSheetData:(UIActionSheet*)actionSheet SheetItemCount:(NSInteger)actionSheetItemCount{
    
    if (actionSheet == nil) {
        return;
    }
 
    for (int i=1; i<actionSheetItemCount; i++) {
        
        UIButton *button = actionSheet.subviews[i];
        
        if (button != nil) {
            UIImage *image = [UIImage imageNamed:(@"icon.png")];
            [button setImage:image forState:UIControlStateNormal];
        }
    }
}

- (void)playingButtonPressed:(id)sender{
	[BTRQDReport reportUserAction:EventPlayingButtonClicked];
    if (playViewType != VIEWTYPE_LIST) {
        return;
    }
    if (isPicDragging || functionButtonMoving) {
        return;
    }
    playViewType = VIEWTYPE_CONVERT;
    self.playingButton.hidden = YES;
    listButton.hidden = NO;
    self.viewTitle.text = @"正在播放";
	self.title = @"正在播放";
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0, -450 - DIFF_HEIGHT, 320, DIFF_HEIGHT+ 400);
        _ropeView.hidden = YES;
        if (functionButtonShow && _storyType != StoryType_Radio) {
            functionButtonView.hidden = NO;
        }
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{
            
            picImageComboView.center = CGPointMake(picImageComboView.center.x, picImageComboView.center.y + WINDOW_HEIGHT);
            
            if (functionButtonShow) {
                functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+0, winsize.width, winsize.height);
            }
            BTStory *story = [_playList objectAtIndex:_playingStoryIndex];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",THREE20_DIRECTORY,story.storyId,[BTUtilityClass getPicSuffix:type_story_playView picVersion:story.picversion]];
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            if (image) {
                picImageView.suffix = [BTUtilityClass getPicSuffix:type_story_playView picVersion:story.picversion];
                if(story.picDownLoadURLs !=nil){
                    picImageView.urlPath = [story.picDownLoadURLs objectAtIndex:0];
                }else{
                    picImageView.urlPath = @"bundle://playerDefault.png";
                }
            }
        }completion:^(BOOL finished) {

            playViewType = VIEWTYPE_IMG;
            BTStory *story = [_playList objectAtIndex:_playingStoryIndex];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",THREE20_DIRECTORY,story.storyId,[BTUtilityClass getPicSuffix:type_story_playView picVersion:story.picversion]];
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            if (!image) {
                [self loadImageWithStory:story];
            }
            
        }];
        
    }];
    
    
}
- (void)listButtonPressed:(id)sender{
    [BTRQDReport reportUserAction:EventPlayingLayerPlaylistButtonClicked];
    if (playViewType != VIEWTYPE_IMG) {
        return;
    }
    if (isPicDragging || functionButtonMoving) {
        return;
    }
    playViewType = VIEWTYPE_CONVERT;
    self.playingButton.hidden = NO;
    listButton.hidden = YES;
    self.viewTitle.text = @"播放列表";
	self.title = @"播放列表";
    [UIView animateWithDuration:0.5 animations:^{
        picImageComboView.center = CGPointMake(picImageComboView.center.x, picImageComboView.center.y - WINDOW_HEIGHT);
        if (functionButtonShow) {
            functionButtonView.frame = CGRectMake(0, DIFF_HEIGHT+BUTTON_FUNCTION_HEIGHT, winsize.width, winsize.height);
        }
    } completion:^(BOOL finished){
        functionButtonView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            
            
            self.tableView.frame = CGRectMake(0, 0, 320, DIFF_HEIGHT+380);
        }completion:^(BOOL finished) {
            _ropeView.hidden = NO;
            playViewType = VIEWTYPE_LIST;
        }];
    
    }];
    
}

//弹出分享按钮界面
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    BOOL connectionRequired = NO;
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (netStatus){
        case NotReachable:{
            connectionRequired= NO; 
            break;
        }
        case ReachableViaWWAN:{
            connectionRequired = YES;
            break;
        }
        case ReachableViaWiFi:{
            connectionRequired = YES;
            break;
        }
    }
    NSInteger totalCount = [actionSheet numberOfButtons];
    if(buttonIndex == totalCount - 1) {//from bottom #1, cancel
        appearByFinishShare = NO;
    } else if (buttonIndex == totalCount - 2) {
        appearByFinishShare = NO;
        [playerAction clickRenrenItem];
    } else if (buttonIndex == totalCount - 3){
        appearByFinishShare = NO;
        [playerAction clickWeixinItem];
    } else if (buttonIndex == totalCount - 4){
        if (!connectionRequired) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求错误"
                                                            message:@"网络连接失败"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            appearByFinishShare = NO;
            return;
        }
        playerAction.sharePicImage = picImageView.image;
        [playerAction clickSinaItem];
        
        
    } else if (buttonIndex == totalCount - 5){
        if (!connectionRequired) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求错误"
                                                            message:@"网络连接失败"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            appearByFinishShare = NO;
            return;
        }
        playerAction.sharePicImage = picImageView.image;
        [playerAction clickTencentItem];
    }
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
         [self backWardItemPressed:nil];
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

-(void)loadImageWithStory:(BTStory *)story {
    
    CGRect rect = picImageView.frame;
    [picImageView removeFromSuperview];
    [picImageView release];
    picImageView = [[BTNetImageView alloc] initWithFrame:rect];
    [picImageComboView insertSubview:picImageView belowSubview:picImageBack];
    //[self.view insertSubview:picImageView aboveSubview:picImageBack];
    picImageBack.hidden = NO;
    hasGetPic = NO;
    
    //Three20 cache下文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",THREE20_DIRECTORY,story.storyId,[BTUtilityClass getPicSuffix:type_story_playView picVersion:story.picversion]];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    //document/babyStor文件路径
    NSString *picFileName = [NSString stringWithFormat:@"%@_storyPlayView",story.storyId];
    NSString *localPicFilePath = [NSString stringWithFormat:@"documents://babyStory/%@",picFileName];
    
    //Three20 cache 文件夹中是否有插图
    BOOL Three20HasImage = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    //document/babyStory 文件夹中是否有插图
    BOOL dcumentHasImage = [[NSFileManager defaultManager] fileExistsAtPath:[BTUtilityClass fileWithPath:picFileName]];  
   
    if(_storyType == StoryType_Local && dcumentHasImage){
        picImageView.defaultImage = TTIMAGE(localPicFilePath);
        if (image == nil) {
            image = [UIImage imageWithContentsOfFile:[BTUtilityClass fileWithPath:picFileName]];
        }
        TLog(@"故事插图名字 = %@",picFileName);
    }else {
        if (image&&story.picDownLoadURLs !=nil) {
            picImageView.defaultImage = image;
            hasGetPic = YES;
            //如果下载中有此故事，将Three20 cache下插图拷贝到本地
            if ([[BTDownLoadManager sharedInstance] isInMyStoryList:story]&&!dcumentHasImage && Three20HasImage) {
                [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:[BTUtilityClass fileWithPath:picFileName] error:nil];
                TLog(@"拷贝故事插图名字 = %@",picFileName);
            }
        }else if(story.picDownLoadURLs ==nil){
            picImageView.defaultImage = TTIMAGE(@"bundle://storyViewDefault.png");
            picImageView.suffix = [BTUtilityClass getPicSuffix:type_story_playView picVersion:story.picversion];
            picImageView.urlPath = @"bundle://playerDefault.png";
            UILabel *waitingLabel = [[UILabel alloc] init];
            waitingLabel.frame = CGRectMake(20, 160, 250, 30);
            NSString *titleName = [NSString stringWithFormat:@"%@",story.title];
            [waitingLabel setFont:[UIFont boldSystemFontOfSize:18]];
            if ([titleName length] > 10) {
                [waitingLabel setFont:[UIFont boldSystemFontOfSize:180 / [titleName length]]];
            }
            [waitingLabel setTextAlignment:UITextAlignmentCenter];
            [waitingLabel setText:titleName];
            [waitingLabel setBackgroundColor:[UIColor clearColor]];
            [waitingLabel setTextColor:[UIColor colorWithRed:18.0/255 green:57.0/255 blue:0.0/255 alpha:1.0]];
            [picImageView addSubview:waitingLabel];
            [waitingLabel release];
        }else {
            picImageView.defaultImage = TTIMAGE(@"bundle://storyViewDefault.png");
            NSString *titleName = [NSString stringWithFormat:@"%@",story.title];
            UILabel *waitingLabel = [[UILabel alloc] init];
            UILabel *loadingLabel = [[UILabel alloc] init];
            waitingLabel.frame = CGRectMake(100, 80, 180, 30);
            loadingLabel.frame = CGRectMake(100, 110, 180, 30);
            [waitingLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
            if ([titleName length] > 10) {
                [waitingLabel setFont:[UIFont fontWithName:@"Arial" size:180 / [titleName length]]];
            }
            [waitingLabel setTextAlignment:UITextAlignmentCenter];
            [waitingLabel setText:titleName];
            [waitingLabel setBackgroundColor:[UIColor clearColor]];
            [waitingLabel setTextColor:[UIColor colorWithRed:113.0/255 green:180.0/255 blue:210.0/255 alpha:1.0]];
            waitingLabel.tag = 1999;
            [loadingLabel setTextAlignment:UITextAlignmentCenter];
            [loadingLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
            [loadingLabel setText:@"正在加载..."];
            [loadingLabel setBackgroundColor:[UIColor clearColor]];
            [loadingLabel setTextColor:[UIColor colorWithRed:113.0/255 green:180.0/255 blue:210.0/255 alpha:1.0]];
            loadingLabel.tag = 2001;
            [picImageView addSubview:waitingLabel];
            [picImageView addSubview:loadingLabel];
            [waitingLabel release];
            [loadingLabel release];
            
            picImageView.suffix = [BTUtilityClass getPicSuffix:type_story_playView picVersion:story.picversion];
            if(story.picDownLoadURLs !=nil){
                picImageView.urlPath = [story.picDownLoadURLs objectAtIndex:0];
            }
        }
    }

    picImageView.viewController = self;
    [BTUtilityClass setMediaInfo:image andTitle:story.title andArtist:nil];
}

-(void)playStory {
    [_currentTimeLabel setText:@"00:00"];
    [_totalTimeLabel setText:@"00:00"];
    storyHasRecorder = NO;
    if (_storyType != StoryType_Radio) {
        playerAction.playList = _playList;
    }
 
    playerAction.playingStoryIndex = _playingStoryIndex;
    playerAction.storyType = _storyType;

    [self setButtonType:BUTTON_LOADING];
    _progressBar.currentCacheProgress=0;
    _progressBar.currentPlayingProgress=0;
    _progressBar.actualCacheProgress=0;
    _progressBar.isPlayThumbAnimationEnable=YES;
    _progressBar.seeking = YES;
    BTStory *story = [_playList objectAtIndex:_playingStoryIndex];
    story.isNew = NO;
    NSString *storyUrl = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@.mp3",story.storyId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:storyUrl]) {
        _progressBar.currentCacheProgress=1.0;
        _progressBar.actualCacheProgress=1.0;
    }  else {
        [self setButtonType:BUTTON_LOADING];
    }
    if (playerAction.player) {
        [playerAction.player stop];
    }
    [self setButtonType:BUTTON_LOADING];
    if ([_playList count] > 0) {
        if (playViewType == VIEWTYPE_IMG ) {
            [self loadImageWithStory:[_playList objectAtIndex:_playingStoryIndex]];
        }
        [playerAction playStory];
        [self createTimer];
    }
}


- (void)createTimer{
    if ([_timer isValid]) {
		[_timer invalidate];
    }
	//TODO: 0.25s待验证，根据总时间来动态决定？
    _timer = [NSTimer scheduledTimerWithTimeInterval:.25f target:self selector:@selector(updateMusicPlayer:) userInfo:nil repeats:YES];
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
    
    if ([_playList count] <= 0) {
        return;
    }
    if (playerAction.player.state == AS_PLAYING){
        [self setButtonType:BUTTON_PAUSE];
    } else if (playerAction.player.state == AS_PAUSED && playerAction.player.pauseReason != AS_STOPPING_TEMPORARILY) {
    
        [self setButtonType:BUTTON_PLAY];
    }
    if (playerAction.player.duration > 1) {
        NSString *totalTime = [NSString stringWithFormat:@"%f",playerAction.player.duration];
        [_totalTimeLabel setText:[BTUtilityClass changToTimeFormatWithString:[totalTime intValue]]];
    }
    _progressBar.isPlayThumbAnimationEnable=YES;
    
    if (!hasGetPic) {
        
        BTStory *story = [_playList objectAtIndex:_playingStoryIndex];

        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",THREE20_DIRECTORY,story.storyId,[BTUtilityClass getPicSuffix:type_story_playView picVersion:story.picversion]];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if (image) {
            UIView *view = [picImageView viewWithTag:1999];
            if (view) {
                [view removeFromSuperview];
            }
            UIView *view2 = [picImageView viewWithTag:2001];
            if (view2) {
                [view2 removeFromSuperview];
            }
            hasGetPic = YES;
            [BTUtilityClass setMediaInfo:image andTitle:story.title andArtist:nil];
        } 
    }

    if (isDrugged && playerAction.player.state != AS_PAUSED) {
        return;
    }
    
    
    //获得当前播放时间
    int currentT = (int)[playerAction.player progress];
    NSString *timeValue = [BTUtilityClass changToTimeFormatWithString:currentT];
    
    //更新显示当前播放时间
    [_currentTimeLabel setText:timeValue];
    //控制进度条的播放和预加载进度
    if([playerAction.player duration] > 0 ) {
        if (playerAction.player.state==AS_PLAYING) {
            if (!isDrugged) {

                _progressBar.currentPlayingProgress=[playerAction.player progress]/[playerAction.player duration];
            }else {
                //由于拖动进度条之后播放器首先要定位到拖动后的位置，定位的过程中播放器的进度还没有更新到最新的位置，若直接调用回出现拖动进度条后，进度条来回弹的现象
                if (fabs(_progressBar.currentPlayingProgress-[playerAction.player progress]/[playerAction.player duration])<=0.02) {
                    isDrugged=NO;
                }
            }
        }
        //设置播放器的加载进度
        _progressBar.actualCacheProgress=[playerAction.player loadingProgress]/[playerAction.player duration];
    } else {
        _progressBar.currentPlayingProgress=0.0;
    }
    if (currentT <= 0) {
        _progressBar.currentPlayingProgress=0.0;
    }
    if (!storyHasRecorder && [playerAction.player progress]/[playerAction.player duration] >= 0.5) {
        [self storyPlayOverHalf:[_playList objectAtIndex:_playingStoryIndex]];
        if (_storyType == StoryType_Local) {
            BTStory *story = [_playList objectAtIndex:_playingStoryIndex];
            [self recordLocalStoryPlayCounts:story.storyId];
        }
    }
}

#pragma mark -
#pragma mark BTPlayerProgressDelegate    
- (void)progressSliderDragBegin{
    if (playerAction==nil) {
        return;
    }

    isDragging=YES;
    _progressBar.isSliderDragging=YES;
    //拖动播放进度条时销毁定时器
    _progressBar.isPlayThumbAnimationEnable=NO;
}

- (void)progressSliderDragEnd{
    if (playerAction==nil) {
        return;
    }
	//判断滑块停止位置是否在缓存区内
    float sliderValue = [playerAction.player loadingProgress];
    
    if ([playerAction.player duration] == 0.0) {
        _progressBar.currentPlayingProgress = 0.0;       //手动更新进度条位置
    } else if(_progressBar.currentPlayingProgress>sliderValue/[playerAction.player duration] - 0.01) {
        isDrugged=YES;
        if (sliderValue > 0.95 * [playerAction.player duration] || [playerAction.player duration] - sliderValue < 6.0) {
            [playerAction.player seekToTime:[playerAction.player duration]];
            
        } else if (sliderValue > 0){
            [playerAction.player seekToTime:sliderValue];
            
            //[self updateMusicPlayer:0.0];   //手动更新进度条位置
        }
        
	}else{
        isDrugged=YES;
        if (_progressBar.currentPlayingProgress > 0.95 || (1.0-_progressBar.currentPlayingProgress)*[playerAction.player duration] < 6.0) {
            [playerAction.player seekToTime:[playerAction.player duration]];
        } else {
            [playerAction.player seekToTime:_progressBar.currentPlayingProgress*[playerAction.player duration]];     
        }
        
	}

    _progressBar.isPlayThumbAnimationEnable=YES;
    isDragging=NO;

}

-(void)storyPlayOverHalf:(BTStory *)story {
    NSString *storyID = story.storyId;
    [self.storyPlayedAction start:storyID];
    storyHasRecorder = YES;
}

-(void)recordLocalStoryPlayCounts:(NSString *)storyId{
    NSString *localPlist = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
    NSMutableArray *locals = [NSMutableArray arrayWithContentsOfFile:localPlist];
    for (int i = 0; i < [locals count]; i++) {
        NSMutableDictionary *dic = [locals objectAtIndex:i];
        if ([storyId isEqualToString:[dic objectForKey:KEY_STORY_ID]]) {
            if ([dic objectForKey:KEY_STORY_PLAYCOUNTS]) {
                NSInteger counts = [[dic objectForKey:KEY_STORY_PLAYCOUNTS] integerValue];
                counts ++;
                CDLog(BTDFLAG_LOCAL_SORT,@"storyId = %@,count = %d",storyId,counts);
                [dic setValue:[NSNumber numberWithInteger:counts] forKey:KEY_STORY_PLAYCOUNTS];
            }else{
                CDLog(BTDFLAG_LOCAL_SORT,@"storyId = %@,count = %d",storyId,1);
                [dic setValue:[NSNumber numberWithInteger:1] forKey:KEY_STORY_PLAYCOUNTS];
            }
        
            [locals writeToFile:localPlist atomically:YES];
            break;
        }
    }

}

//设置按钮状态
- (void)setPlayModeLabelContent{
    switch (playMode) {
        case PLAYBACK_IN_TURN:
            [_styleButton setImage:[UIImage imageNamed:@"Button_style_3.png"] forState:UIControlStateNormal];
            break;
        case PLAYBACK_SINGLE:
            [_styleButton setImage:[UIImage imageNamed:@"Button_style_2.png"] forState:UIControlStateNormal];
            break;
        case PLAYBACK_SINGLE_CYCLE:
            [_styleButton setImage:[UIImage imageNamed:@"Button_style_1.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
-(void)setButtonType:(BUTTON_TYPE)buttonType {
    if (rotationTimer) {
        if ([rotationTimer isValid]) {
            [rotationTimer invalidate];
        }
        rotationTimer=nil;
    }
    _playButton.transform = CGAffineTransformMakeRotation(0);
    switch (buttonType) {
        case BUTTON_PLAY:
            [_playButton setImage:[UIImage imageNamed:@"Button_play.png"] forState:UIControlStateNormal];
            break;
        case BUTTON_PAUSE:
            [_playButton setImage:[UIImage imageNamed:@"Button_pause.png"] forState:UIControlStateNormal];  
            break;
        case BUTTON_LOADING:
            [_playButton setImage:[UIImage imageNamed:@"Button_loading.png"] forState:UIControlStateNormal];
            rotationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLoadButton:) userInfo:nil repeats:YES];
            break;
        default:
            break;
    }
}

-(void)updateLoadButton:(NSTimeInterval) delta{
    rotecount = (rotecount + 10) % 360;
    _playButton.transform = CGAffineTransformMakeRotation(rotecount* M_PI/180);

}



#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return [_playList count];
}
- (void) updateTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BTStoryCell *storyCell = (BTStoryCell *)cell;
    BTStory *storyData = nil;
    if (indexPath.row < [_playList count]) {
        storyData = [_playList objectAtIndex:indexPath.row];
        if(indexPath.row == [_playList count] - 1){
            [storyCell.backButton setImage:[UIImage imageNamed:@"myStory_cell_last_bg.png"] forState:UIControlStateNormal];
        }else {
            [storyCell.backButton setImage:[UIImage imageNamed:@"myStory_cell_bg.png"] forState:UIControlStateNormal];
        }
        storyCell.storyData = storyData;
        [storyCell setPlayListCellData];
        [storyCell setImageController:self];
        storyCell.downloadBtn.hidden = YES;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    static NSString *CellIdentifier = @"Cell";
    
    BTStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTStoryCell" owner:nil options:nil];
        cell = [objs lastObject];
    }
    [self updateTableViewCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView
	didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
    if (indexPath.row < [_playList count]) {
        [self playingButtonPressed:nil];
        _playingStoryIndex = indexPath.row;
        [self playStory];
    }
}

- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
									 cellIdentifier:(NSString*)identifier {
    BTStoryCell *cell = [[[BTStoryCell alloc] initWithStyle:UITableViewCellStyleDefault
											reuseIdentifier:identifier]
						 autorelease];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView
	heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0f;
}

#pragma mark - 定时定量
//定时按钮点击事件
-(void)timingButtonPressed:(id)sender{
	[BTRQDReport reportUserAction:EventPlayingLayerScheduleButtonClicked];
	
    if (playMode == PLAYBACK_SINGLE) {//单个模式不支持定时定量
        [[BTDownLoadAlertView sharedAlertView] showDownLoadCompleteAlertWithString:@"单个模式下不能设置"];
        [BTDownLoadAlertView showAlert];
    } else {//弹出定时定量窗口
		BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
		if (_alarmVC == nil) {
			_alarmVC = [[BTAlarmViewController alloc] init];
		}
		if (_alarmVC.view.superview == nil) {
			[delegate.window addSubview:_alarmVC.view];
		}
		[delegate.window bringSubviewToFront:_alarmVC.view];
	}
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

