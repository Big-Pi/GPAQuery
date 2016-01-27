//
//  Student.m
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Student.h"
#import <UIKit/UIImage.h>
#import "CXHTMLDocument+StringValueForXPath.h"
#import "Helper.h"


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
NSString *const kSchoolRoll=@"//*[@id='lbl_xjzt']";
NSString *const kGrade=@"//*[@id='lbl_dqszj']";

@interface Student ()
@end

@implementation Student


-(void)setHistoryCourses:(NSArray *)historyCourses{
    _historyCourses=historyCourses;
    _historyGPACalcCourses=[self validateCourse];
    [self calcGPA:_historyGPACalcCourses];
}

#pragma mark - Private
-(NSArray *)validateCourse{
    NSMutableArray *validateCourses=[NSMutableArray array];
    for (Course *c in self.historyCourses) {
        if(c.SYNUCourseType==SYNUCourseTypeHistory){
            continue;
        }
        [self addValidateCoursesPrivate:validateCourses courseToAdd:c];
    }
    return validateCourses;
}

-(void)addValidateCoursesPrivate:(NSMutableArray*)validateCoursesArray courseToAdd:(Course*)c{
    BOOL contains=NO;
    Course *sameCodeCourse;
    for (Course *validateC in validateCoursesArray) {
        if([c.courseCode integerValue]==[validateC.courseCode integerValue]){
            sameCodeCourse=validateC;
            contains=YES;
            break;
        }
    }
    if (!contains) {
        [validateCoursesArray addObject:c];
    }else{
        if(c.GPA&& [c.GPA floatValue]>0.0){
            [validateCoursesArray replaceObjectAtIndex:[validateCoursesArray indexOfObject:sameCodeCourse] withObject:c];
        }else{
            //维持原样。。不添加 c
        }
    }
}

-(void)calcGPA:(NSArray*)courses{
    float creditSum=0;
    float creditMutiplyGPASum=0;
    
    for (Course *c in courses) {
        float credit= [c.credit floatValue];
        float GPA= [c.GPA floatValue];
        creditSum+=credit;
        creditMutiplyGPASum+=credit*GPA;
    }
    //    NSLog(@"%f / 学分:%f",creditMutiplyGPASum,creditSum);
    self.creditSum=[NSString stringWithFormat:@"%f",creditSum];
    self.GPA=[NSString stringWithFormat:@"%f",creditMutiplyGPASum/creditSum];
}

#pragma mark -

#if 0
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[Helper gbkEncoding]];
        NSLog(@"%@",str);
        self.studentID=userName;
        self.studentName= [self parseStudentNameFromData:responseObject];
//        [self getAllCourses];
//        [self getUnPassedCourses];
//        [self getScoreStats];
        [self getStudenInformation];
    }];
    
}

/**
 *  学生个人信息
 */
-(void)getStudenInformation{

    NSString *url=[SYNUAPI generateStudentInformationUrl:self.userSessionID studentID:self.studentID studentName:self.studentName];
    
    [self.net get:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[Helper gbkEncoding]];
        NSLog(@"%@",str);
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
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[Helper gbkEncoding]];
        NSLog(@"%@",str);
        [Course coursesFromHtmlData:responseObject];
    }];
}

-(void)getScoreStats{
        NSString *url= [SYNUAPI generateStudentCoursesUrl:self.userSessionID studentID:self.studentID studentName:self.studentName];
    [self.net post:url bodyStr:kScoreStatsBody completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[Helper gbkEncoding]];
//        NSLog(@"%@",str);
        [[ScoreStats alloc]initWithHtmlData:responseObject];
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

#endif

#pragma mark - HTML Parse
-(void)parseStudenInformationWithHtmlData:(NSData*)data{
    CXHTMLDocument *html=[[CXHTMLDocument alloc]initWithXHTMLData:data encoding:[Helper gbkEncoding] options:CXMLDocumentTidyHTML error:NULL];
//    CXHTMLDocument *html=[[CXHTMLDocument alloc]initWithData:data encoding:[Helper gbkEncoding] options:CXMLDocumentTidyHTML error:NULL];
    
    self.studentID =[html stringValueForXPath:kStudentIDPath];
    self.sex =[html stringValueForXPath:kSexPath];
    self.enterSchoolTime =[html stringValueForXPath:kEnterSchoolTimePath];
    self.nationality =[html stringValueForXPath:kNationalityPath];
    self.politicalStatus =[html stringValueForXPath:kPoliticalStatusPath];
    self.province =[html stringValueForXPath:kProvincePath];
    self.major=[html stringValueForXPath:kMajor];
    self.class0 =[html stringValueForXPath:kClass];
    self.education =[html stringValueForXPath:kEducation];
    self.schoolRoll =[html stringValueForXPath:kSchoolRoll];
    self.grade =[html stringValueForXPath:kGrade];
    
}

@end
