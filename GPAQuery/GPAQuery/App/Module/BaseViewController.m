//
//  BaseViewController.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController
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
    }
    self.parentViewController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Dark_Menu_Icon_Setting"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
#pragma clang diagnostic pop
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self.navigationController];
}

-(void)share:(NSString*)text{
    //    [UMSocialSnsService presentSnsIconSheetView:self
    //                                         appKey:@"56a65ebf67e58e7d0300025c"
    //                                      shareText:@"你要分享的文字"
    //                                     shareImage:nil
    //                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
    //                                       delegate:nil];
}
@end
