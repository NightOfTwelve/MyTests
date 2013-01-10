//
//  BTBadgeView.h
//  AABabyTing3
//
//  Created by  on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BTBadgeView : UIView{
    
    NSUInteger width;
	NSString *badgeString;
	
	UIFont *font;
	UITableViewCell *parent;
	
	UIColor *badgeColor;
	UIColor *badgeColorHighlighted;	
}

@property (nonatomic, assign)	NSUInteger fontSize;
@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, retain) NSString *badgeString;
@property (nonatomic, assign) UITableViewCell *parent;
@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, retain) UIColor *badgeColor;
@property (nonatomic, retain) UIColor *badgeColorHighlighted;
@property (nonatomic, assign) id delegate;

- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context 
			  withRadius:(CGFloat) radius;

- (id) initWithFrame:(CGRect)frame fontSize:(NSInteger)fontSize;

@end
