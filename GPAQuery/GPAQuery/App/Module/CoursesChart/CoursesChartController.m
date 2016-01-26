//
//  CoursesChartController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CoursesChartController.h"
#import "Course.h"

@import Charts;

@interface CoursesChartController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) HorizontalBarChartView *barChart;
@end

@implementation CoursesChartController
-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%@",@"成绩图表 Load");
    self.barChart.noDataText=@"正在努力加载解析~";
    self.barChart.descriptionText=@"";
    
    if(self.student.historyCourses && self.student.historyCourses.count>0){
        [self strokeBarChartWithCourses:self.student.historyCourses];
    }else{
        [self reloadData:self.student];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupBasicMenu];
}

-(HorizontalBarChartView *)barChart{
    if(!_barChart){
        _barChart=[[HorizontalBarChartView alloc]init];
        _barChart.extraRightOffset=20;
    }
    return _barChart;
}

#pragma mark - Private
-(void)reloadData:(Student*)student{
    [SpinnerHud showInView:self.view];
    [self.netUtil getAllCourses:self.student completionHandler:^{
        [SpinnerHud hide];
        [self strokeBarChartWithCourses:self.student.historyCourses];
    }];
}

-(void)addMenu{
    REMenuItem *refreshItem = [[REMenuItem alloc] initWithTitle:@"刷新"
                                                       subtitle:@""
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self reloadData:self.student];
                                                         }];
    REMenuItem *shareItem = [[REMenuItem alloc] initWithTitle:@"分享"
                                                     subtitle:@""
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           [self share:@"CoursesChartController"];
                                                       }];
    REMenuItem *saveChartItem = [[REMenuItem alloc] initWithTitle:@"保存图表到相册"
                                                     subtitle:@""
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           [self.barChart saveToCameraRoll];
                                                       }];
    self.menu= [[REMenu alloc]initWithItems:@[refreshItem,shareItem,saveChartItem]];
}

#pragma mark - ios-Charts

-(void)strokeBarChartWithCourses:(NSArray*)courses{
    courses=[[courses reverseObjectEnumerator]allObjects];
    CGRect rect=CGRectMake(0, 0,self.view.bounds.size.width-10,courses.count*50);
    self.barChart.frame=rect;
    
    //准备学生课程数据
    NSMutableArray *entries=[NSMutableArray array];
    NSMutableArray *xValues=[NSMutableArray array];
    BarChartDataEntry *entry;

    for (int i=0;i<courses.count; i++) {
        Course *c=courses[i];
        entry=[[BarChartDataEntry alloc]initWithValue:[c.score doubleValue] xIndex:i];
        [entries addObject:entry];
        [xValues addObject:c.courseName];
    }
    
    BarChartDataSet *set=[[BarChartDataSet alloc]initWithYVals:entries];
    [set setHighlightEnabled:NO];
    set.drawValuesEnabled=YES;
    BarChartData *data=[[BarChartData alloc]initWithXVals:xValues dataSet:set];
    
    //自定义BarChart
    self.barChart.scaleXEnabled=NO;
    self.barChart.scaleYEnabled=NO;
    self.barChart.xAxis.labelPosition=XAxisLabelPositionBottomInside;
    self.barChart.data=data;
    self.barChart.xAxis.drawAxisLineEnabled=NO;
    self.barChart.xAxis.drawGridLinesEnabled=NO;
    //
    ChartYAxis *leftAxis= [self.barChart getAxis:AxisDependencyLeft];
    leftAxis.axisMaximum=100;
    leftAxis.startAtZeroEnabled = YES;
    //
    ChartYAxis *rightAxis = [self.barChart getAxis:AxisDependencyRight];
    rightAxis.enabled = YES;
    //
    self.barChart.legend.enabled=NO;
    
    // 参考线
    ChartLimitLine *passLine=[[ChartLimitLine alloc]initWithLimit:60 label:@"及格"];
    ChartLimitLine *excellentLine=[[ChartLimitLine alloc]initWithLimit:90 label:@"优秀"];
    [leftAxis addLimitLine:passLine];
    [leftAxis addLimitLine:excellentLine];
    //
    self.scrollView.contentSize=rect.size;
    [self.scrollView addSubview:self.barChart];
    
}
@end
