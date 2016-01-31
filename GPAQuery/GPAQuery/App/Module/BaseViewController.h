//
//  BaseViewController.h
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetUtil+SYNUNetWorking.h"
#import "Student.h"
#import "CXHTMLDocument+StringValueForXPath.h"
#import "SpinnerHud.h"
#import "MBProgressHUD+TextMsg.h"
#import "REMenu.h"
#import "UIColor+Global.h"

@interface BaseViewController : UIViewController
@property (strong,nonatomic) Student *student;
@property (strong,nonatomic) NetUtil *netUtil;
@property (strong,nonatomic) REMenu *menu;
-(void)setupBasicMenu;
-(void)share:(NSString*)text;
@end
