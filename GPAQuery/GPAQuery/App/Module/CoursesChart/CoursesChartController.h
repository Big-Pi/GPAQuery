//
//  CoursesChartController.h
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CoursesChartController : BaseViewController
@property (assign,nonatomic) BOOL showAllHistoryCourses;
-(void)strokeBarChartWithCourses:(NSArray*)courses;
@end
