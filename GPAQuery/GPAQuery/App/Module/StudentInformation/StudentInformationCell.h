//
//  StudentInformationCell.h
//  GPAQuery
//
//  Created by pi on 16/1/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *key;
@property (weak, nonatomic) IBOutlet UILabel *value;
-(void)configCellWithDataDict:(NSDictionary*)dict;
@end
