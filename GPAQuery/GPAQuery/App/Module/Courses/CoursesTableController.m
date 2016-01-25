//
//  CoursesTableController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CoursesTableController.h"
#import "CourseTableCell.h"

@interface CoursesTableController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *historyCourses;
@end

@implementation CoursesTableController
-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%@",@"表格 Load");
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseTableCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseTableHeaderCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    //
    if(self.student.historyCourses && self.student.historyCourses.count>0){
        self.historyCourses=self.student.historyCourses;
        [self.tableView reloadData];
    }else{
        [self reloadData:self.student];
    }
    
}

#pragma mark - Private
-(void)reloadData:(Student*)student{
    [SpinnerHud showInView:self.view];
    [self.netUtil getAllCourses:self.student completionHandler:^{
        [SpinnerHud hide];
        self.historyCourses=self.student.historyCourses;
        [self.tableView reloadData];
    }];
}
#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyCourses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell configWithCourse:self.historyCourses[indexPath.row]];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    return cell;
}
@end
