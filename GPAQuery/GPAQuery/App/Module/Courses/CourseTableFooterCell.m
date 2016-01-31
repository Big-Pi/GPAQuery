//
//  CourseTableFooterCell.m
//  GPAQuery
//
//  Created by pi on 16/1/27.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CourseTableFooterCell.h"
#import "Student.h"

@interface CourseTableFooterCell ()
@property (weak, nonatomic) IBOutlet UILabel *creditSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *GPALabel;
@end

@implementation CourseTableFooterCell
-(void)configCellWithStudent:(Student*)student{
    self.creditSumLabel.text=student.creditSum;
    self.GPALabel.text=student.GPA;
}

@end
