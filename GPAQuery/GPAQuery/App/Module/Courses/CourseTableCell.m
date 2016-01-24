//
//  CourseTableCell.m
//  GPAQuery
//
//  Created by pi on 16/1/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CourseTableCell.h"
#import "Course.h"

@interface CourseTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CourseTableCell

-(void)configWithCourse:(Course*)course{
    self.yearLabel.text=course.year;
    self.courseNameLabel.text=course.courseName;
    self.creditLabel.text=course.credit;
    self.scoreLabel.text=course.score;
}

@end
