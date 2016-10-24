//
//  ClassModel.h
//  HomeAction_staff
//
//  Created by zhijiaxingdong on 16/10/11.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
@property (nonatomic, strong)NSString *typeID;  //户型id
@property (nonatomic, strong)NSString *typeName;//户型名称
@property (nonatomic, strong) NSMutableArray *chooseArr;

@end
