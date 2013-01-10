//
//  BTTabBarItem.m
//  BabyTingIntense
//
//  Created by  on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTTabBarItem.h"

@implementation BTTabBarItem

@synthesize normalImage = _normalImage;
@synthesize customHighlightedImage = _customHighlightedImage;
@synthesize normalImageName = _normalImageName;
@synthesize hiImageName = _hiImageName;

-(id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag{
	if(self = [super initWithTitle:title image:nil tag:tag]){
		self.normalImage = image;
		self.customHighlightedImage = selectedImage;
	}
	return self;
}


-(void)dealloc
{
	[_normalImage release];
	[_customHighlightedImage release];
	[_normalImageName release];
	[_hiImageName release];
	[super dealloc];
}


@end
