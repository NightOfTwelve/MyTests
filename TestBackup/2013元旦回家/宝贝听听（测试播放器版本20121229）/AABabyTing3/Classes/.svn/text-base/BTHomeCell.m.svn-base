//
//  BTHomeCell.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTHomeCell.h"

@implementation BTHomeCell
@synthesize netImageView = _netImageView,titleLabel = _titleLabel, descLabel = _descLabel,backButton = _backButton,theNewFlagPic = _theNewFlagPic;


-(void)dealloc{
    _netImageView.viewController = nil;
    [_netImageView release];
    [_titleLabel release];
    [_descLabel release];
    [_backButton release];
    [_theNewFlagPic release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self insertSubview:_backButton atIndex:0];
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
//        _theNewFlagPic = [[BTImageView alloc] initWithFrame:CGRectMake(230, 15, 43, 20)];
//        }
//        UIImage *bottomImage = [UIImage imageNamed:@"new_homePagel.png"];
//        _theNewFlagPic.image = bottomImage;
//        _theNewFlagPic.tag = TAG_NEW_FLAG;
//        [self addSubview:_theNewFlagPic];
    }
    return self;
}

-(void)drawCell:(BTHomeData *)data{
    
    NSString *homeTitle = data.category;
    CDLog(BTDFLAG_NEW_FLAG,@"title = %@",homeTitle);
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize textSize = [homeTitle sizeWithFont:font];
    CDLog(BTDFLAG_NEW_FLAG,@"size = %@",NSStringFromCGSize(textSize));
    
    if (_theNewFlagPic) {
        [_theNewFlagPic removeFromSuperview];
        [_theNewFlagPic release];
        _theNewFlagPic = nil;
    }
    
    CGRect newFlagFrame;
    if (textSize.width > 203 - 43) {
        newFlagFrame = CGRectMake(230, 18, 43, 16);
    }else{
        newFlagFrame = CGRectMake(_titleLabel.frame.origin.x + textSize.width + 7, 18, 43, 16);
    }

    BTImageView *imageView = [[BTImageView alloc] initWithFrame:newFlagFrame];
    self.theNewFlagPic = imageView;
    _theNewFlagPic.image = [UIImage imageNamed:@"new_homePage.png"];
    [self addSubview:_theNewFlagPic];
    _theNewFlagPic.tag = TAG_NEW_FLAG;
    
    if (data.isNew) {
        _theNewFlagPic.hidden = NO;
    }else{
        _theNewFlagPic.hidden = YES;
    }
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _backButton.highlighted = highlighted;
    _titleLabel.highlighted = highlighted;
    _descLabel.highlighted = highlighted;
    _netImageView.highlighted = highlighted;
    _theNewFlagPic.highlighted = highlighted;
}

@end
