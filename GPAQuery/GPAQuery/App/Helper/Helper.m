//
//  Helper.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "Helper.h"

@implementation Helper
+(NSStringEncoding)gbkEncoding{
    static NSStringEncoding gbkEncoding;
    if(!gbkEncoding){
        gbkEncoding=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    return gbkEncoding;
}

+(NSString*)removeChinese:(NSString*)str{
    return [str stringByReplacingOccurrencesOfString:@"[\u4e00-\u9fa5]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, str.length)];
}
@end
