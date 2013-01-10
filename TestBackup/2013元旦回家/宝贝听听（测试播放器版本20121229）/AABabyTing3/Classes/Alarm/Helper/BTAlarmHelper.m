//
//  BTAlarmHelper.m
//  AABabyTing3
//
//  Created by Zero on 12/23/12.
//
//

#import "BTAlarmHelper.h"
#import "BTAlarm.h"

@implementation BTAlarmHelper
+ (NSString *)textOfAlarmRemains:(BTAlarm *)anAlarm {
	NSUInteger remains = anAlarm.remains;
	EnumBTAlarmMode mode = anAlarm.mode;
	
	switch (mode) {
		case eBTAlarmModeCounting:
			return [self textOfRemainCount:remains];
		case eBTAlarmModeTiming:
			return [self textOfSeconds:remains];
		default:
			return nil;
	}
}

+ (NSString *)textOfRemainCount:(NSUInteger)theCount {
	return [NSString stringWithFormat:@"%3u",theCount];
}

+ (NSString *)textOfSeconds:(NSUInteger)theSeconds {
	int minutes = theSeconds/60;
	if (minutes>99) {
		minutes=99;
	} else if (minutes<0) {
		minutes=0;
	}
	int seconds = theSeconds%60;
	if (seconds<0) {
		seconds=0;
	}
	return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}
@end
