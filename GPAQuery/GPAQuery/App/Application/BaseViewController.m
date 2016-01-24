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
@end
