//
//  TreeModel.h
//  TreeTableView
//
//  Created by yi on 16/1/7.
//  Copyright © 2016年 yi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    NodeTypeSectionHead,
    NodeTypeRow,
}NodeType;

@interface TreeModel : NSObject

//@property (nonatomic) int nodeLevel; //节点所处层次
@property (nonatomic) NodeType type; //节点类型
@property (nonatomic) id nodeData;//节点数据
@property (nonatomic) BOOL isExpanded;//节点是否展开
@property (strong,nonatomic) NSMutableArray *sonNodes;//子节点
@property (nonatomic, strong)NSString *OneName;
@property (nonatomic, strong)NSString *twoName;
@property (nonatomic, strong)NSString *pageType;//判断是原生还是h5
@property (nonatomic, strong)NSString *pageUrl; //url
@property (nonatomic, strong)NSString *pageIcon;//图标
@property (nonatomic, strong)NSString *creatTimeStr;//创建时间
@property (nonatomic, strong)NSString *staffNameStr;//客户名
@property (nonatomic, strong)NSString *houseTypeId;//
@property (nonatomic, strong)NSMutableArray *houseTypeArr;//户型数组
@property (nonatomic, strong)NSString *phoneNumStr;//电话
@property (nonatomic, strong)NSString *recId;//
@property (nonatomic, strong)NSString *remarkStr;//备注
@property (nonatomic, strong)NSString *ageGroupStr;//年龄段
@property (nonatomic, strong)NSString *sexStr;//性别





@end
