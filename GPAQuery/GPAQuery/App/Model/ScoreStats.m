//  学生成绩统计信息
//  ScoreStats.m
//  GPAQuery
//
//  Created by pi on 16/1/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ScoreStats.h"
#import "Helper.h"

NSString *const kStatsParentPath=@"//*[@id='xftj']";

@interface ScoreStats ()
@property (copy,nonatomic,readwrite) NSString *creditSelected;//所选学分
@property (copy,nonatomic,readwrite) NSString *creditGain;//获得学分
@property (copy,nonatomic,readwrite) NSString *creditRetake;//重修学分
@property (copy,nonatomic,readwrite) NSString *creditUnPass;//正考未通过学分

@end

@implementation ScoreStats
#pragma mark - Public
- (instancetype)initWithHtmlData:(NSData*)data
{
    self = [super init];
    if (self) {
        [self parseScoreStatsFromHtmlData:data];
    }
    return self;
}

#pragma mark - Getter Setter
-(void)setCreditGain:(NSString *)creditGain{
    _creditGain=[Helper removeChinese:creditGain];
}

-(void)setCreditRetake:(NSString *)creditRetake{
    _creditRetake=[Helper removeChinese:creditRetake];
}

-(void)setCreditUnPass:(NSString *)creditUnPass{
    _creditUnPass=[Helper removeChinese:creditUnPass];
    _creditUnPass=[_creditUnPass stringByReplacingOccurrencesOfString:@"。" withString:@""];
}

-(void)setCreditSelected:(NSString *)creditSelected{
    _creditSelected=[Helper removeChinese:creditSelected];
}

#pragma mark - Private
-(void)parseScoreStatsFromHtmlData:(NSData*)data{
    ONOXMLDocument *doc=[Helper docFormData:data];
    ONOXMLElement *parent= [doc firstChildWithXPath:kStatsParentPath];
    ONOXMLElement *statsElement= parent.children[0];
    NSString *stats=statsElement.stringValue;
    NSArray *array= [stats componentsSeparatedByString:@"；"];
    self.creditSelected=array[0];
    self.creditGain=array[1];
    self.creditRetake=array[2];
    self.creditUnPass=array[3];
}
@end
