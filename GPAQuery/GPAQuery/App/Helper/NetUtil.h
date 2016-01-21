//
//  NetUtil.h
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetUtil : NSObject
+(instancetype)sharedNetUtil;

//
-(void)get:(NSString*)urlStr
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

-(void)get:(NSString*)urlStr
 parameter:(NSDictionary*)parameters
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;
//
-(void)post:(NSString*)urlStr
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

-(void)post:(NSString*)urlStr
  parameter:(NSDictionary*)parameters
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

-(void)post:(NSString*)urlStr
    bodyStr:(NSString*)bodyStr
completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;
@end
