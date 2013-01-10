//
//  BTBook.h
//  AABabyTing3
//
//  Created by baochen he on 12-8-14.
//
//

#import <Foundation/Foundation.h>

@interface BTBook : NSObject {
	
}
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *iconURL;
@property(nonatomic,copy) NSString *bookID;
@property(assign)NSInteger   storyCount;
@property(nonatomic,copy) NSString *desc;
@property(nonatomic,copy) NSString *onlineDate;
@property(assign) NSInteger categoryID;
@property(nonatomic,retain) NSArray *storyArray;
@property(nonatomic,copy) NSString *descBody;
@property(nonatomic,copy) NSString *descHead;
@property(assign)BOOL   isNew;
@property(assign)NSInteger  picVersion;

@end
