//
//  Student.m
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Student.h"
#import <UIKit/UIImage.h>
#import "Helper.h"
#import "Ono.h"


#pragma mark - XPaths
NSString *const kStudentIDPath=@"//*[@id='xh']";
NSString *const kStudentNamePath=@"//*[@id='xhxm']";
NSString *const kSexPath=@"//*[@id='lbl_xb']";
NSString *const kEnterSchoolTimePath=@"//*[@id='lbl_rxrq']";
NSString *const kNationalityPath=@"//*[@id='lbl_mz']";
NSString *const kPoliticalStatusPath=@"//*[@id='lbl_zzmm']";
NSString *const kProvincePath=@"//*[@id='lbl_lys']";
NSString *const kMajor=@"//*[@id='lbl_zymc']";
NSString *const kClass=@"//*[@id='lbl_xzb']";
NSString *const kEducation=@"//*[@id='lbl_CC']";
NSString *const kSchoolRoll=@"//*[@id='lbl_xjzt']";
NSString *const kGrade=@"//*[@id='lbl_dqszj']";

@interface Student ()
@end

@implementation Student


-(void)setHistoryCourses:(NSArray *)historyCourses{
    _historyCourses=historyCourses;
    _historyGPACalcCourses=[self validateCourse];
    [self calcGPA:_historyGPACalcCourses];
}

#pragma mark - Private
-(NSArray *)validateCourse{
    NSMutableArray *validateCourses=[NSMutableArray array];
    for (Course *c in _historyCourses) {
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
    self.creditSum=[NSString stringWithFormat:@"%.1f",creditSum];
    self.GPA=[NSString stringWithFormat:@"%.2f",creditMutiplyGPASum/creditSum];
}

#pragma mark - HTML Parse
-(void)parseStudenInformationWithHtmlData:(NSData*)data{
    ONOXMLDocument *doc= [Helper docFormData:data];
    self.studentID =[doc stringValueForXPath:kStudentIDPath];
    self.sex =[doc stringValueForXPath:kSexPath];
    self.enterSchoolTime =[doc stringValueForXPath:kEnterSchoolTimePath];
    self.nationality =[doc stringValueForXPath:kNationalityPath];
    self.politicalStatus =[doc stringValueForXPath:kPoliticalStatusPath];
    self.province =[doc stringValueForXPath:kProvincePath];
    self.major=[doc stringValueForXPath:kMajor];
    self.class0 =[doc stringValueForXPath:kClass];
    self.education =[doc stringValueForXPath:kEducation];
    self.schoolRoll =[doc stringValueForXPath:kSchoolRoll];
    self.grade =[doc stringValueForXPath:kGrade];
}

@end
