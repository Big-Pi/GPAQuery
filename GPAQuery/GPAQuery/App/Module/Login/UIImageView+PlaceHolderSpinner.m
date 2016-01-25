//
//  UIImageView+PlaceHolderSpinner.m
//  GPAQuery
//
//  Created by pi on 16/1/25.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UIImageView+PlaceHolderSpinner.h"
#import "DGActivityIndicatorView.h"

static DGActivityIndicatorView *spinner;
@implementation UIImageView (PlaceHolderSpinner)

-(void)showPlaceHolder{
    spinner=[[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeThreeDots tintColor:[UIColor orangeColor]];
    CGPoint center= CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    spinner.center=center;
    spinner.bounds=CGRectMake(0, 0, 37, 37);
    [self addSubview:spinner];
    [spinner startAnimating];
}

-(void)hidePlaceHolder{
    [spinner removeFromSuperview];
    spinner=nil;
}
@end
