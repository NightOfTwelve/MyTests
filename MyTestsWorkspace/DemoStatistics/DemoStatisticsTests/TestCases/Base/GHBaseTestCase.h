//
//  GHBaseTestCase.h
//  DemoStatistics
//
//  Created by Song Zhipeng on 1/13/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#define ANY_INT_VALUE ((int)(arc4random()*(arc4random()%2?1:-1)))
#define ANY_ASCII_CHAR ((char)32+arc4random()%(126-32+1))
NSString *AnyNSStringOfLength(NSUInteger aLen);

@interface GHBaseTestCase : GHTestCase

@end
