//
//  DBManager.m
//  GPAQuery
//
//  Created by pi on 16/4/4.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "DBManager.h"
#import "Helper.h"
#import "Student.h"
#import "Course.h"
@import UIKit;

NSString *const kCreateStudentScoreTableSQL=@"CREATE TABLE    \"StudentScore\" (\n\
                                                                \"id\" INTEGER NOT NULL,\n\
                                                                \"studentID\" TEXT,\n\
                                                                \"year\" TEXT,\n\
                                                                \"term\" TEXT,\n\
                                                                \"courseCode\" TEXT,\n\
                                                                \"courseName\" TEXT,\n\
                                                                \"courseType\" integer,\n\
                                                                \"courseSubType\" TEXT,\n\
                                                                \"credit\" integer,\n\
                                                                \"GPA\" TEXT,\n\
                                                                \"score\" TEXT,\n\
                                                                \"tag\" TEXT,\n\
                                                                \"scoreMakeUp\" TEXT,\n\
                                                                \"scoreRetake\" TEXT,\n\
                                                                \"institute\" TEXT,\n\
                                                                \"mark\" TEXT,\n\
                                                                \"retakeTag\" TEXT,\n\
                                                                \"bestScore\" integer,\n\
                                                                \"SYNUCourseType\" integer,\n\
                                                                PRIMARY KEY(\"id\")\n\
                                                                )";

NSString *const kCreateStudentInformationTableSQL=@"CREATE TABLE \"StudentInformation\" (\n\
                                                                    \"id\" integer NOT NULL,\n\
                                                                    \"studentID\" TEXT,\n\
                                                                    \"studentName\" TEXT,\n\
                                                                    \"sex\" TEXT,\n\
                                                                    \"grade\" TEXT,\n\
                                                                    \"nationality\" TEXT,\n\
                                                                    \"education\" TEXT,\n\
                                                                    \"schoolRoll\" TEXT,\n\
                                                                    \"province\" TEXT,\n\
                                                                    \"class0\" TEXT,\n\
                                                                    \"politicalStatus\" TEXT,\n\
                                                                    \"major\" TEXT,\n\
                                                                    \"enterSchoolTime\" TEXT,\n\
                                                                    \"GPA\" TEXT,\n\
                                                                    \"creditSum\" TEXT,\n\
                                                                    \"avatarImg\" blob,\n\
                                                                    PRIMARY KEY(\"id\")\n\
                                                                    )";

//\"StudentInformation\".\"id\",\n\

NSString *const kQueryStudentSQL = @"SELECT \n\
                                            \"StudentInformation\".\"studentID\",\n\
                                            \"StudentInformation\".\"studentName\",\n\
                                            \"StudentInformation\".\"sex\",\n\
                                            \"StudentInformation\".\"grade\",\n\
                                            \"StudentInformation\".\"nationality\",\n\
                                            \"StudentInformation\".\"education\",\n\
                                            \"StudentInformation\".\"schoolRoll\",\n\
                                            \"StudentInformation\".\"province\",\n\
                                            \"StudentInformation\".\"class0\",\n\
                                            \"StudentInformation\".\"politicalStatus\",\n\
                                            \"StudentInformation\".\"major\",\n\
                                            \"StudentInformation\".\"enterSchoolTime\",\n\
                                            \"StudentInformation\".\"GPA\",\n\
                                            \"StudentInformation\".\"creditSum\",\n\
                                            \"StudentInformation\".\"avatarImg\"\n\
                                            FROM\n\
                                            \"StudentInformation\"";

//\"StudentScore\".\"id\",\n\

NSString *const kQueryCoursesSQL=@"SELECT \n\
                                            \"StudentScore\".\"year\",\n\
                                            \"StudentScore\".\"term\",\n\
                                            \"StudentScore\".\"courseCode\",\n\
                                            \"StudentScore\".\"courseName\",\n\
                                            \"StudentScore\".\"courseType\",\n\
                                            \"StudentScore\".\"courseSubType\",\n\
                                            \"StudentScore\".\"credit\",\n\
                                            \"StudentScore\".\"GPA\",\n\
                                            \"StudentScore\".\"score\",\n\
                                            \"StudentScore\".\"tag\",\n\
                                            \"StudentScore\".\"scoreMakeUp\",\n\
                                            \"StudentScore\".\"scoreRetake\",\n\
                                            \"StudentScore\".\"institute\",\n\
                                            \"StudentScore\".\"mark\",\n\
                                            \"StudentScore\".\"retakeTag\",\n\
                                            \"StudentScore\".\"bestScore\",\n\
                                            \"StudentScore\".\"SYNUCourseType\"\n\
                                            FROM\n\
                                            \"StudentScore\"\n\
                                            WHERE\n\
                                            studentID=?";

NSString *const kInsertStudentSQL=@"INSERT OR REPLACE INTO StudentInformation (studentID,studentName,sex,grade,nationality,education,schoolRoll,province,class0,politicalStatus,major,enterSchoolTime,GPA,creditSum,avatarImg) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

NSString *const kInsertCourseSQL=@"INSERT OR REPLACE INTO StudentScore (studentID,year,term,courseCode,courseName,courseType,courseSubType,credit,GPA,score,tag,scoreMakeUp,scoreRetake,institute,mark,retakeTag,bestScore,SYNUCourseType) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

NSString *const kDeleteStudentSQL=@"DELETE from StudentInformation where studentID=?";
NSString *const kDeleteScoreSQL=@"DELETE from StudentScore where studentID=?";


@interface DBManager ()
@property (copy,nonatomic) NSString *dbPath;
@property (strong,nonatomic) FMDatabase *db;
@end

@implementation DBManager

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark -
-(NSString *)dbPath{
    if(!_dbPath){
        _dbPath= [[Helper AppDocumentDirectory] stringByAppendingPathComponent:@"SYNU.db"];
    }
    return _dbPath;
}

+(instancetype)sharedDBManager{
    static id _dbManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dbManager=[DBManager new];
    });
    return _dbManager;
}

-(FMDatabase *)db{
    if(!_db){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL exist = [fileManager fileExistsAtPath:self.dbPath]; //如果不存在,就是第一次进入 App, 需要创建表
        
        _db= [FMDatabase databaseWithPath:self.dbPath];
        if(!exist){
            NSLog(@"需要创建表");
            if ([_db open]) {
            
                BOOL createScoreSucess = [_db executeUpdate:kCreateStudentScoreTableSQL];
                BOOL createImformationSucess=[_db executeUpdate:kCreateStudentInformationTableSQL];
                if(createScoreSucess && createImformationSucess){
                    NSLog(@"表创建成功");
                }else{
                    NSLog(@"表创建失败:%@",[_db lastErrorMessage]);
                }
            }
        }
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    if([_db open]){
        return _db;
    }else{
        NSLog(@"数据库打开失败:%@",[_db lastErrorMessage]);
        return nil;
    }
}

-(BOOL)close{
    return [self.db close];
}

-(void)appResignActiveNotification:(NSNotification*)noti{
    [_db close];
}

#pragma mark - 

-(void)insertStudent:(Student*)stu{
    NSData *imgData =UIImagePNGRepresentation(stu.avatarImg);
    [self.db executeUpdate:kInsertStudentSQL,stu.studentID,stu.studentName,stu.sex,stu.grade,stu.nationality,stu.education,stu.schoolRoll,stu.province,stu.class0,stu.politicalStatus,stu.major,stu.enterSchoolTime,stu.GPA,stu.creditSum,imgData ];
    
}

-(void)insertCourse:(Course*)course{
    [self.db executeUpdate:kInsertCourseSQL,course.studentID,course.year,course.term,course.courseCode,course.courseName,course.courseType,course.courseSubType,course.credit,course.GPA,course.score,course.tag,course.scoreMakeUp,course.scoreRetake,course.institute,course.mark,course.retakeTag,course.bestScore,@(course.SYNUCourseType)];
}

-(void)batchInsertCourses:(NSArray*)courses{
    [self.db beginTransaction];
    [courses enumerateObjectsUsingBlock:^(Course *c, NSUInteger idx, BOOL * _Nonnull stop) {
        [self insertCourse:c];
    }];
    [self.db commit];
}

-(void)queryStudentByStudentID:(Student*)stu{
    FMResultSet *resultSet=[self.db executeQuery:kQueryStudentSQL];
    if([resultSet next]){
        stu.studentID=[resultSet stringForColumnIndex:0];
        stu.studentName=[resultSet stringForColumnIndex:1];
        stu.sex=[resultSet stringForColumnIndex:2];
        stu.grade=[resultSet stringForColumnIndex:3];
        stu.nationality=[resultSet stringForColumnIndex:4];
        stu.education=[resultSet stringForColumnIndex:5];
        stu.schoolRoll=[resultSet stringForColumnIndex:6];
        stu.province=[resultSet stringForColumnIndex:7];
        stu.class0=[resultSet stringForColumnIndex:8];
        stu.politicalStatus=[resultSet stringForColumnIndex:9];
        stu.major=[resultSet stringForColumnIndex:10];
        stu.enterSchoolTime=[resultSet stringForColumnIndex:11];
        stu.GPA=[resultSet stringForColumnIndex:12];
        stu.creditSum=[resultSet stringForColumnIndex:13];
        stu.avatarImg=[UIImage imageWithData:[resultSet dataForColumnIndex:14]];
    }
}

-(NSArray*)queryCoursesForStudent:(Student*)student{
    NSMutableArray *courses= [NSMutableArray array];
    FMResultSet *resultSet = [self.db executeQuery:kQueryCoursesSQL,student.studentID];
    while ([resultSet next]) {
        Course *c=[Course new];
        c.year=[resultSet stringForColumnIndex:0];
        c.term=[resultSet stringForColumnIndex:1];
        c.courseCode=[resultSet stringForColumnIndex:2];
        c.courseName=[resultSet stringForColumnIndex:3];
        c.courseType=[resultSet stringForColumnIndex:4];
        c.courseSubType=[resultSet stringForColumnIndex:5];
        c.credit=[resultSet stringForColumnIndex:6];
        c.GPA=[resultSet stringForColumnIndex:7];
        c.score=[resultSet stringForColumnIndex:8];
        c.tag=[resultSet stringForColumnIndex:9];
        c.scoreMakeUp=[resultSet stringForColumnIndex:10];
        c.scoreRetake=[resultSet stringForColumnIndex:11];
        c.institute=[resultSet stringForColumnIndex:12];
        c.mark=[resultSet stringForColumnIndex:13];
        c.retakeTag=[resultSet stringForColumnIndex:14];
        c.bestScore=[resultSet stringForColumnIndex:15];
        c.SYNUCourseType=[resultSet intForColumnIndex:16];
        [courses addObject:c];
    }
    return courses;
}

-(void)deleteStudent:(Student*)student{
    [self.db executeUpdate:kDeleteStudentSQL,student.studentID];
}

-(void)deleteCoursesForStudent:(Student*)student{
    [self.db executeUpdate:kDeleteScoreSQL,student.studentID];
}
@end
