//
//  MBProgressHUD+TextMsg.h
//  GPAQuery
//
//  Created by pi on 16/1/25.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (TextMsg)
+(void)showMsg:(NSString*)msg forSeconds:(NSTimeInterval)second;
@end
