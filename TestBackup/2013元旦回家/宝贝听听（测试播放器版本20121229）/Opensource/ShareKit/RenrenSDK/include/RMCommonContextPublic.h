//
//  RMCommonContextPrivate.h
//  RMSDK
//
//  Created by renren-inc on 12-2-13.
//  Copyright (c) 2012年 人人网. All rights reserved.
//
/**
 * 返回RMCommonContext对象
 */
#import <Foundation/Foundation.h>
#import "RMObject.h"
#import "RMError.h"

@protocol RMRequestContextDelegate;

@interface RMCommonContext : NSObject {
    
@public
    RMResponse *contextResponse;//接口返回的数据响应对象
    
@protected
    NSData *_responseData; 
    id _objectParsedFromJsonString;

}
@property(nonatomic ,assign) id<RMRequestContextDelegate>delegate;

/**
 *zh
 * 返回一个RMCommonContext对象，delegate要是实现协议RMRequestContextDelegate
 *
 *en
 *
 */
+ (id)contextWithDelegate:(id<RMRequestContextDelegate>)delegate;

/**
 *zh
 * 发送一个同步的通用接口请求
 * @param paramDict:按照人人移动开放平台接口文档要求构建的请求参数字典对象
 * @param *error:接收说明发送请求失败的的错误对象
 * @return 发送请求是否成功，YES:表示成功，NO:表示失败
 *
 *en
 */
- (BOOL)sendSynchronousRequestWithParameterDictionary:(NSDictionary *)paramDict withError:(RMError **)error;
/**
 *zh
 * 发送一个异步的通用接口请求，请自行实现@protocol RMRequestContextDelegate的回调,了解请求过程
 * @param paramDict:按照人人移动开放平台接口文档要求构建的请求参数字典对象
 *  
 *en
 */
- (void)sendAsynchronousRequestWithParameterDictionary: (NSDictionary *)paramDict;

/**
 *zh
 * 用于获得请求返回的响应数据结果，请确认在请求成功结束时调用此方法，以获此次请求正确的响应数据
 *  
 *en
 */
- (RMResponse *)getContextResponse;
@end
