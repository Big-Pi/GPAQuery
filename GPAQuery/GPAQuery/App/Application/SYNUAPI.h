//
//  SYNUAPI.h
//  GPAQuery
//
//  Created by pi on 16/1/16.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYNUAPI : NSObject
+(NSString*)generateCheckCodeUrl:(NSString*)sessionID;

+(NSString*)generateLogInUrl:(NSString*)sessionID;

+(NSString*)generateLogInBody:(NSString*)userName pwd:(NSString*)pwd checkCode:(NSString*)checkCode;

+(NSString*)generateStudentInformationUrl:(NSString*)sessionID studentID:(NSString*)studentID studentName:(NSString*)studentName;
@end
