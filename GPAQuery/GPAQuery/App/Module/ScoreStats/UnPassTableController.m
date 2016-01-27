//
//  UnPassTableController.m
//  GPAQuery
//
//  Created by pi on 16/1/27.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UnPassTableController.h"
#import "UnPassCourseCell.h"

@interface UnPassTableController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSArray *course;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UnPassTableController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"UnPassCourseCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.netUtil getUnPassedCourses:self.student completionHandler:^{
        self.course=self.student.unPassCourses;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }];
}
#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.course.count>0 ? 1 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.course.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UnPassCourseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Course *c=self.course[indexPath.row];
    [cell configWithCourse:c];
    return cell;
}
@end
