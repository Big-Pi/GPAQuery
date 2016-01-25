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

@interface SlideTabViewController ()<DLTabedSlideViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet DLTabedSlideView *slideTab;
@end

@implementation SlideTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.slideTab.tabItemNormalColor = [UIColor blackColor];
    self.slideTab.tabItemSelectedColor = [UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
    self.slideTab.tabbarTrackColor = [UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
    self.slideTab.tabbarBackgroundImage = [UIImage imageNamed:@"tabbarBk"];
    self.slideTab.tabbarBottomSpacing = 3.0;
    
    self.slideTab.baseViewController=self;
    DLTabedbarItem *item1=[DLTabedbarItem itemWithTitle:@"个人信息" image:nil selectedImage:nil];
    DLTabedbarItem *item2=[DLTabedbarItem itemWithTitle:@"成绩" image:nil selectedImage:nil];
    DLTabedbarItem *item3=[DLTabedbarItem itemWithTitle:@"成绩图表" image:nil selectedImage:nil];
    DLTabedbarItem *item4=[DLTabedbarItem itemWithTitle:@"成绩统计" image:nil selectedImage:nil];
    
    self.slideTab.tabbarItems = @[item1, item2, item3,item4];
    [self.slideTab buildTabbar];
    self.slideTab.selectedIndex = 0;
    
    //slide pan 手势和 scrollView手势冲突处理
    DLSlideView *slideView=[self.slideTab valueForKey:@"slideView_"];
    UIPanGestureRecognizer *pan= [slideView valueForKey:@"pan_"];
    pan.delegate=self;
    
}

#pragma mark - DLTabedSlideViewDelegate
-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 4;
}

-(UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    BaseViewController *vc;
    switch (index) {
        case 0:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"StudentInformationViewController"];
            break;
        case 1:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesTableController"];
            break;
        case 2:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesChartController"];
            break;
        case 3:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScoreStatsController"];
            break;
        default:
            break;
    }
    vc.student=self.student;
    return vc;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
