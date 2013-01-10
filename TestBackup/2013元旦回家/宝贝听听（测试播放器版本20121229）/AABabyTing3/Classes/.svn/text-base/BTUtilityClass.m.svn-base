//
//  BTUtilityClass.m
//  AABabyTing3
//
//  Created by  on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTUtilityClass.h"
#import "sys/utsname.h" //获取设备的类型  
#import "BTConstant.h"
#import "JSONKit.h"
#include <sys/xattr.h>  //不备份属性
#import "BTStoryPlayerController.h"
#import "BTPlayerManager.h"
#import "BTStory.h"
#import <MediaPlayer/MediaPlayer.h>
@implementation BTUtilityClass

//Documents/babyStory目录
+(NSString *)getBabyStoryFolderPath{
    return [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"babyStory"];
}

//Documents/cacheFolder目录
+ (NSString *)getStoryCacheFolderPath {
    return [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"cacheFolder"];
}

//返回cacheFolder目录下文件的路径
+ (NSString *)fileWithCacheFolderPath:(NSString *)fileName {
    return [[self getStoryCacheFolderPath] stringByAppendingPathComponent:fileName];
}

//返回babyStory目录下文件的路径
+ (NSString *)fileWithPath:(NSString *)fileName {
    return [[self getBabyStoryFolderPath] stringByAppendingPathComponent:fileName];
}

+ (BOOL)isNetWifi {
	return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi);
}
+ (BOOL)isNet3G {
	return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN);
}
+ (BOOL)isNetWorkNotAvailable{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable);
}

//现在的日期是否等于oldDateStr
+ (BOOL)isNowDateEqualsToDateString:(NSString *)oldDateStr {
	return [self isDate:[NSDate date] equalsToDateString:oldDateStr];
}

//newDate转换成NSString后是否等于oldDateStr
+ (BOOL)isDate:(NSDate *)newDate equalsToDateString:(NSString *)oldDateStr {
	NSString *newDateStr = [newDate stringValue];
	return [newDateStr isEqualToString:oldDateStr];
}

+ (NSString *)todayDateString {
	return [[NSDate date] stringValue];
}

//获取当前时间的double格式
+(double)nowTimeDouble {
	return [[NSString stringWithFormat:@"%ld",time(NULL)] doubleValue];
}

//记录播放次数（完全重写 by Zero）
+(void)recordStoryPlayCount:(NSString *)needToRecordStoryId {
	CILog(BTDFLAG_PlayedCount312,@"播放次数+1，故事ID为%@",needToRecordStoryId);
	if (!needToRecordStoryId) {
		CELog(BTDFLAG_PlayedCount312,@"para'needToRecordStoryId' == nil");
		return;
	}
	int storyIdInt = [needToRecordStoryId intValue];
	if (0 == storyIdInt) {
		CELog(BTDFLAG_PlayedCount312,@"storyIdInt == 0");
		return;
	}
	NSNumber *storyIdNumber = [NSNumber numberWithInt:storyIdInt];
	
    NSString *filePath =[self fileWithPath:RECORDPLAYCOUNT_PLIST_NAME];
	if (!filePath) {
		CELog(BTDFLAG_PlayedCount312,@"filePath == nil");
		return;
	}
	CDLog(BTDFLAG_PlayedCount312,@"before mutableCopy");
	NSMutableArray *records = [[[NSArray arrayWithContentsOfFile:filePath] mutableCopyCompletely] autorelease];
	CDLog(BTDFLAG_PlayedCount312,@"after mutableCopy");
	if (nil == records) {
		CILog(BTDFLAG_PlayedCount312,@"record not exist, create one");
		records = [NSMutableArray array];
	}
	
	BOOL isTodayExist = NO;//日期重复标记
	for (NSMutableDictionary *oneDayRecords in records) {
		NSString *theDate = oneDayRecords[KEY_STATISTICS_DATE];
		if (!theDate) {
			CELog(BTDFLAG_PlayedCount312,@"valueForKey'%@' == nil",KEY_STATISTICS_DATE);
			continue;
		}
		
		if ([[self class] isNowDateEqualsToDateString:theDate]) {//今天已经存过记录
			NSMutableArray *itemList = oneDayRecords[KEY_STATISTICS_RECORD_INFO];
			if (!itemList) {
				CELog(BTDFLAG_PlayedCount312,@"valueForKey'%@' == nil",KEY_STATISTICS_RECORD_INFO);
				continue;
			}
			
			BOOL isIdExist = NO;//故事ID重复标记
			for (NSMutableDictionary *item in itemList) {
				NSNumber *idNum = item[KEY_STATISTICS_STORYID];
				if (!idNum) {
					CELog(BTDFLAG_PlayedCount312,@"valueForKey'%@' == nil",KEY_STATISTICS_STORYID);
					continue;
				}
				if ([idNum isEqualToNumber:storyIdNumber]) {
					//发现该故事已经被记录过，count++
					NSNumber *countNum = item[KEY_STATISTICS_PLAYCOUNT];
					if (!countNum) {
						CELog(BTDFLAG_PlayedCount312,@"valueForKey'%@' == nil",KEY_STATISTICS_STORYID);
						break;
					}
					int countInt = [countNum intValue];
					if (countInt<INT32_MAX) {
						++countInt;
					}
					countNum = [NSNumber numberWithInt:countInt];
					item[KEY_STATISTICS_PLAYCOUNT] = countNum;
					isIdExist = YES;
					break;
				}
			}
			if (!isIdExist) {//故事ID不存在，追加一条
				NSDictionary *newItem = @{
					KEY_STATISTICS_STORYID : storyIdNumber,
					KEY_STATISTICS_PLAYCOUNT : @1
				};
				[itemList addObject:newItem];
			}
			isTodayExist = YES;
			break;
		}
	}
	
	if (!isTodayExist) {//今天没有存过记录，追加一条
		NSDictionary *newDateRecord = @{
			KEY_STATISTICS_DATE : [[self class] todayDateString],
			KEY_STATISTICS_RECORD_INFO : @[
				@{
					KEY_STATISTICS_STORYID : storyIdNumber,
					KEY_STATISTICS_PLAYCOUNT : @1
				}
			]
		};
		[records addObject:newDateRecord];
	}
	
	BOOL writeSuc = [records writeToFile:filePath atomically:YES];
	if (writeSuc) {
		CDLog(BTDFLAG_PlayedCount312, @"write the records to file sucessfully.");
	} else {
		CELog(BTDFLAG_PlayedCount312, @"write the records to file failed!");
	}
}

//将某一ID故事播放次数加一（不使用了 by Zero）
+(void)plusRecordCount:(NSString *)needToRecordStoryId inArray:(NSMutableArray *)array{
    NSNumber *idNumber = [NSNumber numberWithInt:[needToRecordStoryId intValue]];
    BOOL bIsExist = NO;
    
    for (int i = 0; i < [array count]; i++) {
        
        NSMutableDictionary *storyRecordDic = [array objectAtIndex:i];
        NSNumber *storyId = [storyRecordDic objectForKey:KEY_STATISTICS_STORYID];
        int a = [storyId intValue];
        int b = [idNumber intValue];
        if (a == b) {
            
            NSNumber *storyPlayCount = [storyRecordDic objectForKey:KEY_STATISTICS_PLAYCOUNT];
            int counts = [storyPlayCount intValue];
            counts ++;
            [storyRecordDic setValue:[NSString stringWithFormat:@"%d",counts] forKey:KEY_STATISTICS_PLAYCOUNT];
            bIsExist = YES;
            break;
        }
    }
    
    if (!bIsExist) {
        NSMutableDictionary *storyRecordDic = [NSMutableDictionary dictionary];
        [storyRecordDic setValue:idNumber forKey:KEY_STATISTICS_STORYID];
        [storyRecordDic setValue:@1 forKey:KEY_STATISTICS_PLAYCOUNT];
        [array addObject:storyRecordDic];
    }
}

//去掉空白字符
+ (NSString *)removeWhiteSpaceInString:(NSString *)string {
	NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
	NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
	
	NSArray *parts = [string componentsSeparatedByCharactersInSet:whitespaces];
	NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
	NSString *newString = [filteredArray componentsJoinedByString:@""];
	
	return newString;
}

//检查是否是非wifi网路，并且是开关开启
+(BOOL)checkIsWifiDownload{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN &&
        [BTUserDefaults boolForKey:USERDAUFLT_SWITCH_STATUS_WIFI_ONLY]) {
         return YES;
     }else{
         return NO;
     }
}

//创建UIImageView
+(UIImageView *)createImageView:(NSString *)filename withFrame:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:filename];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imageView.frame = rect;
    return imageView;
}

+(UIButton *)creatNomarlButton:(CGRect)frame withFileName:(NSString *)imageName addTarget:(id)target action:(SEL)action
{
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame = frame;
    [Button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    Button.backgroundColor = [UIColor clearColor];
    [Button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return Button;
}

//创建UIButton(有选中效果的)
+(UIButton *)creatImageSelectedButton:(CGRect)frame withFileName:(NSString *)imageName addTarget:(id)target action:(SEL)action
{    
    UIButton *imageButton = [[[UIButton alloc] initWithFrame:frame] autorelease]; 
    NSString *normal = [imageName stringByAppendingString:@".png"];
    [imageButton setBackgroundImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    NSString *selected = [imageName stringByAppendingString:@"Selected.png"];
    [imageButton setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateHighlighted];
    [imageButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return imageButton;
}

//添加“do not backup”的文件属性
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

//创建Label
+(UILabel *)createLabel:(NSString *)text withFrame:(CGRect)frame
{
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.text = text;
    label.font = [UIFont boldSystemFontOfSize:12];
	label.textAlignment = UITextAlignmentLeft;
	return label;
}

//通过传入路径读取对应PList信息
+ (id) readPlistFileWithPath:(NSString*)fileName plistType:(PlistType)plistType 
{
    
    NSString *plistFileName = [NSString stringWithFormat:@"%@.plist",fileName];
    NSString *absolutePath = [BTUtilityClass fileWithPath:plistFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:absolutePath]) {
        switch (plistType) {
            case PLISTTYPE_DICTIONARY:
                return [NSMutableDictionary dictionaryWithContentsOfFile:absolutePath];
                break;
            case PLISTTYPE_ARRAY:
                return [NSMutableArray arrayWithContentsOfFile:absolutePath];
                break;
            case PLISTTYPE_DATA:
                return [NSMutableData dataWithContentsOfFile:absolutePath];
                break;
            default:
                break;
        }
    }
    
    return nil;
}

+ (NSString *)getUrlWithDomain:(NSString *)domain encryptionString:(NSString *)encry resourceId:(NSString *)resourceName{
    NSString *result = nil;
    if (domain && encry && resourceName) {
        result = [NSString stringWithFormat:@"%@%@/%@/%@",@"http://",domain,[self urlDecryption:encry],resourceName];
    }
	return result;
}

//从解密的字符串中获取不包含domain和故事Id的加密字符串
+(NSString *)getEncryptStringFromDecryptString:(NSString *)inputString withDomain:(NSString *)domain andResourceName:(NSString *)res {
    

    NSString *encryptString = nil;
    encryptString = [inputString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    encryptString = [encryptString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",domain] withString:@""];
    encryptString = [encryptString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",res] withString:@""];

    return encryptString;
}

+(NSString *)urlDecryption:(NSString *)url{
	char szTmpBuf[512] ={0};
	char *urlBuf;
	char result[512] = {0};
	//	char *a = malloc(sizeof(char)*512)
	urlBuf = (char *)[url cStringUsingEncoding:NSASCIIStringEncoding];
    
	int iLoopCnt = strlen(urlBuf)/7;
	int iTailCnt = strlen(urlBuf)%7;
	
	for (int i = 0; i<iLoopCnt; i++) {
		for (int j = 0 ; j<7; j++) {
			szTmpBuf[7*i+j]=urlBuf[7*i+6-j];
		}
	}
	for (int k=0; k<iTailCnt; k++) {
		szTmpBuf[7*iLoopCnt+k] = urlBuf[7*iLoopCnt+k];
	}
	iLoopCnt = strlen(urlBuf)/3;
	iTailCnt = strlen(urlBuf)%3;
	
	for (int k=0;k<iLoopCnt;k++)
	{
		result[3*k] = szTmpBuf[3*k+1];
		result[3*k+1] = szTmpBuf[3*k+2];
		result[3*k+2] = szTmpBuf[3*k];
	}
	for (int k=0;k<iTailCnt;k++)
	{
		result[3*iLoopCnt+k]=szTmpBuf[3*iLoopCnt+k];
	}
    
	return [NSString stringWithCString:result encoding:NSASCIIStringEncoding];
}

//设置更多TabBar上的标示
+(void)setTabBarBadgeText:(NSString *)string {
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_BADGE_TO_TABBAR object:string userInfo:[NSDictionary dictionaryWithObject:@"3" forKey:@"index"]];
}

//设置新状态的数量提示
+(void)setTabBarBadgeNumber:(int)number{
    int value = 0;
    NSNumber *badgeValue = [BTUserDefaults valueForKey:TABBAR_BADGE_VALUE];
    if (badgeValue == nil) {
        [BTUserDefaults setInteger:number forKey:TABBAR_BADGE_VALUE];
        value = number;
    }else{
        value = [badgeValue intValue] + number;
    }
    
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_BADGE_TO_TABBAR object:[NSString stringWithFormat:@"%d",value] userInfo:[NSDictionary dictionaryWithObject:@"2" forKey:@"index"]];
    
    [BTUserDefaults setInteger:value forKey:TABBAR_BADGE_VALUE];
}

+(float)getFreeDiskspace {
	float totalFreeSpace = 0.0f;
	NSError *error = nil;  
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];  
	
	if (dictionary) {  
		NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
		totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
	} 
	return totalFreeSpace;
}

/*  
 *功能：获取设备类型  
 *  
 *  AppleTV2,1    AppleTV(2G)  
 *  i386          simulator  
 *  
 *  iPod1,1       iPodTouch(1G)  
 *  iPod2,1       iPodTouch(2G)  
 *  iPod3,1       iPodTouch(3G)  
 *  iPod4,1       iPodTouch(4G)  
 *  
 *  iPhone1,1     iPhone  
 *  iPhone1,2     iPhone 3G  
 *  iPhone2,1     iPhone 3GS  
 *  
 *  iPhone3,1     iPhone 4  
 *  iPhone3,3     iPhone4 CDMA版(iPhone4(vz))  
 
 *  iPhone4,1     iPhone 4S  
 *  
 *  iPad1,1       iPad  
 *  iPad2,1       iPad2 Wifi版  
 *  iPad2,2       iPad2 GSM3G版  
 *  iPad2,3       iPad2 CDMA3G版  
 *  @return null  
 */  
+ (NSString *)getDeviceVersion{   
    struct utsname systemInfo;   
    uname(&systemInfo);   
    //get the device model and the system version   
    NSString *machine =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];    
    return machine;   
}



+ (int)getInternalBundleVersion{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSDictionary *infoDic = [mainBundle infoDictionary];
    NSNumber *internalVersion = [infoDic numberForKey:@"Internal Bundle version"];
    if(internalVersion){
        return [internalVersion integerValue];
    }else{
        return -1;
    }
}


+(NSString *)getBundleVersion{
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSDictionary *infoDictionary = [mainBundle infoDictionary];
	NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    //rdm平台构件dailybuild包时可能在版本号后添加内容导致问题
#ifdef TARGET_DAILYBUILD
    {
        NSArray *verNumbers = [appVersion componentsSeparatedByString:@"."];
        if ([verNumbers count] > 2) {
            NSString *thirdVerNumber = [verNumbers objectAtIndex:2];
            if ([thirdVerNumber intValue] != 0) {
                appVersion = [NSString stringWithFormat:@"%@.%@.%@",[verNumbers objectAtIndex:0],[verNumbers objectAtIndex:1],[verNumbers objectAtIndex:2]];
            }else {
                appVersion = [NSString stringWithFormat:@"%@.%@",[verNumbers objectAtIndex:0],[verNumbers objectAtIndex:1]];
            }
        }
    }
#endif
    
	return appVersion;
}
+(NSString *)changToTimeFormatWithString:(int)seconds{
	int minute = seconds/60;
    int second = seconds%60;
	NSString *time = [NSString stringWithFormat:@"%02d:%02d",minute,second];
	return	 time;
}
+(BOOL) writeDataToPlistFile:(id)data withFileName:(NSString*)fileName
{
    BOOL ret = NO;
    NSString *plistFileName = [NSString stringWithFormat:@"%@.plist",fileName];
    NSString *absolutePath = [BTUtilityClass fileWithPath:plistFileName];
    
    if (data) {
        ret = [BTUtilityClass writeToFile:absolutePath withObject:data];
    }    
    return ret;
}
+ (BOOL)writeToFile:(NSString*)path withObject:(id)object
{
    BOOL ret = NO;
    ret = [object writeToFile:path atomically:YES];
    //    if (ret) {
    //        [BTUtilityClass addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    //    }
    return ret;
}
//判断某故事是否为新
+(BOOL)isNewStory:(NSString *)storyId stamp:(int)stamp{
    
    NSString *coverPlist = [NSString stringWithFormat:@"babyStory/%@",NEWFLAG_PLIST_NAME];
    NSString *arrFilePath =[DOCUMENTS_DIRECTORY stringByAppendingPathComponent:coverPlist];
    NSMutableArray *hasReadStoryArr =  [NSMutableArray arrayWithContentsOfFile:arrFilePath];
    int idIntValue = [storyId intValue];
    for (NSNumber *num in hasReadStoryArr) {
        if ([num intValue] == idIntValue) {
            //DLog(@"表里已经有这个故事了: %@", storyId);
            return NO;
        }
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id check = [ud objectForKey:CREATESTAMP];
    if (check != nil) {
        int createTime = [[ud objectForKey:CREATESTAMP] intValue];
        if (createTime > stamp) {
            //DLog(@"%@: %d, %d",storyId,createTime,stamp);
            return NO;
        }
    }

    return YES;
}
+(void)setStoryIsOld:(NSString *)storyId {
    NSString *coverPlist = [NSString stringWithFormat:@"babyStory/%@",NEWFLAG_PLIST_NAME];
    NSString *arrFilePath =[DOCUMENTS_DIRECTORY stringByAppendingPathComponent:coverPlist];
    NSMutableArray *hasReadStoryArr =  [NSMutableArray arrayWithContentsOfFile:arrFilePath];
    BOOL needAdd = YES;

    int idIntValue = [storyId intValue];
    for (NSNumber *nums in hasReadStoryArr) {
        if ([nums intValue] == idIntValue) {
            needAdd = NO;
            break;
        }
    }
    if (needAdd) {
        NSNumber *num = [NSNumber numberWithInt:idIntValue];
        [hasReadStoryArr addObject:num];
        [self writeDataToPlistFile:hasReadStoryArr withFileName:@"hasReadStory"];
    }

}

+(BOOL)isNewBook:(NSString *)bookId{
    NSMutableDictionary *localDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME]];
    NSNumber *num = [[localDic objectForKey:bookId] objectForKey:KEY_BOOK_SHOWNEWFLAG];
    [localDic release];
    return [num boolValue];
}

+(void)setBookIsOld:(NSString *)bookId {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME] ];
    [[dic objectForKey:[NSString stringWithFormat:@"%@",bookId]] setValue:[NSNumber numberWithBool:NO] forKey:KEY_BOOK_SHOWNEWFLAG];
    [dic writeToFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME] atomically:YES];
}

//判断ios版本采用不同的json解析方式
+ (NSDictionary *)jsonParser:(NSData *)data{
    
    NSDictionary *parserDic = nil;
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 5.0) {
        
        //系统的解析方法，解析失败返回nil
        parserDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        // DLog(@"NSJSONSerialization Parser jsonDic = %@",parserDic);
    }else{
        //此处解析失败也会返回nil，在外层判断是否为空就ok
        parserDic = [data objectFromJSONData];
        //DLog(@"JSONDecoder Parser jsonDic = %@",parserDic);
    }
    if (![parserDic isKindOfClass:[NSDictionary class]]) {//解析结果不是字典，认为解析失败
		parserDic = nil;
	}
    return parserDic;
}

+ (NSString *)cfUUIDfromKeyChain {
    NSString *str;
#ifdef TARGET_DAILYBUILD
    {
        str=[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        if (!str || [str isEqualToString:@""]) {
            //generate the UUID
            NSString *uuidString=[BTPublicFunctions generateUuidString];
            if (uuidString && uuidString.length) {
                [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:@"uuid"];
                str=[NSString stringWithString:uuidString];
            }else {
//                DLog(@"fail to generate uuid string");
            }
        }
    }
#else
    {
        KeychainItemWrapper *wrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil] autorelease];
        str = [wrapper objectForKey:@"acct"];
        if(!str || str.length <= 0){
            NSString *uuidString = [BTUtilityClass generateUuidString];
            [wrapper setObject:uuidString forKey:@"acct"];
            str = [NSString stringWithString:uuidString];
        }
    }
#endif
    return str;
}

+ (NSString*)generateUuidString{
    
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString*uuidString = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // transfer ownership of the string
    // to the autorelease pool
    [uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    return uuidString;
}

//意见反馈中增加一些程序和用户的基本信息
+ (NSData *)requestPacking:(NSString*)requestName withInfo:(NSDictionary*)requestInfo
{
    NSMutableDictionary *cannon = [[[NSMutableDictionary alloc]initWithCapacity:0] autorelease];
    [cannon setObject:APP_NAME forKey:@"app_name"];
    //todo:keychain
    //[cannon setObject:[[UIDevice currentDevice]uniqueIdentifier] forKey:@"identifier"];
    NSString *uuid = [BTUtilityClass cfUUIDfromKeyChain];
    [cannon setObject:uuid forKey:@"identifier"];
    [cannon setObject:[BTUtilityClass getBundleVersion] forKey:@"app_version"];
    [cannon setObject:[NSString stringWithFormat:@"%0.1f",CHECKIN_API_VERSION] forKey:@"api_version"];
    [cannon setObject:requestName forKey:@"request_name"];
    [cannon setObject:requestInfo forKey:@"request_info"];
    [cannon setObject:[NSNumber numberWithInt:DOWNLOAD_CHANNEL_FLAG] forKey:@"channel"];
    
    NSData* postData = [cannon JSONData];
    return postData;
}

+(BOOL)isPlayingStory:(NSString *)storyId {
    

    if ([[BTPlayerManager sharedInstance].playingStoryId isEqualToString:storyId]) {
        return YES;
    }
    return NO;
}

+(BOOL)isNetUrl:(NSString *)urlString {
    if ([urlString hasPrefix:@"http"]) {
        return YES;
    }
    return NO;
}
#pragma mark -
#pragma mark 设置锁屏时故事的插图和名字
+(void)setMediaInfo:(UIImage *)img andTitle:(NSString *)title andArtist:(NSString *)artist
{
    if (title == nil){
        return;
    }
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setValue:title forKey:MPMediaItemPropertyAlbumTitle];
        MPMediaItemArtwork * mArt = nil;
        if (img) {
            mArt = [[MPMediaItemArtwork alloc] initWithImage:img];
            
        }
        [dict setValue:mArt forKey:MPMediaItemPropertyArtwork];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        [dict release];
        [mArt release];
    }
}
+ (NSString *)getIdFromURL:(NSString *)urlPath{
    NSArray* childStrArr= [urlPath componentsSeparatedByString:@"/"];
    NSString *IDString = [childStrArr lastObject];
    NSRange ra = [IDString rangeOfString:@"."];
    NSRange ra2 = NSMakeRange(0, ra.location);
    NSString *ID = [IDString substringWithRange:ra2];
    return ID;
}

+(void)configeMaxLocalStoriesCount{
    //若没有值，则赋初始值
	NSNumber *numMaxLocal = [BTUserDefaults valueForKey:CONFIGURATION_MAX_LOCAL_STORY];
	if (nil == numMaxLocal) {
		[BTUserDefaults setInteger:100
							forKey:CONFIGURATION_MAX_LOCAL_STORY];//默认为100首上限
	}
}


+(double)getCacheTotalCapacity{
    //缓存的故事大小
    double storyCache = 0.0f;
    NSArray *storiesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[BTUtilityClass getStoryCacheFolderPath] error:nil];
    for(NSString *str in storiesArray){
        NSString *fullPath = [BTUtilityClass fileWithCacheFolderPath:str] ;
        if([fullPath hasSuffix:@".mp3"]){
            NSDictionary *fileAttributeDic=[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            storyCache += fileAttributeDic.fileSize;
        }
    }
    
    
    //320的图片大小
    double picCache = 0.0f;
    NSArray *picsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:THREE20_DIRECTORY error:nil];
    for(NSString *str in picsArray){
        BOOL isDic = NO;
        NSString *fullPath = [THREE20_DIRECTORY stringByAppendingPathComponent:str];
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDic];
        if(!isDic&&![fullPath hasSuffix:@"_banner"]){
            NSDictionary *fileAttributeDic=[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            picCache += fileAttributeDic.fileSize;
        }
    }
    return picCache+storyCache;
}

+ (NSString *)changToDiskCapacity:(double)CapacityByMB{
    //double capacityByMB = CapacityByBytes/1024.0f/1024.0f;
    NSString *returnStr = nil;
    if(CapacityByMB <1024.0){
        returnStr = [NSString stringWithFormat:@"%.1fM",CapacityByMB];
    }else if(CapacityByMB >=1024.0){
        double capacityByGB = CapacityByMB/1024.0f;
        if(capacityByGB<=999.0){
            returnStr = [NSString stringWithFormat:@"%.1fG",capacityByGB];
        }else{
            returnStr = @"999+G";
        }
    }
    
    return returnStr;
}

+ (NSString *)getPicSuffix:(ImageType)type picVersion:(int)version{
    NSString *returnStr = nil;
    switch (type) {
        case type_banner_cell_view:
            returnStr = @"_banner";//@"_%dbanner",iD ??
            break;
        case type_home_icon:
            returnStr = @"_home";
            break;
        case type_newStory_icon:
            returnStr = @"_newStoryIcon";
            break;
        case type_collection_icon:
            returnStr = @"_collectionIcon";
            break;
        case type_age_category_icon:
            returnStr = @"_age_categoryIcon";
            break;
        case type_content_category_icon:
            returnStr = @"_content_categoryIcon";
            break;
        case type_story_icon:
            returnStr = @"_storyIcon";
            break;
        case type_story_playView:
            returnStr = @"_storyPlayView";
            break;
        case type_newStory_Intro_icon:
            returnStr = @"_newStoryIntroIcon";
            break;
        case type_Chosen_intro_icon:
            returnStr = @"_chosenIntroIcon";
            break;
        case type_radio_icon:
            returnStr = @"_radioIcon";
            break;
        case type_category_intro_icon:
            returnStr = @"_categotyIcon";
            break;
        case type_book_icon:
            returnStr = @"_bookIcon";
            break;
        case type_default:
            returnStr = @"";
            break;
        default:
            returnStr = @"";
            break;
    }
    if(version>10){
        returnStr = [NSString stringWithFormat:@"_V%d%@",version,returnStr];
    }
    
    return returnStr;
}




+ (ImageType)getTypeFromSuffix:(NSString *)aSuffix{
    ImageType type = type_default;
    if ([aSuffix hasSuffix:@"_banner"]) {
        type = type_banner_cell_view;
    }else if([aSuffix hasSuffix:@"_home"]){
        type = type_home_icon;
    }
    else if([aSuffix hasSuffix:@"_newStoryIcon"]){
        type = type_newStory_icon;
    }
    else if([aSuffix hasSuffix:@"_collectionIcon"]){
        type = type_collection_icon;
    }
    else if([aSuffix hasSuffix:@"_age_categoryIcon"]){
        type = type_age_category_icon;
    }
    else if([aSuffix hasSuffix:@"_content_categoryIcon"]){
        type = type_content_category_icon;
    }
    else if([aSuffix hasSuffix:@"_storyIcon"]){
        type = type_story_icon;
    }
    else if([aSuffix hasSuffix:@"_storyPlayView"]){
        type = type_story_playView;
    }
    else if([aSuffix hasSuffix:@"_newStoryIntroIcon"]){
        type = type_newStory_Intro_icon;
    }
    else if([aSuffix hasSuffix:@"_chosenIntroIcon"]){
        type = type_Chosen_intro_icon;
    }
    else if([aSuffix hasSuffix:@"_radioIcon"]){
        type = type_radio_icon;
    }
    else if([aSuffix hasSuffix:@"_categotyIcon"]){
        type = type_category_intro_icon;
    }
    else if([aSuffix hasSuffix:@"_bookIcon"]){
        type = type_book_icon;
    }
    return type;
}

//获取当前时间的年和月的加和，例如2012年12月  则返回201212
+ (int)getCurrentYearAndMonth{
    NSDate *nowData = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowData];
    int year = [dateComponent year];
    int month = [dateComponent month];
    return year*100+month;
}
@end
