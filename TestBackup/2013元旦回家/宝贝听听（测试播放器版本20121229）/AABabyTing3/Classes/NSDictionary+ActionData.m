//
//  
//  testNSDictionaryErrorDeal
//
//  Created by Zero on 10/17/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import "NSDictionary+ActionData.h"

@implementation NSDictionary (ActionData)

- (id)valueForKey:(NSString *)key withClass:(Class)class {
	id ret = nil;
	@try {
		ret = [self valueForKey:key];
		if (![ret isKindOfClass:class]) {
			ret = nil;
		}
	}
	@catch (NSException *exception) {
	}
	
	return ret;
}

- (NSString *)stringForKey:(NSString *)key;
{
	return [self valueForKey:key withClass:[NSString class]];
}
- (NSNumber *)numberForKey:(NSString *)key;
{
	return [self valueForKey:key withClass:[NSNumber class]];
}
- (NSDictionary *)dictionaryForKey:(NSString *)key;
{
	return [self valueForKey:key withClass:[NSDictionary class]];
}
- (NSArray *)arrayForKey:(NSString *)key;
{
	return [self valueForKey:key withClass:[NSArray class]];
}

@end
