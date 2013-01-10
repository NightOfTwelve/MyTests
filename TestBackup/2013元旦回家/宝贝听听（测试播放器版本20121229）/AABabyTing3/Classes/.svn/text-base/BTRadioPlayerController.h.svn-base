

#import <UIKit/UIKit.h>
#import "BTConstant.h"
#import <AVFoundation/AVFoundation.h>
#import "BTPlayerAction.h"
#import "BTPlayerProgressView.h"
#import "FXLabel.h"
#import "BTTableViewController.h"
#import "BTDataManager.h"
#import "BTOneRadioAction.h"
#import "BTBaseAction.h"
#import "BTStoryPlayedAction.h"
#import "BTListViewController.h"
#import "BTStoryPlayerTimeController.h"
#import "BTStoryPlayerNumberController.h"



#define firstRequestRadioCount          5
#define RadioRequestMinLeftNum          5 


                    




@class BTStory;
@class BTStoryPlayedAction;
@class BTRadioData;

@class BTAlarmViewController;
@interface BTRadioPlayerController : BTListViewController
<AVAudioSessionDelegate, BTBaseActionDelegate>
{
    BTPlayerAction              *playerAction;
    StoryType                   _storyType;                     //故事类型
    NSMutableArray              *_playList;                     //故事列表
    NSString                    *_categoryName;                 //故事列表标题
    int                         _playingStoryIndex;             //当前播放故事索引

    BOOL                        buttonPressFlag;
    UIView                      *bottomView;                    //播放按钮区域
    UIView                      *TvView;                        //电视
    CGSize                      winsize;                        //视图大小
	BOOL					    _bIsBackToCurrentPlayingLayer;  //是否是从正在播放入口进入
    PLAYBACK_MODE               playMode;                       //播放模式
    NSTimer                     *_timer;                        //进度条计时器

    BOOL                        storyHasRecorder;               //用于标记现在播放的故事是否已经播放到了一半
    UILabel                     *_radioTitle;                   //故事标题
    UIButton                    *_playButton;                   //播放按钮
    UIButton                    *_nextButton;                   //下一首按钮
    UIButton                    *_screenPlayButton;             //下一首按钮
    UIButton                    *_timeButton;
    UIImageView                 *_dianboView;
    UIImageView                 *_dianboView1;
    UIImageView                 *_dianboView2;
    int                         dianboPoint;
    UIImageView                 *pauseScreen;
    UIImageView                 *loadingView;
    UIImageView                 *loadingViewBack;
    int                         loadingCount;
    BOOL                        isLoading;
    
	
    BTStoryPlayedAction                 *_storyPlayedAction;    //砸蛋action
    BTRadioData                         *_radio;                //电台数据
    BTOneRadioAction                    *_radioAction;          //电台action
    BOOL                                isInStory;
    

	//定时定量
	UILabel		*_remainsLabel;	//剩余时间（个数）
	UIImageView	*_countSuffixImageView;	//“个”字
	BTAlarmViewController *_alarmVC;		//定时定量ViewController
}

//统计上报和砸蛋使用的处理Action，要由播放界面持有，不要乱release哈
@property (nonatomic, retain)   BTStoryPlayedAction         *storyPlayedAction;
@property (nonatomic, retain)   BTPlayerAction              *playerAction;

@property (nonatomic, retain)   BTOneRadioAction            *radioAction;
@property (nonatomic,copy)      NSMutableArray              *playList;
@property (nonatomic)           int                         playingStoryIndex;
@property (nonatomic)           StoryType                   storyType;
@property (nonatomic)           BOOL                        bIsBackToCurrentPlayingLayer;
@property (nonatomic,retain)    NSString                    *categoryName;
@property (nonatomic,retain)    UIButton                    *playButton;
@property (nonatomic,retain)    UIButton                    *nextButton;
@property (nonatomic,retain)    UIButton                    *timeButton;

@property (nonatomic,retain)    BTRadioData                 *radio;
//初始化数据
-(void)initData;
//初始化ui
-(void)initUI;
//播放按钮
-(void)playItemPressed:(id)sender;
//下一首按钮
-(void)forWardItemPressed:(id)sender;
//当前故事停止时的处理
-(void)currentStoryStop:(id)sender;
//播放故事
-(void)playStory;
//启动播放定时器
- (void)createTimer;
//销毁播放定时器
- (void)destroyTimer;
//记录某个故事已经播放超过一半
-(void)storyPlayOverHalf:(BTStory *)story;
//电台请求
-(void)startRequestRadio;
//砸蛋活动View显示
-(void)eggViewWillAppear:(NSNotification *)notification;

@end
