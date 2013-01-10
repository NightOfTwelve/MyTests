//
//  BTHotStoryCell.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTHotStoryCell.h"
#import "Only320Network.h"

@implementation BTHotStoryCell

@synthesize hotDownloadDelegate=_hotDownloadDelegate,storyData = _storyData,backButton = _backButton,rankBackView = _rankBackView;
- (void)dealloc{
    _storyImg.viewController = nil;
    [_title release];
    [_downloadTimes release];
    [_rankNum release];
    [_downloadBtn release];
    [_storyImg stopLoading];
    [_storyImg release];
    [_storyData release];
    [_backButton release];
    [_rankBackView release];
    [newFlagPic release];
    [playingFlagPic release];
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

    // Configure the view for the selected state
}


-(IBAction)downloadPress:(id)sender{
    [_hotDownloadDelegate storyDownload:_storyData];
}


- (void)drawCell{
    _storyImg.tag= TAG_NetImage;
    _storyImg.defaultImage= TTIMAGE(@"bundle://story_cell_default.png");
    //_storyImg.type = type_story_icon;
    _storyImg.suffix = [BTUtilityClass getPicSuffix:type_story_icon picVersion:_storyData.picversion];
    if(_storyData.iconURL!=nil){
        _storyImg.urlPath = _storyData.iconURL;
    }else{
        _storyImg.urlPath = @"bundle://storyDefaultIcon.png";
    }
    //_speakerName.text = _storyData.speakerName;
    _title.text = _storyData.title;
    //_downloadBtn.titleLabel.text = @"下载"; 
    //[_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    //_categoryTitle.text = _storyData.categoryName;

    NSString *times = nil;
    if(_storyData.pressTime>=10000){
        //此处计算是为了处理类似1.0万  来显示1万来增加的2个临时值
        int tmp = _storyData.pressTime;
        int letf = tmp/1000%10;
        if(letf == 0){
             times = [NSString stringWithFormat:@"%.0f万",_storyData.pressTime/10000.0];
        }else{
            times = [NSString stringWithFormat:@"%.1f万",_storyData.pressTime/10000.0];
        }
    }else{
        times = [NSString stringWithFormat:@"%d",_storyData.pressTime];
    }
    _downloadTimes.text = [NSString stringWithFormat:@"播放:%@次",times];
    _rankNum.text = [NSString stringWithFormat:@"%d",_storyData.rankNum];
    
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
    if (newFlagPic == nil) {
        newFlagPic = [[BTImageView alloc] initWithFrame:CGRectMake(18, 1, 22, 21)];
        UIImage *bottomImage = [UIImage imageNamed:@"newFlag.png"];
        newFlagPic.image = bottomImage;
        [_storyImg addSubview:newFlagPic];
        newFlagPic.tag = TAG_NEW_FLAG;
    }
    isNew = [BTUtilityClass isNewStory:_storyData.storyId stamp:_storyData.stamp];
    if (!isNew) {
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

- (void)setImageController:(UIViewController *)viewController{
    _storyImg.viewController = viewController;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = self.frame;
        [self insertSubview:_backButton atIndex:0];
        
    }
    return self;
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _backButton.highlighted = highlighted;
    _title.highlighted = highlighted;
    _downloadTimes.highlighted = highlighted;
    //_speakerName.highlighted = highlighted;
    _downloadBtn.highlighted = highlighted;
    _rankBackView.highlighted = highlighted;
    _storyImg.highlighted = highlighted;
    newFlagPic.highlighted = highlighted;
    playingFlagPic.highlighted = highlighted;
}
@end
