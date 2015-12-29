//
//  Student.m
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Student.h"
#import "NetUtil.h"
#import <UIKit/UIImage.h>
NSString *const kMainPageUrl=@"http://210.30.208.126/";
NSString *const kCheckCodeUrl=@"http://210.30.208.126/(%@)/CheckCode.aspx";
NSString *const kLogInUrl=@"http://210.30.208.126/(%@)/default2.aspx";
NSString *const kLogInBody=@"__VIEWSTATE=dDwyODE2NTM0OTg7Oz7akNIwXHhlJks4341V36F4cAnbnQ==&txtUserName=%@&TextBox2=%@&txtSecretCode=%@&RadioButtonList1=学生&Button1=&lbLanguage=&hidPdrs=&hidsc=";

@interface Student ()
@property (strong,nonatomic) NetUtil *net;
@property (copy,nonatomic) NSString *userSessionID;
@property (strong,nonatomic) UIImage *verifyImg;
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

-(void)getVerifyImageWithcompletionHandler:(void (^)(UIImage *verifyImg))completionHandler{
    [self.net get:kMainPageUrl completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        self.userSessionID= [self parseUserIDFromResponse:response];
        [self verifyImgWithUserSessionID:self.userSessionID completionHandler:completionHandler];
    }];
}

-(void)logInWithUserName:(NSString*)userName pwd:(NSString*)pwd checkCode:(NSString*)checkCode{
    NSString *logInUrl=[NSString stringWithFormat:kLogInUrl,self.userSessionID];
    NSString *logInBody=[NSString stringWithFormat:kLogInBody,userName,pwd,checkCode];
    [self.net post:logInUrl body:logInBody completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:gbkEncoding];
        NSLog(@"%@",str);
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

@end
