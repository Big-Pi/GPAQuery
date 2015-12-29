//
//  OnoResponseSerializer.m
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "OnoResponseSerializer.h"
#import <Ono.h>

@interface _OnoXMLResponseSerializer : OnoResponseSerializer
@end

@interface _OnoHTMLResponseSerializer : OnoResponseSerializer
@end

@implementation OnoResponseSerializer
+(instancetype)serializer{
    return  [[self alloc]init];
}

+(_OnoXMLResponseSerializer*)sharedXMLResponseSerializer{
    static id _sharedXMLResponseSerializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedXMLResponseSerializer=[[_OnoXMLResponseSerializer alloc]init];
    });
    return  _sharedXMLResponseSerializer;
}

+(_OnoHTMLResponseSerializer*)sharedHTMLResponseSerializer{
    static id _sharedHTMLResponseSerializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHTMLResponseSerializer=[[_OnoHTMLResponseSerializer alloc]init];
    });
    return  _sharedHTMLResponseSerializer;
}

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error{
    NSError *serializationError;
    id responseObj=nil;
    if(!responseObj){
        responseObj=[[[self class]sharedXMLResponseSerializer]responseObjectForResponse:response data:data error:&serializationError];
    }
    if(!responseObj){
        responseObj=[[[self class]sharedHTMLResponseSerializer]responseObjectForResponse:response data:data error:&serializationError];
    }
    return responseObj;
}
@end;

#pragma mark - _OnoXMLResponseSerializer

@implementation _OnoXMLResponseSerializer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", @"application/xml", nil];
    return self;
}

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error{
    if(![self validateResponse:(NSHTTPURLResponse*)response data:data error:error]){
        return nil;
    }
    return [ONOXMLDocument XMLDocumentWithData:data error:error];
}

@end




#pragma mark - _OnoHTMLResponseSerializer

@implementation _OnoHTMLResponseSerializer

-(instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    return self;
}

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error{
    if(![self validateResponse:(NSHTTPURLResponse*)response data:data error:error]){
        return nil;
    }
    return [ONOXMLDocument HTMLDocumentWithData:data error:error];
}

@end



