//
//  StudentInformationViewController.h
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class Student;

@interface StudentInformationViewController :UITableViewController
@property (strong,nonatomic) Student *student;
@end
