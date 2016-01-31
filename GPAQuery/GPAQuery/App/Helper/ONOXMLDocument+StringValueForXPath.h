//
//  ONOXMLDocument+StringValueForXPath.h
//  GPAQuery
//
//  Created by pi on 16/1/31.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Ono/Ono.h>

@interface ONOXMLDocument (StringValueForXPath)
-(NSString*)stringValueForXPath:(NSString*)xpath;
@end
