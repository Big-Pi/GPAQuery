//
//  SpinnerHud.m
//  GPAQuery
//
//  Created by pi on 16/1/25.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "SpinnerHud.h"
#import "MBProgressHUD.h"
#import "DGActivityIndicatorView.h"

static MBProgressHUD *hud;

@implementation SpinnerHud
+(void)showForSeconds:(NSTimeInterval)second{
    [self show];
    [self hideAfter:second];
}

+(void)show{
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    hud= [[MBProgressHUD alloc]initWithWindow:window];
    hud.labelText=@"正在努力加载中 ~ ";
    hud.mode=MBProgressHUDModeCustomView;
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide=YES;
//    hud.dimBackground=YES;
    //
    DGActivityIndicatorView *spinner=[[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeCookieTerminator];
    spinner.bounds=CGRectMake(0, 0, 37*2, 37*2);
    [spinner startAnimating];
    hud.customView=spinner;
    //
    [hud show:YES];
}

+(void)hide{
    [self hideAfter:0];
}

+(void)hideAfter:(NSTimeInterval)second{
    [hud hide:YES afterDelay:second];
}
@end
