//
//  Student.h
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "ScoreStats.h"

extern NSString *const kStudentIDPath;
extern NSString *const kStudentNamePath;
extern NSString *const kSexPath;
extern NSString *const kEnterSchoolTimePath;
extern NSString *const kNationalityPath;
extern NSString *const kPoliticalStatusPath;
extern NSString *const kProvincePath;
extern NSString *const kMajor;
extern NSString *const kClass;
extern NSString *const kEducation;
extern NSString *const kSchoolRoll;
extern NSString *const kGrade;

@class UIImage;
@class ScoreStats;

@interface Student : NSObject
@property (strong,nonatomic) NSArray *historyCourses;
@property (strong,nonatomic) NSArray *unPassCourses;
@property (strong,nonatomic) ScoreStats *scoreStats;
//
@property (strong,nonatomic) UIImage *verifyImg;//验证码图片
@property (strong,nonatomic) UIImage *avatarImg;//头像图片
@property (copy,nonatomic) NSString *userSessionID;

//Login
@property (copy,nonatomic) NSString *userName;
@property (copy,nonatomic) NSString *pwd;
@property (copy,nonatomic) NSString *checkCode;
//
@property (copy,nonatomic) NSString *studentID;//学号
@property (copy,nonatomic) NSString *studentName;//学生姓名
@property (copy,nonatomic) NSString *grade;//年级 2012级
@property (copy,nonatomic) NSString *nationality;//民族
@property (copy,nonatomic) NSString *education;//学历
@property (copy,nonatomic) NSString *schoolRoll;//学籍 有
@property (copy,nonatomic) NSString *province;//来源省
@property (copy,nonatomic) NSString *class0;//行政班 嵌入式12-1
@property (copy,nonatomic) NSString *politicalStatus;//政治面貌
@property (copy,nonatomic) NSString *major;//所学专业
@property (copy,nonatomic) NSString *sex;//性别
@property (copy,nonatomic) NSString *enterSchoolTime;//入学时间

//
-(void)parseStudenInformationWithHtmlData:(NSData*)data;
@end
