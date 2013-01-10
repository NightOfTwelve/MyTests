//
//  BTUserDefaults.h
//  AABabyTing3
//
//  Created by Zero on 9/9/12.
//
//

#import <Foundation/Foundation.h>
#import "BTAlarmConstants.h"

@interface BTUserDefaults : NSObject{
}


@property (nonatomic) NSInteger    coverVersion;

+(id)sharedUserDefault;

//定时器
+ (EnumBTAlarmMode)alarmMode;
+ (void)setAlarmMode:(EnumBTAlarmMode)aMode;
+ (NSInteger)alarmIndex;
+ (void)setAlarmIndex:(NSInteger)anIndex;

//父母必备时间戳
+ (NSInteger)necessarySoftUpdateStamp;
+ (void)setNecessarySoftUpdateStamp:(NSInteger)stamp;

+ (NSInteger)maxLocalStory;
+ (void)setMaxLocalStory:(NSInteger)intValue;
+ (NSInteger)internalVersion;
+ (void)setInternalVersion:(NSInteger)aVersion;
+ (NSString *)internalVersionNum;
+ (void)setInternalVersionNum:(NSString *)aVersion;
+ (NSInteger)localSortIndex;
+ (void)setLocalSortIndex:(NSInteger)index;
//下面的这三个函数只有在3。4版本和在3。4升级到3.5的时候会用到。其他版本没有用到。
+ (double)saveFlow;
+ (void)setSaveFlow:(double)flow;
+ (void)removeSaveFlow;


//下面的2个方法是在3.5版本以后在存储节省流量数值时候使用，存的字典是2个值，一个是月份，一个是节省的流量。

+ (NSDictionary *)saveFlowAndDate;
+ (void)setSaveFlowAndDate:(NSDictionary *)aDic;

//以下方法不要使用，目前只是为了保证程序不crash才声明出来的，请尽快转成上面读写访问器的形式！
+ (void)setDate:(NSDate *)date forKey:(NSString *)key;
+ (void)setInteger:(NSInteger)intValue forKey:(NSString *)key;
+ (void)setBool:(BOOL)yesOrNo forKey:(NSString *)key;
+ (void)setValue:(id)value forKey:(NSString *)key;
+ (NSString *)dateForKey:(NSString *)key;
+ (NSInteger)integerForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
+ (id)valueForKey:(NSString *)key;
+ (void)deleteKey:(NSString *)key;

@end
