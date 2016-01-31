//
//  ONOXMLDocument+StringValueForXPath.m
//  GPAQuery
//
//  Created by pi on 16/1/31.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ONOXMLDocument+StringValueForXPath.h"

@implementation ONOXMLDocument (StringValueForXPath)
-(NSString*)stringValueForXPath:(NSString*)xpath{
    return [self firstChildWithXPath:xpath].stringValue ? : @"";
}
@end
