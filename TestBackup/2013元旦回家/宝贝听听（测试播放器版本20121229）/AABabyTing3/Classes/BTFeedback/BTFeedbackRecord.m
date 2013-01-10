//
//  BTFeedbackRecord.m
//  Test_Feedback
//
//  Created by Zero on 11/23/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import "BTFeedbackRecord.h"

@implementation BTFeedbackRecord
- (NSString *)pixelInfo {
	CGSize size = [UIScreen mainScreen].pixel;
	return [NSString stringWithFormat:@"||%.0f*%.0f",size.height,size.width];
}
- (NSString *)machineType {
	return [NSString stringWithFormat:@"||%@",[BTUtilityClass getDeviceVersion]];
}
- (NSString *)systemVersion {
	return [NSString stringWithFormat:@"||iOS%@",[UIDevice currentDevice].systemVersion];
}

- (void)setText:(NSString *)text {
	if (text != _text) {
		[_text release];
		CDLog(BTDFLAG_NEW_FEEDBACK,@"text:%@",text);
		if (text!=nil) {
			_text = [[NSString alloc] initWithFormat:@"%@%@%@%@",text,[self machineType],[self systemVersion], [self pixelInfo]];
		}
	}
}

- (id)init {
	self = [super init];
	if (self) {
		self.appName = APP_NAME;
		if (_appName == nil) {
			self.appName = @"BabyTing";
		}
		self.uuid = [BTUtilityClass cfUUIDfromKeyChain];
		if (_uuid == nil) {
			self.uuid = @"unknown";
		}
		self.appVersion = [BTUtilityClass getBundleVersion];
		if (_appVersion == nil) {
			self.appVersion = @"unknown";
		}
		self.apiVersion = [NSString stringWithFormat:@"%0.1f",CHECKIN_API_VERSION];
		if (_apiVersion == nil) {
			self.apiVersion = @"1.2";
		}
		self.text = nil;
		self.qq = @"";
		self.email = @"";
		self.tel = @"";
		self.date = [NSDate date];
	}
	return self;
}

+ (BTFeedbackRecord *)record {
	return [[[self alloc] init] autorelease];
}
- (void)dealloc {
	self.appName = nil;
	self.appVersion = nil;
	self.apiVersion = nil;
	self.uuid = nil;
	self.text = nil;
	self.qq = nil;
	self.email = nil;
	self.tel = nil;
	self.date = nil;
	[super dealloc];
}
#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.appName forKey:@"feedback_record_appName"];
	[aCoder encodeObject:self.appVersion forKey:@"feedback_record_appVersion"];
	[aCoder encodeObject:self.apiVersion forKey:@"feedback_record_apiVersion"];
	[aCoder encodeObject:self.uuid forKey:@"feedback_record_uuid"];
	[aCoder encodeObject:self.text forKey:@"feedback_record_text"];
	[aCoder encodeObject:self.qq forKey:@"feedback_record_qq"];
	[aCoder encodeObject:self.email forKey:@"feedback_record_email"];
	[aCoder encodeObject:self.tel forKey:@"feedback_record_tel"];
	[aCoder encodeObject:self.date forKey:@"feedback_record_date"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		self.appName = [aDecoder decodeObjectForKey:@"feedback_record_appName"];
		self.appVersion = [aDecoder decodeObjectForKey:@"feedback_record_appVersion"];
		self.apiVersion = [aDecoder decodeObjectForKey:@"feedback_record_apiVersion"];
		self.uuid = [aDecoder decodeObjectForKey:@"feedback_record_uuid"];
		_text = [[aDecoder decodeObjectForKey:@"feedback_record_text"] copy];
		self.qq = [aDecoder decodeObjectForKey:@"feedback_record_qq"];
		self.email = [aDecoder decodeObjectForKey:@"feedback_record_email"];
		self.tel = [aDecoder decodeObjectForKey:@"feedback_record_tel"];
		self.date = [aDecoder decodeObjectForKey:@"feedback_record_date"];
		
	}
	return self;
}
@end
