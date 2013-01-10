//
//  BTMyStroyCell.m
//  AABabyTing3
//
//  Created by  on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTMyStroyCell.h"
#import "BTDownLoadManager.h"
#import "BTUtilityClass.h"
#import "Only320Network.h"


@implementation BTMyStroyCell


@synthesize storyName = _storyName;
@synthesize storyAlbumName = _storyAlbumName;
@synthesize storyLength = _storyLength;
@synthesize storyImage = _storyImage;
@synthesize cellBg = _cellBg;
@synthesize story = _story;
@synthesize bgButton = _bgButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        _storyName = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 165, 21)];
        _storyName.backgroundColor = [UIColor clearColor];
        _storyName.textColor = [UIColor colorWithRed:0.478 green:0.259 blue:0.0 alpha:1.0];
        _storyName.font = [UIFont boldSystemFontOfSize:17];
        _storyName.textAlignment = UITextAlignmentLeft;
        //        _storyName.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_storyName];
        
        _storyImage = [[BTNetImageView alloc] initWithFrame:CGRectMake(20,8, 41, 41)];
        _storyImage.tag = TAG_NetImage;
        [self.contentView addSubview:_storyImage];
        
        _storyImage.defaultImage= TTIMAGE(@"bundle://story_cell_default.png");
        _storyAlbumName = [BTUtilityClass createLabel:_story.categoryName withFrame:CGRectMake(70, 25, 180, 30)];
        _storyAlbumName.textColor = [UIColor colorWithRed:0.616 green:0.506 blue:0.373 alpha:1.0];
        _storyAlbumName.font = [UIFont boldSystemFontOfSize:12];
        //    _storyAlbumName.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_storyAlbumName];
        
        _storyLength = [BTUtilityClass createLabel:[BTUtilityClass changToTimeFormatWithString:[_story.timeLength intValue]] withFrame:CGRectMake(265, 14, 50, 30)];
        //    _storyLength.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        _storyLength.textColor = [UIColor colorWithRed:0.616 green:0.506 blue:0.373 alpha:1.0];
        _storyLength.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_storyLength];
        
        self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgButton.frame = CGRectMake(0, 0, 320, 57);
        [self insertSubview:_bgButton atIndex:0];
    }
    return self;
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

    if(_story.categoryName&&[_story.categoryName length]>0){
        _storyAlbumName.text = [NSString stringWithFormat:@"《%@》%@",_story.categoryName,_story.speakerName];
    }else{
        _storyAlbumName.text = _story.speakerName;
    }
    _storyLength.text = [BTUtilityClass changToTimeFormatWithString:[_story.timeLength intValue]];
    //正在播放标记
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

-(void)setimageViewController:(UIViewController *)viewController{
    _storyImage.viewController = viewController;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    _bgButton.highlighted = highlighted;
    _storyImage.highlighted = highlighted;
    playingFlagPic.highlighted = highlighted;

}

//自定义cell的删除按钮
//-(void)willTransitionToState:(UITableViewCellStateMask)state{
//    
//    [super willTransitionToState:state];
//
//    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
//        for (UIView *subview in self.subviews) {
//            DLog(@"%@", NSStringFromClass([subview class]));
//            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {             
//                UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 33)];
//                [deleteBtn setImage:[UIImage imageNamed:@"cellImage.png"]];
//                [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
//                [deleteBtn release];
//            }
//        }
//    } 
//}

-(void)dealloc{
    _storyImage.viewController = nil;
    [_storyName release];
    [_storyImage stopLoading];
    [_storyImage release];
    [_storyAlbumName release];
    [_storyLength release];
    [_story release];
    [_bgButton release];
    [playingFlagPic release];
    [super dealloc];
}

@end
