#import "AudioModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ASIHTTPRequest.h"
#import "BTConstant.h"
#import "SHKItem.h"
#import "WXApi.h"
#import "VSImageHelp.h"
#import "BTStory.h"
#import "RMConnectCenter+Share.h"
#define NOTIFICATION_NO_WEIXIN @"no_weixin"
@interface BTPlayerAction : NSObject 
<RMShareComponentDelegate>
{
    AudioModel                  *_player; 
    NSMutableArray              *_playList;              //故事列表
    int                         _playingStoryIndex;      //当前播放故事索引 
    StoryType                   _storyType;              //故事类型
    NSString                    *_shareImageUrl;
    BOOL                        _isFinishPlaying;
    BOOL                        _bIsReadyToPlay;         //是否准备开始播放
    UIImage                     *sharePicImage;             //分享的图片

}

@property (nonatomic,retain)    AudioModel          *player;
@property (nonatomic,retain)    NSMutableArray      *playList;
@property (nonatomic,retain)    NSString            *shareImageUrl;
@property (nonatomic)           int                 playingStoryIndex;
@property (nonatomic)           StoryType           storyType;
@property (nonatomic)           BOOL                bIsReadyToPlay;
@property (nonatomic)           BOOL                isFinishPlaying;
@property (nonatomic,retain)    UIImage             *sharePicImage;
-(void)playButtonPressed;
-(void)playStory;
-(void)destroyStreamer;
-(void)clickTencentItem;
-(void)clickRenrenItem;
-(void)clickWeixinItem;
-(void)clickSinaItem;
-(NSString *)getSharePicName;
-(void)deleteLowCache:(NSString *)cacheFile;
@end
