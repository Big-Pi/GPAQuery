//
//  Course.h
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SYNUCourseTypeHistory=0, //所有历史课程
    SYNUCourseTypeUnPass=1,   //未通过课程
    SYNUCourseTypeHistoryGPACalc=2 //历史课程中需要计算绩点的课程 (公共选修课等不需要计算绩点)
} SYNUCourseType;

@interface Course : NSObject
@property (copy,nonatomic) NSString *studentID; //谁的课程信息
@property (copy,nonatomic) NSString *year;//学年
@property (copy,nonatomic) NSString *term;//学期
@property (copy,nonatomic) NSString *courseCode;//课程代码
@property (copy,nonatomic) NSString *courseName;//课程名称
@property (copy,nonatomic) NSString *courseType;//课程性质
@property (copy,nonatomic) NSString *courseSubType;//课程归属
@property (copy,nonatomic) NSString *credit;//学分
@property (copy,nonatomic) NSString *GPA;//绩点
@property (copy,nonatomic) NSString *score;//成绩
@property (copy,nonatomic) NSString *tag;//辅修标记
@property (copy,nonatomic) NSString *scoreMakeUp;//补考成绩
@property (copy,nonatomic) NSString *scoreRetake;//重修成绩
@property (copy,nonatomic) NSString *institute;//开课学院
@property (copy,nonatomic) NSString *mark;//备注
@property (copy,nonatomic) NSString *retakeTag;//重修标记
@property (copy,nonatomic) NSString *bestScore;//最高成绩
@property (assign,nonatomic) SYNUCourseType SYNUCourseType;
+(NSArray *)coursesFromHtmlData:(NSData *)data studentID:(NSString*)studentID;
@end
