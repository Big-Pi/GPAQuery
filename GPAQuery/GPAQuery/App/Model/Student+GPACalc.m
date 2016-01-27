//
//  Student+GPACalc.m
//  GPAQuery
//
//  Created by pi on 16/1/27.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "Student+GPACalc.h"

@implementation Student (GPACalc)

-(void)calcGPA{
    [self calcGPA:[self validateCourse]];
}

-(void)calcGPA:(NSArray*)courses{
    float creditSum=0;
    float creditMutiplyGPASum=0;
    
    for (Course *c in courses) {
        float credit= [c.credit floatValue];
        float GPA= [c.GPA floatValue];
        creditSum+=credit;
        creditMutiplyGPASum+=credit*GPA;
    }
//    NSLog(@"%f / 学分:%f",creditMutiplyGPASum,creditSum);
    self.creditSum=[NSString stringWithFormat:@"%f",creditSum];
    self.GPA=[NSString stringWithFormat:@"%f",creditMutiplyGPASum/creditSum];
}

-(NSArray *)validateCourse{
    NSMutableArray *validateCourses=[NSMutableArray array];
    for (Course *c in self.historyCourses) {
        if(c.SYNUCourseType==SYNUCourseTypeHistory){
            continue;
        }
        [self addValidateCoursesPrivate:validateCourses courseToAdd:c];
    }
    return validateCourses;
}

-(void)addValidateCoursesPrivate:(NSMutableArray*)validateCoursesArray courseToAdd:(Course*)c{
    BOOL contains=NO;
    Course *sameCodeCourse;
    for (Course *validateC in validateCoursesArray) {
        if([c.courseCode integerValue]==[validateC.courseCode integerValue]){
            sameCodeCourse=validateC;
            contains=YES;
            break;
        }
    }
    if (!contains) {
        [validateCoursesArray addObject:c];
    }else{
        if(c.GPA&& [c.GPA floatValue]>0.0){
            [validateCoursesArray replaceObjectAtIndex:[validateCoursesArray indexOfObject:sameCodeCourse] withObject:c];
        }else{
            //维持原样。。不添加 c
        }
    }
}

@end
