//
//  Student.m
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Student.h"
#import "NetUtil.h"
#import "Course.h"
#import "SYNUAPI.h"
#import <UIKit/UIImage.h>
#import "CXHTMLDocument.h"
#import "CXHTMLDocument+StringValueForXPath.h"

#pragma mark - XPaths
NSString *const kStudentIDPath=@"//*[@id='xh']";
NSString *const kStudentNamePath=@"//*[@id='xhxm']";
NSString *const kSexPath=@"//*[@id='lbl_xb']";
NSString *const kEnterSchoolTimePath=@"//*[@id='lbl_rxrq']";
NSString *const kNationalityPath=@"//*[@id='lbl_mz']";
NSString *const kPoliticalStatusPath=@"//*[@id='lbl_zzmm']";
NSString *const kProvincePath=@"//*[@id='lbl_lys']";
NSString *const kMajor=@"//*[@id='lbl_zymc']";
NSString *const kClass=@"//*[@id='lbl_xzb']";
NSString *const kEducation=@"//*[@id='lbl_CC']";
NSString *const kSchoolSystem=@"//*[@id='lbl_CC']";
NSString *const kSchoolRoll=@"//*[@id='lbl_xjzt']";
NSString *const kGrade=@"//*[@id='lbxsgrxx_dqszj']";
NSString *const kLearningForm=@"//*[@id='lbxsgrxx_xxxs']";

@interface Student ()
@property (strong,nonatomic) NetUtil *net;
@property (strong,nonatomic,readwrite) UIImage *verifyImg;//验证码图片
@property (strong,nonatomic,readwrite) UIImage *avatarImg;//头像图片

@property (copy,nonatomic,readwrite) NSString *userSessionID;
//
@property (copy,nonatomic,readwrite) NSString *studentID;//学号
@property (copy,nonatomic,readwrite) NSString *studentName;//学生姓名
@property (copy,nonatomic,readwrite) NSString *grade;//年级 2012级
@property (copy,nonatomic,readwrite) NSString *nationality;//民族
@property (copy,nonatomic,readwrite) NSString *schoolSystem;//学制 4年制
@property (copy,nonatomic,readwrite) NSString *education;//学历
@property (copy,nonatomic,readwrite) NSString *schoolRoll;//学籍 有
@property (copy,nonatomic,readwrite) NSString *learningForm;//学习形式 普通全日制
@property (copy,nonatomic,readwrite) NSString *province;//来源省
@property (copy,nonatomic,readwrite) NSString *class;//行政班 嵌入式12-1
@property (copy,nonatomic,readwrite) NSString *politicalStatus;//政治面貌
@property (copy,nonatomic,readwrite) NSString *major;//所学专业
@property (copy,nonatomic,readwrite) NSString *sex;//性别
@property (copy,nonatomic,readwrite) NSString *enterSchoolTime;//入学时间

@end

@implementation Student
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.net=[NetUtil sharedNetUtil];
        self.studentName=@"赵志明";
    }
    return self;
}

/**
 *  获取验证码图片
 *
 *  @param completionHandler
 */
-(void)getVerifyImageWithCompletionHandler:(void (^)(UIImage *verifyImg))completionHandler{
    [self.net get:[SYNUAPI generateMainPageUrl] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        self.userSessionID= [self parseUserIDFromResponse:response];
        [self verifyImgWithUserSessionID:self.userSessionID completionHandler:completionHandler];
    }];
}

/**
 *  登录
 *
 *  @param userName
 *  @param pwd
 *  @param checkCode
 */
-(void)logInWithUserName:(NSString*)userName pwd:(NSString*)pwd checkCode:(NSString*)checkCode{
    NSString *logInUrl=[SYNUAPI generateLogInUrl:self.userSessionID];
    
    NSString *logInBody=[SYNUAPI generateLogInBody:userName pwd:pwd checkCode:checkCode];

    [self.net post:logInUrl bodyStr:logInBody completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[NetUtil gbkEncoding]];
//        NSLog(@"%@",str);
        self.studentID=userName;
        self.studentName= [self parseStudentNameFromData:responseObject];
//        [self getAllCourses];
        [self getUnPassedCourses];
    }];
    
}

/**
 *  学生个人信息
 */
-(void)getStudenInformation{

    NSString *url=[SYNUAPI generateStudentInformationUrl:self.userSessionID studentID:self.studentID studentName:self.studentName];
    
    [self.net get:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[NetUtil gbkEncoding]];
//        NSLog(@"%@",str);
        [self parseStudenInformationWithHtmlData:responseObject];
    }];
}

/**
 *  未通过课程
 */
-(void)getUnPassedCourses{
    NSString *url=[SYNUAPI generateStudentCoursesUrl:self.userSessionID studentID:self.studentID studentName:self.studentName];
    [self.net get:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [Course coursesFromHtmlData:responseObject];
    }];
}

/**
 *  所有课程列表
 */
-(void)getAllCourses{
    NSString *url= [SYNUAPI generateStudentCoursesUrl:self.userSessionID studentID:self.studentID studentName:self.studentName];
    
    [self.net post:url bodyStr:kAllCoursesBody completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[NetUtil gbkEncoding]];
        NSLog(@"%@",str);
        [Course coursesFromHtmlData:responseObject];
    }];
}

/**
 *  获取学生头像图片
 *
 *  @param completionHandler
 */
-(void)getAvatarImageWithCompletionHandler:(void (^)(UIImage *verifyImg))completionHandler{
    [self.net get:[SYNUAPI generateStudentAvantarUrl:self.userSessionID studentID:self.studentID] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        self.avatarImg=[UIImage imageWithData:responseObject];
        completionHandler(self.avatarImg);
    }];
}


#pragma mark - Private
/**
 *  根据session 获取验证码
 *
 *  @param sessionID
 *  @param completionHandler
 */
-(void)verifyImgWithUserSessionID:(NSString*)sessionID completionHandler:(void (^)(UIImage *verifyImg))completionHandler{

    [self.net get:[SYNUAPI generateCheckCodeUrl:self.userSessionID] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        self.verifyImg= [UIImage imageWithData:responseObject];
        completionHandler(self.verifyImg);
    }];
}

/**
 *  取出sessionID
 *
 *  @param response
 *
 */
-(NSString*)parseUserIDFromResponse:(NSURLResponse*)response{
    NSArray *pathComponents= response.URL.pathComponents;
    NSString *identifier=pathComponents[1];
    identifier=[identifier stringByReplacingOccurrencesOfString:@"(" withString:@""];
    identifier=[identifier stringByReplacingOccurrencesOfString:@")" withString:@""];
    return identifier;
}

/**
 *  取出学生姓名
 *
 *  @param data
 *
 */
-(NSString*)parseStudentNameFromData:(NSData*)data{
    CXHTMLDocument *html=[[CXHTMLDocument alloc]initWithData:data encoding:[NetUtil gbkEncoding] options:CXMLDocumentTidyHTML error:NULL];
    NSString *studentName=[html stringValueForXPath:kStudentNamePath];
    
    studentName=[studentName stringByReplacingOccurrencesOfString:@"同学" withString:@"" options:0 range:NSMakeRange(0,studentName.length)];
    return studentName;
}

#pragma mark - HTML Parse
-(void)parseStudenInformationWithHtmlData:(NSData*)data{
    
    CXHTMLDocument *html=[[CXHTMLDocument alloc]initWithData:data encoding:[NetUtil gbkEncoding] options:0 error:NULL];
    
    self.studentID =[html stringValueForXPath:kStudentIDPath];
    self.sex =[html stringValueForXPath:kSexPath];
    self.enterSchoolTime =[html stringValueForXPath:kEnterSchoolTimePath];
    self.nationality =[html stringValueForXPath:kNationalityPath];
    self.politicalStatus =[html stringValueForXPath:kPoliticalStatusPath];
    self.province =[html stringValueForXPath:kProvincePath];
    self.major=[html stringValueForXPath:kMajor];
    self.class =[html stringValueForXPath:kClass];
    self.education =[html stringValueForXPath:kEducation];
    self.schoolSystem =[html stringValueForXPath:kSchoolSystem];
    self.schoolRoll =[html stringValueForXPath:kSchoolRoll];
    self.grade =[html stringValueForXPath:kGrade];
    self.learningForm =[html stringValueForXPath:kLearningForm];
    
}

@end
