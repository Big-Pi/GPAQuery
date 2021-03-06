//
//  LogInViewController.m
//  GPAQuery
//
//  Created by pi on 15/12/29.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "LogInViewController.h"
#import "UIImageView+PlaceHolderSpinner.h"
#import "SlideTabViewController.h"


@interface LogInViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkCodeImg;
@end

@implementation LogInViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.netUtil getSessionIDWithStudent:self.student completionHandler:^{
        [self reloadVerifyImage:self.student];
    }];
}

#pragma mark - Private
- (IBAction)logIn:(UIButton *)sender {
    
    self.student.userName=self.userNameTextField.text;
    self.student.pwd=self.pwdTextField.text;
    self.student.checkCode=self.checkCodeTextField.text;
    self.student.studentID=self.student.userName;
    
    if(self.student.checkCode==nil || self.student.checkCode.length!=4){
        [MBProgressHUD showMsg:@"请输入正确的验证码" forSeconds:1.0];
        return;
    }
    self.checkCodeTextField.text=@"";
    [SpinnerHud showInView:self.view];
    //
    [self.netUtil logInWithStudent:self.student completionHandler:^(BOOL success, NSString *errorMsg) {
        [SpinnerHud hide];
        if(success){
            [self performSegueWithIdentifier:@"slideTab" sender:self.student];
        }else{
            [MBProgressHUD showMsg:errorMsg forSeconds:1.5];
            [self reloadVerifyImage:self.student];
        }
    }];
}

-(void)reloadVerifyImage:(Student*)student{
    [self.checkCodeImg showPlaceHolder];
    //重新获取验证码
    [self.netUtil verifyImgWithStudent:self.student completionHandler:^(UIImage *verifyImg) {
        [self.checkCodeImg hidePlaceHolder];
        self.checkCodeImg.image=verifyImg;
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"slideTab"]){
        SlideTabViewController *vc= segue.destinationViewController;
        vc.student=self.student;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 4;
}

@end
