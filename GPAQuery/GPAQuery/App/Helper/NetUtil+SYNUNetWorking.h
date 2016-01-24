//
//  NetUtil+SYNUNetWorking.h
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NetUtil.h"
@import UIKit;
@class Student;

@interface NetUtil (SYNUNetWorking)
-(void)getVerifyImageWithStudent:(Student*)student completionHandler:(void (^)(UIImage *verifyImg))completionHandler;
-(void)logInWithStudent:(Student*)student completionHandler:(void (^)())completionHandler;
-(void)getStudentInformation:(Student*)student completionHandler:(void (^)())completionHandler;

-(void)getUnPassedCourses:(Student*)student completionHandler:(void (^)())completionHandler;

-(void)getAllCourses:(Student*)student completionHandler:(void (^)())completionHandler;

-(void)getScoreStats:(Student*)student completionHandler:(void (^)())completionHandler;

-(void)getAvatarImage:(Student*)student completionHandler:(void (^)(UIImage *avatarImg))completionHandler;
@end
