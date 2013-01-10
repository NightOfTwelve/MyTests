//
//  BTFeedbackSingletonService.h
//  AABabyTing3
//
//  Created by Zero on 11/23/12.
//
//

#import <Foundation/Foundation.h>

@class BTFeedbackRecord;
@protocol BTFeedbackSingletonServiceDelegate;

@interface BTFeedbackSingletonService : NSObject
<ASIHTTPRequestDelegate>

@property(nonatomic,retain) BTFeedbackRecord *record;
@property(nonatomic,assign) id<BTFeedbackSingletonServiceDelegate> delegate;

- (void)start;
- (void)cancel;

@end


@protocol BTFeedbackSingletonServiceDelegate <NSObject>
- (void)didFinishedReportFeedbackOnService:(BTFeedbackSingletonService *)service;
- (void)didFailedReportFeedbackOnService:(BTFeedbackSingletonService *)service withError:(NSError *)error;
@end