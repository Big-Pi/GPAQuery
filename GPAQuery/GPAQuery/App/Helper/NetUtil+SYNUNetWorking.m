//
//  NetUtil+SYNUNetWorking.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NetUtil+SYNUNetWorking.h"
#import "SYNUAPI.h"
#import "Student.h"
#import "Course.h"
#import "Helper.h"
#import "ScoreStats.h"
#import "Ono.h"


@implementation NetUtil (SYNUNetWorking)

/**
 *  获取SessionID
 *
 *  @param completionHandler
 */
-(void)getSessionIDWithStudent:(Student*)student completionHandler:(void (^)())completionHandler{
    [self get:[SYNUAPI generateMainPageUrl] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        student.userSessionID= [self parseUserIDFromResponse:response];
        completionHandler();
    }];
}

/**
 *  登录
 *
 *  @param userName
 *  @param pwd
 *  @param checkCode
 */
-(void)logInWithStudent:(Student*)student completionHandler:(void (^)(BOOL success,NSString *errorMsg))completionHandler{
    NSString *logInUrl=[SYNUAPI generateLogInUrl:student.userSessionID];
    
    NSString *logInBody=[SYNUAPI generateLogInBody:student.userName pwd:student.pwd checkCode:student.checkCode];
    
    [self post:logInUrl bodyStr:logInBody completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSString *errorMsg= [self validateLogInSuccess:responseObject];
        
        if(!errorMsg){
            student.studentName= [self parseStudentNameFromData:responseObject];
        }
        completionHandler(!errorMsg,errorMsg);
    }];
}

-(NSString*)validateLogInSuccess:(NSData*)responseData{
    NSString *str=[[NSString alloc]initWithData:responseData encoding:[Helper gbkEncoding]];
//    NSLog(@"%@",str);
    NSString *errorMsg=nil;
    if([str containsString:@"验证码不正确"]){
        errorMsg=@"验证码不正确";
    }else if([str containsString:@"密码错误"]){
        errorMsg=@"密码错误";
    }else if([str containsString:@"用户名不存在或未按照要求参加教学活动"]){
        errorMsg=@"用户名不存在或未按照要求参加教学活动";
    }
    return errorMsg;
}

/**
 *  学生个人信息
 */
-(void)getStudentInformation:(Student*)student completionHandler:(void (^)())completionHandler{
    
    NSString *url=[SYNUAPI generateStudentInformationUrl:student.userSessionID studentID:student.studentID studentName:student.studentName];
    
    [self get:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[Helper gbkEncoding]];
//        NSLog(@"%@",str);
        [student parseStudenInformationWithHtmlData:responseObject];
        completionHandler();
    }];
}

/**
 *  未通过课程
 */
-(void)getUnPassedCourses:(Student*)student completionHandler:(void (^)())completionHandler{
    NSString *url=[SYNUAPI generateStudentCoursesUrl:student.userSessionID studentID:student.studentID studentName:student.studentName];
    [self get:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        student.unPassCourses=[Course coursesFromHtmlData:responseObject];
        completionHandler();
    }];
}

/**
 *  所有课程列表
 */
-(void)getAllCourses:(Student*)student completionHandler:(void (^)())completionHandler{
    NSString *url= [SYNUAPI generateStudentCoursesUrl:student.userSessionID studentID:student.studentID studentName:student.studentName];
    
    [self post:url bodyStr:kAllCoursesBody completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[Helper gbkEncoding]];
//        NSLog(@"%@",str);
        student.historyCourses= [Course coursesFromHtmlData:responseObject];
        completionHandler();
    }];
}

-(void)getScoreStats:(Student*)student completionHandler:(void (^)())completionHandler{
    NSString *url= [SYNUAPI generateStudentCoursesUrl:student.userSessionID studentID:student.studentID studentName:student.studentName];
    [self post:url bodyStr:kScoreStatsBody completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        //        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[Helper gbkEncoding]];
        //        NSLog(@"%@",str);
        student.scoreStats=[[ScoreStats alloc]initWithHtmlData:responseObject];
        completionHandler();
    }];
    
}

/**
 *  获取学生头像图片
 *
 *  @param completionHandler
 */
-(void)getAvatarImage:(Student*)student completionHandler:(void (^)(UIImage *avatarImg))completionHandler{
    [self get:[SYNUAPI generateStudentAvantarUrl:student.userSessionID studentID:student.studentID] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        student.avatarImg=[UIImage imageWithData:responseObject];
        completionHandler(student.avatarImg);
    }];
}



#pragma mark - Private
/**
 *  根据session 获取验证码
 *
 *  @param sessionID
 *  @param completionHandler
 */
-(void)verifyImgWithStudent:(Student*)student completionHandler:(void (^)(UIImage *verifyImg))completionHandler{
    [self get:[SYNUAPI generateCheckCodeUrl:student.userSessionID] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        student.verifyImg= [UIImage imageWithData:responseObject];
        completionHandler(student.verifyImg);
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
    ONOXMLDocument *doc=[Helper docFormData:data];
    ONOXMLElement *element= [doc firstChildWithXPath:kStudentNamePath];
    NSString *studentName=[element stringValue];
        studentName=[studentName stringByReplacingOccurrencesOfString:@"同学" withString:@"" options:0 range:NSMakeRange(0,studentName.length)];
    return studentName;
}

@end
