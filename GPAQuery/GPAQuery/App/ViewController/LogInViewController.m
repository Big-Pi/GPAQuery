//
//  LogInViewController.m
//  GPAQuery
//
//  Created by pi on 15/12/29.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "LogInViewController.h"
#import "Student.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkCodeImg;
@property (strong,nonatomic) Student *student;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.student=[[Student alloc]init];
    [self.student getVerifyImageWithCompletionHandler:^(UIImage *verifyImg) {
        self.checkCodeImg.image=verifyImg;
    }];
}

#pragma mark - Private
- (IBAction)logIn:(UIButton *)sender {
    NSString *userName= self.userNameTextField.text;
    NSString *pwd= self.pwdTextField.text;
    NSString *checkCode= self.checkCodeTextField.text;
    [self.student logInWithUserName:userName pwd:pwd checkCode:checkCode];
}

@end
