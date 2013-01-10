//
//  ZeroCategories.h
//  ZeroCategory
//
//  Created by Zero on 11/13/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

//扫描与遍历视图层次结构
@interface UIView (PrintSubviews)
- (void)printSubviews;
@end

//创建URL方法扩展
@interface NSURL (urlWithStringFormat)
+ (NSURL *)URLWithStringFormat:(NSString *)format, ...;
@end

//获取屏幕分辨率
@interface UIScreen(pixel)
- (CGSize)pixel;
@end

@interface NSData(UTF8String)
- (NSString *)UTF8String;
@end

