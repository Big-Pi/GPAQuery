//
//  Course.m
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Course.h"
#import "Helper.h"

#pragma mark - XPaths
NSString *const kCourseTableHeadPath=@"//*[@class='datelisthead']";

@interface Course ()
@end

@implementation Course

#pragma mark - Public
/**
 *  从responseObj的html中解析所有成绩数据
 *
 *  @param data
 *
 *  @return
 */

+(NSArray *)coursesFromHtmlData:(NSData *)data studentID:(NSString *)studentID{
    //找到成绩表格头部
    NSMutableArray *array=[NSMutableArray array];
    ONOXMLDocument *doc=[Helper docFormData:data];
    ONOXMLElement *tableHead= [doc firstChildWithXPath:kCourseTableHeadPath];

    ONOXMLElement *courseElement;
    for (courseElement=[tableHead nextSibling]; courseElement!=nil; courseElement=[courseElement nextSibling]) {
        Course *course=[[Course alloc]initWithNode:courseElement];
        course.studentID=studentID;
        [array addObject:course];
    }
    [array removeLastObject];
    return array;
}

#pragma mark - Private

- (instancetype)initWithNode:(ONOXMLElement*)node
{
    self = [super init];
    if (self) {
        [self parseCourseFromNode:node];
    }
    return self;
}

-(void)setYear:(NSString *)year{
    if(year.length==9){
        NSString *str1= [year substringToIndex:5];
        NSString *str2= [year substringFromIndex:7];
        NSString *shortYear=[NSString stringWithFormat:@"%@%@",str1,str2];
        _year=shortYear;
    }else{
      _year=year;
    }
}

-(void)setScore:(NSString *)score{
    if([Helper isChinese:score]){
        if ([score rangeOfString:@"不"].location!=NSNotFound) {
            score=[NSString stringWithFormat:@"%d",0];
        }else if([score rangeOfString:@"及格"].location!=NSNotFound){
            score=[NSString stringWithFormat:@"%d",65];
        }else if([score rangeOfString:@"合格"].location!=NSNotFound){
            score=[NSString stringWithFormat:@"%d",65];
        }else if ([score rangeOfString:@"中等"].location!=NSNotFound){
            score=[NSString stringWithFormat:@"%d",75];
        }else if ([score rangeOfString:@"良好"].location!=NSNotFound){
            score=[NSString stringWithFormat:@"%d",85];
        }else if ([score rangeOfString:@"优秀"].location!=NSNotFound){
            score=[NSString stringWithFormat:@"%d",95];
        }
    }
    _score=score;
}

-(void)setCourseType:(NSString *)courseType{
    _courseType=courseType;
    //通识必修 学科必修 公共选修
    if([courseType rangeOfString:@"公共选修"].location!=NSNotFound){
        self.SYNUCourseType=SYNUCourseTypeHistory;
    }
}

-(void)parseCourseFromNode:(ONOXMLElement*)element{
    NSArray *children=element.children;
    if(children.count>=15){
        self.SYNUCourseType=SYNUCourseTypeHistoryGPACalc;
        self.year=((ONOXMLElement*)children[0]).stringValue;
        self.term=((ONOXMLElement*)children[1]).stringValue;
        self.courseCode=((ONOXMLElement*)children[2]).stringValue;
        self.courseName=((ONOXMLElement*)children[3]).stringValue;
        self.courseType=((ONOXMLElement*)children[4]).stringValue;
        self.courseSubType=((ONOXMLElement*)children[5]).stringValue;
        self.credit=((ONOXMLElement*)children[6]).stringValue;
        self.GPA=((ONOXMLElement*)children[7]).stringValue;
//        self.score=((ONOXMLElement*)children[8]).stringValue;
//        self.tag=((ONOXMLElement*)children[9]).stringValue;
//        self.scoreMakeUp=((ONOXMLElement*)children[10]).stringValue;
//        self.scoreRetake=((ONOXMLElement*)children[11]).stringValue;
//        self.institute=((ONOXMLElement*)children[12]).stringValue;
//        self.mark=((ONOXMLElement*)children[13]).stringValue;
//        self.retakeTag=((ONOXMLElement*)children[14]).stringValue;
        self.score=((ONOXMLElement*)children[12]).stringValue;
        self.tag=((ONOXMLElement*)children[13]).stringValue;
        self.scoreMakeUp=((ONOXMLElement*)children[14]).stringValue;
        self.scoreRetake=((ONOXMLElement*)children[15]).stringValue;
        self.institute=((ONOXMLElement*)children[16]).stringValue;
        self.mark=((ONOXMLElement*)children[17]).stringValue;
        self.retakeTag=((ONOXMLElement*)children[18]).stringValue;

    }else if(children.count==6){
        self.SYNUCourseType=SYNUCourseTypeUnPass;
        self.courseCode=((ONOXMLElement*)children[0]).stringValue;
        self.courseName=((ONOXMLElement*)children[1]).stringValue;
        self.courseType=((ONOXMLElement*)children[2]).stringValue;
        self.credit=((ONOXMLElement*)children[3]).stringValue;
        self.bestScore=((ONOXMLElement*)children[4]).stringValue;
        self.courseSubType=((ONOXMLElement*)children[5]).stringValue;
    }
}
@end
