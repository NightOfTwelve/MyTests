//
//  BTFeedbackSingletonService.m
//  AABabyTing3
//
//  Created by Zero on 11/23/12.
//
//

#import "BTFeedbackSingletonService.h"
#import "BTFeedbackRecord.h"
#import "BTServiceConstant.h"
#import "JSONKit.h"

@interface BTFeedbackSingletonService ()
@property(nonatomic,assign) ASIHTTPRequest *request;
@end

@implementation BTFeedbackSingletonService

- (void)dealloc {
	self.record = nil;
	_delegate = nil;
	[self cancel];
	[super dealloc];
}

#pragma mark -
- (void)start {
	CDLog(BTDFLAG_NEW_FEEDBACK, @"service start");
	[self.request startAsynchronous];
}

- (void)cancel {
	if (_request != nil) {
		[_request clearDelegatesAndCancel];
		[_request release];
		_request = nil;
	}
}

#pragma mark -
- (ASIHTTPRequest *)request {
	[self cancel];
	
	NSURL *url = [NSURL URLWithString:DefaultServer_IP];
	_request = [[ASIHTTPRequest alloc] initWithURL:url];
	[_request setTimeOutSeconds:TIME_OUT_SECONDS];
	_request.numberOfTimesToRetryOnTimeout = RETRY_COUNTS;
	_request.delegate = self;
	[_request appendPostData:[self getPostData]];
	
	return _request;
}

- (NSData *)getPostData {
	NSDictionary *requestInfo = @{
		@"feedback" : self.record.text,
		@"email" : self.record.email
	};
	NSDictionary *postInfo = @{
		@"app_name" : self.record.appName,
		@"app_version" : self.record.appVersion,
		@"api_version" : self.record.apiVersion,
		@"identifier" : self.record.uuid,
		@"request_name" : REQUEST_NAME_FEEDBACK,
		@"request_info" : requestInfo
	};
	NSData *postData = nil;
	@try {
		postData = [postInfo JSONData];
		
		NSString *str = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
		CDLog(BTDFLAG_NEW_FEEDBACK,@"意见反馈Service组包完毕。");
		CVLog(BTDFLAG_NEW_FEEDBACK,@"包内容：%@",str);
		[str release];
	}
	@catch (NSException *exception) {
		
	}
	
	return postData;
}

#pragma mark - ASIHttpRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
	int errorCode = ERROR_CODE_UNKNOWNERROR;
	@try {
		NSData *data = request.responseData;
		NSDictionary *info = [BTUtilityClass jsonParser:data];
		id ret = info[@"ret"];
		errorCode = [ret intValue];
		if (errorCode == 100) {//成功
			CILog(BTDFLAG_NEW_FEEDBACK,@"意见反馈上报成功！");
			BOOL shouldReturn = NO;
			@try {
				[self.delegate didFinishedReportFeedbackOnService:self];
				shouldReturn = YES;
			}
			@catch (NSException *exception) {
			}
			@finally {
				if (shouldReturn) {
					return;
				}
			}
		} else {
			errorCode = ERROR_CODE_REQUSETERROR;
		}
	}
	@catch (NSException *exception) {
	}
	
	NSError *error = [NSError errorWithDomain:FEEDBACK_ERROR_DOMAIN
										 code:errorCode
									 userInfo:@{}];
	[self didFailedWithError:error];
}

- (void)didFailedWithError:(NSError *)error {
	CELog(BTDFLAG_NEW_FEEDBACK,@"意见反馈上报失败！(%@)",error);
	@try {
		[self.delegate didFailedReportFeedbackOnService:self
											  withError:error];
	}
	@catch (NSException *exception) {
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[self didFailedWithError:request.error];
}
@end
