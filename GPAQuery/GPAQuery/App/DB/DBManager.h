//
//  DBManager.h
//  GPAQuery
//
//  Created by pi on 16/4/4.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@class Student;
@class Course;


@interface DBManager : NSObject
+(instancetype)sharedDBManager;
-(BOOL)close;
#pragma mark - 

-(void)insertStudent:(Student*)stu;

-(void)insertCourse:(Course*)course;

-(void)batchInsertCourses:(NSArray*)courses;

-(void)queryStudentByStudentID:(Student*)stu;

-(NSArray*)queryCoursesForStudent:(Student*)student;

-(void)deleteStudent:(Student*)student;

-(void)deleteCoursesForStudent:(Student*)student;
@end
