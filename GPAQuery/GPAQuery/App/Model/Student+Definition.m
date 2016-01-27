//
//  Student+Definition.m
//  GPAQuery
//
//  Created by pi on 16/1/27.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "Student+Definition.h"


#define GPA2Level(GPA) (NSInteger)((GPA-1.3)/0.23)

@implementation Student (Definition)


/**
 *  1.3 - 3.6 为1到10 level
 *  每个level 有不同的定义 学霸 学魔 学渣。。
 *
 *  @return 根据GPA多少 生成的定义
 */
-(NSString*)definitionFromGPA{
    float GPA= [self.GPA floatValue];
    NSInteger level= GPA2Level(GPA);
    if(level<1){
        level=1;
    }
    if(level>10){
        level=10;
    }
    NSString *levelKey=[NSString stringWithFormat:@"%d",level];
    return [[self definitions]valueForKey:levelKey];
}

-(NSDictionary*)definitions{
    static NSDictionary *definitions;
    if(!definitions){
        NSURL *url =[[NSBundle mainBundle]URLForResource:@"GPADescription" withExtension:@"plist"];
        definitions =[NSDictionary dictionaryWithContentsOfURL:url];
    }
    return definitions;
}
@end
