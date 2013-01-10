//
//  BTParentSoftWareCell.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTSoftWareData.h"
#import "BTBaseCell.h"
@protocol BTSoftWareDownloadDelegate <NSObject>

- (void)downLoadSoftWare:(id)data;

@end

@interface BTParentSoftWareCell : BTBaseCell{
    id<BTSoftWareDownloadDelegate>      _softwareDelegate;
    IBOutlet    UIButton                *_downloadBtn;
    BTSoftWareData                      *_softData;
    IBOutlet    UIImageView                         *_infoView;
}
@property(assign)id<BTSoftWareDownloadDelegate>    softwareDelegate;
@property(nonatomic,retain)BTSoftWareData             *softData;

- (void)drawCell;
@end
