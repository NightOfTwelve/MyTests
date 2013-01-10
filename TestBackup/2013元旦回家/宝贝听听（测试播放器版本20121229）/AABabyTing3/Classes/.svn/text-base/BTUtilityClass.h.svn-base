
typedef enum 
{
    PLISTTYPE_DICTIONARY,
    PLISTTYPE_ARRAY,
    PLISTTYPE_DATA,
} PlistType;
#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"
#import "BTUserDefaults.h"//UserDefaults相关方法，请进入查看

@interface BTUtilityClass : NSObject

//Documents/babyStory目录
+ (NSString *)getStoryCacheFolderPath;
//Documents/cacheFolder目录
+ (NSString *)getBabyStoryFolderPath;
//返回cacheFolder目录下文件的路径
+ (NSString *)fileWithCacheFolderPath:(NSString *)fileName;
//返回babyStory目录下文件的路径
+ (NSString *)fileWithPath:(NSString *)fileName;

+ (NSString *)todayDateString;

+ (BOOL)isNetWifi;

+ (BOOL)isNet3G;

+ (BOOL)isNetWorkNotAvailable;

+ (BOOL)isNowDateEqualsToDateString:(NSString *)oldDateStr;

+ (BOOL)isDate:(NSDate *)newDate equalsToDateString:(NSString *)oldDateStr;

+(double)nowTimeDouble;

//+(NSString *)getPopularizFolderPath;

//+(NSString *)fileAbsolutePathWithPopulariz:(NSString *)fileName;

+(void)recordStoryPlayCount:(NSString *)needToRecordStoryId;

//+(NSString *)fileAbsolutePathWithBabyStory:(NSString *)fileName;

+(NSString *)removeWhiteSpaceInString:(NSString *)string;

+(BOOL)checkIsWifiDownload;

+(UIImageView *)createImageView:(NSString *)filename withFrame:(CGRect)rect;

+(UIButton *)creatNomarlButton:(CGRect)frame withFileName:(NSString *)imageName addTarget:(id)target action:(SEL)action;

+(UIButton *)creatImageSelectedButton:(CGRect)frame withFileName:(NSString *)imageName addTarget:(id)target action:(SEL)action;

+(UILabel *)createLabel:(NSString *)text withFrame:(CGRect)frame;

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+(NSString *)getDeviceVersion; 

//设置新状态的数量提示
+(void)setTabBarBadgeNumber:(int)number;

+(void)setTabBarBadgeText:(NSString *)string;
//获取剩余存储空间信息
+(float)getFreeDiskspace;

//通过传入文件名读取对应PList信息
+(BOOL) writeDataToPlistFile:(id)data withFileName:(NSString*)fileName;
+(BOOL)writeToFile:(NSString*)path withObject:(id)object;
+(id) readPlistFileWithPath:(NSString*)fileName plistType:(PlistType)plistType;
+(NSString*)getUrlWithDomain:(NSString *)domain encryptionString:(NSString *)encry resourceId:(NSString *)resourceName;
+(NSString *)getEncryptStringFromDecryptString:(NSString *)inputString withDomain:(NSString *)domain andResourceName:(NSString *)res;
+(NSString *)urlDecryption:(NSString *)url;

+(int)getInternalBundleVersion;

+(NSString *)getBundleVersion;
//根据秒数获取时间格式
+(NSString *)changToTimeFormatWithString:(int)seconds;

+(BOOL)isNewStory:(NSString *)storyId stamp:(int)stamp;

+(void)setStoryIsOld:(NSString *)storyId;

+(BOOL)isNewBook:(NSString *)bookId;

+(void)setBookIsOld:(NSString *)bookId;

+(NSDictionary *)jsonParser:(NSData *)data;

+(NSString *)cfUUIDfromKeyChain;
+(NSString*)generateUuidString;
+(NSData *)requestPacking:(NSString*)requestName withInfo:(NSDictionary*)requestInfo;
+(BOOL)isPlayingStory:(NSString *)storyId;
+(BOOL)isNetUrl:(NSString *)urlString;
+ (NSString *)getIdFromURL:(NSString *)urlPath;
+(void)setMediaInfo:(UIImage *)img andTitle:(NSString *)title andArtist:(NSString *)artist;
//再没有获取到最大下载数量的时候，设置默认值为100
+(void)configeMaxLocalStoriesCount;

+(double)getCacheTotalCapacity;

+ (NSString *)changToDiskCapacity:(double)CapacityByMB;


+ (NSString *)getPicSuffix:(ImageType)type picVersion:(int)version;

+ (ImageType)getTypeFromSuffix:(NSString *)aSuffix;


//获取当前时间的年和月的加和，例如2012年12月  则返回201212
+ (int)getCurrentYearAndMonth;
@end
