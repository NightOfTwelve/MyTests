//
//  BTTeaCryptTests.m
//  AABabyTing3
//
//  Created by Zero on 11/29/13.
//
//

#import "BTTeaCryptTests.h"
#import "KPCrypt.h"

@implementation BTTeaCryptTests
- (void)test001_Encrypt {
	static NSString * key = @"KP^_Fuck_Merlin!";
	NSString *str1 = @"012345678";
	NSData *data1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
	
	NSData *data2 = [KPCrypt encrypt:data1 withKey:key];
	NSString *str2 = [[[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding] autorelease];
	CDLog(BTDFLAG_NEW_TEA_CRYPT,@"<<<<%@",str2);
	
	NSData *data3 = [KPCrypt decrypt:data2 withKey:key];
	NSString *str3 = [[[NSString alloc] initWithData:data3 encoding:NSUTF8StringEncoding] autorelease];
	CDLog(BTDFLAG_NEW_TEA_CRYPT,@">>>>%@",str3);
}

@end
