//
//  Student.h
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface Student : NSObject
@property (strong,nonatomic,readonly) UIImage *verifyImg;//验证码图片
@property (strong,nonatomic,readonly) UIImage *avatarImg;//头像图片
@property (copy,nonatomic,readonly) NSString *userSessionID;

//
@property (copy,nonatomic,readonly) NSString *studentID;//学号
@property (copy,nonatomic,readonly) NSString *studentName;//学生姓名
@property (copy,nonatomic,readonly) NSString *grade;//年级 2012级
@property (copy,nonatomic,readonly) NSString *nationality;//民族
@property (copy,nonatomic,readonly) NSString *schoolSystem;//学制 4年制
@property (copy,nonatomic,readonly) NSString *education;//学历
@property (copy,nonatomic,readonly) NSString *schoolRoll;//学籍 有
@property (copy,nonatomic,readonly) NSString *learningForm;//学习形式 普通全日制
@property (copy,nonatomic,readonly) NSString *province;//来源省
@property (copy,nonatomic,readonly) NSString *class;//行政班 嵌入式12-1
@property (copy,nonatomic,readonly) NSString *politicalStatus;//政治面貌
@property (copy,nonatomic,readonly) NSString *major;//所学专业
@property (copy,nonatomic,readonly) NSString *sex;//性别
@property (copy,nonatomic,readonly) NSString *enterSchoolTime;//入学时间

-(void)getVerifyImageWithCompletionHandler:(void (^)(UIImage *verifyImg))completionHandler;
-(void)logInWithUserName:(NSString*)userName pwd:(NSString*)pwd checkCode:(NSString*)checkCode;
@end
