//
//  BTNecessarySoftwareService.h
//  AABabyTing3
//
//  Created by Tiny on 12-9-29.
//
//

#import "BTBaseService.h"

@interface BTNecessarySoftwareService : BTBaseService{
    
    NSString *_updateHtmlUrl;
    int updateStamp;
}

@property (nonatomic,retain) NSString *updateHtmlUrl;

- (id)initWithData:(NSDictionary *)dic;

@end
