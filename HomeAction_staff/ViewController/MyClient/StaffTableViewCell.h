//
//  StaffTableViewCell.h
//  HomeAction_staff
//
//  Created by zhijiaxingdong on 2016/10/19.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *tinmeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end
