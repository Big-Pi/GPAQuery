//
//  CoursesTableController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CoursesTableController.h"
#import "CourseTableCell.h"
#import "OBJ2ExcelHelper.h"
#import "CourseTableFooterCell.h"
#import "CourseDetailTableController.h"

@interface CoursesTableController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *courses;
@property (assign,nonatomic) BOOL showAllHistoryCourses;
@end

@implementation CoursesTableController
-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%@",@"表格 Load");
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseTableCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseTableFooterCell" bundle:nil] forCellReuseIdentifier:@"FooterCell"];

    //
    if(self.student.historyCourses && self.student.historyCourses.count>0){
        [self updateUI];
    }else{
        [self reloadData:self.student];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupBasicMenu];
}

#pragma mark - Private
-(void)reloadData:(Student*)student{
    [SpinnerHud showInView:self.view];
    [self.netUtil getAllCourses:self.student completionHandler:^{
        [SpinnerHud hide];
        [self updateUI];
    }];
}

-(void)updateUI{
    self.courses=self.student.historyGPACalcCourses;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
        self.tableView.tableHeaderView=[self.tableView dequeueReusableCellWithIdentifier:@"Cell"].contentView;
    CourseTableFooterCell *footerCell=[self.tableView dequeueReusableCellWithIdentifier:@"FooterCell"];
    [footerCell configCellWithStudent:self.student];
        self.tableView.tableFooterView=footerCell.contentView;
}

-(void)addMenu{
    REMenuItem *refreshItem = [[REMenuItem alloc] initWithTitle:@"刷新"
                                                       subtitle:@""
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self reloadData:self.student];
                                                         }];
    //显示哪个 item
    REMenuItem *showCoursesItem ;
    if(self.showAllHistoryCourses){
        showCoursesItem = [[REMenuItem alloc] initWithTitle:@"去除绩点无关课程"
                                                 subtitle:@""
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
                                                       self.showAllHistoryCourses=!self.showAllHistoryCourses;
                                                       self.courses=self.student.historyGPACalcCourses;
                                                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
                                                       [self addMenu];
                                                   }];
    }else{
        showCoursesItem = [[REMenuItem alloc] initWithTitle:@"显示全部课程"
                                                  subtitle:@""
                                                     image:nil
                                          highlightedImage:nil
                                                    action:^(REMenuItem *item) {
                                                        self.showAllHistoryCourses=!self.showAllHistoryCourses;
                                                        self.courses=self.student.historyCourses;
                                                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
                                                         [self addMenu];
                                                    }];
    }
    REMenuItem *shareItem = [[REMenuItem alloc] initWithTitle:@"分享"
                                                     subtitle:@""
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           [self share:@"CoursesChartController"];
                                                       }];
    REMenuItem *saveDataItem = [[REMenuItem alloc] initWithTitle:@"保存成绩为Excel"
                                                         subtitle:@""
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                               [OBJ2ExcelHelper generateExcelWithName:self.student.studentID courses:self.student.historyCourses completion:^{
                                                                   [MBProgressHUD showMsg:@"成绩信息已保存到文档目录" forSeconds:1.5];
                                                               }];
                                                           }];
    self.menu= [[REMenu alloc]initWithItems:@[refreshItem,showCoursesItem,shareItem,saveDataItem]];
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courses.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:@"CourseDetail" sender:self.student];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell configWithCourse:self.courses[indexPath.row]];
    return cell;
}

#pragma mark - 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"CourseDetail"]){
        UINavigationController *navc=segue.destinationViewController;
        CourseDetailTableController *detailVC=(CourseDetailTableController*) navc.topViewController;
        if([sender isKindOfClass:[Student class]]){
            detailVC.student=sender;
        }
    }
}
@end
