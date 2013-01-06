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

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error {
  return [[KPStore shareStore].managedObjectContext executeFetchRequest:request error:error];
}

+ (NSArray*)findAllWithError:(NSError **)error {
  return [self findAllSortByKey:nil ascending:YES error:error];
}

+ (NSArray*)findAllSortByKey:(NSString*)sortKey ascending:(BOOL)ascending error:(NSError **)error {
  NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [[KPStore shareStore] entityForName:[self entityName]];
  [fetchRequest setEntity:entity];
  if (sortKey) {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                                   ascending:ascending];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
  }
  NSArray *array = [[KPStore shareStore] executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return array;
}


+ (id)createNewObject {
  id newObject = nil;
  newObject = [[KPStore shareStore] insertNewObjectForEntityForName:[self entityName]];
  return newObject;
}

+ (void)deleteAllObjects {
	
}

+ (void) deleteObjectByID:(NSManagedObjectID*)objectID {
  [[KPStore shareStore] deleteObjectByID:objectID];
}
//+ (void) saveContext {
//  [[KPStore shareStore] saveContext];
//}
//
//+ (void) deleteObject:(NSManagedObject*)object {
//  [[KPStore shareStore] deleteObject:object];
//}

- (void) deleteSelf {
  [[KPStore shareStore] deleteObject:self];
}
- (void) save {
  [[KPStore shareStore] saveContext];
}

@end
