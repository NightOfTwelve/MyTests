//
//  BTProgressView.m
//  BabyTingiPad
//
//  Created by SJKP on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BTPlayerProgressView.h"
#import "BTConstant.h"
@interface BTPlayerProgressView (private)
- (void)initUI;
- (void)updateCacheProgress;
- (void)updatePlayingProgress;
- (void)computePlayingProgress;
- (void)moveCacheThumb;
- (void)removeCacheThumb;
@end

@implementation BTPlayerProgressView
@synthesize actualCacheProgress=_actualCacheProgress;
@synthesize currentCacheProgress=_currentCacheProgress;
@synthesize currentPlayingProgress=_currentPlayingProgress;
@synthesize cacheThumb=_cacheThumb;
@synthesize playingThumb=_playingThumb;
@synthesize progressTrackImage=_progressTrackImage;
@synthesize allowDrag=_allowdrag;
@synthesize isPlayThumbAnimationEnable=_isPlayThumbAnimationEnable;
@synthesize target=_target;
@synthesize progressBackImage = _progressBackImage;
@synthesize isSliderDragging = _isSliderDragging;
@synthesize bufferDistant = _bufferDistant;
@synthesize seeking = _seeking;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        _playingThumb=@"Bug.png";
        _progressTrackImage=@"SliderBarCache.png";
        _progressBackImage = @"player_green.png";
        _actualCacheProgress=0;
        _currentCacheProgress=0;
        _currentPlayingProgress=0;
        _bufferDistant = 1.0;
        _allowdrag=YES;
        _isSliderDragging=NO;

        [self initUI];
    }
    return self;
}

- (void)dealloc{
    [_cacheThumb release];
    [_playingThumb release];
    [_progressTrackImage release];
    [_progressBackImage release];
    [_cacheThumbView release];
    [_playingProgressView release];
    [_backBarView release];
    [_playingThumbView release];
    [_progressObitView release];
    [super dealloc];
}
#pragma mark -
#pragma mark private methods
- (void)initUI{
    
    _playingThumbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_playingThumb]];
    _playingThumbView.center=CGPointMake(_playingThumbView.frame.size.width/2, BUG_OFFSET_Y);
    [self addSubview:_playingThumbView];
 
    _backBarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 320, 86)];
    _backBarView.image=[UIImage imageNamed:_progressBackImage];
    _backBarView.contentMode=UIViewContentModeLeft;
    [self addSubview:_backBarView];
    
    _progressObitView=[[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-35, 1, 21)];
    _progressObitView.image=[UIImage imageNamed:_progressTrackImage];
    _progressObitView.clipsToBounds=YES;
    _progressObitView.contentMode=UIViewContentModeLeft;
    [self addSubview:_progressObitView];
    
    _playingProgressView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-35, 1, 21)];
    _playingProgressView.image=[UIImage imageNamed:@"SliderBarBack.png"];
    _playingProgressView.clipsToBounds=YES;
    _playingProgressView.contentMode=UIViewContentModeLeft;
    [self addSubview:_playingProgressView];
    
}

- (void)removeCacheThumb{
    [_cacheThumbView removeFromSuperview];
    _cacheThumbView=nil;
}

#pragma mark -
#pragma mark property method

- (void)setActualCacheProgress:(float)actualCacheProgress{
    if (_currentCacheProgress==0) {
        _progressObitView.frame=CGRectMake(10, self.frame.size.height-35, _playingThumbView.frame.size.width/2, 21);
    }
    _actualCacheProgress=actualCacheProgress;
    [self updateCacheProgress];
}

- (void)setCurrentPlayingProgress:(float)currentPlayingProgress{
    
    if (currentPlayingProgress>_currentCacheProgress ) {
        if (currentPlayingProgress >= 0.98 || _currentCacheProgress < 0.02) {
            _currentPlayingProgress = _currentCacheProgress;
        } else {
            _currentPlayingProgress=_currentCacheProgress - 0.02;
        }
    } else {
        _currentPlayingProgress=currentPlayingProgress;
    }
    if (_currentCacheProgress > 0 && _currentPlayingProgress <= 0) {
        _currentPlayingProgress = 0;
        if (_playingThumbView.center.x > 300) {

            _playingThumbView.center=CGPointMake(_playingThumbView.frame.size.width/2, BUG_OFFSET_Y);
        }
        
        return;
    }
    [self updatePlayingProgress];
}



#pragma mark -
#pragma mark progress
//差距越大，追赶越快，差距越小，追赶越慢
-(void)updateCacheProgress{
    if (_actualCacheProgress==1 && _currentCacheProgress==1) {
         _progressObitView.frame=CGRectMake(10, self.frame.size.height-35, 320 , _progressObitView.frame.size.height);
        return;
    }
    if (_currentCacheProgress == 0.0) {
        _progressObitView.frame =CGRectMake(10, self.frame.size.height-35, 1, _progressObitView.frame.size.height);
    }
    float cacheDiff=_actualCacheProgress-_currentCacheProgress;
    //DLog(@"ttt:  %f, %f, %f",_currentCacheProgress,cacheDiff,_progressObitView.frame.size.width);
    if (cacheDiff*100>5) {
        //改变缓冲进度视图的宽度
        if (_progressObitView.frame.size.width<=self.frame.size.width - 20) {
            _progressObitView.frame=CGRectMake(10, self.frame.size.height-35, _progressObitView.frame.size.width+cacheDiff*(self.frame.size.width-_playingThumbView.frame.size.width/2)/5, _progressObitView.frame.size.height);
            _currentCacheProgress+=(cacheDiff/5);
        }
    }else if(cacheDiff>=0){
        //改变缓冲进度视图的宽度
        if (_progressObitView.frame.size.width<=self.frame.size.width - 20) {
            _progressObitView.frame=CGRectMake(10, self.frame.size.height-35, _progressObitView.frame.size.width+cacheDiff*(self.frame.size.width-_playingThumbView.frame.size.width/2), _progressObitView.frame.size.height);
            _currentCacheProgress+=cacheDiff;
        }
    }
}

//更新播放进度
-(void)updatePlayingProgress{
    if (!_isSliderDragging) {
            _playingThumbView.center=CGPointMake(_currentPlayingProgress*(self.frame.size.width-_playingThumbView.frame.size.width)+_playingThumbView.frame.size.width/2, BUG_OFFSET_Y);
    }

    
    _playingProgressView.frame=CGRectMake(10, self.frame.size.height-35, 320 * _currentPlayingProgress, _playingProgressView.frame.size.height);

    
    
}

- (void)computePlayingProgress{
    if (!_isSliderDragging) {
        self.currentPlayingProgress=(_playingThumbView.center.x-_playingThumbView.frame.size.width/2)/(self.frame.size.width-_playingThumbView.frame.size.width);
    }
    [_target progressSliderDragEnd];
}

#pragma mark -
#pragma mark touche event
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_currentCacheProgress <= _bufferDistant / 320) {
        return;
    }
    if (_seeking) {
        return;
    }
    UITouch *touche=[touches anyObject];
    CGPoint touchLocation=[touche locationInView:self];
    if (!_isSliderDragging) {

        if (CGRectContainsPoint(_playingThumbView.frame, touchLocation)) {
            [_target progressSliderDragBegin];
            //_isSliderDragging=YES;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_currentCacheProgress <= _bufferDistant / 320) {
        return;
    }
    if (_seeking) {
        return;
    }
    UITouch *touche=[touches anyObject];
    CGPoint touchLocation=[touche locationInView:self];
    if (_allowdrag && _isSliderDragging) {
        
        float tempProgress=(touchLocation.x-_playingThumbView.frame.size.width/2)/(self.frame.size.width-_playingThumbView.frame.size.width);
        
        if (tempProgress >_currentCacheProgress - _bufferDistant / 320) {
            _playingThumbView.center=CGPointMake(_currentCacheProgress*(self.frame.size.width-_playingThumbView.frame.size.width)+_playingThumbView.frame.size.width/2 - _bufferDistant, BUG_OFFSET_Y);
        } else if(tempProgress < 0) {
            _playingThumbView.center=CGPointMake(_playingThumbView.frame.size.width/2, BUG_OFFSET_Y);
        } else {
            
            _playingThumbView.center=CGPointMake(touchLocation.x, BUG_OFFSET_Y);
        }
        

    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_currentCacheProgress <= _bufferDistant / 320) {
        return;
    }
    if (_seeking) {
        return;
    }
    UITouch *touche=[touches anyObject];
    CGPoint touchLocation=[touche locationInView:self];
    if (_allowdrag && _isSliderDragging) {
        float tempProgress=(touchLocation.x-_playingThumbView.frame.size.width/2)/(self.frame.size.width-_playingThumbView.frame.size.width);
        if (touchLocation.x>self.bounds.origin.x+_playingThumbView.frame.size.width/2 && touchLocation.x<self.bounds.origin.x+_progressObitView.frame.size.width-_playingThumbView.frame.size.width/2) {
            _playingThumbView.center=CGPointMake(touchLocation.x, BUG_OFFSET_Y);
        }else if(touchLocation.x<=self.bounds.origin.x+_playingThumbView.frame.size.width/2){
//            DLog(@"蜗牛被拖出进度条的最左端 %f %f",_currentCacheProgress,_currentPlayingProgress);
//            _playingThumbView.center=CGPointMake(_currentPlayingProgress*(self.frame.size.width-_playingThumbView.frame.size.width)+_playingThumbView.frame.size.width/2, BUG_OFFSET_Y);
            _playingThumbView.center = CGPointMake(self.bounds.origin.x + _playingThumbView.frame.size.width/2, _playingThumbView.center.y);
        
        }else if (tempProgress >_currentCacheProgress - _bufferDistant / 320) {
            //DLog(@"蜗牛被拖出进度条的最右端");
            _playingThumbView.center=CGPointMake(_currentCacheProgress*(self.frame.size.width-_playingThumbView.frame.size.width)+_playingThumbView.frame.size.width/2 - _bufferDistant, BUG_OFFSET_Y);
        }
        _isSliderDragging=NO;
        [self computePlayingProgress];
        //_seeking = YES;
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
}

@end
