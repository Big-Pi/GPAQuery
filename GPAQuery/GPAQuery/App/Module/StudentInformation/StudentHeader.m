//
//  StudentHeader.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "StudentHeader.h"

@interface StudentHeader ()
@property (strong,nonatomic) UIView *content;
@end

@implementation StudentHeader
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initPrivate];
    }
    return self;
}

-(void)initPrivate{
    self.content=[[[NSBundle mainBundle]loadNibNamed:@"StudentHeader" owner:self options:nil]lastObject];
    [self addSubview:self.content];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.content.frame=self.bounds;
}
@end
