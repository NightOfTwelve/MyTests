//
//  OCMockSampleTest.m
//  DemoGHUnitSample
//
//  Created by Song Zhipeng on 1/10/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import "OCMockSampleTest.h"
#import <OCMock/OCMock.h>

@interface TempUtilities : NSObject
+ (int)calculate:(int)a and:(int)b;
@end

@implementation TempUtilities
+ (int)calculate:(int)a and:(int)b {
	return a+b;
}
@end

@implementation OCMockSampleTest
// simple test to ensure building, linking,

// and running test case works in the project

- (int)calculate:(int)a and:(int)b {
	return [TempUtilities calculate:a and:b];
}

- (void)testCalculateAnd {
	OCMockSampleTest *realObject = [[[OCMockSampleTest alloc] init] autorelease];
    id mock = [OCMockObject partialMockForObject:realObject];
	
	int a=1,b=2;
	int r=3;

	int returnValue = [mock calculate:a and:b];
	GHAssertEquals(returnValue, r, nil);
}

- (void)testOCMockPass

{
	
    id mock = [OCMockObject mockForClass:NSString.class];
	
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
	
    
	
    NSString *returnValue = [mock lowercaseString];
	
    GHAssertEqualObjects(@"mocktest", returnValue,
						 
                         @"Should have returned the expected string.");
	
}

- (void)testOCMockFail

{
	
    id mock = [OCMockObject mockForClass:NSString.class];
	
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
	
    NSString *returnValue = [mock lowercaseString];
	
    GHAssertEqualObjects(@"thisIsTheWrongValueToCheck",
						 
                         returnValue, @"Should have returned the expected string.");
	
}
@end
