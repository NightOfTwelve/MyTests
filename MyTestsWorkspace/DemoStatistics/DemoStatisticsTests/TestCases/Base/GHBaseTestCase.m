//
//  GHBaseTestCase.m
//  DemoStatistics
//
//  Created by Song Zhipeng on 1/13/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import "GHBaseTestCase.h"

@implementation GHBaseTestCase

@end

#pragma mark - 
NSString *AnyNSStringOfLength(NSUInteger aLen) {
	static const int MaxLength = 1024;
	if (aLen>0 && aLen<MaxLength) {
		char s[MaxLength];
		memset(s, 0, sizeof(s));
		for (int i=0; i<aLen; i++) {
			s[i] = ANY_ASCII_CHAR;
		}
		s[aLen] = '\0';
		return [NSString stringWithCString:s
								  encoding:NSASCIIStringEncoding];
	}
	return @"";
}