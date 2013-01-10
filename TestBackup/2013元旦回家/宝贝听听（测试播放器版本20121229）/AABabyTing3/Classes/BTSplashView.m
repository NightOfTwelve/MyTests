//
//  BTSplashView.m
//  闪屏
//
//  Created by vicky on 8/31/12.
//	Modified by Zero on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
//	神一样的注释，我表示看的眼睛疼，这个BUG我还必须现在改，所以整个文件基本都被我删除重新写了，见谅。(Zero)
#import "BTSplashView.h"
#import "BTAppDelegate.h"
@implementation BTSplashView
@synthesize imageView,bIsDefaultSplash;
@synthesize guoduImageView  = _guoduoImageView;
- (id)init {
	CGRect bounds = [UIScreen mainScreen].bounds;
    CDLog(BTDFLAG_SPLASH, @"splash bounds = %@",NSStringFromCGRect(bounds));
	self = [super initWithFrame:bounds];
	if (self) {
		self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
		UIImage *splashImage = [BTSplashAction getSplashImage];
        CDLog(BTDFLAG_DOUBLESPLASH,@"splashImage =%@",splashImage);
        bIsDefaultSplash = NO;
        if (splashImage == nil) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",[NSBundle mainBundle].resourcePath,@"SplashDefault.png"];
            splashImage = [UIImage imageWithContentsOfFile:filePath];
            
            self.bIsDefaultSplash = YES;
        }
        
        imageView = [[UIImageView alloc] initWithFrame:bounds];
		imageView.image = splashImage;
        imageView.alpha = 0.f;
        [self addSubview:imageView];
        
#pragma mark - 过度闪屏，Dora扩展
        BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
        BOOL isFromBackground =  delegate.isFromBackground;
        if (!isFromBackground) {
            //过度闪屏（初次启动）
            _guoduoImageView =[[UIImageView alloc] initWithFrame:bounds];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",[NSBundle mainBundle].resourcePath,@"SplashDefault.png"];
            _guoduoImageView.image = [UIImage imageWithContentsOfFile:filePath];
            [self addSubview:_guoduoImageView];
            [_guoduoImageView release];
        }
	}
	return (self);
}

- (void)dealloc {
    [imageView release];
	[super dealloc];
}
@end

