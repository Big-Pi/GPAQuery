//
//  Helper.h
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONOXMLDocument+StringValueForXPath.h"


@interface Helper : NSObject
+(NSStringEncoding)gbkEncoding;
+(NSString*)removeChinese:(NSString*)str;
+(BOOL)isChinese:(NSString*)str;
+(NSArray*)sort:(NSArray*)array;
+(ONOXMLDocument*)docFormData:(NSData*)data;

+(NSString*)AppHomeDirectory;

+(NSString*)AppTempDirectory;

+(NSString*)AppDocumentDirectory;
@end
