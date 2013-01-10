//
//  BTStory.h
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import <Foundation/Foundation.h>
//下载中 》点击 》暂停 (提示点击继续下载)
//暂停中 》点击 》下载中 or 等待下载（无下载任务时开始下载，有下载时等待）
//等待中 》点击 》暂停
//失败中 》点击 》下载中 or 等待下载（无下载任务时开始下载，有下载时等待）
typedef enum {
    StoryStateDefault = 0,
    StoryStateDownLoading = 1,
    StoryStateWaiting = 2,
    StoryStatePausing = 3,
    StoryStateFailed = 4,
    StoryStateFinished = 5,
} StoryState;

typedef enum{
    StoryPicIcon = 10,
    StoryPicPlayView,
}StoryPicType;

/**   重要 ******
  从写了isEqual和hash方法
 
 */
@interface BTStory : NSObject {
    NSString* _lowAudioDownLoadUrl;
    NSString* _highAudioDownLoadUrl;
    NSString* _iconURL;
    NSMutableArray* _picDownLoadURLs;
}


@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *storyId;
@property(nonatomic,copy)NSString *domain;
@property(assign)NSInteger stamp;
@property(nonatomic,readonly)NSString *iconURL;
@property(nonatomic,copy)NSString *speakerName;
@property(nonatomic,copy)NSString *categoryName;
@property(nonatomic,copy)NSString *timeLength;
@property(nonatomic,readonly)NSMutableArray *picDownLoadURLs;
@property(nonatomic)NSInteger pressTime;
@property(nonatomic)NSInteger rankNum;
@property(nonatomic)BOOL bIsInLocal;
@property(nonatomic,readonly)NSString *lowAudioDownLoadUrl;   
@property(nonatomic,readonly)NSString *highAudioDownLoadUrl;
@property(nonatomic,copy)NSString *prodcutVersion;
@property(nonatomic,copy)NSString *lstory;
@property(nonatomic,copy)NSString *hstory;
@property(nonatomic,copy)NSString *spic;
@property(nonatomic,copy)NSMutableArray *bpic;
@property(assign)BOOL                   isNew;
//用在故事下载界面
@property(nonatomic) float tempProgress;                                    //用来保存下载的临时进度
@property(nonatomic) StoryState state;                                      //用来保存下载的状态
@property(assign) int encryType;
@property(nonatomic,assign) NSInteger orderby;                                        //专辑中顺序
@property(nonatomic,assign) NSInteger picversion;                                     //图片的版本号
@property(nonatomic,assign) NSInteger albumid;                                        //故事所在专辑id
@property(nonatomic,assign) NSInteger downloadStamp;                                  //故事下载的时间戳，用于本地下载排序
@property(nonatomic,assign) NSInteger playCounts;                                     //故事的播放次数
@property(nonatomic,assign) BOOL      isUpdated;
@property(nonatomic,assign) BOOL      iconHasExisted;                                 //本地是否存在故事缩略图
@property(nonatomic,assign) BOOL      playViewImageHasExisted;                        //本地是否存在播放界面的插图
- (NSMutableDictionary*) toDictionary;
- (id) initWithDictionary:(NSDictionary*)dict;
@end
