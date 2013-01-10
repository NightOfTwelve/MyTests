//
//  NSObject+mutableCopyCompletely.m
//  AABabyTing3
//
//  Created by Zero on 10/25/12.
//
//

#import "NSObject+mutableCopyCompletely.h"

@implementation NSObject (mutableCopyCompletely)
- (id)mutableCopyCompletely {
	id ret = nil;
	
	if ([self isKindOfClass:[NSArray class]]) {
		//数组
		NSArray *arr = (NSArray *)self;
		NSMutableArray *marr = [[NSMutableArray alloc] init];
		for (int i=0; i<arr.count; i++) {
			[marr addObject:[[arr[i] mutableCopyCompletely] autorelease]];
		}
		ret = marr;
	} else if ([self isKindOfClass:[NSDictionary class]]) {
		//字典
		NSDictionary *dic = (NSDictionary *)self;
		NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
		for (NSString *key in dic) {
			id value = [[dic[key] mutableCopyCompletely] autorelease];
			[mdic setValue:value forKey:key];
		}
		ret = mdic;
	} else {
//		if ([self respondsToSelector:@selector(mutableCopy)]) {
//			ret = [self mutableCopy];
//		} else {
			ret = [self copy];
//		}
	}
	
	return ret;
}
@end
