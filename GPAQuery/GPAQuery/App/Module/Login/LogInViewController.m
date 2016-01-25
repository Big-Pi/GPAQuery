//
//  LogInViewController.m
//  GPAQuery
//
//  Created by pi on 15/12/29.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "LogInViewController.h"
#import "Student.h"
#import "NetUtil+SYNUNetWorking.h"
#import "StudentInformationViewController.h"
#import "CoursesTableController.h"
#import "ScoreStatsController.h"
#import "CoursesChartController.h"
#import "SpinnerHud.h"
#import "MBProgressHUD+TextMsg.h"
#import "UIImageView+PlaceHolderSpinner.h"


@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkCodeImg;
@property (strong,nonatomic) Student *student;
@property (strong,nonatomic) NetUtil *netUtil;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.student=[[Student alloc]init];
    self.netUtil=[NetUtil sharedNetUtil];
    
    [self.checkCodeImg showPlaceHolder];
    [self.netUtil getVerifyImageWithStudent:self.student completionHandler:^(UIImage *verifyImg) {
        [self.checkCodeImg hidePlaceHolder];
        self.checkCodeImg.image=verifyImg;
    }];
}

#pragma mark - Private
- (IBAction)logIn:(UIButton *)sender {
    self.student.userName=self.userNameTextField.text;
    self.student.pwd=self.pwdTextField.text;
    self.student.checkCode=self.checkCodeTextField.text;
    self.student.studentID=self.student.userName;
    
    [SpinnerHud show];
    //
    [self.netUtil logInWithStudent:self.student completionHandler:^(BOOL success) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SpinnerHud hide];
            if(success){
    //            NSLog(@"%@",@"登录成功");
                [self performSegueWithIdentifier:@"courseChart" sender:self.student];
            }else{
                [MBProgressHUD showMsg:@"验证码错误" forSeconds:1.5];
                [self.checkCodeImg showPlaceHolder];
                [self.netUtil verifyImgWithStudent:self.student completionHandler:^(UIImage *verifyImg) {
                    [self.checkCodeImg hidePlaceHolder];
                    self.checkCodeImg.image=verifyImg;
                }];
            }
        });
    }];
}


#pragma mark - 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"studentInformation"]){
        StudentInformationViewController *vc=segue.destinationViewController;
        if([sender isKindOfClass:[Student class]]){
            vc.student=sender;
        }
    }else if([segue.identifier isEqualToString:@"courses"]){
        CoursesTableController *vc=segue.destinationViewController;
        if([sender isKindOfClass:[Student class]]){
            vc.student=sender;
        }
    }else if([segue.identifier isEqualToString:@"scoreStats"]){
        ScoreStatsController *vc=segue.destinationViewController;
        if([sender isKindOfClass:[Student class]]){
            vc.student=sender;
        }
    }else if([segue.identifier isEqualToString:@"courseChart"]){
        CoursesChartController *vc=segue.destinationViewController;
        if([sender isKindOfClass:[Student class]]){
            vc.student=sender;
        }
    }
}

@end
