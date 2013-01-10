//
//  KPTeaKeyGenerator.m
//  AABabyTing3
//
//  Created by Zero on 11/5/12.
//
//

#import "KPTeaKeyGenerator.h"

void getKey(char *keys, int num[]);
NSString *getTeaKey(NSArray *arrKey);

@implementation KPTeaKeyGenerator
+ (NSString *)teaKeyOfCID {
	NSArray *teaKeyArr = @[@(0x4b505f24),@(0x255e2654),@(0x78745f2a),@(0x265e3938)];
	return getTeaKey(teaKeyArr);
}
@end

void getKey(char *keys, int num[]) {
	int and[] = {0xff000000,0x00ff0000,0x0000ff00,0x000000ff};
	//默认认为只有16位key，败忘了哈~
	for (int i=0; i<16; i++) {
		keys[i] = ((num[i/4]&and[i%4]) >> ((3-(i%4))*8))&0xff;
		//		printf("%d->%x->%c\n",i,keys[i],keys[i]);
	}
	keys[16] = '\0';
}

NSString *getTeaKey(NSArray *arrKey) {
	int keyArr[4];
	for (int i=0; i<4; i++) {
		keyArr[i] = [arrKey[i] intValue];
	}
	char keyStr[17];
	getKey(keyStr, keyArr);
	NSString *strKey = [NSString stringWithCString:keyStr encoding:NSUTF8StringEncoding];
	return strKey;
}
