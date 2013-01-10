//
//  BTStoryCell.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTStoryCell.h"
#import "Only320Network.h"
#import "BTUtilityClass.h"
#import "BTStoryPlayerController.h"
#import "BTPlayerManager.h"
#import "BTAppDelegate.h"
#import "BTDownLoadManager.h"
//@synthesize storyImg = _storyImg,speakerLabel = _speakerLabel,timeLabel= _timeLabel,titleLabel= _titleLabel,downloadBtn = _downloadBtn,categoryLabel = _categoryLabel,storyDelegate = _storyDelegate,storyData = _storyData;


@implementation BTStoryCell

@synthesize storyDelegate = _storyDelegate,storyData = _storyData,backButton = _backButton, downloadBtn = _downloadBtn,isShowCategory = _isShowCategory;
- (void)dealloc{
    _storyImg.viewController = nil;
	[_keyword release];
    [_storyImg stopLoading];
    [_storyImg release];
    [_titleLabel release];
    [_timeLabel release];
    [_categoryLabel release];
    [_storyData release];
    [_backButton release];
    [playingFlagPic release];
    [newFlagPic release];
    [_downloadBtn release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (IBAction)downloadPress:(id)sender{
    [_storyDelegate storyDownLoad:_storyData];
}

- (void)setImageController:(UIViewController *)viewController{
    _storyImg.viewController = viewController;
}

- (void)configurateCell{
    
    //_speakerLabel.text = _storyData.speakerName;
    _timeLabel.text = [BTUtilityClass changToTimeFormatWithString:[_storyData.timeLength integerValue]];
	if (_titleLabel) {
		[_titleLabel removeFromSuperview];
        [_titleLabel release];
		_titleLabel = nil;
	}
	_titleLabel = [[KPLabel labelWithFrame:CGRectMake(70,10,165,22) text:_storyData.title keyword:_keyword] retain];
	_titleLabel.backgroundColor = [UIColor clearColor];
	
	
	[self addSubview:_titleLabel];
    //    _titleLabel.text = _storyData.title;
    if(_isShowCategory && _storyData.categoryName!=nil && [_storyData.categoryName length]>0){
        if (_categoryLabel != nil) {
			[_categoryLabel removeFromSuperview];
			_categoryLabel = nil;
		}
		_categoryLabel = [KPLabel categoryLabelWithFrame:CGRectMake(70,25,142,30) text:[NSString stringWithFormat:@"《%@》%@",_storyData.categoryName,_storyData.speakerName] keyword:_keyword];
		_categoryLabel.backgroundColor = [UIColor clearColor];
            [_categoryLabel retain];
		[self addSubview:_categoryLabel];
    }else{
        if (_categoryLabel != nil) {
			[_categoryLabel removeFromSuperview];
			_categoryLabel = nil;
		}
		_categoryLabel = [KPLabel categoryLabelWithFrame:CGRectMake(70,25,142,30) text:_storyData.speakerName keyword:_keyword];
		_categoryLabel.backgroundColor = [UIColor clearColor];
        [_categoryLabel retain];
		[self addSubview:_categoryLabel];
    }
    
    BOOL bisInlocal;
    bisInlocal = [[BTDownLoadManager sharedInstance] isInMyStoryList:_storyData];
    _storyData.bIsInLocal = bisInlocal;
    if(bisInlocal){
        
        [_downloadBtn setEnabled:NO];
        [_downloadBtn setImage:[UIImage imageNamed:@"hasDownload.png"] forState:UIControlStateDisabled];
    }else{
        [_downloadBtn setEnabled:YES];
        [_downloadBtn setImage:[UIImage imageNamed:@"storyDownload.png"] forState:UIControlStateNormal];
    }
    //new标记
    if (newFlagPic == nil) {
        newFlagPic = [[BTImageView alloc] initWithFrame:CGRectMake(18, 1, 22, 21)];
        UIImage *bottomImage = [UIImage imageNamed:@"newFlag.png"];
        newFlagPic.image = bottomImage;
        [_storyImg addSubview:newFlagPic];
        newFlagPic.tag = TAG_NEW_FLAG;
    }
    //isNew = [BTUtilityClass isNewStory:_storyData.storyId stamp:_storyData.stamp];
    if (!_storyData.isNew) {
        newFlagPic.hidden = YES;
    } else {
        newFlagPic.hidden = NO;
    }
    //正在播放标记
    if (playingFlagPic == nil) {
        playingFlagPic = [[BTImageView alloc] initWithFrame:CGRectMake(22, 22, 18, 18)];
        UIImage *image = [UIImage imageNamed:@"Story_playing_mark.png"];
        playingFlagPic.image = image;
        [_storyImg addSubview:playingFlagPic];
        playingFlagPic.tag = TAG_PLAYING_FLAG;
    }
    BOOL isPlaying = [BTUtilityClass isPlayingStory:_storyData.storyId];
    if (!isPlaying) {
        playingFlagPic.hidden = YES;
    } else {
        playingFlagPic.hidden = NO;
    }

}

- (void)setPlayListCellData{
    _storyImg.defaultImage= TTIMAGE(@"bundle://story_cell_default.png");
    _storyImg.suffix = [BTUtilityClass getPicSuffix:type_story_icon picVersion:_storyData.picversion];
    
//    NSString *fileName = [NSString stringWithFormat:@"%@%@",_storyData.storyId,[BTUtilityClass getPicSuffix:type_story_icon picVersion:_storyData.picversion]];
    NSString *fileName = [NSString stringWithFormat:@"%@_storyIcon",_storyData.storyId];
    NSString *localIconFile = [NSString stringWithFormat:@"documents://babyStory/%@",fileName];
    if (_storyData.iconHasExisted) {
        _storyImg.urlPath = localIconFile;
    }else if(_storyData.iconURL!=nil){
        _storyImg.urlPath = _storyData.iconURL;
    }else{
        _storyImg.urlPath = @"bundle://storyDefaultIcon.png";
    }
    
    [self configurateCell];
}

- (void)setCellData{
    _storyImg.defaultImage= TTIMAGE(@"bundle://story_cell_default.png");
    //_storyImg.type = type_story_icon;
    _storyImg.suffix = [BTUtilityClass getPicSuffix:type_story_icon picVersion:_storyData.picversion];
    if(_storyData.iconURL!=nil){
        _storyImg.urlPath = _storyData.iconURL;
    }else{
        _storyImg.urlPath = @"bundle://storyDefaultIcon.png";
    }
    
    [self configurateCell];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = self.frame;
        [self insertSubview:_backButton atIndex:0];
        _isShowCategory = YES;
    }
    return self;
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _backButton.highlighted = highlighted;
    _storyImg.highlighted = highlighted;
    _downloadBtn.highlighted = highlighted;
//	if (_titleLabel) {
//		_titleLabel.highlighted = highlighted;
//	}
    //_speakerLabel.highlighted = highlighted;
    _timeLabel.highlighted = highlighted;
//    if (_categoryLabel) {
//		_categoryLabel.highlighted = highlighted;
//	}
    newFlagPic.highlighted = highlighted;
    playingFlagPic.highlighted = highlighted;
}

@end
