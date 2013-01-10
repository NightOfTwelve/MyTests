//
//  BTOneBookStoryListHeaderData.h
//  cid = 317
//
//  Created by Vicky on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTOneBookStoryListHeaderData : NSObject{
    
}

@property (nonatomic,copy)NSString          *name;
@property (assign)       NSInteger          size;
@property (assign)       NSInteger          headerid;
@property (nonatomic,copy)NSString          *desch;
@property (nonatomic,copy)NSString          *descb;
@property (nonatomic,copy)NSString          *onLineDay;
@property (nonatomic,copy)NSString          *logourl;
@property (nonatomic,copy)NSString          *picurl;
@property (assign)NSInteger                 picVersion;
@end