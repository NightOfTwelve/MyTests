//
//  BTParentSoftWareCell.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTParentSoftWareCell.h"
#import "Only320Network.h"

@implementation BTParentSoftWareCell
@synthesize softwareDelegate = _softwareDelegate,softData = _softData;
- (void)dealloc{
    [_downloadBtn release];
    [_infoView release];
    [_softData release];
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

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){ 
    }
    return self;
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    //_backButton.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)softwareDownload:(id)sender{
    [_softwareDelegate downLoadSoftWare:_softData];
}


- (void)drawCell{
    if([_softData.sotfID isEqualToString:@"1"]){
        [_infoView setImage:[UIImage imageNamed:@"babyGrow.png"]];
    }
    else if([_softData.sotfID isEqualToString:@"2"]){
        [_infoView setImage:[UIImage imageNamed:@"babyGraw.png"]];
    }
    else if([_softData.sotfID isEqualToString:@"3"]){
        [_infoView setImage:[UIImage imageNamed:@"babyPaiPai.png"]];
    }
    else if([_softData.sotfID isEqualToString:@"4"]){
        [_infoView setImage:[UIImage imageNamed:@"babyTuTu.png"]];
    }
    else if([_softData.sotfID isEqualToString:@"5"]){
        [_infoView setImage:[UIImage imageNamed:@"babyPinPin.png"]];
    }
}

@end
