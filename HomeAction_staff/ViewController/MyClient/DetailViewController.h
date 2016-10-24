//
//  DetailViewController.h
//  HomeAction_staff
//
//  Created by 郭同明 on 16/9/20.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailViewController : BaseViewController
@property (nonatomic, strong) NSString *ViewIdentify;// 跳转界面标识
@property (nonatomic, strong) NSString *staffID; //客户关系ID
@property (nonatomic, strong) NSMutableArray *changtypeArr; //修改客户户型数组
@property (nonatomic, strong) NSString *changeNameStr; //客户姓名
@property (nonatomic, strong) NSString *changePhoneStr; //联系电话
@property (nonatomic, strong) NSString *changeRemarkStr; //备注
@property (nonatomic, strong) NSString *changeTypeStr; //户型
@property (nonatomic, strong) NSString * ageStr;
@property (nonatomic, strong) NSString * sexStr;
@end
