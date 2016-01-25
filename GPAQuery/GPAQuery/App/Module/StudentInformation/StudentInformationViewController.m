//
//  StudentInformationViewController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "StudentInformationViewController.h"
#import "StudentHeader.h"
#import "StudentInformationCell.h"
#import <VGParallaxHeader/UIScrollView+VGParallaxHeader.h>

@interface StudentInformationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *dataArray;
@end

@implementation StudentInformationViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%@",@"学生信息 Load");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentInformationCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    UIView *header= [[StudentHeader alloc]initWithStudent:self.student];
    [self.tableView setParallaxHeaderView:header mode:VGParallaxHeaderModeFill height:200];
    
    if(self.student.grade && self.student.major){
        self.dataArray=[self buildDataFromStudent:self.student];
        [self.tableView reloadData];
    }else{
        [self reloadData:self.student];
    }
    
}

#pragma mark - Private
-(void)reloadData:(Student*)student{
    [SpinnerHud showInView:self.view];
    [self.netUtil getStudentInformation:self.student completionHandler:^{
        [SpinnerHud hide];
        self.dataArray=[self buildDataFromStudent:self.student];
        [self.tableView reloadData];
    }];
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentInformationCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *dict=self.dataArray[indexPath.row];
    [cell configCellWithDataDict:dict];
    return cell;
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView shouldPositionParallaxHeader];
}

#pragma mark - Private
-(NSArray *)buildDataFromStudent:(Student*)student{
    NSArray *data=@[@{@"年级":student.grade},
                    @{@"所学专业":student.major},
                    @{@"民族":student.nationality},
                    @{@"学历":student.education},
                    @{@"学籍":student.schoolRoll},
                    @{@"来源省":student.province},
                    @{@"政治面貌":student.politicalStatus},
                    @{@"入学时间":student.enterSchoolTime}];
    return data;
}
@end
