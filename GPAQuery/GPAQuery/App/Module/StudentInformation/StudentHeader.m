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
#import "UIColor+Global.h"

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
    }
    return self;
}

-(void)initPrivate{
    self.content=[[[NSBundle mainBundle]loadNibNamed:@"StudentHeader" owner:self options:nil]lastObject];
    self.content.backgroundColor=kWihteBG;
    [self addSubview:self.content];
//    CGFloat radius= MIN(self.avatarImageView.bounds.size.height, self.avatarImageView.bounds.size.width);
//    self.avatarImageView.layer.cornerRadius=radius/2;
//    self.avatarImageView.layer.borderWidth=8;
//    self.avatarImageView.layer.borderColor=[UIColor colorFromHexString:kGlobalMeatStr].CGColor;
//    self.avatarImageView.clipsToBounds=YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.content.frame=self.bounds;
}

-(void)configWithStudent:(Student*)student{
    self.avatarImageView.image=student.avatarImg;
    self.nameLabel.text=student.studentName;
    self.class0Label.text=student.class0;
}

@end
