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
    self.barChart.noDataText=@"正在努力加载解析~";
    self.barChart.descriptionText=@"";
    [self.netUtil getAllCourses:self.student completionHandler:^{
        [self strokeBarChartWithCourses:self.student.historyCourses];
    }];
}

-(HorizontalBarChartView *)barChart{
    if(!_barChart){
        _barChart=[[HorizontalBarChartView alloc]init];
    }
    return _barChart;
}

#pragma mark - ios-Charts

-(void)strokeBarChartWithCourses:(NSArray*)courses{
    CGRect rect=CGRectMake(0, 0,self.scrollView.bounds.size.width ,courses.count*50);
    self.barChart.frame=rect;
    
    //准备学生课程数据
    NSMutableArray *entries=[NSMutableArray array];
    NSMutableArray *xValues=[NSMutableArray array];
    BarChartDataEntry *entry;
    for (int i=courses.count-1;i>0; i--) {
        Course *c=courses[i];
        entry=[[BarChartDataEntry alloc]initWithValue:[c.score doubleValue] xIndex:i];
        [entries addObject:entry];
        [xValues addObject:c.courseName];
    }
    
    BarChartDataSet *set=[[BarChartDataSet alloc]initWithYVals:entries];
    BarChartData *data=[[BarChartData alloc]initWithXVals:xValues dataSet:set];
    
    //自定义BarChart
    self.barChart.xAxis.labelPosition=XAxisLabelPositionBottomInside;
    self.barChart.data=data;
    self.barChart.xAxis.drawAxisLineEnabled=NO;
    self.barChart.xAxis.drawGridLinesEnabled=NO;
    ChartYAxis *yAxis= [self.barChart getAxis:AxisDependencyLeft];
    yAxis.axisMaximum=100;
    self.barChart.legend.enabled=NO;
    
    // 参考线
    ChartLimitLine *passLine=[[ChartLimitLine alloc]initWithLimit:60 label:@"及格"];
    ChartLimitLine *excellentLine=[[ChartLimitLine alloc]initWithLimit:90 label:@"优秀"];
    [yAxis addLimitLine:passLine];
    [yAxis addLimitLine:excellentLine];
    //
    self.scrollView.contentSize=rect.size;
    [self.scrollView addSubview:self.barChart];
    
}
@end
