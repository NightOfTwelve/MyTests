//
//  BTZeroCategoriesTests.m
//  AABabyTing3
//
//  Created by Zero on 12/5/12.
//
//

#import "BTZeroCategoriesTests.h"

@implementation BTZeroCategoriesTests
////扫描与遍历视图层次结构
//@interface UIView (PrintSubviews)
//- (void)printSubviews;
//@end
//

////创建URL方法扩展
//@interface NSURL (urlWithStringFormat)
//+ (NSURL *)URLWithStringFormat:(NSString *)format, ...;
//@end
//

////获取屏幕分辨率
//@interface UIScreen(pixel)
//- (CGSize)pixel;
//@end
//

//@interface NSData(UTF8String)
//- (NSString *)string;
//@end
- (void)testNSData_UTF8String {
	{
		const char *cstr = "Hello";
		NSData *data = [[[NSData alloc] initWithBytes:cstr length:strlen(cstr)] autorelease];
		NSString *str = [data UTF8String];
		STAssertEqualObjects(str, @"Hello", nil);
	}
	{
		const char *cstr = "你好";
		NSData *data = [[[NSData alloc] initWithBytes:cstr length:strlen(cstr)] autorelease];
		NSString *str = [data UTF8String];
		STAssertEqualObjects(str, @"你好", nil);
	}
	{
		const char *cstr = "你好";
		NSString *str1 = [[[NSString alloc] initWithBytes:cstr length:strlen(cstr) encoding:NSASCIIStringEncoding] autorelease];
		NSData *data = [[[NSData alloc] initWithBytes:[str1 UTF8String] length:strlen([str1 UTF8String])] autorelease];
		NSString *str = [data UTF8String];
		BOOL b = ![str isEqualToString:@"你好"];
		STAssertTrue(b, nil);
	}
}
@end
