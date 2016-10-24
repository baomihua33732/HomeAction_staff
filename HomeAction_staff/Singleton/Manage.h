//
//  Manage.h
//  HomeAction_staff
//
//  Created by zhijiaxingdong on 16/10/8.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manage : NSObject
+ (Manage *)shareManager;


@property (nonatomic, strong)NSString *staffCode;  //账号名
@property (nonatomic, strong)NSString *staffName;  //名称
@property (nonatomic, strong)NSString *staffPhone;//电话
@property (nonatomic, strong)NSString *orgNameStr;//项目名称
@end
