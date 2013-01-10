//
//  BTListInfo.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-5.
//
//

#import <Foundation/Foundation.h>

@interface BTListInfo : NSObject

@property (nonatomic,retain) NSMutableArray *result;
@property (nonatomic,assign) NSInteger countInNet;
@property (nonatomic,assign,readonly) NSInteger countInDataManager;

@end
