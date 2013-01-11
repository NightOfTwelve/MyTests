//
//  ViewController.m
//  TestLock
//
//  Created by Zero on 1/11/13.
//  Copyright (c) 2013 21kunpeng. All rights reserved.
//

#import "ViewController.h"

static BOOL __bLock = NO;
static NSLock *__lock = nil;

@interface ViewController ()

@end

@implementation ViewController

+ (void)initialize {
	__lock = [[NSLock alloc] init];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.multipleTouchEnabled = NO;
//	self.view.exclusiveTouch = NO;
	self.buttonA.exclusiveTouch = YES;
	self.buttonB.exclusiveTouch = YES;
}

- (void)dealloc {
    [_buttonA release];
    [_buttonB release];
    [super dealloc];
}

- (IBAction)onClickedButton:(UIButton *)sender {
	NSLog(@"%@ button clicked!",sender.titleLabel.text);
	if ([__lock tryLock]) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.0]];
		NSLog(@"%@ button ok!",sender.titleLabel.text);
		[__lock unlock];
	}
	NSLog(@"%@ button finish!",sender.titleLabel.text);
}

@end
