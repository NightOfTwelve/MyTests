//
//  UIView+PrintSubviews.m
//  ZeroCategory
//
//  Created by Zero on 11/13/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import "ZeroCategories.h"

#pragma mark - UIView+PrintSubviews
@implementation UIView (PrintSubviews)
- (void)printSubviewsWithIndentString:(NSString *)indentString {
#if DEBUG
	if (indentString == nil) {
		indentString = @"";
	}
	NSString *viewDescription = NSStringFromClass([self class]);
	printf("%s+-%s\n",[indentString UTF8String],[viewDescription UTF8String]);
	
	NSArray *siblings = self.superview.subviews;
	if (siblings.count>1 && [siblings indexOfObject:self]<siblings.count-1) {
		indentString = [indentString stringByAppendingString:@"| "];
	} else {
		indentString = [indentString stringByAppendingString:@"  "];
	}
	
	for (UIView *subview in self.subviews) {
		[subview printSubviewsWithIndentString:indentString];
	}
#endif
}
- (void)printSubviews {
#if DEBUG
	[self printSubviewsWithIndentString:nil];
#endif
}
@end

#pragma mark - NSURL+
@implementation NSURL (urlWithStringFormat)
+ (NSURL *)URLWithStringFormat:(NSString *)format, ... {
	va_list argList;
	va_start(argList, format);
	NSString *str = [[NSString alloc] initWithFormat:format arguments:argList];
	va_end(argList);
	NSURL *url = [NSURL URLWithString:str];
	[str release];
	return url;
}
@end

#pragma mark - 分辨率
@implementation UIScreen(pixel)
- (CGSize)pixel {
	CGSize size = self.bounds.size;
	CGFloat scale = self.scale;
	size.width *= scale;
	size.height *= scale;
	return size;
}
@end

#pragma mark - NSData->NSString
@implementation NSData(UTF8String)
- (NSString *)UTF8String {
	return [[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding] autorelease];
}
@end