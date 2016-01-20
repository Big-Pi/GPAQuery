//
//  ScoreStats.h
//  GPAQuery
//
//  Created by pi on 16/1/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreStats : NSObject
@property (copy,nonatomic,readonly) NSString *creditSelected;//所选学分
@property (copy,nonatomic,readonly) NSString *creditGain;//获得学分
@property (copy,nonatomic,readonly) NSString *creditRetake;//重修学分
@property (copy,nonatomic,readonly) NSString *creditUnPass;//正考未通过学分

- (instancetype)initWithHtmlData:(NSData*)data;

@end
