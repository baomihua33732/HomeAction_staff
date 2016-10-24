//
//  Manage.m
//  HomeAction_staff
//
//  Created by zhijiaxingdong on 16/10/8.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "Manage.h"

@implementation Manage
static Manage *manager = nil;
+(Manage *)shareManager{
    if (manager == nil) {
        manager = [[Manage alloc] init];
    }
    return manager;
}
@end
