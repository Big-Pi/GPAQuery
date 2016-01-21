//
//  ScoreStatsController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ScoreStatsController.h"
#import "Student.h"
#import "NetUtil+SYNUNetWorking.h"

@implementation ScoreStatsController
-(void)viewDidLoad{
    [super viewDidLoad];
    [[NetUtil sharedNetUtil]getScoreStats:self.student completionHandler:^{
    }];
}
@end
