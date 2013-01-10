//
//  BTAlarmButton.h
//  testAlarm2
//
//  Created by Zero on 12/18/12.
//  Copyright (c) 2012 21kunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTAlarmConstants.h"

@interface BTAlarmButton : UIButton

@property(nonatomic,assign) EnumBTAlarmMode mode;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,retain) UILabel *textLabel;

- (id)initWithFrame:(CGRect)frame;


@end
