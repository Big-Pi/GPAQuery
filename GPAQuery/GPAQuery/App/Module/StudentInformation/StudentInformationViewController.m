//
//  StudentInformationViewController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "StudentInformationViewController.h"
#import "StudentHeader.h"
#import <VGParallaxHeader/UIScrollView+VGParallaxHeader.h>
#import "Student.h"
#import "NetUtil+SYNUNetWorking.h"

@interface StudentInformationViewController ()

@end

@implementation StudentInformationViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *header= [[StudentHeader alloc]init];
    [self.tableView setParallaxHeaderView:header mode:VGParallaxHeaderModeFill height:200];
    [[NetUtil sharedNetUtil]getStudentInformation:self.student completionHandler:^{
        NSLog(@"%@",self.student);
    }];
}

#pragma mark - TableView
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return <#expression#>
//}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView shouldPositionParallaxHeader];
}
@end
