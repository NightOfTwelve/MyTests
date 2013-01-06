//
//  NSManagedObject+ActiveRecord.h
//  KPStore
//
//  Created by He baochen on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ActiveRecord)

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error;

//查找该类型对象的全部数据
+ (NSArray*)findAllWithError:(NSError **)error;
+ (NSArray*)findAllSortByKey:(NSString*)sortKey ascending:(BOOL)ascending error:(NSError **)error;

//创新一个新对象
+ (id)createNewObject;

+ (void) deleteObjectByID:(NSManagedObjectID*)objectID;
+ (void) deleteAllObjects;
//+ (void) deleteObject:(NSManagedObject*)object;
//+ (void) saveContext;
- (void) deleteSelf;
- (void) save;

+ (NSString*)entityName;

@end
