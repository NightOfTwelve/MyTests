//
//  BTOCUnitBaseTestCase.h
//  AABabyTing3Tests
//
//  Created by Neo Wang on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface BTOCUnitBaseTestCase : SenTestCase

- (void)wait;
- (void)wait:(NSTimeInterval)seconds;
@end
