//
//  Helper.h
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
+(NSStringEncoding)gbkEncoding;
+(NSString*)removeChinese:(NSString*)str;
+(BOOL)isChinese:(NSString*)str;
@end
