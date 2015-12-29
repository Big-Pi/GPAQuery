//
//  ViewController.m
//  GPAQuery
//
//  Created by pi on 15/12/17.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <Ono.h>
#import "Student.h"

@interface ViewController ()<UIWebViewDelegate>
@property (strong,nonatomic) Student *student;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getLogInPage];
//    [self logIn:@"kl4b1s45bpf0th45qo1thjjy"];
//    [self chengji:@"kl4b1s45bpf0th45qo1thjjy"];
//    [self getContent:@"kl4b1s45bpf0th45qo1thjjy"];

}

-(void)getLogInPage{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSURL *URL = [NSURL URLWithString:@"http://210.30.208.126/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *str=[[NSString alloc]initWithData:responseObject encoding:gbkEncoding];
            NSLog(@"%@\n%@",response,str);
            NSArray *pathComponents= response.URL.pathComponents;
            NSString *identifier=pathComponents[1];
            identifier=[identifier stringByReplacingOccurrencesOfString:@"(" withString:@""];
            identifier=[identifier stringByReplacingOccurrencesOfString:@")" withString:@""];
            [self requestImage:identifier];
        }
    }];
    [dataTask resume];
}

-(void)requestImage:(NSString*)identifier{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *urlStr=[NSString stringWithFormat:@"http://210.30.208.126/(%@)/CheckCode.aspx",identifier];
    NSURL *URL = [NSURL URLWithString:[urlStr stringByReplacingPercentEscapesUsingEncoding:kCFStringEncodingUTF8]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            UIImage *img= [UIImage imageWithData:responseObject];
            NSLog(@"%@",img);
        }
    }];
    [dataTask resume];
}

-(void)logIn:(NSString*)identifier{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSString *urlStr=[NSString stringWithFormat:@"http://210.30.208.126/(%@)/default2.aspx",identifier];
    NSURL *URL = [NSURL URLWithString:[urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod=@"POST";
    //
    NSString *username=@"12999029";
    NSString *pwd=@"1993429w";
    NSString *verifyCode=@"nsm4";
    //
    NSString *body=[NSString stringWithFormat:@"__VIEWSTATE=dDwyODE2NTM0OTg7Oz7akNIwXHhlJks4341V36F4cAnbnQ==&txtUserName=%@&TextBox2=%@&txtSecretCode=%@&RadioButtonList1=学生&Button1=&lbLanguage=&hidPdrs=&hidsc=",username,pwd,verifyCode];
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    body=[body stringByReplacingPercentEscapesUsingEncoding:gbkEncoding];
    request.HTTPBody=[body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *str=[[NSString alloc]initWithData:responseObject encoding:gbkEncoding];
//            NSLog(@"%@\n%@",response,str);
//            [self getContent:identifier];
//            [self contentPage:identifier];
            [self getContent:identifier];
            [self chengji:identifier];
        }
    }];
    [dataTask resume];

}

-(void)getContent:(NSString*)identifier{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSString *urlStr=[NSString stringWithFormat:@"http://210.30.208.126/(%@)/xs_main.aspx?xh=12999029",identifier];
    NSURL *URL = [NSURL URLWithString:[urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setAllHTTPHeaderFields:@{@"Referer":@"http://210.30.208.126/(so5f1n55ol0grk5524uatl45)/default2.aspx"}];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *str=[[NSString alloc]initWithData:responseObject encoding:gbkEncoding];
            NSLog(@"%@\n%@",response,str);
        }
    }];
    [dataTask resume];
}

-(void)chengji:(NSString*)identifier{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSString *urlStr=[NSString stringWithFormat:@"http://210.30.208.126/(%@)/xscjcx.aspx?xh=12999029&xm=赵志明&gnmkdm=N121605",identifier];
    NSString *requestUrl=[NSString stringWithFormat:@"http://210.30.208.126/(%@)/xscjcx.aspx",identifier];
    NSError *error;
    
    NSMutableURLRequest *request=[[AFHTTPRequestSerializer serializer]requestWithMethod:@"GET" URLString:[requestUrl stringByReplacingPercentEscapesUsingEncoding:gbkEncoding] parameters:@{@"xh":@"12999029",@"xm":@"赵志明",@"gnmkdm":@"N121605"} error:&error];
    [request setAllHTTPHeaderFields:@{@"Referer":@"http://210.30.208.126/(so5f1n55ol0grk5524uatl45)/xs_main.aspx?xh=12999029"}];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *str=[[NSString alloc]initWithData:responseObject encoding:gbkEncoding];
            NSLog(@"%@\n%@",response,str);
        }
    }];
    [dataTask resume];
}
@end
