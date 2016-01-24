//
//  CourseTableCell.h
//  GPAQuery
//
//  Created by pi on 16/1/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Course;
@interface CourseTableCell : UITableViewCell
-(void)configWithCourse:(Course*)course;
@end
