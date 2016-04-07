//
//  OBJ2ExcelHelper.m
//  GPAQuery
//
//  Created by pi on 16/1/26.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "OBJ2ExcelHelper.h"
#import "JXLS.h"
#import "Course.h"

@implementation OBJ2ExcelHelper
+ (void)generateExcelWithName:(NSString*)name courses:(NSArray*)array completion:(void (^)())completion
{
//    NSString *filePath = @"/tmp/foo.xls";
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    if(![name hasSuffix:@"xls"]){
        name=[name stringByAppendingString:@".xls"];
    }
    filePath=[filePath stringByAppendingPathComponent:name];
    //
    JXLSWorkBook *workBook = [JXLSWorkBook new];
    JXLSWorkSheet *workSheet = [workBook workSheetWithName:@"成绩信息"];
    
    NSInteger count=array.count;
    
    [workSheet setCellAtRow:0 column:0 toString:@"学年"];
    [workSheet setCellAtRow:0 column:1 toString:@"学期"];
    [workSheet setCellAtRow:0 column:2 toString:@"课程代码"];
    [workSheet setWidth:12000 forColumn:3 defaultFormat:NULL];
    [workSheet setCellAtRow:0 column:3 toString:@"课程名称"];
    [workSheet setCellAtRow:0 column:4 toString:@"课程性质"];
    //
    [workSheet setCellAtRow:0 column:5 toString:@"课程归属"];
    [workSheet setCellAtRow:0 column:6 toString:@"学分"];
    [workSheet setCellAtRow:0 column:7 toString:@"绩点"];
    [workSheet setCellAtRow:0 column:8 toString:@"成绩"];
    [workSheet setCellAtRow:0 column:9 toString:@"辅修标记"];
    //
    [workSheet setCellAtRow:0 column:10 toString:@"补考成绩"];
    [workSheet setCellAtRow:0 column:11 toString:@"重修成绩"];
    [workSheet setWidth:6500 forColumn:12 defaultFormat:NULL];
    [workSheet setCellAtRow:0 column:12 toString:@"开课学院"];
    [workSheet setCellAtRow:0 column:13 toString:@"备注"];
    [workSheet setCellAtRow:0 column:14 toString:@"重修标记"];
    //
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
    

    for(NSInteger idx=1;idx<count;idx++){
        Course *c=array[idx];
        [workSheet setCellAtRow:idx column:0 toString:c.year];
        [workSheet setCellAtRow:idx column:1 toString:c.term];
        [workSheet setCellAtRow:idx column:2 toString:c.courseCode];
        [workSheet setCellAtRow:idx column:3 toString:c.courseName];
        [workSheet setCellAtRow:idx column:4 toString:c.courseType];
        //
        [workSheet setCellAtRow:idx column:5 toString:c.courseSubType];
        [workSheet setCellAtRow:idx column:6 toString:c.credit];
        [workSheet setCellAtRow:idx column:7 toString:c.GPA];
        [workSheet setCellAtRow:idx column:8 toString:c.score];
        [workSheet setCellAtRow:idx column:9 toString:c.tag];
        //
        [workSheet setCellAtRow:idx column:10 toString:c.scoreMakeUp];
        [workSheet setCellAtRow:idx column:11 toString:c.scoreRetake];
        [workSheet setCellAtRow:idx column:12 toString:c.institute];
        [workSheet setCellAtRow:idx column:13 toString:c.mark];
        [workSheet setCellAtRow:idx column:14 toString:c.retakeTag];
    }
#pragma clang diagnostic pop    
    int fud = [workBook writeToFile:filePath];
    
    NSLog(@"OK - bye! fud=%d", fud);
    completion();
}
@end
