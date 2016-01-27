//
//  UMengShareInit.m
//  GPAQuery
//
//  Created by pi on 16/1/27.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UMengShareInit.h"
#import "UMSocialQQHandler.h"


NSString *const kUMengAppKey=@"56a65ebf67e58e7d0300025c";
NSString *const kQQAppID=@"1105142270";
NSString *const kQQAppKey=@"u0PFYPpxxXhfFNEM";

@implementation UMengShareInit
+(void)load{
    [UMSocialData setAppKey:kUMengAppKey];
    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQAppKey url:nil];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ]];
}
@end
