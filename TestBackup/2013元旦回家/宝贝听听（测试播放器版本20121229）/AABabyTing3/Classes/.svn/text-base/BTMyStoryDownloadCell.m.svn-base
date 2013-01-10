//
//  BTMyStoryDownloadCell.m
//  AABabyTing3
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTMyStoryDownloadCell.h"
#import "Only320Network.h"
#import "BTUtilityClass.h"

@implementation BTMyStoryDownloadCell
@synthesize statusLabel = _statusLabel;

-(void)dealloc{
    [_indicator release];
    [_statusLabel release];
    [playingFlagPic release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 25, 120, 30)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor colorWithRed:0.478 green:0.259 blue:0.0 alpha:1.0];
        _statusLabel.font = [UIFont boldSystemFontOfSize:12];
        _statusLabel.textAlignment = UITextAlignmentLeft;
        //        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_statusLabel];  
        
        _indicator = [[BTProgressIndicator alloc] initWithFrame:CGRectMake(70, 10, self.contentView.frame.size.width - 130, 40)];
        _indicator.progressView.progress = 0.0f;
        [self.contentView addSubview:_indicator];
    
        _storyImage.defaultImage= TTIMAGE(@"bundle://story_cell_default.png");
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setProgress:(float)progress{
    [_indicator setProgress:progress];
    
}

-(void)update{
    _storyName.text = _story.title;
    _storyImage.suffix = [BTUtilityClass getPicSuffix:type_story_icon picVersion:_story.picversion];

//    NSString *fileName = [NSString stringWithFormat:@"%@%@",_story.storyId,[BTUtilityClass getPicSuffix:type_story_icon picVersion:_story.picversion]];
    NSString *fileName = [NSString stringWithFormat:@"%@_storyIcon",_story.storyId];
    NSString *localIconFile = [NSString stringWithFormat:@"documents://babyStory/%@",fileName];
    
    if (_story.iconHasExisted) {
        _storyImage.urlPath = localIconFile;
         TLog(@"本地下载的icon storyId = %@",_story.storyId);
    }else if(_story.iconURL!=nil){
        _storyImage.urlPath = _story.iconURL;
    }else{
        _storyImage.urlPath = @"bundle://storyDefaultIcon.png";
    }
    _storyAlbumName.text = @"";
    //_storyAnnouncer.text = @"";
    _storyLength.text = @"";
    _indicator.hidden = NO;
    [_indicator setProgress:_story.tempProgress];
    switch (_story.state) {
        case StoryStateDownLoading:
            //_statusLabel.text = @"下载中";
            break;
        case StoryStateWaiting:
            _indicator.label.text = @"等待中";
            break;
        case StoryStateFailed:
            _indicator.label.text = @"下载失败";
            break;
        case StoryStatePausing:
            _indicator.label.text = @"点击继续";
            break;
        default:
            _indicator.label.text = @"";
            break;
    }

    if (playingFlagPic == nil) {
        playingFlagPic = [[BTImageView alloc] initWithFrame:CGRectMake(22, 22, 18, 18)];
        UIImage *image = [UIImage imageNamed:@"Story_playing_mark.png"];
        playingFlagPic.image = image;
        [_storyImage addSubview:playingFlagPic];
        playingFlagPic.tag = TAG_PLAYING_FLAG;
    }
    BOOL isPlaying = [BTUtilityClass isPlayingStory:_story.storyId];
    if (!isPlaying) {
        playingFlagPic.hidden = YES;
    } else {
        playingFlagPic.hidden = NO;
    }
}
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
//    
//    _bgButton.highlighted = highlighted;
//    _storyImage.highlighted = highlighted;
//    playingFlagPic.highlighted = highlighted;
//    
//}

@end
