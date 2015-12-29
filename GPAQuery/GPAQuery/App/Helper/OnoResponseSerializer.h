//
//  OnoResponseSerializer.h
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface OnoResponseSerializer : AFHTTPResponseSerializer
+(instancetype)serializer;
@end
