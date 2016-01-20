//
//  NetUtil.m
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "NetUtil.h"
#import <AFNetworking.h>

@interface NetUtil ()
@property (strong,nonatomic) NSURLSessionConfiguration *configuration;
@property (strong,nonatomic) AFURLSessionManager *manager;
@end

@implementation NetUtil
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager=[[AFURLSessionManager alloc]initWithSessionConfiguration:self.configuration];
        self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    }
    return self;
}

+(instancetype)sharedNetUtil{
    static id netUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netUtil=[[NetUtil alloc]init];
    });
    return netUtil;
}

#pragma mark - Public


-(void)get:(NSString*)urlStr
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    [self get:urlStr parameter:nil completionHandler:completionHandler];
}

-(void)get:(NSString*)urlStr
 parameter:(NSDictionary*)parameters
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{

    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:[NetUtil gbkEncoding]];
    NSMutableURLRequest *request=[[AFHTTPRequestSerializer serializer]requestWithMethod:@"GET" URLString:urlStr parameters:nil error:NULL];
    
//    NSURL *URL = [NSURL URLWithString: [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    request.HTTPMethod=@"GET";
    
    [request setAllHTTPHeaderFields:@{@"Referer":@"http://210.30.208.126/"}];
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:completionHandler];
    [dataTask resume];
}

-(void)post:(NSString*)urlStr
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    [self post:urlStr parameter:nil completionHandler:completionHandler];
}

-(void)post:(NSString*)urlStr
  parameter:(NSDictionary*)parameters
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{

    NSMutableString *body=[NSMutableString string];
    for (NSString *key in parameters) {
        NSString *value= [parameters valueForKey:key];
        [body appendFormat:@"%@=%@",key,value];
    }
    [self post:urlStr bodyStr:body completionHandler:completionHandler];
}

-(void)post:(NSString*)urlStr
   bodyStr:(NSString*)bodyStr
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    
    NSURL *URL = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:[NetUtil gbkEncoding]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod=@"POST";
    if(bodyStr && bodyStr.length>0){
//        bodyStr=[bodyStr stringByAddingPercentEscapesUsingEncoding:[NetUtil gbkEncoding]];
        request.HTTPBody=[bodyStr dataUsingEncoding:[NetUtil gbkEncoding]];
    }
    [request setAllHTTPHeaderFields:@{@"Referer":@"http://210.30.208.126/"}];
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:completionHandler];
    [dataTask resume];
}

#pragma mark - Private
+(NSStringEncoding)gbkEncoding{
    static NSStringEncoding gbkEncoding;
    if(!gbkEncoding){
        gbkEncoding=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    return gbkEncoding;
}
@end
