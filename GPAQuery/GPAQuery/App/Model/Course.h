//
//  Course.h
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SYNUCourseTypeHistory, //所有历史课程
    SYNUCourseTypeUnPass,   //未通过课程
    SYNUCourseTypeHistoryGPACalc //历史课程中需要计算绩点的课程 (公共选修课等不需要计算绩点)
} SYNUCourseType;

@interface Course : NSObject
@property (copy,nonatomic,readonly) NSString *year;//学年
@property (copy,nonatomic,readonly) NSString *term;//学期
@property (copy,nonatomic,readonly) NSString *courseCode;//课程代码
@property (copy,nonatomic,readonly) NSString *courseName;//课程名称
@property (copy,nonatomic,readonly) NSString *courseType;//课程性质
@property (copy,nonatomic,readonly) NSString *courseSubType;//课程归属
@property (copy,nonatomic,readonly) NSString *credit;//学分
@property (copy,nonatomic,readonly) NSString *GPA;//绩点
@property (copy,nonatomic,readonly) NSString *score;//成绩
@property (copy,nonatomic,readonly) NSString *tag;//辅修标记
@property (copy,nonatomic,readonly) NSString *scoreMakeUp;//补考成绩
@property (copy,nonatomic,readonly) NSString *scoreRetake;//重修成绩
@property (copy,nonatomic,readonly) NSString *institute;//开课学院
@property (copy,nonatomic,readonly) NSString *mark;//备注
@property (copy,nonatomic,readonly) NSString *retakeTag;//重修标记
@property (assign,nonatomic,readonly) SYNUCourseType SYNUCourseType;
+(NSArray *)coursesFromHtmlData:(NSData *)data;
@end
