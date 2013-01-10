//
//  RMObject.h
//  RMSDK
//
//  Created by Renren-inc on 11-10-8.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
/**
 *zh
 * RMObject特指由RenrenMobile接口返回的数据对象父类           
 *
 *en
 * RMObject represent parent class of data object returned by RenrenMobile interface
 */
#import <Foundation/Foundation.h>

/**
 *zh
 * RMObject特指由RenrenMobile接口返回的数据对象父类           
 *
 *en
 * RMObject represent parent class of data object returned by RenrenMobile interface
 */
@interface RMObject :  NSObject{
    NSDictionary* _responseDictionary;
}

@end

//人人的数据对象基类        base class of renren data object
/**
 *人人数据对象基类
 */
@interface RMItem : RMObject 

@end

//人人的接口响应对象基类     base class of renren interface responser object
/**
 *人人接口响应对象基类
 */
@interface RMResponse : RMObject 

/**
 * 表示对应的json字典对象。 
 */
-(NSDictionary*)responseDictionary;
@end
