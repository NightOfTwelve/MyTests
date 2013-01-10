//
//  BTConstant.h
//  AABabyTing3
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTRQDConstant.h"
#import	"BTImportConstant.h"

//cachestory type
typedef enum  {
    High_Complete = 0,
    High_Incomplete,
    Low_Complete,
    Low_Incomplete,
} StoryCache;

//播放模式
typedef enum{
    PLAYBACK_SINGLE=1000  ,          //单首播放：默认
    PLAYBACK_IN_TURN,           //顺序播放
    PLAYBACK_SINGLE_CYCLE,      //单首循环播放 
}PLAYBACK_MODE;

typedef enum  {
	StoryType_Default,
	
    StoryType_Net,
    StoryType_Collect,//现在不用了
    StoryType_Local,
    StoryType_Radio,
	
	StoryType_Count
    
} StoryType;


typedef enum{
	TimeToStop_InStoryNum = 500,     //开启定量模式
	TimeToStop_InLeftTime,			//开启定时模式
	TimeToStop_NoSet,				//关闭该模式
}TimeToStop_MODE;

//view的网络拉取相关的notification
#define viewWillDisAppearNotification      @"viewwillDisappear"
#define viewWillAppearNotification         @"viewwillAppear"

#define WINDOW_HEIGHT	([UIScreen mainScreen].bounds.size.height)

//LOG(Add by Zero)
//#define BTLOG
#define BTLOG			do{ DLog(@"%@,%s",self,__FUNCTION__); }while(0)

//上次切到后台的时间
#define	LAST_APP_DID_ENTER_BG_TIME	@"applicationDidEnterBackgroundTime"

//302配置请求，（存的单位是秒）
#define	CONFIGURATION_RESPONSE				@"response"
#define CONFIGURATION_MAX_LOCAL_STORY		@"max_local_story"	//NSNumber->int
#define	CONFIGURATION_NEXT_REQUEST_TIME		@"next_req_time"	//NSNumber->int
#define	CONFIGURATION_RESOURCE_UPDATE		@"next_change_res"	//NSNumber->int
#define	CONFIGURATION_CLEAR_DATA_MANAGER	@"next_clear_catch"	//NSNumber->int
#define	CONFIGURATION_LAST_REQUEST_TIME		@"last_req_302_time"//上次请求302的成功时间

//Token
#define	PUSH_TOKEN_HAS_UPLOADED		@"token_has_uploaded"	//token是否已经上报成功了

//与数字常量相关的宏
//int MAXNUMBER_OF_LOCAL = 100;
//userDefaults中存了，见上面CONFIGURATION_MAX_LOCAL_STORY和CONFIGURATION_NEXT_REQUEST_TIME

#define MAX_CACHE_STORY_COUNT       20
#define BUFFER_SIZE                 1024 * 100
#define MinDiskSpace                52428800*2+200*1024*1024     //100M
#define cacheDiskSpace              52428800*2+200*1024*1024     //缓存的100M
#define cacheSpaceUpline            50*1024*1024                 //当缓存满50M的时候 会提示用户跳到设置界面
//#define cacheSpaceUpline            0
#define showSaveFLowUpline          1000*1024                     //1000GB
#define KEY_SAVEFLOW_DATE           @"saveFlowDate"
#define KEY_SAVEFLOW_NUM            @"saveFlowNum"

//3.0版本之前故事下载字段
#define KEY_DOWNLOAD_STORYNAME @"storyName"
#define KEY_DOWNLOAD_STORYURL @"storyUrl"
#define KEY_DOWNLOAD_STORYURL_HIGH @"storyUrlHigh"
#define KEY_DOWNLOAD_STORYID @"storyID"
#define KEY_DOWNLOAD_STORYLEN @"storyLen"
#define KEY_DOWNLOAD_STORYANC @"storyAnc"
#define KEY_DOWNLOAD_STORYDES @"storyDes"
#define KEY_DOWNLOAD_STORYDOMAIN @"storyDomain"
#define KEY_DOWNLOAD_PICINPLAYVIEW @"storyPic"
#define KEY_DOWNLOAD_PICINLOCAL @"storyPicLocal"
#define KEY_DOWNLOAD_PICINPLAYVIEW_HIGH @"storyPicHigh"
#define KEY_DOWNLOAD_PICINLOCAL_HIGH @"storyPicLocalHigh"
#define KEY_DOWNLOAD_STORY_ENCRY   @"StoryEncryDownLoad"
#define KEY_DOWNLOAD_CATEGORY_NAME @"storyCategoryName"

//3.0版本之前本地故事字段
#define KEY_LOCAL_STORYNAME  @"localStoryName"
#define KEY_LOCAL_STORTID	@"localStoryID"
#define KEY_LOCAL_STORYLEN  @"localStoryLen"
#define KEY_LOCAL_STORYANC  @"localStoryAnc"
#define KEY_LOCAL_STORYDOMAIN @"localStoryDomain"
#define KEY_LOCAL_STORYURL  @"localStoryUrl"
#define KEY_LOCAL_STORYURL_HIGH  @"localStoryUrlHigh"
#define KEY_LOCAL_STORYDES  @"localStoryDes"
#define KEY_LOCAL_STORYPIC_INPLAYVIEW @"localStoryCloundPic"
#define KEY_LOCAL_STORYPIC_INLOCAL @"localStorySquarePic"
#define KEY_LOCAL_STORYPIC_INPLAYVIEW_HIGH @"localStoryCloundPicHigh"
#define KEY_LOCAL_STORYPIC_INLOCAL_HIGH @"localStorySquarePicHigh"
#define KEY_LOCAL_STORY_ENCRY      @"localStoryEncry"
#define KEY_PROTOCAL_VERSION        @"protocalVersion"
#define KEY_LOCAL_CATEGORY_NAME @"localCategoryName" 

//3.0统一的story key
#define KEY_STORY_NAME                              @"name"             //故事名字
#define KEY_STORY_ID                                @"id"               //故事Id
#define KEY_STORY_AUDIO_URL_LOW                     @"lstory"           //故事低质量音频
#define KEY_STORY_AUDIO_URL_HIGH                    @"hstory"           //故事高质量音频
#define KEY_STORY_LENGTH                            @"slen"             //故事播放时长  
#define KEY_STORY_ANNOUNCER                         @"anc"              //故事播音员      
#define KEY_STORY_DESCRIPTION                       @"des"              //故事描述
#define KEY_STORY_DOMAIN                            @"domain"           //故事url的IP
#define KEY_STORY_PIC_SMALL                         @"spic"             //故事小封面
#define KEY_STORY_PIC_BIG                           @"bpic"             //故事大插图
#define KEY_STORY_CATEGORY_NAME                     @"albumnm"          //故事所在专辑的名字
#define KEY_PRODUCT_VERSION                         @"productVersion"   //产品版本号
#define KEY_STORY_ENCRY_TYPE                        @"encryType"        //加密类型
#define KEY_STORY_ORDERBY                           @"orderby"          //故事所在专辑中的顺序
#define KEY_STORY_PICVERSION                        @"picversion"       //故事图片版本号
#define KEY_STORY_ALBUMID                           @"albumid"          //故事所在专辑的id
#define KEY_STORY_HITCOUNT                          @"hitcount"         //故事的点击率
#define KEY_STORY_UPDATE_TIME                       @"uptime"           //故事更新时间
#define KEY_STORY_DOWNLOAD_STAMP                    @"downloadStamp"    //故事下载的时间戳
#define KEY_STORY_PLAYCOUNTS                        @"playCounts"       //故事播放次数
#define KEY_STORY_INFO_IS_UPDATED                   @"isStoryInfoUpdated"   //故事信息是否需要更新
#define KEY_STORY_ICON_HAS_EXISTED                  @"iconHasExisted"   //故事icon是否存在本地
#define KEY_STORY_PLAYVIEW_IMAGE_HAS_EXISTED        @"playViewImageHasExisted" //故事插图是否存在本地

//下载的通知
#define NOTIFICATION_DOWNLOAD_PAUSE_QUEUE           @"pauseDownloadQueue" //暂停下载队列
#define NOTIFICATION_DOWNLOAD_RESUME_QUEUE          @"resumeDownloadQueue"//恢复下载队列

//当播放界面缓冲故事时,设置ASIHTTPRequest 每秒最大的流量限制 1 bytes/s
#define MAX_DOWNLOAD_BANDWIDTH_PER_SECOND           ASIWWANBandwidthThrottleAmount

//plist
#define BOOK_FILE_NAME                  @"bookFile.plist"
#define PLAYLIST_FILE_NAME              @"userInfo.plist"
#define DOWNLOAD_PLIST_NAME             @"downLoadList.plist"
#define LOCALSTORY_PLIST_NAME           @"localStoryList.plist"
#define LOCALSTORY_PLIST_NAME_NEW       @"localStoryListNew.plist"
#define NEWFLAG_PLIST_NAME              @"hasReadStory.plist"
#define RECORDPLAYCOUNT_PLIST_NAME      @"recordPlayCount.plist"        //记录故事的播放次数
#define SPLASH_FILE_NAME                @"splashinfo.plist"				//闪屏信息
#define STORYCACHE_PLIST_NAME           @"storyCache.plist" 
#define BANNER_PLIST_NAME				@"banner.plist"					//运营栏信息
#define GIFT_EGGS_PLIST_NAME			@"giftEggs.plist"				//砸蛋信息
#define	STORY_DOWNED_COUNT_PLIST_NAME	@"storyDownloadedCount.plist"	//故事下载统计plist

#define LABEL_FONT_DEFAULT              @"DFPHaiBaoW12-GB"
#define SOURCE_UPDATE_ASK_DATE          @"sourceUpdateAskDate"          //上次请求资源更新的日期
#define SOURCE_UPDATE_TIME              @"sourceUpdateTime"             //资源更新时间
//故事书new标记相关
#define KEY_BOOK_SHOWNEWFLAG        @"plistBookShowNew"
#define KEY_BOOK_UPDATETIME         @"plistBookUpdateTime"
#define KEY_BOOK_PLISTID            @"plistBookID"
//微博分享成功
#define NOTIFICATION_WEIBO_SHARESUCCESS				@"weibo_share_success"
#define NOTIFICATION_WEIBO_ALERT_SHARESUCCESS		@"weibo_share_alert_success"
#define NOTIFICATION_PLAY_STORY                     @"playStory"
#define NOTIFICATION_DOWNLOAD_IN_STORYPLAYER        @"downLoadInStoryplayer"

//userDauflt info
#define USERDAUFLT_EFFECT_KEY                   @"effect_switch"
#define USERDAUFLT_CACHE_KEY                    @"cache_switch"
#define USERDAUFLT_STORYPLAY_COUNTS_KEY         @"storyPlay_counts"
#define URL_FEEDBACK                            @"http://124.93.223.118/PocketKitchenServer/clientInfo/feedback.act"
#define USERDAUFLT_COVER_VERSION_NUMBER         @"CoverVersionNumber" 
#define USERDAUFLT_SWITCH_STATUS_WIFI_ONLY      @"DownloadWifiOnly"

#define TABBAR_BADGE_VALUE                      @"tabBarBadgeValue"
#define USERDAUFLT_COVER_INTERNAL_VERSION_NUMBER @"CoverInternalBundleVersion"

//锁屏控制
#define NOTIFICATION_REMOTE_CONTROL_CHANGED           @"remoteControlChanged"
#define NOTIFICATION_ADD_BADGE_TO_TABBAR              @"addBadgeToTabBar" 

//splash的相关字段（闪屏）
#define NOTIFICATION_SPLASH_DISPLAY_FINISHED					@"splash_display_finished_notification"
#define SPLASH_DOWNLOAD_URL                                     @"splash_url"
#define SPLASH_START_TIME                                       @"start_time"
#define SPLASH_END_TIME                                         @"end_time"
#define SPLASH_ID                                               @"id"

//document目录
#define DOCUMENTS_DIRECTORY ([( NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0])
#define CACHES_DIRECTORY  ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define LIBRARY_DIRECTORY ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define THREE20_DIRECTORY ([LIBRARY_DIRECTORY stringByAppendingPathComponent:@"Caches/Three20"])
//时间戳创建标识               
#define CREATESTAMP     @"LanchTime2"
#define UPDATE_STAMP     @"updateStamp"



/*客户端请求所需的应用名字
 BabyTing:1
 BabyTing_Android:2
 BabyTingIpad:3
 BabyTingFlash:4
*/

#define REQUEST_APPNAME_TYPE    1

//闪屏的Tag
#define Splash_Loading_Tag      890824





//全局的view tag
#define TAG_PLAYING_BUTTON 9036
#define TAG_BackButton    89824
#define TAG_EDITOR_BUTTON 79525
#define TAG_NEW_FLAG      1998
#define TAG_PLAYING_FLAG  2012
#define TAG_ALL_STORY_DOWNLOAD_BUTTON   6789
#define TAG_PLAYER_TIME_SET       43563
#define TAG_PLAYER_NUMBER_SET     43564
#define TAG_NetImage       201212
#define TAG_HeaderNetImage 201213
//checkin API 版本号
#define CHECKIN_API_VERSION         (1.2)

//checkin 需要上传的应用名字
#define APP_NAME                                @"BabyTing"
#define NEVER_UPDATE                            @"1900-00-00 00:00:00.0"

#define REQUEST_NAME_CHECKIN                    @"checkin"
#define REQUEST_NAME_FEEDBACK                   @"user_feedback"
#define REQUEST_NAME_GROUPLIST                  @"refreshGroup"
#define REQUEST_NAME_PICTURES                   @"refreshPictures"
#define REQUEST_NAME_STORY_DOWNLOADED_COUNT		@"accumulation_behavior_statistic"			//故事下载次数上报
#define REQUEST_NAME_BANNER_CLICKED_COUNT		@"accumulation_behavior_statistic"			//Banner点击次数上报
#define REQUEST_NAME_LOCAL_STORY_COUNT			@"user_behavior_statistic"					//本地故事数量上报

//统计故事播放次数
#define XML_PARSER_KEY_STATISTICS_RESULT                        @"statistics result"
#define KEY_STATISTICS_DATE                                     @"date"             //哪天统计的
#define KEY_STATISTICS_RECORD_INFO                              @"itemlist"             //存储ID和Count
#define KEY_STATISTICS_STORYID                                  @"id"          //故事ID
#define KEY_STATISTICS_PLAYCOUNT                                @"count"   //故事播放次数

//运营栏相关
#define POPULARIZ_TYPE_GIFT_EGGS		(3)
#define POPULARIZ_TYPE_BANNER			(2)
#define POPULARIZ_ID					@"id"					//唯一标识
#define POPULARIZ_TYPE					@"type"					//活动类型标识，根据各自程序而定（2为运营栏，3为砸蛋）
#define POPULARIZ_IMG_URL				@"img_url"				//图片地址
#define POPULARIZ_DESCRIBE_MSG			@"describe_msg"			//描述
#define POPULARIZ_DOWNLOAD_URL			@"download_url"			//在砸蛋中使用
#define	POPULARIZ_RUN_URL				@"run_url"				//
#define POPULARIZ_SHOW_TIMES			@"show_times"			//在砸蛋中使用，作为任务完成上限次数
#define	POPULARIZ_START_TIME			@"start_time"			//开始时间
#define POPULARIZ_END_TIME				@"end_time"				//结束时间
#define	BANNER_REQUEST_FINISH_NOTIFICATION	@"banner_request_finish"	//checkin返回，发给banner_view的通知

//砸蛋相关
#define GIFT_EGGS_ID						@"id"				//唯一标识
#define	GIFT_EGGS_REQUEST_OPPORTUNITY_URl	@"download_url"		//第一次请求是否有砸蛋机会的URL
#define GIFT_EGGS_RUN_URL					@"run_url"			//作为砸蛋使用的URL
#define GIFT_EGGS_MISSION_MAX				@"show_times"		//砸蛋活动中任务完成上限数
#define GIFT_EGGS_MISSION_DONE				@"done_times"		//砸蛋活动中已经完成任务的次数
#define GIFT_EGGS_START_TIME				@"start_time"		//开始时间
#define GIFT_EGGS_END_TIME					@"end_time"			//结束时间
#define GIFT_EGGS_REQUEST_RETURN			@"ret"				//返回字段
#define GIFT_EGGS_PLAYED_COUNT				@"played_count"		//已经播放的故事个数（某任务内，取值0~MISSION_MAX-1）
#define GIFT_EGGS_PLAYED_COUNT_MAX			(5)					//播放次数上限（完成任务要求）
//#define GIFT_EGGS_DONT_ASK_ME				@"gift_eggs_dont_ask_me"	//userdefault中使用，用来标记本次使用产品过程中是否判断砸蛋
#define	GIFT_EGGS_RETURN					@"gift_eggs_return"	//砸蛋返回值，封装到userinfo中的key值
#define	GIFT_EGGS_SHOW_NOTIFICATION			@"gift_eggs_show_notification"
#define	GIFT_EGGS_LAST_MISSION_DATE			@"last_mission_date"//上次尝试完成任务的日期
#define	GIFT_EGGS_RETRY_CANCEL_FLAG			@"gift_eggs_retry_cancel_flag"//若联网失败时，此标识为YES，不提示“重试/取消”；反之，则提示。

//feedback常量
#define FEEDBACK_REQUEST_CONTENT						@"feedback"			//用户输入的反馈意见
#define FEEDBACK_REQUEST_QQ								@"qq"				//用户QQ
#define FEEDBACK_REQUEST_EMAIL							@"email"			//用户email，模仿iPad版本，使用这个字段统一上传联系方式
#define FEEDBACK_REQUEST_TEL							@"tel"				//用户电话号

//checkin结束后通知“版本更新action“
#define NOTIFICATION_UPDATE_SOFTWARE_WHEN_CHECKIN_FINISH	@"checkin_finish_update_software"
#define UPDATE_SOFTWARE_UPDATE_TYPE							@"update_type"


#define pullUpdateViewTag 8908241

//error domain
#define ERROR_CODE_DOMAIN                               @"com.21kunpeng.service"

//error code
#define ERROR_CODE_NOERROR								9999	//没有错误，初始值
#define ERROR_CODE_RET_IS_NSNULL						2		//服务器返回的"ret"的值为NSNull对象
#define ERROR_CODE_JSONPASERINTERNALERROR				1		//JSON解析内部错误
#define ERROR_CODE_JSONPASERERROR                       0		//JSON解析失败，返回空
#define ERROR_CODE_SERVERERROR                          1       //服务器内部错误
#define ERROR_CODE_PARAMETERERROR                       2       //参数错误
#define ERROR_CODE_RESNOFOUND                           -1      //res字段不存在
#define ERROR_CODE_RESPONSENULL                         -2      //服务器返回空字符串
#define ERROR_CODE_REQUSETERROR                         -3      //请求失败
#define ERROR_CODE_NONETWORK                            -4      //没有网络
#define ERROR_CODE_UNKNOWNERROR							-5		//未知错误
#define ERROR_CODE_CID_TYPE_ERROR                       -6      //获取cid字段时出错（类型）

#define DIFF_HEIGHT						([UIScreen mainScreen].bounds.size.height - (479+1))
#define APPEAR_MOVEDISTANT								22		//播放及电台界面下方移动的高度
//error checkin服务器
#define CHECKIN_ERROR_CODE_DOMAIN                       @"com.21kunpeng.checkin"


//高品质音频缓冲完成之后，发出通知
#define HIGH_QUALITY_AUDIO_FILE_CACHE_FINISHED_NOTIFICATION			@"high_quality_audio_file_cache_finished_notification"
#define NOTIFICATION_STORY_ID							@"id"
#define NOTIFICATION_STORY_CACHE_FILE_PATH				@"cache_file_path"
#define NOTIFICATION_REFRESH_MYSTORY_VIEW               @"refreshMystoryView"

//error code checkin服务器
#define CHECKIN_ERROR_CODE_PARAMETERERROR               111     //参数错误
#define CHECKIN_ERROR_CODE_PARAMETERFOMATEERROR         112     //参数格式错误
#define CHECKIN_ERROR_CODE_NORESOURCE                   600     //资源不存在
#define CHECKIN_ERROR_CODE_NOLIMIT                      601     //无权限访问
#define CHECKIN_ERROR_CODE_SERVERERROR                  700     //服务器异常
#define CHECKIN_ERROR_CODE_REQUSETNOREQUEST             701     //请求未实现
#define CHECKIN_ERROR_CODE_REQUSETEBUSY                 702     //服务器忙
#define CHECKIN_ERROR_CODE_REQUSETERROR                 800     //请求失败

#define CHECKIN_ERROR_CODE_RESPONSENULL                 900      //服务器返回空字符串




//所有图片的类型

typedef enum{
    type_default = 0,
    type_home_icon,                       //主界面的icon
    type_newStory_Intro_icon,             //新故事首发上面的header的图片icon
    type_newStory_icon,                   //暂时没有使用，新故事首发的前面图片和故事的图片是一个。
    type_collection_icon,                 //合集的默认插图
    type_age_category_icon,                   //大分类 大专辑的插图  年龄
    type_content_category_icon,                     // 内容分类
    type_book_icon,                       //专辑下的故事书的插图
    type_story_icon,                      //每一个故事前面的icon
    type_story_playView,                  //每一个故事在播放界面的插图
    type_Chosen_intro_icon,               //合集上面的图片
	type_banner_cell_view,
    type_radio_icon,                       //故事电台的前面的小icon
    type_category_intro_icon               //专辑上面的图片
}ImageType;