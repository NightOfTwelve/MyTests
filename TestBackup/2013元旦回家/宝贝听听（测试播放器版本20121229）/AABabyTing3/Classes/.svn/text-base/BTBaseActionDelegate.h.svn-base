//
//  BTBaseActionDelegate.h
//  AABabyTing3
//
//  Created by Zero on 11/2/12.
//
//

#import <Foundation/Foundation.h>

@class BTBaseAction;
@protocol BTBaseActionDelegate <NSObject>
/*
 NSError的userInfo属性包括两个Key
 kAlertType:Controller根据这个类型来显示提示框的类型，或者不显示
 kErrorMsg:错误的文字描述，面向的，用户友好的
 */
- (void)onAction:(BTBaseAction*) action withError:(NSError*)error;
- (void)onAction:(BTBaseAction*) action withData:(id) data;

@end