//
//  InsideTableViewCell.h
//  HomeAction_client
//
//  Created by 郭同明 on 16/5/7.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsideTableViewCell : UITableViewCell
@property (retain,strong,nonatomic) TreeModel *node;//data
@property (weak, nonatomic) IBOutlet UILabel *insideLabel;
@end
