//
//  ScoreStatsController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ScoreStatsController.h"
#import "ScoreStats.h"

@import Charts;

@interface ScoreStatsController ()
@property (weak, nonatomic) IBOutlet PieChartView *pieChart;


@end

@implementation ScoreStatsController
//@property (copy,nonatomic,readonly) NSString *creditSelected;//所选学分
//@property (copy,nonatomic,readonly) NSString *creditGain;//获得学分
//@property (copy,nonatomic,readonly) NSString *creditRetake;//重修学分
//@property (copy,nonatomic,readonly) NSString *creditUnPass;//正考未通过学分

-(void)viewDidLoad{
    [super viewDidLoad];
    self.pieChart.noDataText=@"正在努力加载解析~";
    self.pieChart.descriptionText=@"学分获得情况";
    [self.netUtil getScoreStats:self.student completionHandler:^{
        [self strokeChartWIthScoreStats:self.student.scoreStats];
    }];
}

#pragma mark - Private

#pragma mark - ios-Charts
-(void)strokeChartWIthScoreStats:(ScoreStats*)scoreStats{
    ChartDataEntry *entry1=[[ChartDataEntry alloc]initWithValue:[scoreStats.creditGain floatValue]   xIndex:0];
    ChartDataEntry *entry2=[[ChartDataEntry alloc]initWithValue:[scoreStats.creditRetake floatValue]  xIndex:1];
    ChartDataEntry *entry3=[[ChartDataEntry alloc]initWithValue:[scoreStats.creditUnPass floatValue] xIndex:2];
    NSString *label= [NSString stringWithFormat:@"所选:%@ 学分",scoreStats.creditSelected];
    PieChartDataSet *ds=[[PieChartDataSet alloc]initWithYVals:@[entry1,entry2,entry3] label:label];
    ds.colors=[ChartColorTemplates joyful];
    ds.valueTextColor=[UIColor blackColor];
    PieChartData *data=[[PieChartData alloc]initWithXVals:@[@"获得",@"重修",@"未通过"] dataSet:ds];
    self.pieChart.data=data;
    
}
@end
