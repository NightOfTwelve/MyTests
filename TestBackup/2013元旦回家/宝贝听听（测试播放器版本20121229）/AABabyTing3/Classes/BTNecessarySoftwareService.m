//
//  BTNecessarySoftwareService.m
//  AABabyTing3
//
//  Created by Tiny on 12-9-29.
//
//

#import "BTNecessarySoftwareService.h"
#import "ZipArchive.h"
#import "BTConstant.h"

@implementation BTNecessarySoftwareService
@synthesize updateHtmlUrl = _updateHtmlUrl;

- (id)initWithData:(NSDictionary *)dic {
    
    self = [super init];
	if (self) {
        NSString *url = [dic objectForKey:CHECKIN_RESPONSE_NECESSARY_SOFT_UPDATE_URL];
        int stamp = [[dic objectForKey:CHECKIN_RESPONSE_NECESSARY_SOFT_CREATE_TIME] intValue];
		self.updateHtmlUrl = url;
        updateStamp = stamp;
	}
	return self;
}

- (void)defaultRequestMake {
    NSURL *url = [NSURL URLWithString:_updateHtmlUrl];
	_request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
    _request.numberOfTimesToRetryOnTimeout = RETRY_COUNTS;
    _request.delegate = self;
}

- (void)dealloc {
	[_updateHtmlUrl release];
	[super dealloc];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    DLog(@"request.error = %@",request.error);
}

- (void)requestFinished:(ASIHTTPRequest *)request{
	//存储原始文件
    NSData *data = [request responseData];
    NSString *zipFilePath = [BTUtilityClass fileWithPath:@"software.zip"];
    [data writeToFile:zipFilePath atomically:YES];

	//删除原来的解压后的文件夹
    NSString *unZipFilePath = [BTUtilityClass fileWithPath:@"parent"];
    [[NSFileManager defaultManager] removeItemAtPath:unZipFilePath error:nil];

	//尝试解压
    ZipArchive *zip = [[ZipArchive alloc] init];
    BOOL bIsCanOpen = [zip UnzipOpenFile:zipFilePath];
    if (bIsCanOpen) {//打开压缩文件成功
		BOOL bIsUnzipped = [zip UnzipFileTo:[BTUtilityClass getBabyStoryFolderPath] overWrite:YES];
		if (bIsUnzipped) {//解压成功
			[BTUserDefaults setNecessarySoftUpdateStamp:updateStamp];
		}
    }else{//打开压缩文件失败
    }
    
    [zip release];

}

@end
