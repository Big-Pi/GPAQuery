//
//  CXHTMLDocument+StringValueForXPath.m
//  GPAQuery
//
//  Created by pi on 16/1/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CXHTMLDocument+StringValueForXPath.h"

@implementation CXHTMLDocument (StringValueForXPath)
-(NSString*)stringValueForXPath:(NSString*)xpath{
    CXMLNode *node= [[self nodesForXPath:xpath error:NULL]lastObject];
    return node.stringValue ? node.stringValue : @"";
}
@end
