

#import <UIKit/UIKit.h>

@protocol BTPlayerProgressDelegate <NSObject>

@optional
- (void)progressSliderDragBegin;
- (void)progressSliderDragEnd;
- (void)pauseToWaitCache;
- (void)continueToPlay;
@end
#define BUG_OFFSET_Y 20
@interface BTPlayerProgressView : UIView{
    NSString                    *_cacheThumb;
    NSString                    *_playingThumb;
    NSString                    *_progressTrackImage;
    NSString                    *_progressBackImage;
    BOOL                        _allowdrag;
    
    //缓冲进度和播放进度的值范围［0,1］
    float                       _actualCacheProgress;
    float                       _currentCacheProgress;
    float                       _currentPlayingProgress;
    
    BOOL                        _isSliderDragging;
    //如果_isPlayThumbAnimationEnable＝yes则开启播放蜗牛的动画，否则只显示progress_snail_3.png
    //停止、暂停和拖动播放按钮都使_isPlayThumbAnimationEnable＝no；
    BOOL                        _isPlayThumbAnimationEnable;
    BOOL                        _seeking;
    
    UIImageView                 *_backBarView;
    UIImageView                 *_cacheThumbView;
    UIImageView                 *_playingProgressView;
    UIImageView                 *_playingThumbView;
    UIImageView                 *_progressObitView;
    float                       _bufferDistant;
    id<BTPlayerProgressDelegate>      _target;
}
@property (nonatomic,assign)float       actualCacheProgress;
@property (nonatomic,assign)float       currentCacheProgress;
@property (nonatomic,assign)float       currentPlayingProgress;
@property (nonatomic,assign)float       bufferDistant;
@property (nonatomic,retain)NSString    *cacheThumb;
@property (nonatomic,retain)NSString    *playingThumb;
@property (nonatomic,retain)NSString    *progressTrackImage;
@property (nonatomic,retain)NSString    *progressBackImage;
@property (nonatomic,assign)BOOL        allowDrag;
@property (nonatomic,assign)BOOL        seeking;
@property (nonatomic,assign)BOOL        isPlayThumbAnimationEnable;
@property (nonatomic,assign)BOOL        isSliderDragging;
@property (nonatomic,assign)id<BTPlayerProgressDelegate>          target;

@end

