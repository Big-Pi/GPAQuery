//
//  CoursesTableController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CoursesTableController.h"
#import "Student.h"
#import "NetUtil+SYNUNetWorking.h"

@implementation CoursesTableController
-(void)viewDidLoad{
    [super viewDidLoad];
    [[NetUtil sharedNetUtil]getAllCourses:self.student completionHandler:^{
        
    }];
}
@end
