//
//  NSManagedObject+ActiveRecord.m
//  KPStore
//
//  Created by He baochen on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObject+ActiveRecord.h"
#import "KPStore.h"

@implementation NSManagedObject (ActiveRecord)

+ (NSString*)entityName {
  return NSStringFromClass([self class]);
}

+ (NSFetchRequest*)defaultFetchRequest{
	NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [[KPStore storeForObject:[self class]] entityForName:[self entityName]];
	[fetchRequest setEntity:entity];
	return fetchRequest;
}
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error {
  return [[KPStore storeForObject:[self class]].managedObjectContext executeFetchRequest:request error:error];
}

+ (NSArray *)findAllOnLimit:(NSUInteger)theLimit
					  error:(NSError **)anError {
	NSFetchRequest* fetchRequest = [self defaultFetchRequest];
	[fetchRequest setFetchLimit:theLimit];
	return [self executeFetchRequest:fetchRequest
							   error:anError];
}

+ (NSArray*)findAllWithError:(NSError **)error {
  return [self findAllSortByKey:nil ascending:YES error:error];
}

+ (NSArray*)findAllSortByKey:(NSString*)sortKey ascending:(BOOL)ascending error:(NSError **)error {
  NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [[KPStore storeForObject:[self class]] entityForName:[self entityName]];
  [fetchRequest setEntity:entity];
  if (sortKey) {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                                   ascending:ascending];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
  }
  NSArray *array = [[KPStore storeForObject:[self class]] executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return array;
}


+ (id)createNewObject {
  id newObject = nil;
	KPStore *store = [KPStore storeForObject:[self class]];
  newObject = [store insertNewObjectForEntityForName:[self entityName]];
  return newObject;
}

+ (void)deleteAllObjects {
	NSArray *objects = [self findAllWithError:nil];
	for (NSManagedObject *o in objects) {
		[o deleteSelf];
	}
	[self save];
}

+ (void) deleteObjectByID:(NSManagedObjectID*)objectID {
  [[KPStore storeForObject:[self class]] deleteObjectByID:objectID];
}

- (void) deleteSelf {
  [[KPStore storeForObject:[self class]] deleteObject:self];
}
- (void) save {
  [[KPStore storeForObject:[self class]] saveContext];
}

+ (void)save {
	[[KPStore storeForObject:[self class]] saveContext];
}

@end
