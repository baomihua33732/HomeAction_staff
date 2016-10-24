//
//  StaffViewController.m
//  HomeAction_staff
//
//  Created by zhijiaxingdong on 2016/10/19.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "StaffViewController.h"
#include "HomeViewController.h"
#import "StaffTableViewCell.h"
#import "DetailViewController.h"
@interface StaffViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *NoStaffView; //无客户展示的view
@property (nonatomic, strong) NSString *typeNameStr;
@property (nonatomic, strong)NSMutableArray *typeNameArr;
@property (nonatomic) int count;
@property (nonatomic) int Allcount;  //总页数
@end

@implementation StaffViewController

-(void)viewWillAppear:(BOOL)animated{
   _count = 1;
    if (_staffDataArray.count != 0) {
        _NoStaffView.hidden = YES;
        _tableView.hidden = NO;
    }else{
        _NoStaffView.hidden = NO;
        _tableView.hidden = YES;
    }
    
    if (![_strNum isEqualToString:@"1"]) {
         [self requestManageData];
    }
   
}
-(void)viewWillDisappear:(BOOL)animated{
    _strNum = @"2";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.delegate     =self;
    _tableView.dataSource   =self;
    
//    _staffDataArray = [NSMutableArray new];
    [self addrefresh];
}

-(void)addrefresh{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(hander)];
    // 设置普通状态的动画图片
    [header setImages:(NSArray *)[UIImage imageNamed:@"arrow"] forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:(NSArray *)[UIImage imageNamed:@"arrow"]forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:(NSArray *)[UIImage imageNamed:@"arrow"] forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    //header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    //header.stateLabel.hidden = YES;
    
    // 设置文字
    [header setTitle:@"刷新成功" forState:MJRefreshStateIdle];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中 ..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    
    // 设置header
    _tableView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footer)];
    
    
    
    // 设置尾部
    self.tableView.mj_footer = footer;
    
    
}
- (void)hander
{
    //多线程 延时调用
    [self performSelector:@selector(refresh) withObject:nil afterDelay:3];
}
-(void)refresh
{
    [_staffDataArray removeAllObjects];
    _count = 1;
    [self requestManageData];
    //结束刷新
    
}
- (void)footer
{
    
    [self performSelector:@selector(addMore) withObject:nil];
}
- (void)addMore
{
    _count ++;
    if (_count<=_Allcount) {
        [self requestManageData];
    }else{
        
        [_tableView.mj_footer endRefreshing];
    }
    
    
    //结束刷新
    //    [_tableView.mj_header endRefreshing];
    
    /* 刷新状态控制
     进入刷新状态
     - (void)beginRefreshing;
     结束刷新状态
     - (void)endRefreshing;
     是否正在刷新
     - (BOOL)isRefreshing;
     */
}


- (IBAction)leftBtnACTION:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)goBackBtnAction:(id)sender {
    HomeViewController * homeVC = [HomeViewController new];
    [self.navigationController pushViewController:homeVC animated:NO];
}

#pragma mark - Table view data source
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _staffDataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *indentifier = @"StaffTableViewCell";
    
    StaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StaffTableViewCell" owner:self options:nil] lastObject];
    }
    TreeModel *model = _staffDataArray[indexPath.row];
  
    cell.backgroundColor=[UIColor clearColor];
    cell.nameLabel.text =[NSString stringWithFormat:@"客户:%@",model.staffNameStr];
    cell.phoneLabel.text = [NSString stringWithFormat:@"电话:%@",model.phoneNumStr];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:([model.creatTimeStr longLongValue]/1000)];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    cell.tinmeLabel.text = [NSString stringWithFormat:@"到访时间:%@",confromTimespStr];
    cell.remarkLabel.text = [NSString stringWithFormat:@"备注:%@",model.remarkStr];
    for (int i = 0; i <model.houseTypeArr.count;i++ ) {
        NSDictionary *dic = model.houseTypeArr[i];
        
        if (model.houseTypeArr.count == 1) {
            _typeNameStr = dic[@"houseTypeName"];
        }else{
            if (i == 0) {
                 _typeNameStr = dic[@"houseTypeName"];
            }else{
                _typeNameStr =  [_typeNameStr stringByAppendingString:
                                [NSString stringWithFormat:@",%@",dic[@"houseTypeName"]]];
            }
        }
        
    }
    cell.typeLabel.text = _typeNameStr;
    if ([model.sexStr isEqualToString:@"1"]) {
        cell.sexLabel.text = @"性别: 先生";
    }else if ([model.sexStr isEqualToString:@"2"]){
        cell.sexLabel.text = @"性别: 女士";
    }
    if ([model.ageGroupStr isEqualToString:@"20"]) {
        cell.ageLabel.text = @"年龄段: 20-30";
    } else if ([model.ageGroupStr isEqualToString:@"30"]) {
        cell.ageLabel.text = @"年龄段: 30-40";
    }else if ([model.ageGroupStr isEqualToString:@"40"]) {
        cell.ageLabel.text = @"年龄段: 40-50";
    }else if ([model.ageGroupStr isEqualToString:@"50"]) {
        cell.ageLabel.text = @"年龄段: 50-60";
    }else if ([model.ageGroupStr isEqualToString:@"60"]) {
        cell.ageLabel.text = @"年龄段: 60以上";
    }

    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeModel *model = _staffDataArray[indexPath.row];

    DetailViewController *detail = [DetailViewController new];
    detail.ViewIdentify = @"修改客户信息";
    detail.staffID = model.recId;
    detail.changeNameStr = model.staffNameStr;
    detail.changePhoneStr = model.phoneNumStr;
    detail.changeRemarkStr = model.remarkStr;
    detail.changtypeArr = model.houseTypeArr;
    [self.navigationController pushViewController:detail animated:YES];
    
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 123;
}


-(void)requestManageData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"processTag":@"2",@"pageIndex":[NSString stringWithFormat:@"%d",_count],@"rowPerPage":@"10"};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kCustomerDataQuery];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"%@",responseObject);
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            [_staffDataArray removeAllObjects];
            if (responseObject[@"custInfDtos"] != [NSNull null]) {
                NSArray *array = responseObject[@"custInfDtos"];
                for (NSDictionary *dic in array) {
                    TreeModel *model = [[TreeModel alloc]init];
                    model.creatTimeStr = [dic[@"createDate"]stringValue];
                    model.staffNameStr = dic[@"custName"];
                    model.phoneNumStr = dic[@"phoneNumber"];
                    model.recId = dic[@"recId"];
                    model.remarkStr = dic[@"remark"];
                    model.houseTypeArr= dic[@"hoiseTypes"];
                    model.ageGroupStr = dic[@"ageGroup"];
                    model.sexStr = [dic[@"sex"]stringValue];
                    [_staffDataArray addObject:model];
                }
                
                _Allcount = [responseObject[@"pageCount"]intValue];
                [self.tableView reloadData];
            }else{
                _NoStaffView.hidden = NO;
                _tableView.hidden = YES;
            }
           
        }else{
            NSLog(@"客户列表出错码和信息 %@ %@",responseObject[@"errorCode"],responseObject[@"errorMessage"]);
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"客户列表error %@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
