//
//  BTAlarmViewController.m
//  DemoAlarm
//
//  Created by Zero on 12/21/12.
//  Copyright (c) 2012 Zero. All rights reserved.
//

#import "BTAlarmViewController.h"
#import "BTUserDefaults.h"
#import "BTAlarmButton.h"
#import "BTAlarmDataSource.h"

#define ITEMS_CANVAS_FRAME CGRectMake(22, 70, 212, (38+6)*5)

@implementation BTAlarmViewController

- (id)init {
	self = [super init];
	if (self) {
		[BTAlarmNotifications
		 addObserver:self
		 selector:@selector(resetSavedModeAndIndex)
		 object:nil
		 name:BTAlarmDidFinishedNotification];
		
		[BTAlarmNotifications
		 addObserver:self
		 selector:@selector(resetSavedModeAndIndex)
		 object:nil
		 name:BTAlarmDidStopedNotification];
	}
	return self;
}

- (void)resetSavedModeAndIndex {
	[self saveMode:eBTAlarmModeTiming
		  andIndex:NOT_SELECTED];
	
	BTAlarmButton *button = [[BTAlarmButton alloc] init];
	button.index = NOT_SELECTED;
	[self postAlarmButtonNotification:button];
	[button release];
}

- (void)dealloc {
	[BTAlarmNotifications removeObserver:self];
	[_shadowView release];
	[_canvasView release];
	[_timingView release];
	[_timingCanvasView release];
	[_countingView release];
	[_countingCanvasView release];
	[_buttonView release];
	[_timingButton release];
	[_countingButton release];
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initUI];
}

#pragma mark - Switch Alarm Mode
- (void)onClickedTimingButton {
	[self bringTimingLayerToFront];
}

- (void)onClickedCountingButton {
	[self bringCountingLayerToFront];
}

- (void)bringTimingLayerToFront {
	[_canvasView bringSubviewToFront:_timingView];
	[_canvasView bringSubviewToFront:_buttonView];
}

- (void)bringCountingLayerToFront {
	[_canvasView bringSubviewToFront:_countingView];
	[_canvasView bringSubviewToFront:_buttonView];
}

//初始化层级关系（定时／定量谁在最上层）
- (void)initLayerLevel {
	BTAlarm *alarm = [BTAlarm sharedInstance];
	EnumBTAlarmMode mode = eBTAlarmModeTiming;
	if (alarm.state == eBTAlarmStateRunning) {
		mode = [BTUserDefaults alarmMode];
	}
	switch (mode) {
		case eBTAlarmModeTiming:
			[self bringTimingLayerToFront];
			break;
		case eBTAlarmModeCounting:
			[self bringCountingLayerToFront];
			break;
		default:
			break;
	}
}

#pragma mark - Init UI
- (void)initUI {
	self.view.backgroundColor = [UIColor clearColor];
	[self initShadowLayer];
	[self initCanvasLayer];
	
	[self initCountingLayer];
	[self initTimingLayer];
	
	[self initItemsSelected];
	[self initButtonLayer];
	
	[self initLayerLevel];
}

- (void)initShadowLayer {
	CGRect frame = [UIScreen mainScreen].bounds;
	_shadowView = [[UIView alloc] initWithFrame:frame];
	_shadowView.backgroundColor = [UIColor blackColor];
	_shadowView.alpha = .8;
	[self.view addSubview:_shadowView];
	
	UITapGestureRecognizer *tap
	= [[UITapGestureRecognizer alloc]
	   initWithTarget:self
	   action:@selector(dismissSelf)];
	[_shadowView addGestureRecognizer:tap];
	[tap release];
}

- (void)initCanvasLayer {
	CGRect bounds = [UIScreen mainScreen].bounds;
	CGRect frame = CGRectMake((bounds.size.width-256)/2, (bounds.size.height-311)/2-28, 256, 311);
	_canvasView = [[UIView alloc] initWithFrame:frame];
	_canvasView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:_canvasView];
}

- (void)initCountingLayer {
	UIImage *image = [UIImage imageNamed:@"counting_background"];
	_countingView = [[UIImageView alloc] initWithImage:image];
	[_canvasView addSubview:_countingView];
	[self initCountingCanvasView];
	_countingView.userInteractionEnabled = YES;
}

- (void)initTimingLayer {
	UIImage *image = [UIImage imageNamed:@"timing_background"];
	_timingView = [[UIImageView alloc] initWithImage:image];
	[_canvasView addSubview:_timingView];
	[self initTimingCanvasView];
	_timingView.userInteractionEnabled = YES;
}

- (void)initCountingCanvasView {
	CGRect frame = ITEMS_CANVAS_FRAME;
	_countingCanvasView = [[UIView alloc] initWithFrame:frame];
	_countingCanvasView.backgroundColor = [UIColor clearColor];
	[_countingView addSubview:_countingCanvasView];
	
	[self addItemsToCanvasOnMode:eBTAlarmModeCounting];
}

- (void)initTimingCanvasView {
	CGRect frame = ITEMS_CANVAS_FRAME;
	_timingCanvasView = [[UIView alloc] initWithFrame:frame];
	_timingCanvasView.backgroundColor = [UIColor clearColor];
	[_timingView addSubview:_timingCanvasView];
	
	[self addItemsToCanvasOnMode:eBTAlarmModeTiming];
}

- (UIView *)canvasViewOnMode:(EnumBTAlarmMode)mode {
	switch (mode) {
		case eBTAlarmModeCounting:
			return _countingCanvasView;
		case eBTAlarmModeTiming:
			return _timingCanvasView;
		default:
			return nil;
	}
}

- (UIImage *)normalImageOnMode:(EnumBTAlarmMode)mode {
	NSString *imageName = nil;
	switch (mode) {
		case eBTAlarmModeCounting:
			imageName = @"counting_item";
			break;
		case eBTAlarmModeTiming:
			imageName = @"timing_item";
			break;
		default:
			break;
	}
	return [UIImage imageNamed:imageName];
}

- (UIImage *)selectedImageOnMode:(EnumBTAlarmMode)mode {
	NSString *imageName = nil;
	switch (mode) {
		case eBTAlarmModeCounting:
			imageName = @"counting_item_selected";
			break;
		case eBTAlarmModeTiming:
			imageName = @"timing_item_selected";
			break;
		default:
			break;
	}
	return [UIImage imageNamed:imageName];
}

- (void)addItemsToCanvasOnMode:(EnumBTAlarmMode)aMode {
	UIView *theCanvasView = [self canvasViewOnMode:aMode];
	NSUInteger itemsCount = [BTAlarmDataSource countOnMode:aMode];
	for (int i=0; i<itemsCount; i++) {
		BTAlarmButton *btn = [[BTAlarmButton alloc] initWithFrame:CGRectMake(0, i*(38+6)+3, 212, 38)];
		[btn setImage:[self normalImageOnMode:aMode]
			 forState:UIControlStateNormal];
		[btn setImage:[self selectedImageOnMode:aMode]
			 forState:UIControlStateSelected];
		btn.mode = aMode;
		btn.index = i;
		NSArray *texts = [BTAlarmDataSource textsOnMode:aMode];
		btn.textLabel.text = [texts objectAtIndex:i];
		[btn addTarget:self
				action:@selector(onClickedItemButton:)
	  forControlEvents:UIControlEventTouchUpInside];
		[theCanvasView addSubview:btn];
		[btn release];
	}
}

- (void)initItemsSelected {
	BTAlarmButton *btn = [[BTAlarmButton alloc] init];
	BTAlarm *alarm = [BTAlarm sharedInstance];
	if (alarm.state == eBTAlarmStateRunning) {
		btn.mode = [BTUserDefaults alarmMode];
		btn.index = [BTUserDefaults alarmIndex];
	} else {
		btn.mode = eBTAlarmModeTiming;
		btn.index = NOT_SELECTED;
	}
	
	[self postAlarmButtonNotification:btn];
	[btn release];
}

//初始化切换按钮层
- (void)initButtonLayer {
	CGRect frame = CGRectMake(0, 0, 256, 50);
	_buttonView = [[UIView alloc] initWithFrame:frame];
	_buttonView.backgroundColor = [UIColor clearColor];
	[_canvasView addSubview:_buttonView];
	
	[self initCountingButton];
	[self initTimingButton];
}

- (void)initCountingButton {
	CGRect frame = CGRectMake(256-85, 0, 80, 50);
	_countingButton = [[UIButton alloc] initWithFrame:frame];
	UIImage *image = [UIImage imageNamed:@"counting_button_text"];
	[_countingButton setImage:image
					forState:UIControlStateNormal];
	[_countingButton addTarget:self
					   action:@selector(onClickedCountingButton)
			 forControlEvents:UIControlEventTouchUpInside];
	[_buttonView addSubview:_countingButton];
}

- (void)initTimingButton {
	CGRect frame = CGRectMake(5, 0, 80, 50);
	_timingButton = [[UIButton alloc] initWithFrame:frame];
	UIImage *image = [UIImage imageNamed:@"timing_button_text"];
	[_timingButton setImage:image
				  forState:UIControlStateNormal];
	[_timingButton addTarget:self
					 action:@selector(onClickedTimingButton)
		   forControlEvents:UIControlEventTouchUpInside];
	[_buttonView addSubview:_timingButton];
}

#pragma mark - Item Button Clicked Events
- (void)onClickedItemButton:(BTAlarmButton *)aButton {
	[self postAlarmButtonNotification:aButton];
	if (aButton.selected) {
		[self startWithButton:aButton];
	} else {
		[self stopWithButton:aButton];
	}
}

- (void)saveMode:(EnumBTAlarmMode)aMode
		andIndex:(NSInteger)anIndex {
	[BTUserDefaults setAlarmMode:aMode];
	[BTUserDefaults setAlarmIndex:anIndex];
}

- (BOOL)isIndexLegal:(NSInteger)anIndex
			  OnMode:(EnumBTAlarmMode)aMode {
	NSUInteger count = [BTAlarmDataSource countOnMode:aMode];
	return (anIndex>=0 && anIndex<count);
}

- (void)startWithButton:(BTAlarmButton *)aButton {
	EnumBTAlarmMode mode = aButton.mode;
	NSInteger index = aButton.index;
	[self saveMode:mode
		  andIndex:index];
	
	if ([self isIndexLegal:index
					OnMode:mode]) {
		NSArray *values = [BTAlarmDataSource valuesOnMode:mode];
		NSUInteger value = [[values objectAtIndex:index] unsignedIntegerValue];
		if (value > 0) {
			switch (mode) {
				case eBTAlarmModeCounting:
					[[BTAlarm sharedInstance] startCounting:value];
					break;
				case eBTAlarmModeTiming:
					[[BTAlarm sharedInstance] startTiming:value];
				default:
					break;
			}
		}
	}
}

- (void)stopWithButton:(BTAlarmButton *)aButton {
	[self resetSavedModeAndIndex];
	[[BTAlarm sharedInstance] stop];
}

- (void)postAlarmButtonNotification:(BTAlarmButton *)button {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	NSDictionary *userInfo 
		= [NSDictionary dictionaryWithObject:button
		  forKey:KEY_ALARM_BUTTON_CLICKED_BUTTON];
	NSString *notifName = BTAlarmButtonDidClickedNotification;
	
	[center postNotificationName:notifName
						  object:nil
						userInfo:userInfo];
}

#pragma mark -
- (void)dismissSelf {
	[BTAlarmNotifications
	 postNotificationName:BTAlarmViewControllerShouldDisappearNotification
	 withAlarm:nil];
//	ZLog(@"self.retainCount:%u",self.retainCount);
//	[self.view removeFromSuperview];
//	UIViewController *vc = self.presentingViewController;
//	
//	if ([vc respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
//		[vc dismissViewControllerAnimated:NO
//								 completion:nil];
//	} else if ([vc respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
//		[vc dismissModalViewControllerAnimated:NO];
//	}
}


@end
