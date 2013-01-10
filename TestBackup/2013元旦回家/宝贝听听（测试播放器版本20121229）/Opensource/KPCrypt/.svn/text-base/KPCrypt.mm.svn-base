//
//  KPCrypt.m
//  testEncrypt
//
//  Created by Zero on 11/3/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import "KPCrypt.h"
#import <string>
#import "QQCltCrypt.h"
using namespace std;

@implementation KPCrypt
+ (NSMutableData *)encrypt:(NSData *)data withKey:(NSString *)theKey{
	const char *key = [theKey cStringUsingEncoding:NSASCIIStringEncoding];
	vector<char> vec = TeaEncrypt2(key, (const char*)[data bytes], data.length);
	NSMutableData* newData = [NSMutableData dataWithBytes:(const void*)&vec[0] length:vec.size()];
	return newData;
}
+ (NSMutableData *)decrypt:(NSData *)data withKey:(NSString *)theKey{
	const char *key = [theKey cStringUsingEncoding:NSASCIIStringEncoding];
	vector<char> vec = TeaDecrypt2(key, (const char*)[data bytes], data.length);
	NSMutableData *newData = [NSMutableData dataWithBytes:&vec[0] length:vec.size()];
	return newData;
}
@end
