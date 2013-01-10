//
//  BTOneBookStoryListData.h
//  305
//
//  Created by Vicky on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTOneBookStoryListData : NSObject{
	
}
@property (assign)        NSUInteger     albumid;
@property (assign)        NSUInteger     total;
@property (assign)        NSUInteger     count;
@property (assign)        NSUInteger     bookid;

@property (nonatomic,copy)NSString       *bookName;
@property (nonatomic,copy)NSString       *bookDesc;
@property (nonatomic,copy)NSString       *bookSlen;
@property (nonatomic,copy)NSString       *bookAnc;
@property (nonatomic,copy)NSString       *bookUptime;
@property (nonatomic,copy)NSString       *bookbPic;
@property (nonatomic,copy)NSString       *booksPic;
@property (nonatomic,copy)NSString       *bookHistory;
@property (nonatomic,copy)NSString       *bookLStory;
@property (assign)NSInteger              picVersion;

@end
