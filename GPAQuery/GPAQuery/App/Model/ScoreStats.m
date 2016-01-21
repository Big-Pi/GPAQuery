//  学生成绩统计信息
//  ScoreStats.m
//  GPAQuery
//
//  Created by pi on 16/1/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ScoreStats.h"
#import "CXHTMLDocument.h"
#import "Helper.h"

NSString *const kStatsParentPath=@"//*[@id='xftj']";

@interface ScoreStats ()
@property (copy,nonatomic,readwrite) NSString *creditSelected;//所选学分
@property (copy,nonatomic,readwrite) NSString *creditGain;//获得学分
@property (copy,nonatomic,readwrite) NSString *creditRetake;//重修学分
@property (copy,nonatomic,readwrite) NSString *creditUnPass;//正考未通过学分

@end

@implementation ScoreStats
#pragma mark - Private

- (instancetype)initWithHtmlData:(NSData*)data
{
    self = [super init];
    if (self) {
        [self parseScoreStatsFromHtmlData:data];
    }
    return self;
}

-(void)setCreditUnPass:(NSString *)creditUnPass{
    _creditUnPass=[creditUnPass stringByReplacingOccurrencesOfString:@"。" withString:@""];
}

-(void)parseScoreStatsFromHtmlData:(NSData*)data{
    CXHTMLDocument *html=[[CXHTMLDocument alloc]initWithXHTMLData:data encoding:[Helper gbkEncoding] options:0 error:NULL];
    CXMLNode *parentNode= [html nodesForXPath:kStatsParentPath error:NULL][0];
    CXMLNode *statsNode= parentNode.children[0];
    NSString *stats=statsNode.stringValue;
    
    NSArray *array= [stats componentsSeparatedByString:@"；"];
    self.creditSelected=array[0];
    self.creditGain=array[1];
    self.creditRetake=array[2];
    self.creditUnPass=array[3];
}
@end
