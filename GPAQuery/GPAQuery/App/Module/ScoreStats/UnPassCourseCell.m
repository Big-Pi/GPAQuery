//
//  UnPassCourseCell.m
//  GPAQuery
//
//  Created by pi on 16/1/27.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UnPassCourseCell.h"
#import "Course.h"

@interface UnPassCourseCell ()
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestScoreLabel;
@end

@implementation UnPassCourseCell
-(void)configWithCourse:(Course*)c{
    self.courseNameLabel.text=c.courseName;
    self.courseTypeLabel.text=c.courseType;
    self.creditLabel.text=c.credit;
    self.bestScoreLabel.text=c.bestScore;
}
@end
