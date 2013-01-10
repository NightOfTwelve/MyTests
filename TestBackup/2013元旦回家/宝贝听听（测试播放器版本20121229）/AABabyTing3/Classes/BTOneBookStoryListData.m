//
//  BTOneBookStoryListData.m
//  305
//
//  Created by Vicky on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BTOneBookStoryListData.h"

@implementation BTOneBookStoryListData
@synthesize albumid,total,count,bookid,bookName,bookDesc,bookSlen,bookAnc,bookUptime,bookbPic,booksPic,bookHistory,bookLStory;

-(void)dealloc{
//    [albumid    release];
//    [total      release];
//    [count      release];
//    [bookid     release];
    [bookName   release];
    [bookDesc   release];
    [bookSlen   release];
    [bookAnc    release];
    [bookUptime release];
    [bookbPic   release];
    [booksPic   release];
    [bookHistory release];
    [bookLStory  release];
    [super dealloc];
}
@end