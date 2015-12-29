//
//  Student.h
//  GPAQuery
//
//  Created by pi on 15/12/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface Student : NSObject
@property (strong,nonatomic,readonly) UIImage *verifyImg;
-(void)getVerifyImageWithcompletionHandler:(void (^)(UIImage *verifyImg))completionHandler;
-(void)logInWithUserName:(NSString*)userName pwd:(NSString*)pwd checkCode:(NSString*)checkCode;
@end
