//
//  BTRadioCell.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTRadioCell.h"

@implementation BTRadioCell
@synthesize radioTitle = _radioTitle,backButton = _backButton,iconView = _iconView,theNewFlagPic = _theNewFlagPic;

-(void)dealloc{
    _iconView.viewController = nil;
    [_iconView stopLoading];
    [_iconView release];
    [_backButton release];
    [_radioTitle release];
    [_theNewFlagPic release];
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

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = self.frame;
        [self insertSubview:_backButton atIndex:0];
        
//        if (_theNewFlagPic == nil) {
//            _theNewFlagPic = [[BTImageView alloc] initWithFrame:CGRectMake(230, 28, 43, 20)];
//        }
//        UIImage *bottomImage = [UIImage imageNamed:@"new_homePagel.png"];
//        _theNewFlagPic.image = bottomImage;
//        _theNewFlagPic.tag = TAG_NEW_FLAG;
//        [self addSubview:_theNewFlagPic];

    }
    
    return self;
}

-(void)drawCell:(BTRadioData *)data{
    
    if (_theNewFlagPic == nil) {
        self.theNewFlagPic = [[[BTImageView alloc] initWithFrame:CGRectMake(39, 17, 22, 21)] autorelease];
        UIImage *bottomImage = [UIImage imageNamed:@"newFlag.png"];
        _theNewFlagPic.image = bottomImage;
        [_iconView addSubview:_theNewFlagPic];
        _theNewFlagPic.tag = TAG_NEW_FLAG;
    }
    
    if (data.isNew) {
        _theNewFlagPic.hidden = NO;
    }else{
        _theNewFlagPic.hidden = YES;
    }
    
    //因3.2版本对图片大小frame的修改，该版本new标识不显示，如需显示将下行代码注释掉即可（neo）
    _theNewFlagPic.hidden = YES;
    
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _backButton.highlighted = highlighted;
    _iconView.highlighted = highlighted;
    _theNewFlagPic.highlighted = highlighted;
}

@end
