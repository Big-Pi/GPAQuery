//
//  ScoreStatsController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ScoreStatsController.h"
#import "ScoreStats.h"
#import "Student+Definition.h"

@import Charts;

@interface ScoreStatsController ()
@property (weak, nonatomic) IBOutlet PieChartView *pieChart;
@property (weak, nonatomic) IBOutlet UILabel *creditSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *GPALabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelDescriptionLabel;
@end

@implementation ScoreStatsController

-(void)viewDidLoad{
    [super viewDidLoad];
     NSLog(@"%@",@"学生统计信息 Load");
    self.pieChart.noDataText=@"正在努力加载解析~";
    self.pieChart.descriptionText=@"学分获得情况";
    if(self.student.scoreStats){
        [self updateInterfaceWithStudent];
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
    [self.netUtil getScoreStats:self.student completionHandler:^{
        [SpinnerHud hide];
        [self updateInterfaceWithStudent];
        [self.pieChart animateWithYAxisDuration:2.0];
    }];
}

-(void)updateInterfaceWithStudent{
    [self strokeChartWIthScoreStats:self.student.scoreStats];
    self.creditSumLabel.text=self.student.creditSum;
    self.GPALabel.text=self.student.GPA;
    NSString *def= [self.student definitionFromGPA];
    NSArray *defArray= [def componentsSeparatedByString:@":"];
    self.levelLabel.text=defArray[0];
    self.levelDescriptionLabel.text=defArray[1];
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
                                                          [self share:@"scroeStatsController"];
                                                      }];
    self.menu= [[REMenu alloc]initWithItems:@[refreshItem,shareItem]];
}

#pragma mark - ios-Charts
-(void)strokeChartWIthScoreStats:(ScoreStats*)scoreStats{
    ChartDataEntry *entry1=[[ChartDataEntry alloc]initWithValue:[scoreStats.creditGain floatValue] xIndex:0];
    ChartDataEntry *entry2=[[ChartDataEntry alloc]initWithValue:[scoreStats.creditRetake floatValue] xIndex:1];
    ChartDataEntry *entry3=[[ChartDataEntry alloc]initWithValue:[scoreStats.creditUnPass floatValue] xIndex:2];
    NSString *label= [NSString stringWithFormat:@"所选:%@ 学分",scoreStats.creditSelected];
    PieChartDataSet *ds=[[PieChartDataSet alloc]initWithYVals:@[entry1,entry2,entry3] label:label];
    ds.colors=[ChartColorTemplates joyful];
    ds.valueTextColor=[UIColor blackColor];
    PieChartData *data=[[PieChartData alloc]initWithXVals:@[@"获得",@"重修",@"正考未通过"] dataSet:ds];
    self.pieChart.data=data;
    
}
@end
