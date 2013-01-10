

#import "BTSourceUpdateService.h"
#import "BTConstant.h"

@implementation BTSourceUpdateService

- (id)init{
    self = [super init];
    if(self){

    }
    return self;
}
- (NSData *)getPostData{
    self.requestCID = RESOURCE_CHANGE_REQUEST_NOTIFICATION_CID;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[RESOURCE_CHANGE_REQUEST_NOTIFICATION_CID integerValue]];
    id check = [ud objectForKey:SOURCE_UPDATE_TIME];
    if (check == nil) {
        rd.stamp = [NSNumber numberWithInt:0];
    } else {
        NSNumber *createTime = [ud objectForKey:SOURCE_UPDATE_TIME];
        rd.stamp = createTime;
    }
    //rd.stamp = [NSNumber numberWithInt:1];
    NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
    
}

@end
