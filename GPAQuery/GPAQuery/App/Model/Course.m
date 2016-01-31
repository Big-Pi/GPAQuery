//
//  Course.m
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Course.h"
#import "CXHTMLDocument.h"
#import "Helper.h"

#pragma mark - XPaths
NSString *const kCourseTableHeadPath=@"//*[@class='datelisthead']";

@interface Course ()
@property (assign,nonatomic,readwrite) SYNUCourseType SYNUCourseType;
//
@property (copy,nonatomic,readwrite) NSString *year;//学年
@property (copy,nonatomic,readwrite) NSString *term;//学期
@property (copy,nonatomic,readwrite) NSString *courseCode;//课程代码
@property (copy,nonatomic,readwrite) NSString *courseName;//课程名称
@property (copy,nonatomic,readwrite) NSString *courseType;//课程性质
@property (copy,nonatomic,readwrite) NSString *courseSubType;//课程归属
@property (copy,nonatomic,readwrite) NSString *credit;//学分
@property (copy,nonatomic,readwrite) NSString *GPA;//绩点
@property (copy,nonatomic,readwrite) NSString *score;//成绩
@property (copy,nonatomic,readwrite) NSString *tag;//辅修标记
@property (copy,nonatomic,readwrite) NSString *scoreMakeUp;//补考成绩
@property (copy,nonatomic,readwrite) NSString *scoreRetake;//重修成绩
@property (copy,nonatomic,readwrite) NSString *institute;//开课学院
@property (copy,nonatomic,readwrite) NSString *mark;//备注
@property (copy,nonatomic,readwrite) NSString *retakeTag;//重修标记
//
@property (copy,nonatomic,readwrite) NSString *bestScore;//最高成绩

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
+(NSArray *)coursesFromHtmlData:(NSData *)data{
    
    NSMutableArray *array=[NSMutableArray array];
    NSError *error;
    CXHTMLDocument *html=[[CXHTMLDocument alloc]initWithXHTMLData:data encoding:[Helper gbkEncoding] options:0 error:&error];

    NSArray *nodes= [html nodesForXPath:kCourseTableHeadPath error:NULL];
    CXMLNode *headNode=nodes[0];
    
    CXMLNode *courseNode;
    for (courseNode=[headNode nextSibling]; courseNode!=nil; courseNode=[courseNode nextSibling]) {
        Course *course=[[Course alloc]initWithNode:courseNode];
        [array addObject:course];
    }
    return array;
}

#pragma mark - Private

- (instancetype)initWithNode:(CXMLNode*)node
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
        if ([score containsString:@"不"]) {
            score=[NSString stringWithFormat:@"%d",0];
        }else if([score containsString:@"及格"]){
            score=[NSString stringWithFormat:@"%d",65];
        }else if([score containsString:@"合格"]){
            score=[NSString stringWithFormat:@"%d",65];
        }else if ([score containsString:@"中等"]){
            score=[NSString stringWithFormat:@"%d",75];
        }else if ([score containsString:@"良好"]){
            score=[NSString stringWithFormat:@"%d",85];
        }else if ([score containsString:@"优秀"]){
            score=[NSString stringWithFormat:@"%d",95];
        }
    }
    _score=score;
}

-(void)setCourseType:(NSString *)courseType{
    _courseType=courseType;
    //通识必修 学科必修 公共选修
    if([courseType containsString:@"公共选修"]){
        self.SYNUCourseType=SYNUCourseTypeHistory;
    }
}

-(void)parseCourseFromNode:(CXMLNode*)node{
    NSArray *children=node.children;
    if(children.count==16){
        self.SYNUCourseType=SYNUCourseTypeHistoryGPACalc;
        self.year=((CXMLNode*)children[0]).stringValue;
        self.term=((CXMLNode*)children[1]).stringValue;
        self.courseCode=((CXMLNode*)children[2]).stringValue;
        self.courseName=((CXMLNode*)children[3]).stringValue;
        self.courseType=((CXMLNode*)children[4]).stringValue;
        self.courseSubType=((CXMLNode*)children[5]).stringValue;
        self.credit=((CXMLNode*)children[6]).stringValue;
        self.GPA=((CXMLNode*)children[7]).stringValue;
        self.score=((CXMLNode*)children[8]).stringValue;
        self.tag=((CXMLNode*)children[9]).stringValue;
        self.scoreMakeUp=((CXMLNode*)children[10]).stringValue;
        self.scoreRetake=((CXMLNode*)children[11]).stringValue;
        self.institute=((CXMLNode*)children[12]).stringValue;
        self.mark=((CXMLNode*)children[13]).stringValue;
        self.retakeTag=((CXMLNode*)children[14]).stringValue;
    }else if(children.count==7){
        self.SYNUCourseType=SYNUCourseTypeUnPass;
        self.courseCode=((CXMLNode*)children[0]).stringValue;
        self.courseName=((CXMLNode*)children[1]).stringValue;
        self.courseType=((CXMLNode*)children[2]).stringValue;
        self.credit=((CXMLNode*)children[3]).stringValue;
        self.bestScore=((CXMLNode*)children[4]).stringValue;
        self.courseSubType=((CXMLNode*)children[5]).stringValue;
    }
}
@end
