//
//  OBJ2ExcelHelper.h
//  GPAQuery
//
//  Created by pi on 16/1/26.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBJ2ExcelHelper : NSObject
+ (void)generateExcelWithName:(NSString*)name courses:(NSArray*)array completion:(void (^)())completion;
@end
