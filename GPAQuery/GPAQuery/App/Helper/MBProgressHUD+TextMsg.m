//
//  MBProgressHUD+TextMsg.m
//  GPAQuery
//
//  Created by pi on 16/1/25.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MBProgressHUD+TextMsg.h"

@implementation MBProgressHUD (TextMsg)
+(void)showMsg:(NSString*)msg forSeconds:(NSTimeInterval)second{
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud=[[MBProgressHUD alloc]initWithWindow:window];
    [window addSubview:hud];
    
    hud.labelText=msg;
    hud.mode=MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide=YES;
    hud.bounds=CGRectMake(0,0, 66, 44);
    [hud show:YES];
    [hud hide:YES afterDelay:second];
}
@end
