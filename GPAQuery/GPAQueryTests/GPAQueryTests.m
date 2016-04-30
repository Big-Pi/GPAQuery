//
//  GPAQueryTests.m
//  GPAQueryTests
//
//  Created by pi on 15/12/17.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DBManager.h"
#import "Student.h"
#import "Course.h"
#import "NetUtil+SYNUNetWorking.h"
#import "Helper.h"

@interface GPAQueryTests : XCTestCase

@end

@implementation GPAQueryTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {

    [super tearDown];
}

#pragma mark - DB

- (void)testInformation {
    Student *stu=[Student new];
    stu.studentID=@"12999029";
    stu.studentName=@"呵呵哒";
    stu.sex=@"男";
    stu.grade=@"2012";
    stu.nationality=@"辽宁省";
    stu.education=@"本科";
    stu.schoolRoll=@"1";
    stu.province=@"辽宁省";
    stu.class0=@"嵌入式12-1";
    stu.politicalStatus=@"共青团员";
    stu.major=@"嵌入式";
    stu.enterSchoolTime=@"2012-09-01";
    stu.GPA=@"1.6";
    stu.creditSum=@"125";
    stu.avatarImg=[UIImage imageNamed:@"Logo"];
    [[DBManager sharedDBManager]insertStudent:stu]; //插入一条学生信息数据

    Student *queryStu=[Student new];
    queryStu.studentID=@"12999029";
    [[DBManager sharedDBManager]queryStudentByStudentID:queryStu];//查询学生信息数据
    
    XCTAssertNotNil(queryStu.studentName); //断言 学生数据不为空
    
    [[DBManager sharedDBManager]deleteStudent:queryStu]; //删除学生信息数据
}

- (void)testScore {
    Course *c=[Course new];
    c.studentID=@"12999029";
    c.year=@"2012-2013";
    c.term=@"1";
    c.courseCode=@"00000508";
    c.courseName=@"体育1";
    c.courseType=@"通识必修";
    c.courseSubType=@"";
    c.credit=@"1";
    c.GPA=@"3";
    c.score=@"83";
    
    [[DBManager sharedDBManager]batchInsertCourses:@[c,c,c,c,c,c,c]]; //插入学生课程数据

    Student *queryStu=[Student new];
    queryStu.studentID=@"12999029";
    NSArray *courses= [[DBManager sharedDBManager]queryCoursesForStudent:queryStu];//查询学生课程数据
    
    XCTAssertGreaterThanOrEqual(courses.count, 1); //断言查询的课程数据不为空
    
    [[DBManager sharedDBManager]deleteCoursesForStudent:queryStu];//删除课程数据
}

#pragma mark - 排序算法
-(void)testSortAlgorthim{
    NSArray *randomNumber=@[@2,@15,@8,@-10,@0,@88,@6,@59,@7,@12,@3,@29,@16,@18,@7,@12,@6,@0];
    randomNumber=[Helper sort:randomNumber];
    NSLog(@"%@",randomNumber);
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        
    }];
}

@end
