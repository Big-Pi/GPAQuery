//
//  BaseViewController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "BaseViewController.h"
#import "UMengShareInit.h"

@interface BaseViewController ()<UMSocialUIDelegate>


@end

@implementation BaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
}

-(NetUtil *)netUtil{
    if (_netUtil==nil) {
        _netUtil=[NetUtil sharedNetUtil];
    }
    return _netUtil;
}

-(Student *)student{
    if(!_student){
        _student=[[Student alloc]init];
    }
    return _student;
}


-(void)setupBasicMenu{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
    SEL sel=@selector(addMenu);
    if([self respondsToSelector:sel]){
        [self performSelector:sel];
        [self customMenuStyle];
    }
    
    self.parentViewController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
#pragma clang diagnostic pop
}
-(void)customMenuStyle{
    self.menu.borderWidth=0;
    self.menu.backgroundColor=kGlobalMeat;
    self.menu.highlightedBackgroundColor=kGlobalMeat;
    self.menu.separatorHeight=0;
    self.menu.textColor=kBarBlack;
    self.menu.highlightedTextShadowColor=[UIColor clearColor];
    self.menu.shadowOpacity=0.0;
    self.menu.shadowColor=[UIColor clearColor];
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    [self.menu showFromNavigationController:self.navigationController];
}

#pragma mark - Share
-(void)share:(NSString*)text{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMengAppKey
                                      shareText:text
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,nil]
                                       delegate:self];
}

#pragma mark - Share Delegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    NSString *msg;
    if(response.responseCode==UMSResponseCodeSuccess){
        msg=@"分享成功";
    }else{
        msg=@"分享失败";
    }
    if(response.responseCode==UMSResponseCodeCancel){
        return;
    }
    [MBProgressHUD showMsg:msg forSeconds:1.25];
}

@end
