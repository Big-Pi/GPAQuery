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
#import <Ono.h>
#import <UIKit/UIImage.h>
#import "TouchXML.h"
#import "CXHTMLDocument.h"
#import "CXHTMLDocument+StringValueForXPath.h"


NSString *const kMainPageUrl=@"http://210.30.208.126/";
NSString *const kCheckCodeUrl=@"http://210.30.208.126/(%@)/CheckCode.aspx";
NSString *const kLogInUrl=@"http://210.30.208.126/(%@)/default2.aspx";
NSString *const kLogInBodyUrl=@"__VIEWSTATE=dDwyODE2NTM0OTg7Oz7akNIwXHhlJks4341V36F4cAnbnQ==&txtUserName=%@&TextBox2=%@&txtSecretCode=%@&RadioButtonList1=学生&Button1=&lbLanguage=&hidPdrs=&hidsc=";
NSString *const kManagementSystemMainPageUrl=@"http://210.30.208.126/(%@)/xs_main.aspx?xh=%@";
NSString *const kStudentInformationUrl= @"http://210.30.208.126/(%@)/xsgrxx.aspx?xh=%@&xm=%@&gnmkdm=N121501";
//
NSString *const kStudentIDPath=@"//*[@id='xh']";
NSString *const kSexPath=@"//*[@id='lbl_xb']";
NSString *const kEnterSchoolTimePath=@"//*[@id='lbl_rxrq']";
NSString *const kNationalityPath=@"//*[@id='lbl_mz']";
NSString *const kPoliticalStatusPath=@"//*[@id='lbl_zzmm']";
//NSString *const kProvincePath=@"//*[@id='lbl_lys']";
NSString *const kProvincePath=@"/html/body/form/div[2]/div/span/table[1]/tbody/tr[10]/td[2]/span";
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
    }
    return self;
}
/**
 *  获取验证码图片
 *
 *  @param completionHandler
 */
-(void)getVerifyImageWithcompletionHandler:(void (^)(UIImage *verifyImg))completionHandler{
    [self.net get:kMainPageUrl completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
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
    NSString *logInUrl=[NSString stringWithFormat:kLogInUrl,self.userSessionID];
    NSString *logInBody=[NSString stringWithFormat:kLogInBodyUrl,userName,pwd,checkCode];
    [self.net post:logInUrl body:logInBody completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        self.studentID=userName;
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[NetUtil gbkEncoding]];
//        NSLog(@"%@",str);
        
        [self getStudenInformation];
    }];
}

-(void)getManagementSystemMainPage{
    NSString *url=[NSString stringWithFormat:kManagementSystemMainPageUrl,self.userSessionID,self.studentID];
    [self.net get:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[NetUtil gbkEncoding]];
        NSLog(@"%@",str);
    }];
}

-(void)getStudenInformation{
    self.studentName=@"赵志明";
    NSString *url=[NSString stringWithFormat:kStudentInformationUrl,self.userSessionID,self.studentID,self.studentName];
    [self.net get:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSString *str=[[NSString alloc]initWithData:responseObject encoding:[NetUtil gbkEncoding]];
//        NSLog(@"%@",str);
        [self configWithHtmlData:responseObject];
    }];
}

#pragma mark - Private
-(void)verifyImgWithUserSessionID:(NSString*)sessionID completionHandler:(void (^)(UIImage *verifyImg))completionHandler{
    NSString *checkCodeUrl=[NSString stringWithFormat:kCheckCodeUrl,self.userSessionID];
    [self.net get:checkCodeUrl completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        self.verifyImg= [UIImage imageWithData:responseObject];
        completionHandler(self.verifyImg);
    }];
}

-(NSString*)parseUserIDFromResponse:(NSURLResponse*)response{
    NSArray *pathComponents= response.URL.pathComponents;
    NSString *identifier=pathComponents[1];
    identifier=[identifier stringByReplacingOccurrencesOfString:@"(" withString:@""];
    identifier=[identifier stringByReplacingOccurrencesOfString:@")" withString:@""];
    return identifier;
}


#pragma mark - HTML Parse
-(void)configWithHtmlData:(NSData*)data{
    
    CXHTMLDocument *html=[[CXHTMLDocument alloc]initWithData:data encoding:[NetUtil gbkEncoding] options:CXMLDocumentTidyHTML error:NULL];
    
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
