//
//  SYNUAPI.m
//  GPAQuery
//
//  Created by pi on 16/1/16.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "SYNUAPI.h"

@implementation SYNUAPI

NSString *const kHost=@"http://210.30.208.126/";
//NSString *const kHost=@"http://210.30.208.126/";

NSString *const kCheckCode=@"(%@)/CheckCode.aspx";//获取验证码

NSString *const kLogIn=@"(%@)/default2.aspx";//登录教务处的地址
NSString *const kLogInBody=@"__VIEWSTATE=dDwyODE2NTM0OTg7Oz7akNIwXHhlJks4341V36F4cAnbnQ==&txtUserName=%@&TextBox2=%@&txtSecretCode=%@&RadioButtonList1=学生&Button1=&lbLanguage=&hidPdrs=&hidsc=";//登录教务处的body
NSString *const kManagementSystemMainPage=@"(%@)/xs_main.aspx?xh=%@";//教务管理系统的首页
NSString *const kStudentAvantar=@"(%@)/readimagexs.aspx?xh=%@";//学生头像
NSString *const kStudentInformation= @"(%@)/xsgrxx.aspx?xh=%@&xm=%@&gnmkdm=N121501";//学生个人信息页面


+(NSString*)generateCheckCodeUrl:(NSString*)sessionID{
    return [NSString stringWithFormat:[kHost stringByAppendingPathComponent:kCheckCode],sessionID];
}

+(NSString*)generateLogInUrl:(NSString*)sessionID{
    return [NSString stringWithFormat:[kHost stringByAppendingPathComponent:kLogIn],sessionID];
}

+(NSString*)generateLogInBody:(NSString*)userName pwd:(NSString*)pwd checkCode:(NSString*)checkCode {
    return [NSString stringWithFormat:[kHost stringByAppendingPathComponent:kLogInBody],userName,pwd,checkCode];
}

+(NSString*)generateStudentInformationUrl:(NSString*)sessionID studentID:(NSString*)studentID studentName:(NSString*)studentName{
    return [NSString stringWithFormat:[kHost stringByAppendingPathComponent:kLogIn],sessionID];
}

+(NSString*)generateStudentInformationUrl:(NSString*)sessionID studentID:(NSString*)studentID {
    return [NSString stringWithFormat:[kHost stringByAppendingPathComponent:kStudentAvantar],sessionID,studentID];
}
@end
