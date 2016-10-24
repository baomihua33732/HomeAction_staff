//
//  MyClientViewController.m
//  HomeAction_staff
//
//  Created by 郭同明 on 16/9/13.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//


#import "MyClientViewController.h"
#import "DetailViewController.h"
#import "OuterTableViewCell.h"   //外层cell
#import "InsideTableViewCell.h"  //内层cell
#import "TreeModel.h"
#import "StaffViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface MyClientViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *leftView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) NSMutableArray* dataArray;  //左侧外层数组
@property (nonatomic,strong)NSMutableArray *dataArr;   //左侧内层数组
@property (nonatomic, strong) DetailViewController *detailVC;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (weak, nonatomic) IBOutlet UIButton *gobackBtn;
@property (weak, nonatomic) IBOutlet UIButton *showLeftBtn;  //展示左侧
@property (nonatomic, strong) NSMutableArray *staffDataArray;

@end

@implementation MyClientViewController

-(void)viewWillAppear:(BOOL)animated{
    _showLeftBtn.hidden = YES;
    _leftView.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = [[NSMutableArray alloc] init];
    _dataArr = [[NSMutableArray alloc]init];
    _staffDataArray = [NSMutableArray new];
   
    _tableView.delegate     =self;
    _tableView.dataSource   =self;
    _tableView.showsVerticalScrollIndicator = NO;
    _detailVC = [DetailViewController new];
    self.tableView.backgroundColor=[UIColor clearColor];
    _webView.hidden = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
    _showLeftBtn.hidden = YES;
    _imageView.image = [UIImage imageNamed:@"tableBack"];
    [self.tableView setBackgroundView:_imageView];
    [self requestQueryData];
    //添加手势
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftView:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeftView:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    
    
}
- (void)showLeftView:(UISwipeGestureRecognizer *)sender
{
    _showLeftBtn.hidden = YES;
    _leftView.hidden = NO;
}
- (void)closeLeftView:(UISwipeGestureRecognizer *)sender
{
    _leftView.hidden = YES;
    _showLeftBtn.hidden = NO;
}


#pragma mark --- 关闭左侧菜单
- (IBAction)showOrCloseBtnAction:(UIButton *)sender {
    _leftView.hidden = YES;
    _showLeftBtn.hidden = NO;
   
}
#pragma mark --- 展开左侧菜单
- (IBAction)showLeftViewBtnAction:(id)sender {
    _showLeftBtn.hidden = YES;
    _leftView.hidden = NO;
}

#pragma mark - Table view data source
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    TreeModel *node = _dataArray[section];
    if (node.isExpanded) {
        return node.sonNodes.count + 1;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentifier = @"OuterTableViewCell";
    static NSString *indentifier1 = @"RowCell";
    
    TreeModel *node;
    if (indexPath.row == 0) {
        node = _dataArray[indexPath.section];
      
    } else {
        TreeModel *nodeSection = _dataArray[indexPath.section];
        node = nodeSection.sonNodes[indexPath.row-1];
    }
    if(indexPath.row == 0) {
        OuterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OuterTableViewCell" owner:self options:nil] lastObject];
        }
        cell.backgroundColor=[UIColor clearColor];
        cell.outLabel.text = node.OneName;
        NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:node.pageIcon];
        cell.iconImageView.image =[UIImage imageWithData:_decodedImageData];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    } else {
        InsideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InsideTableViewCell" owner:self options:nil] lastObject];
        }
        cell.backgroundColor=[UIColor clearColor];
        cell.node = node;
        cell.insideLabel.text = node.twoName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeModel *node = _dataArray[indexPath.section];
    if (indexPath.row == 0) {
        
        BOOL isExpand = node.isExpanded;
        ///////////////////////////////////////////////////
        //控制Tree显示样式
        for (int i = 0; i<_dataArray.count; i++) {
            TreeModel *nodeI = _dataArray[i];
            
            nodeI.isExpanded = NO;
        }
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
        if ([node.OneName isEqualToString:@"客户管理"]) {
            
            [self requestManageData];
        }
        node.isExpanded = !isExpand;
        [tableView reloadData];
    }else{
        TreeModel *nodeSection = _dataArray[indexPath.section];
        node = nodeSection.sonNodes[indexPath.row-1];
        _leftView.hidden = YES;
        _showLeftBtn.hidden = NO;
       
    
        if ([node.pageType isEqualToString:@"20000"]) {
            NSString *str = [NSString stringWithFormat:@"%@%@?device=ios",kWebUrl,node.pageUrl];
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            _webView.delegate = self;
            [_webView loadRequest:request];
                    }
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"jstoocNoPrams"] = ^(){
        //调用方法处理内容
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    };

    _webView.hidden=NO;
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    return 40;
}

#pragma mark ---- 隐藏和展示左菜单
- (IBAction)leftBtnAction:(UIButton *)sender {
    _leftView.frame = CGRectMake(0, 72, 200, 496);
    
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self.webView goBack];
}
- (IBAction)testBtnAction:(id)sender {
   
    [self.navigationController pushViewController:_detailVC animated:YES];
}









#pragma mark ---- 请求报表菜单
-(void)requestQueryData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = nil;
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kQueryReportCatalog];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            NSArray *array = responseObject[@"reportcatalog"][@"children"];
    
            for (NSDictionary *dic in array) {
                TreeModel *model = [[TreeModel alloc]init];
                model.OneName = dic[@"DISPLAY_NAME"];
                 model.pageIcon = dic[@"DISPLAY_ICON"];
                [_dataArray addObject:model];
                if (dic[@"children"] != [NSNull null]){
                    NSMutableArray *arrays = dic[@"children"];
                    
                    _dataArr = [NSMutableArray new];
                    for (NSDictionary *dics in arrays) {
                        TreeModel *model = [[TreeModel alloc]init];
                        model.twoName = dics[@"DISPLAY_NAME"];
                        model.pageType = dics[@"PAGE_TYPE"];
                        model.pageUrl = dics[@"PAGE_ACCESS"];
                       
                        [_dataArr addObject:model];
                    }
                    model.sonNodes = [NSMutableArray arrayWithArray:_dataArr];
                }
            }
            [self.tableView reloadData];
        }else if([responseObject[@"errorCode"]isEqualToString:@"10200"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",responseObject[@"errorMessage"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            NSLog(@"菜单出错码和信息 %@ %@",responseObject[@"errorCode"],responseObject[@"errorMessage"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"报表error %@",error);
    }];
}


#pragma mark ---- 请求客户资料查询
-(void)requestManageData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"processTag":@"2",@"pageIndex":@"1",@"rowPerPage":@"10"};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kCustomerDataQuery];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
       
//        NSLog(@"99999999 %@",responseObject);
        _leftView.hidden = YES;
        _showLeftBtn.hidden = NO;
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
            }else{
                
            }
            StaffViewController *staffVC = [StaffViewController new];
            staffVC.staffDataArray = _staffDataArray;
            staffVC.strNum = @"1";
            [self.navigationController pushViewController:staffVC animated:NO];
           
        }else{
            NSLog(@"客户列表出错码和信息 %@ %@",responseObject[@"errorCode"],responseObject[@"errorMessage"]);
        }
    
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
