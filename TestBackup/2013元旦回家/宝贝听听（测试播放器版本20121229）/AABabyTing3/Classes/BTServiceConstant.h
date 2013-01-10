//
//  BTServiceConstant.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-13.
//
//

#import <Foundation/Foundation.h>


#define TIME_OUT_SECONDS                                8 //超时时间
#define RETRY_COUNTS                                    2 //重发次数


//json解析常量
#define JSON_NAME_RET                                   @"ret"
#define JSON_NAME_RESPONSE                              @"response"



//通知常量
#define HOME_REQUEST_NOTIFICATION_CID						@"301"
#define CONFIGURATION_REQUEST_NOTIFICATION_CID				@"302"
#define CATEGORY_REQUEST_NOTIFICATION_CID					@"303"
#define ONECATEGORY_BOOKLIST_REQUSET_NOTIFICATION_CID       @"304"
#define ONEBOOK_STORYLIST_REQUEST_NOTIFICATION_CID          @"305"
#define RADIOLIST_REQUEST_NOTIFICATION_CID                  @"306"
#define ONERADIO_STORYLIST_REQUEST_NOTIFICATION_CID         @"307"
#define NEWEST_SOTRYLIST_REQUEST_NOTIFICATION_CID           @"308"
#define HOTEST_SOTRYLIST_REQUEST_NOTIFICATION_CID           @"309"
#define COLLECTION_REQUEST_NOTIFICATION_CID                 @"310"
#define ONECOLLECTION_STORYLIST_REQUEST_NOTIFICATION_CID    @"311"
#define PLAYTIMES_UPLOAD_REQUEST_NOTIFICATION_CID           @"312"
#define PUSHTOKEN_UPLOAD_REQUEST_NOTIFICATION_CID           @"313"
#define STORYINFO_REQUEST_NOTIFICATION_CID                  @"315"
#define RESOURCE_CHANGE_REQUEST_NOTIFICATION_CID            @"316"
#define ONE_BOOK_LIST_HEADER_REQUEST_NOTIFICATION_CID       @"317"
#define ONE_CHOOSEN_LIST_HEADER_REQUEST_NOTIFICATION_CID    @"318"
#define NEWEST_STORY_HEADER_NOTIFICATION_CID                @"319"
#define SEARCH_STORY_NOTIFICATION_CID                       @"320"
#define BANNER_IMAGE_REQUEST_NOTIFICATION_CID				@"banner_image_download_finish"
#define FEEDBACK_REQUEST_FINISH_NOTIFICATION				@"feedback_request_finish"
#define LOCAL_STROIES_COUNT_FINISH_NOTIFICATION				@"local_stories_count_finish"
#define STORY_DOWNLOADED_COUNT_FINISH_NOTIFICATION			@"story_downloaded_count_finish"
#define GIFT_EGGS_NOTIFICATION								@"gift_eggs"					//砸蛋

//checkin常量
#define CHECKIN_REQUEST_NOTIFICATION                    @"checkin_request_notification"
#define DOWNLOAD_SPLASH_NOTIFICATION					@"download_splash_notification"
#define DOWNLOAD_BANNER_NOTIFICATION

#define CHECKIN_REQUEST_DEVICE_SYSTEM_NAME              @"system_name"      //设备系统名字
#define CHECKIN_REQUEST_DEVICE_SYSTEM_VERSION           @"system_version"   //设备系统版本
#define CHECKIN_REQUEST_DEVICE_MODEL                    @"model"            //设备模式
#define CHECKIN_REQUEST_DEVICE_LOCALIZED_MODEL          @"localized_model"  //设备本地化模式
#define CHECKIN_REQUEST_DEVICE_SCREEN_WIDTH             @"screen_width"     //设备屏幕宽
#define CHECKIN_REQUEST_DEVICE_SCREEN_HEIGHT            @"screen_height"    //设备屏幕高
#define CHECKIN_REQUEST_DEVICE_INFO                     @"device_info"      //设备信息
#define CHECKIN_REQUEST_STATISTICS                      @"Statistics"       //统计数据
#define CHECKIN_REQUEST_LAST_UPDATE_DATE                @"last_update_date" //上次更新时间

#define CHECKIN_RESPONSE_INFO                           @"response_info"    //总返回信息
#define CHECKIN_RESPONSE_POPULARIZE                     @"popularize"       //运营位信息
#define CHECKIN_RESPONSE_RECOMMEND                      @"recommend"        //微博活动
#define CHECKIN_RESPONSE_SPLASH                         @"splash"           //闪屏信息
#define CHECKIN_RESPONSE_UPDATE_TYPE                    @"update_type"      //更新类型
#define CHECKIN_RESPONSE_UPDATE_URL                     @"url"              //更新下载地址
#define CHECKIN_RESPONSE_NECESSARY_SOFT                 @"recommend_url"    //父母必备软件html信息
#define CHECKIN_RESPONSE_NECESSARY_SOFT_CREATE_TIME     @"createTime"       //父母必备软件时间戳
#define CHECKIN_RESPONSE_NECESSARY_SOFT_UPDATE_URL      @"recommend_url"    //父母必备软件更新地址
//token上报313常量
#define PUSH_TOKEN_UPLOAD								@"token"

//json key
#define REQUEST_JSON_KEY_



#define ERROR_CODE_ALREADY_EXIST						-4		//请求已存在


//Popularize Error Code
#define POPULARIZE_ERROR_CODE_ID_NOT_FOUND				1904	//没有这个“活动”（活动、运营位、砸蛋）

//意见反馈的错误
#define FEEDBACK_ERROR_DOMAIN							@"com.21kunpeng.feedback"

//砸蛋请求的错误
#define GIFT_EGGS_ERROR_DOMAIN							@"com.21kunpeng.giftEggs"
#define GIFT_EGGS_ERROR_CODE							1905

//下载图片的错误
#define DOWNLOAD_PIC_ERROR_DOMAIN                       @"com.21kunpeng.picDown"
#define DOWNLOAD_PIC_ERROR_CODE                         402

//notification
#define NOTIFICATION_ERROR                              @"kError"
#define NOTIFICATION_ROOTDOC                            @"rootDoc"
#define NOTIFICATION_PICDATA                            @"picData"



//分页请求的个数
#define pageRequestCount                     20

