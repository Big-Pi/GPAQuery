//
//  SlideTabViewController.m
//  GPAQuery
//
//  Created by pi on 16/1/25.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "SlideTabViewController.h"
#import "DLTabedSlideView.h"
#import "ScoreStatsController.h"
#import "StudentInformationViewController.h"
#import "CoursesTableController.h"
#import "CoursesChartController.h"
#import "DLSlideView.h"

@interface SlideTabViewController ()<DLTabedSlideViewDelegate>
@property (weak, nonatomic) IBOutlet DLTabedSlideView *slideTab;
@end

@implementation SlideTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.slideTab.backgroundColor=kWihteBG;
    self.slideTab.tabItemNormalColor = kBarBlack;
    self.slideTab.tabItemSelectedColor = kNiceGreen;
    self.slideTab.tabbarTrackColor = [UIColor clearColor];
    self.slideTab.backgroundColor=kGlobalMeat;
    self.slideTab.tabbarBottomSpacing = 3.0;
    self.slideTab.tabbarHeight=50;
    
    self.slideTab.baseViewController=self;
    DLTabedbarItem *item1=[DLTabedbarItem itemWithTitle:@"成绩图表" image:nil selectedImage:nil];
    DLTabedbarItem *item2=[DLTabedbarItem itemWithTitle:@"成绩" image:nil selectedImage:nil];
    DLTabedbarItem *item3=[DLTabedbarItem itemWithTitle:@"成绩统计" image:nil selectedImage:nil];
    DLTabedbarItem *item4=[DLTabedbarItem itemWithTitle:@"个人信息" image:nil selectedImage:nil];
    
    self.slideTab.tabbarItems = @[item1, item2, item3,item4];
    [self.slideTab buildTabbar];
//    self.slideTab.tabbarTrackColor
    self.slideTab.selectedIndex = 0;
    
}

#pragma mark - DLTabedSlideViewDelegate
-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 4;
}

-(UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    BaseViewController *vc;
    switch (index) {
        case 0:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                  instantiateViewControllerWithIdentifier:@"CoursesChartController"];
            break;
        case 1:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesTableController"];
            break;
        case 2:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScoreStatsController"];
            break;
        case 3:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"StudentInformationViewController"];
            break;
        default:
            break;
    }
    vc.student=self.student;
    return vc;
}

@end
