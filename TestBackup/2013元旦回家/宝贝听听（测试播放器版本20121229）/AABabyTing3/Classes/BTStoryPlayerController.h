

#import <UIKit/UIKit.h>
#import "BTConstant.h"
#import <AVFoundation/AVFoundation.h>
#import "BTPlayerAction.h"
#import "BTNetImageView.h"
#import "Only320Network.h"
#import "BTPlayerProgressView.h"
#import "FXLabel.h"
#import "BTTableViewController.h"
#import "BTDataManager.h"
#import "BTBaseAction.h"
#import "BTStoryPlayedAction.h"
#import "BTListViewController.h"


#define firstRequestRadioCount          5
#define RadioRequestMinLeftNum          5 

#define BUTTON_AUDIO_WIDTH              57
#define BUTTON_AUDIO_HEIGHT             57
#define BUTTON_AUDIO_Y                  28
#define BUTTON_FUNCTION_WIDTH           65
#define BUTTON_FUNCTION_HEIGHT          75
#define BUTTON_FUNCTION_Y               320


#define IMG_MOVE_Y_MIN                 110
#define IMG_MOVE_Y_MAX                 270

#define PIC_BACK_RECT                   (CGRectMake(0, DIFF_HEIGHT/2-100, 320, 479+1))
#define PIC_IMAGE_RECT                  (CGRectMake(17, DIFF_HEIGHT/2+133, 286, 189))
#define PIC_COMBO_RECT                  (CGRectMake(0, 0, 320, WINDOW_HEIGHT))
#define PIC_COMBO_RECT_HIGH             (CGRectMake(0, -50,320,WINDOW_HEIGHT))



@class BTStory;
@class BTStoryPlayedAction;

//播放模式
typedef enum{
    BUTTON_PLAY=1,          //暂停状态
    BUTTON_PAUSE,           //播放状态
    BUTTON_LOADING,         //loading状态
}BUTTON_TYPE;

//显示状态
typedef enum{
    VIEWTYPE_IMG = 1,       //插图状态
    VIEWTYPE_CONVERT,     //转换动画状态
    VIEWTYPE_LIST,        //列表状态
}PLAYVIEW_TYPE;

@class BTAlarmViewController;

@interface BTStoryPlayerController : BTListViewController
<AVAudioSessionDelegate, UIActionSheetDelegate,BTPlayerProgressDelegate,BTBaseActionDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BTPlayerAction              *playerAction;
    StoryType                   _storyType;                     //故事类型
    NSMutableArray              *_playList;                     //故事列表
    NSString                    *_categoryName;                 //故事列表标题
    int                         _playingStoryIndex;             //当前播放故事索引
    BTPlayerProgressView        *_progressBar;                  //播放进度条
    BTNetImageView              *picImageView;                  //插图
    UIImageView                 *picImageBack;                  //插图背景框
    UIView                      *picImageComboView;              //插图和背景框的组合View
    UIView                      *bottomView;                    //播放按钮区域
    UIView                      *functionButtonView;            //功能按钮区域
    CGSize                      winsize;                        //视图大小
    BOOL                        functionButtonMoving;           //功能按钮是否移动过程中
    BOOL                        functionButtonShow;             //功能按钮是否显示
    BOOL                        appearByFinishShare;            //是否按下了分享按钮
	BOOL					    _bIsBackToCurrentPlayingLayer;  //是否是从正在播放入口进入
    BOOL                        isDragging;                     //是否正在拖动进度条
    BOOL                        isDrugged;                      //进度条拖动完成标记，防止瓢虫跳动
    BOOL                        buttonPressFlag;                //防止暴力点击的标识位
    BOOL                        bIsSingleCycle;                 //是否单曲循环
    BOOL                        isPicDragging;                  //插图是否被拖拽
    BOOL                        isPicMoved;                     //图片移动了
    float                       startPianYiY;                   //拖拽插图点偏移中心位置
    PLAYBACK_MODE               playMode;                       //播放模式
    NSTimer                     *_timer;                        //进度条计时器
    NSTimer                     *rotationTimer;                 //loading按钮旋转计时器
    int                         rotecount;                      //用于记录loading按钮旋转的位置
    BOOL                        storyHasRecorder;               //用于标记现在播放的故事是否已经播放到了一半
    BOOL                        hasGetPic;                      //是否已经显示故事插图
    UIButton                    *_playButton;                   //播放按钮
    UIButton                    *_prevButton;                   //上一首按钮
    UIButton                    *_nextButton;                   //下一首按钮
    UIButton                    *_shareButton;                  //分享按钮
    UIButton                    *_timeButton;                   //定时定量按钮
    UIButton                    *_downloadButton;               //下载按钮
    UIButton                    *_styleButton;                  //播放模式按钮
    UILabel                     *_currentTimeLabel;             //当前播放时间
    UILabel                     *_totalTimeLabel;               //总计播放时间
    PLAYVIEW_TYPE               playViewType;                   //显示模式
    
    
    BTStoryPlayedAction                 *_storyPlayedAction;    //砸蛋action

    BOOL                                isInStory;
    BTNavButton                         *listButton;
	
	//定时定量
	UILabel		*_remainsLabel;	//剩余时间（个数）
	UIImageView	*_countSuffixImageView;	//“个”字
	BTAlarmViewController *_alarmVC;		//定时定量ViewController
}

//统计上报和砸蛋使用的处理Action，要由播放界面持有，不要乱release哈
@property (nonatomic, retain)   BTStoryPlayedAction         *storyPlayedAction;

@property (nonatomic,retain)    BTPlayerAction              *playerAction;
@property (nonatomic,copy)      NSMutableArray              *playList;
@property (nonatomic)           int                         playingStoryIndex;
@property (nonatomic)           StoryType                   storyType;
@property (nonatomic)           BOOL                        bIsBackToCurrentPlayingLayer;
@property (nonatomic,retain)    NSString                    *categoryName;
@property (nonatomic,retain)    BTPlayerProgressView        *progressBar;
@property (nonatomic,retain)    UIButton                    *playButton;
@property (nonatomic,retain)    UIButton                    *prevButton;
@property (nonatomic,retain)    UIButton                    *nextButton;
@property (nonatomic,retain)    UIButton                    *shareButton;
@property (nonatomic,retain)    UIButton                    *timeButton;
@property (nonatomic,retain)    UIButton                    *downloadButton;
@property (nonatomic,retain)    UIButton                    *styleButton;

@property (retain, nonatomic)   UILabel                     *currentTimeLabel;
@property (retain, nonatomic)   UILabel                     *totalTimeLabel;
@property (retain, nonatomic)   UISlider                    *playProgressSlider;
//初始化数据
-(void)initData;
//初始化ui
-(void)initUI;
//根据故事信息拉取插图
-(void)loadImageWithStory:(BTStory *)story;
//上一首按钮
-(void)backWardItemPressed:(id)sender;
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
//设置循环模式按钮样式
- (void)setPlayModeLabelContent;
//设置播放按钮状态
-(void)setButtonType:(BUTTON_TYPE)buttonType;
//记录某个故事已经播放超过一半
-(void)storyPlayOverHalf:(BTStory *)story;
-(void)recordLocalStoryPlayCounts:(NSString *)storyId;
//设置锁屏时故事的插图和名字
-(void)setMediaInfo:(UIImage *)img andTitle:(NSString *)title andArtist:(NSString *)artist;
//砸蛋活动View显示
-(void)eggViewWillAppear:(NSNotification *)notification;

@end
