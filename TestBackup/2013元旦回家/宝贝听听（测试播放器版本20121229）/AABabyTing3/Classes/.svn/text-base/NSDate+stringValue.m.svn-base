//
//  NSDate+stringValue.m
//  AABabyTing3
//
//  Created by Zero on 9/11/12.
//
//

#import "NSDate+stringValue.h"

@implementation NSDate (stringValue)

//将NSDate转成字符串（年-月-日）
- (NSString *)stringValue {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd";
	NSString *dateStr = [formatter stringFromDate:self];
	[formatter release];
	
	return dateStr;
}

@end
