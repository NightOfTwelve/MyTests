//
//  KPStore.h
//  kweibo
//
//  Created by He baochen on 11-9-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 使用说明：
 1. 在新工程中使用的时候，需要先修改 MODEL_FILE_NAME, 例如model文件名为 Hello.xcdatamodeld，MODEL_FILE_NAME 需要指定为Hello
  
 */
#define MODEL_FILE_NAME @"Model"
#ifndef MODEL_FILE_NAME
#warning please define MODEL_FILE_NAME 
#endif

@interface KPStore : NSObject {
    NSManagedObjectContext *__managedObjectContext;
    NSManagedObjectModel *__managedObjectModel;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
}

+ (KPStore*) shareStore;
+ (void)destory;


@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory;
- (void) saveContext;
- (void) didReceiveMemoryWarning;
- (void) resetPersistentStore;

- (NSManagedObject *)objectWithID:(NSManagedObjectID *)objectID; 
- (void)deleteObject:(NSManagedObject *)object;
- (NSManagedObject*) insertNewObjectForEntityForName:(NSString*)entityName;
- (void)deleteObjectByID:(NSManagedObjectID *)objectID;
- (NSEntityDescription*) entityForName:(NSString*)entityName;
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error;
@end
