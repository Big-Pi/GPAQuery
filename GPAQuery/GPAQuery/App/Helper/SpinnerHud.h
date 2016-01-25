//
//  SpinnerHud.h
//  GPAQuery
//
//  Created by pi on 16/1/25.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerHud : UIView
+(void)showForSeconds:(NSTimeInterval)second;

+(void)show;

+(void)showInView:(UIView*)v;

+(void)hide;

+(void)hideAfter:(NSTimeInterval)second;
@end
