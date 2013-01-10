//
//  BTUserDefaults.m
//  AABabyTing3
//
//  Created by Zero on 9/9/12.
//
//

#import "BTUserDefaults.h"
#import "BTUserDefaultsKeysDefine.h"
#import "NSDate+stringValue.h"


static BTUserDefaults *userDefault = nil;
@implementation BTUserDefaults

+ (BTUserDefaults *)sharedUserDefault{
    @synchronized (self){
        if(userDefault ==nil){
            userDefault = [[BTUserDefaults alloc] init];
        }
        return userDefault;
    }
    
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - 读写访问器（可自定义追加）

//定时器
+ (EnumBTAlarmMode)alarmMode {
	id mod = [self valueForKey:UDKEY_ALARM_MODE];
	if (mod == nil) {
		return eBTAlarmModeTiming;
	} else {
		return [mod unsignedIntegerValue];
	}
}

+ (void)setAlarmMode:(EnumBTAlarmMode)aMode {
	[self setInteger:aMode
			  forKey:UDKEY_ALARM_MODE];
}

+ (NSInteger)alarmIndex {
	id idx = [self valueForKey:UDKEY_ALARM_INDEX];
	if (idx == nil) {
		return NOT_SELECTED;
	} else {
		return [idx integerValue];
	}
	return [self integerForKey:UDKEY_ALARM_INDEX];
}

+ (void)setAlarmIndex:(NSInteger)anIndex {
	[self setInteger:anIndex
			  forKey:UDKEY_ALARM_INDEX];
}

//父母必备时间戳
+ (NSInteger)necessarySoftUpdateStamp {
	return [self integerForKey:USERDAUFLT_NECESSARY_SOFT_UPDATE_STAMP];
}
+ (void)setNecessarySoftUpdateStamp:(NSInteger)stamp {
	[self setInteger:stamp forKey:USERDAUFLT_NECESSARY_SOFT_UPDATE_STAMP];
}

//节省流量
+ (void)removeSaveFlow{
    [[self class] deleteKey:UDKEY_SaveFlow_NUM];
}


+ (double)saveFlow{
    NSString *numStr = [self valueForKey:UDKEY_SaveFlow_NUM];
    double num = [numStr doubleValue];
    return num;
}

+ (void)setSaveFlow:(double)flow{
    [[self class] setDouble:flow forKey:UDKEY_SaveFlow_NUM];
}

//节省流量+月份
+ (void)setSaveFlowAndDate:(NSDictionary *)aDic{
    [[self class] setValue:aDic forKey:UDKEY_SAVEFLOW_ANDDATE_NUM];
}

+ (NSDictionary *)saveFlowAndDate{
    NSDictionary *dic = [self valueForKey:UDKEY_SAVEFLOW_ANDDATE_NUM];
    return dic;
}


//本地故事上限
+ (NSInteger)maxLocalStory {
	return [self integerForKey:UDKEY_CONFIGURATION_MAX_LOCAL_STORY];
}
+ (void)setMaxLocalStory:(NSInteger)intValue {
	[self setInteger:intValue forKey:UDKEY_CONFIGURATION_MAX_LOCAL_STORY];
}


//版本升级
+ (NSInteger)internalVersion {
    return [self integerForKey:UDKEY_VERSION];
}
+ (void)setInternalVersion:(NSInteger)aVersion{
    [self setInteger:aVersion forKey:UDKEY_VERSION];
}


//老的判断的版本升级

+ (NSString *)internalVersionNum{
    return [self stringForKey:UDKEY_VERSION_NUM];
}
+ (void)setInternalVersionNum:(NSString *)aVersion{
    [self setValue:aVersion forKey:UDKEY_VERSION_NUM];
}


//版本升级属性版本
- (void)setCoverVersion:(NSInteger)CoverVersion{
    [BTUserDefaults setInternalVersion:CoverVersion];
}

- (NSInteger)coverVersion{
   return [BTUserDefaults internalVersion];
}

//本地故事排序类型
+ (NSInteger)localSortIndex{
    return [self integerForKey:UDKEY_LOCAL_SORT_INDEX];
}

+ (void)setLocalSortIndex:(NSInteger)index{
    [self setInteger:index forKey:UDKEY_LOCAL_SORT_INDEX];
}

#pragma mark - 基础方法（私有）
//set Date
+ (void)setDate:(NSDate *)date forKey:(NSString *)key {
	[self setValue:[date stringValue] forKey:key];
}

//set Integer
+ (void)setInteger:(NSInteger)intValue forKey:(NSString *)key {
	[self setValue:[NSNumber numberWithInteger:intValue] forKey:key];
}

//set Boolean
+ (void)setBool:(BOOL)yesOrNo forKey:(NSString *)key {
	[self setValue:[NSNumber numberWithBool:yesOrNo] forKey:key];
}

//写值（空值不写入，想删除键值，请显式调用deleteKey:）
+ (void)setValue:(id)value forKey:(NSString *)key {
	if (nil == value) {
		return;
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:value forKey:key];
	[defaults synchronize];//立刻保存到UserDefaults（写文件）
}

+ (void)setDouble:(double)value forKey:(NSString *)key{
    if(0 == value){
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setDouble:value forKey:key];
	[defaults synchronize];
}

//set String
+ (void)setString:(NSString *)str forKey:(NSString *)key {
	[self setValue:str forKey:key];
}

//get Date（返回日期字符串，如：@"2012-10-31"）
+ (NSString *)dateForKey:(NSString *)key {
	return [self valueForKey:key];
}

//get Integer
+ (NSInteger)integerForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

//get Boolean
+ (BOOL)boolForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


//get  Str

+ (NSString *)stringForKey:(NSString *)aKey{
    return [[NSUserDefaults standardUserDefaults] stringForKey:aKey];
}

//取值
+ (id)valueForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

//删除键值对
+ (void)deleteKey:(NSString *)key {
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	[ud removeObjectForKey:key];
	[ud synchronize];
}

@end

