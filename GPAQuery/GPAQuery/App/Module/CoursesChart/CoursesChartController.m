//
//  CoursesChartController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CoursesChartController.h"
#import "Course.h"
#import "Student+Definition.h"

NSInteger const kTopValueFontSize=11;
NSInteger const kXValueFontSize=12;
NSInteger const kLimitLineFontSize=12;

@import Charts;

@interface CoursesChartController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) HorizontalBarChartView *barChart;
@property (strong,nonatomic) NSArray *courses;
@end

@implementation CoursesChartController
-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%@",@"成绩图表 Load");
    self.scrollView.backgroundColor=kWihteBG;
    self.barChart.backgroundColor=kWihteBG;
    self.barChart.gridBackgroundColor=kWihteBG;
    self.barChart.noDataText=@"正在努力加载解析~";
    self.barChart.descriptionText=@"";
    
    if(self.student.historyCourses && self.student.historyCourses.count>0){
        [self strokeBarChartWithCourses:self.student.historyGPACalcCourses];
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
        [self strokeBarChartWithCourses:self.student.historyGPACalcCourses];
        [self.barChart animateWithYAxisDuration:1.4];
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
                                                         [self strokeBarChartWithCourses:self.courses];
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
                                                         [self strokeBarChartWithCourses:self.courses];
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
    
    REMenuItem *saveChartItem = [[REMenuItem alloc] initWithTitle:@"保存图表到相册"
                                                     subtitle:@""
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           [self.barChart saveToCameraRoll];
                                                           [MBProgressHUD showMsg:@"成绩图标已保存到相册" forSeconds:1.5];
                                                       }];
    self.menu= [[REMenu alloc]initWithItems:@[refreshItem,showCoursesItem,shareItem,saveChartItem]];
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
    NSMutableArray *colors=[NSMutableArray array];
    for (int i=0;i<courses.count; i++) {
        Course *c=courses[i];
        if([c.scoreMakeUp floatValue]>0){
            entry=[[BarChartDataEntry alloc]initWithValue:[c.scoreMakeUp doubleValue] xIndex:i];
        }else{
            entry=[[BarChartDataEntry alloc]initWithValue:[c.score doubleValue] xIndex:i];
        }
        [entries addObject:entry];
        [xValues addObject:c.courseName];
        if(entry.value>=60){
            [colors addObject:[UIColor colorFromHexString:kNiceGreenLightStr]];
        }else{
            [colors addObject:[UIColor colorFromHexString:kNiceOrangeStr]];
        }
    }
    
    BarChartDataSet *set=[[BarChartDataSet alloc]initWithYVals:entries];
    set.drawValuesEnabled=YES;
    set.colors=colors;
    BarChartData *data=[[BarChartData alloc]initWithXVals:xValues dataSet:set];
    [data setValueFont:[UIFont systemFontOfSize:kTopValueFontSize weight:UIFontWeightThin]];
    
    //自定义BarChart
    self.barChart.userInteractionEnabled=NO;
    self.barChart.xAxis.labelPosition=XAxisLabelPositionBottomInside;
    self.barChart.xAxis.labelFont=[UIFont systemFontOfSize:kXValueFontSize];
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
    UIFont *font=[UIFont systemFontOfSize:kLimitLineFontSize];
    UIColor *fontColor=[UIColor colorFromHexString:kBarBlackStr];
    [passLine setValueFont:font];
    [passLine setValueTextColor:fontColor];
    [excellentLine setValueFont:font];
    [excellentLine setValueTextColor:fontColor];
    excellentLine.lineColor=kNiceGreen;
    [leftAxis addLimitLine:passLine];
    [leftAxis addLimitLine:excellentLine];
    //
    self.scrollView.contentSize=rect.size;
    [self.scrollView addSubview:self.barChart];
    
}
@end

