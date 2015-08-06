//
//  DeskHttpRequest.m
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//



#import "DeskHttpRequest.h"
#import "AFNetworking.h"




Class object_getClass(id object);

@interface DeskHttpRequest()
{
    Class afOrinClass;
}

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager; //AF请求对象
@property(nonatomic,weak)id<DeskHttpRequestDelegate> delegate;
@end

@implementation DeskHttpRequest

#pragma mark initData
- (id)initWithDelegate:(id)delegate
{
    if ((self = [super init])) {
        afOrinClass = object_getClass(delegate);
        [self setDelegate:delegate];
           [self httpInit];
    }
    
    return self;
}




#pragma mark httpMode
/**
 * 初始化HTTP
 */
- (void)httpInit
{
    //应用配置文件
    self.manager = [AFHTTPRequestOperationManager manager];
    
    //申明返回的结果是JSON类型
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
//        self.manager.responseSerializer.acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-www-form-urlencode"];
  
    self.manager.responseSerializer.acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    
    //清求时间设置

     self.manager.requestSerializer.timeoutInterval = 30;
    
    
    //添加header头信息
    [self addRequestHeader];
}

/**
 * 添加header头信息
 */
- (void)addRequestHeader
{

        [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"IF-VERSION"];
   
}


- (void)addHeaderKey:(NSString*)key Value:(NSString*)value
{
    
    [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    
}

/**
 * 发送get请求
 */
- (void)startGet:(NSString*)uri tag:(NSString *)tag
{
 
    
    [self.manager GET:uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self requestFinished:responseObject tag:tag];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self requestFailed:tag error:error];
    }];
    
    

 

}

- (AFHTTPRequestOperation *)cacheOperationWithRequest:(NSURLRequest *)urlRequest
                                                  tag:(NSString *)tag
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [self.manager HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:urlRequest];
        cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:operation.response data:operation.responseData userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
        [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:urlRequest];
        
        success(operation,responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error.code == kCFURLErrorNotConnectedToInternet) {
            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:urlRequest];
            if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
                success(operation, cachedResponse.data);
            } else {
                failure(operation, error);
            }
        } else {
            failure(operation, error);
        }
    }];
    
    return operation;
}

/**
 * 发送getCache请求
 */
- (void)startCache:(NSString *)aCacheName cacheTime:(NSInteger)aTime uri:(NSString *)uri tag:(NSString *)tag
{
  
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",self.baseUrl,uri] parameters:nil error:nil];
    
    [request setTimeoutInterval:20];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; //此处将NSURLRequestReturnCacheDataElseLoad替换要不然无论有无网络情况每次请求都会取本地缓存数据
    
    //请求成功Block块
    void (^requestSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self requestFinished:responseObject tag:tag];
    };
    
    //请求失败Block块
    void (^requestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
        [self requestFailed:tag error:error];
    };
    
    //请求数据
    AFHTTPRequestOperation *operation = [self cacheOperationWithRequest:request tag:tag success:requestSuccessBlock failure:requestFailureBlock];
    [self.manager.operationQueue addOperation:operation];
}

/**
 * 获取缓存数据
 */
- (id)cachedResponseObject:(AFHTTPRequestOperation *)operation{
    
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:operation.request];
    AFHTTPResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
    id responseObject = [serializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
    return responseObject;
}

/**
 * 发送post请求
 */
- (void)startPost:(NSString*)uri params:(NSDictionary*)dit tag:(NSString *)tag postType:(PostDataStyle) type
{

    id params;
    
    if (type==PostDataStyleKeyValue) {
        params= [[self  DicttoString:dit] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else if (type==PostDataStyleJson) {
        params = [dit  JSONString];
    }
    else if (type==PostDataStyleKeyValue) {
        params = [NSData dataWithData:[dit JSONData]];
    } else if(type==PostDataStyleDictionary)
    {
        params = dit;
    }

    [self.manager POST:uri parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self requestFinished:responseObject tag:tag];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailed:tag error: error];
    }];
}


-(NSString *)DicttoString:(NSDictionary *)dict
{
    NSString * str=@"";
    
    NSArray *keys = [dict allKeys];
    for (int i=0;i<[keys count] ; i++) {
        str=[str  stringByAppendingFormat:@"%@=%@",[keys objectAtIndex:i],[dict  objectForKey:[keys objectAtIndex:i]]];
        if (i<[keys count]-1) {
            str=[str  stringByAppendingFormat:@"%@",@"&"];
        }
        
    }
    return str;
}


/**
 * 上传文件
 */
- (void)uploadFileURI:(NSString *)aUri filePath:(NSString *)aPath keyName:(NSString *)aKeyName
{
    [self httpInit];
    
    [self.manager POST:aUri  parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:aPath];
        
        //获取文件类型
        NSMutableString *filePath = [NSMutableString stringWithString:aPath];
        CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[filePath pathExtension], NULL);
        CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
        
        NSString *fileName = [filePath lastPathComponent];
        
        //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名;fileName,指定文件名;mimeType,指定文件格式 */
        [formData appendPartWithFileData:imageData name:aKeyName fileName:fileName mimeType:(__bridge NSString *)(MIMEType)];
        
    }success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [self requestFinished:responseObject tag:@"200"];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    /*
     /设置上传操作的进度
     
     [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     
     NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];
     
     UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
     
     [progress setProgressWithUploadProgressOfOperation:operation animated:YES];
     
     [progress setFrame:CGRectMake(0, 130, 320, 30)];
     
     [self.view addSubview:progress];
     */
    //[operation start];
}

/**
 停止请求
 */
- (void)cancel
{
    if (_manager != nil) {
        _manager = nil;
    }
}

/**
 * 清理回调block
 */
- (void)cleanupBlocks
{
    _complete = nil;
    _failed = nil;
}

/*
 解析通用协议头:
 1.检查协议体合法性
 2.协议版本检查，执行协议版本客户端处理逻辑
 
 返回值：BOOL 通过解析检查返回YES,否则 NO
 对于没有通过检查的协议消息，返回客户端协议错误的消息，或者版本不支持的错误
 */
- (BOOL)parseHead:(NSDictionary*)msg
{
    //错误代码解析
    //错误描述
    //版本提取，客户端版本规则逻辑执行
    
    return YES;
}

#pragma mark AFHTTPDelegate
/**
 * 代理-请求结束
 */
- (void)requestFinished:(NSDictionary *)aDictionary tag:(NSString *)aTag
{
    //如果消息头解析成功并通过合法性检查
    if([self parseHead:aDictionary] == YES){
        
        if ([self.errCode intValue] <= 0) {
            
            if ([self.delegate respondsToSelector:@selector(getFinished:tag:)]) {
                [self.delegate getFinished:aDictionary tag:aTag];
            }
        }else{
            if (_failed) {
                _failed(self.errCode,self.errMsg);
            }
            if ([self.delegate respondsToSelector:@selector(getError:tag:)]) {
                [self.delegate getError:aDictionary tag:aTag];
            }
        }
    }
}

/**
 * 代理-请求失败
 */
- (void)requestFailed:(NSString *)aTag error:  (NSError *)error
{
    if (afOrinClass != object_getClass(_delegate)) {
        NSLog(@"model已销毁");
        return;
    }
    
    if (_failed) {
        _failed(@"1",@"request error");
    }
    
    //检测如果有配置代理则去执行代理
    if ([self.delegate respondsToSelector:@selector(getError:tag:)]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:error.code],@"errcode",@"request error",@"errmsg", nil];
        [self.delegate getError:dic tag:aTag];
    }
}

@end