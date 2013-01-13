//
//  BTCoreDataRegister.m
//  DemoStatistics
//
//  Created by Song Zhipeng on 1/13/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import "BTCoreDataRegister.h"

@implementation BTCoreDataRegister

+ (void)registerAll {
	[MagicalRecord setupCoreDataStackWithStoreNamed:@"Model"];
}

@end
