//
//  DeskHttpRequest.h
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"



typedef NS_ENUM(NSUInteger, PostDataStyle) {
    
    PostDataStyleKeyValue,  //password=111111&device_id=ylm
    
    PostDataStyleJson,
    
    PostDataStyleJsonData,
    PostDataStyleDictionary,
    
};

#define DEFAULT_PAGESIZE 20 //默认分页数量

/**
 请求完成处理
 */
typedef void (^Complete)();

/**
 请求失败处理
 */
typedef void (^Failed)(NSString *state,NSString *errmsg);

/**
 数据请求模型的基类，包含基本网络请求
 */
@interface DeskHttpRequest : NSObject{
    
@protected
    
    Complete _complete; //请求完成
    Failed   _failed;   //请求失败
}


//HTTP参数设置
@property(nonatomic,strong)NSString         *baseUrl;       //API基础地址
@property(nonatomic,strong)NSString         *host;          //代理主机IP地址
@property(nonatomic,assign)NSInteger        port;           //代理主机端口

@property(nonatomic,strong)NSString         *errCode;       //错误代码
@property(nonatomic,strong)NSString         *errMsg;        //错误描述
@property(nonatomic,strong)NSString         *version;       //协议版本(客户端兼容最小版本)

- (id)initWithDelegate:(id)delegate;
/**
 * 发送get请求
 */
- (void)startGet:(NSString*)url tag:(NSString *)tag;

/**
 * 外部添加头部
 */

- (void)addHeaderKey:(NSString*)key Value:(NSString*)value;

/**
 * 发送getCache请求
 */
- (void)startCache:(NSString *)aCacheName cacheTime:(NSInteger)aTime uri:(NSString *)uri tag:(NSString *)tag;

/**
 * 发送post请求
 */
- (void)startPost:(NSString*)url params:(NSDictionary*)dit tag:(NSString *)tag postType:(PostDataStyle) type;

/**
 * 上传文件
 */
- (void)uploadFileURI:(NSString*)aUri filePath:(NSString*)aPath keyName:(NSString *)aKeyName;

/**
 * 取消请求
 */
- (void)cancel;

@end


#pragma mark delegate
@protocol DeskHttpRequestDelegate <NSObject>
@optional
/**
 请求完成时-调用
 */
-(void)getFinished:(NSDictionary *)msg tag:(NSString *)tag;

/**
 请求失败时-调用
 */
-(void)getError:(NSDictionary *)msg tag:(NSString *)tag;

@end
