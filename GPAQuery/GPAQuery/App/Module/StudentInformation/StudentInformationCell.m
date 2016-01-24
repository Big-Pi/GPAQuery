//
//  StudentInformationCell.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "StudentInformationCell.h"


@interface StudentInformationCell ()


@end

@implementation StudentInformationCell

-(void)configCellWithDataDict:(NSDictionary*)dict{
    self.key.text=dict.allKeys[0];
    self.value.text=dict.allValues[0];
}

@end
