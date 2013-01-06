//
//  BTRecord.m
//  TestCoreData
//
//  Created by Song Zhipeng on 1/6/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import "BTRecord.h"
#import "KPStore.h"

@implementation BTRecord

@dynamic eventID;
@dynamic targetID;
@dynamic value;
@dynamic timeStamp;

//- (BOOL)isEqual:(id)object {
//	BTRecord *record = (BTRecord *)object;
//	return (self.eventID == record.eventID
//			&& self.targetID == record.targetID
//			&& self.value == record.value
//			&& self.timeStamp == record.timeStamp);
//}

- (NSString *)description {
	return [NSString stringWithFormat:@"event:%d,target:%d,value:%d,timestamp:%d",self.eventID,self.targetID,self.value,self.timeStamp];
}

+ (NSArray *)findByEventID:(int32_t)anEventID
			   andTargetID:(int32_t)aTargetID
			  andTimeStamp:(int32_t)aTimeStamp
					 error:(NSError **)anError {
	NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [[KPStore shareStore] entityForName:[self entityName]];
	[fetchRequest setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventID == %d and targetID == %d and timeStamp == %d",anEventID,aTargetID,aTimeStamp];
	
	[fetchRequest setPredicate:predicate];
	
	return [[KPStore shareStore] executeFetchRequest:fetchRequest
											   error:anError];
}

@end
