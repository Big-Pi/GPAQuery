//
//  UnPassCourseCell.h
//  GPAQuery
//
//  Created by pi on 16/1/27.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Course;

@interface UnPassCourseCell : UITableViewCell
-(void)configWithCourse:(Course*)c;
@end
