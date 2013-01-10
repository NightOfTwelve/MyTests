//
//  BTNavView.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-11.
//
//

#import "BTNavView.h"

@implementation BTNavView

@synthesize backButton= _backButton,bgView = _bgView,titleLabel = _titleLabel,playingButton= _playingButton,editButton = _editButton, playListButton = _playListButton,delegate = _delegate;



- (void)dealloc{
    [_editButton release];
    [_backButton release];
    [_titleLabel release];
    [_playListButton release];
    [_playingButton release];
    [_bgView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{
    self = [super init];
    if(self){
        self.frame= CGRectMake(0, 10, 320, 59);
        //叶子的背景图片
        _bgView = [BTUtilityClass createImageView:@"top_leaf_before.png" withFrame:self.frame];
        
        //左边的返回按钮
        _backButton = [[BTNavButton alloc] initWithFrame:CGRectMake(0,10, 85, 50)];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton setImage:[UIImage imageNamed:@"global_back.png"] forState:UIControlStateNormal];
        
        //左边的编辑按钮
        _editButton = [[BTNavButton alloc] initWithFrame:CGRectMake(0,10, 85, 50)];
        _editButton.backgroundColor = [UIColor clearColor];
        [_editButton setImage:[UIImage imageNamed:@"myStory_editor.png"] forState:UIControlStateNormal];
        _editButton.hidden = YES;
        
        //上面的标题
        _titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(80,10,160,51)];
        //_titleLabel.tag = TAG_TitleView;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumFontSize = 17.0;
        _titleLabel.textColor = [UIColor colorWithRed:0.98f green:0.72f blue:0.3f alpha:1.0f];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.shadowColor = [UIColor colorWithRed:0.0f green:0.27f blue:0.14f alpha:1.0f];
        [_titleLabel setUserInteractionEnabled:YES];
        //_viewTitle.shadowColor = [UIColor redColor];
        _titleLabel.shadowOffset = CGSizeZero;
        _titleLabel.shadowBlur = 4.0f;
        _titleLabel.oversampling = 2;
        
        

        
        
        
        //右边的返回正在播放
        _playingButton = [[BTNavButton alloc] initWithFrame:CGRectMake(320-85, 10, 85, 50)];
        _playingButton.backgroundColor = [UIColor clearColor];
        [_playingButton setImage:[UIImage imageNamed:@"playing_button.png"] forState:UIControlStateNormal];
        
        //右边的列表按钮
        _playListButton = [[BTNavButton alloc] initWithFrame:CGRectMake(320-83,10, 84, 45)];
        _playListButton.backgroundColor = [UIColor clearColor];
        [_playListButton setImage:[UIImage imageNamed:@"ButtonPlayList.png"] forState:UIControlStateNormal];
        _playListButton.hidden = YES;
        
        //增加上面的四个元素
        [self addSubview:_bgView];
        [self addSubview:_backButton];
        [self addSubview:_playingButton];
        [self addSubview:_titleLabel];
        [self addSubview:_editButton];
        [self addSubview:_playListButton];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelPress:)];
        //tap.delegate = self;
        [_titleLabel addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)labelPress:(id)sender{
    //DLog(@"helloworld");
//    [_delegate labelPress:sender];
}

@end
