//
//  Helper.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "Helper.h"


NSString *const kChinese=@"[\u4e00-\u9fa5]";
static NSRegularExpression *reg;

@implementation Helper
+(NSStringEncoding)gbkEncoding{
    static NSStringEncoding gbkEncoding;
    if(!gbkEncoding){
        gbkEncoding=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    return gbkEncoding;
}

+(NSString*)removeChinese:(NSString*)str{
    return [str stringByReplacingOccurrencesOfString:kChinese withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, str.length)];
}

+(BOOL)isChinese:(NSString*)str{
    if(!reg){
        reg=[NSRegularExpression regularExpressionWithPattern:kChinese options:0 error:NULL];
    }
    NSArray *matchs= [reg matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    return matchs.count>0;
}

+(ONOXMLDocument*)docFormData:(NSData*)data{
    NSString *str= [[NSString alloc]initWithData:data encoding:[Helper gbkEncoding]];
    str=[str stringByReplacingOccurrencesOfString:@"gb2312" withString:@"UTF-8"];
    NSError *error;
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithString:str encoding:NSUTF8StringEncoding error:&error];
    return doc;
}
@end
