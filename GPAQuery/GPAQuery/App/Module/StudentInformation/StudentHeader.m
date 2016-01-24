//
//  StudentHeader.m
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "StudentHeader.h"
#import "Student.h"
#import "NetUtil+SYNUNetWorking.h"

@interface StudentHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *class0Label;
@property (strong,nonatomic) UIView *content;

@end

@implementation StudentHeader

-(instancetype)initWithStudent:(Student*)student{
    self=[super init];
    if(self){
        [self initPrivate];
        [self configWithStudent:student];
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

-(void)configWithStudent:(Student*)student{
    
    [[NetUtil sharedNetUtil]getAvatarImage:student completionHandler:^(UIImage *avatarImg) {
        self.avatarImageView.image=avatarImg;
    }];
    self.nameLabel.text=student.studentName;
    self.class0Label.text=student.class0;
}

@end
