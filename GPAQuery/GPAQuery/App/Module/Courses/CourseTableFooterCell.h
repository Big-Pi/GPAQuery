//
//  CourseTableFooterCell.h
//  GPAQuery
//
//  Created by pi on 16/1/27.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Student;
@interface CourseTableFooterCell : UITableViewCell
-(void)configCellWithStudent:(Student*)student;
@end
