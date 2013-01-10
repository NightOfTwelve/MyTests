//
//  BTBookListAction.h
//  cid = 304.故事列表第二个TabView相关。
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTBaseAction.h"
#import "BTBookListService.h"

@interface BTBookListAction : BTBaseAction{
    NSInteger             _categotyID;                                  ///< 分类ID
    NSString              *_type;                                       ///< 年龄或内容分类
    NSInteger             _lastID;
    NSInteger             _len;
}

- (id)initWithCategoryID:(NSInteger)categoryID type:(NSString *)type len:(NSInteger)len lastId:(NSInteger       )lastID;
@end
