//
//  BTAlarmButton.m
//  testAlarm2
//
//  Created by Zero on 12/18/12.
//  Copyright (c) 2012 21kunpeng. All rights reserved.
//

#import "BTAlarmButton.h"
#import "BTAlarmNotifications.h"

@implementation BTAlarmButton
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.selected = NO;
		
		[self initTextLabel];
		
		[BTAlarmNotifications
		 addObserver:self
		 selector:@selector(handleBTAlarmButtonDidClickedNotification:)
		 object:nil
		 name:BTAlarmButtonDidClickedNotification];
	}
	return self;
}

- (void)dealloc {
	[BTAlarmNotifications removeObserver:self];
	[_textLabel release], _textLabel = nil;
	[super dealloc];
}

- (void)changeTextColorOnMode:(EnumBTAlarmMode)mode {
	if (_textLabel != nil) {
		switch (_mode) {
			case eBTAlarmModeCounting:
				_textLabel.textColor = [UIColor darkTextColor];
				break;
			case eBTAlarmModeTiming:
				_textLabel.textColor = [UIColor brownColor];
			default:
				break;
		}
	}
}

- (void)initTextLabel {
	CGRect frame = CGRectMake(14, 8, 140, 19);
	self.textLabel = [[[UILabel alloc] initWithFrame:frame]
					  autorelease];
	_textLabel.backgroundColor = [UIColor clearColor];
	_textLabel.font = [UIFont systemFontOfSize:17];
	_textLabel.textColor = [UIColor darkTextColor];
	[self addSubview:self.textLabel];
}

- (void)setMode:(EnumBTAlarmMode)mode {
	if (mode != _mode) {
		_mode = mode;
	}
	[self changeTextColorOnMode:mode];
}

- (BOOL)isEqualToAlarmButton:(BTAlarmButton *)button {
	return (button!=nil
			&& _mode==button.mode
			&& _index==button.index);
}

- (void)handleBTAlarmButtonDidClickedNotification:(NSNotification *)notif {
	NSDictionary *userInfo = notif.userInfo;
	BTAlarmButton *clickedButton = [userInfo valueForKey:KEY_ALARM_BUTTON_CLICKED_BUTTON];
	if ([self isEqualToAlarmButton:clickedButton]) {
		self.selected = !self.selected;
	} else {
		self.selected = NO;
	}
}

@end
