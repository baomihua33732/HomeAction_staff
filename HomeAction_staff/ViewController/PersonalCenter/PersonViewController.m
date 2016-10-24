//
//  PersonViewController.m
//  HomeAction_staff
//
//  Created by 郭同明 on 16/9/13.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "PersonViewController.h"
#import "ChangeViewController.h"
#import "LoginViewController.h"
@interface PersonViewController ()

@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel; //姓名
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;//联系方式
@property (strong, nonatomic) IBOutlet UILabel *passWordLabel;//密码
@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;//项目名称
@property (strong, nonatomic) IBOutlet UILabel *projectCompanyLabel;//公司名称
@property (strong, nonatomic) IBOutlet UIButton *exitBtn; //退出按钮
@end

@implementation PersonViewController


-(void)viewWillAppear:(BOOL)animated{
    _nickNameLabel.text = kShareManager.staffName;
    _phoneLabel.text = kShareManager.staffPhone;
     _projectNameLabel.text = kShareManager.orgNameStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _exitBtn.layer.masksToBounds = YES;
    _exitBtn.layer.cornerRadius = 3;
    
   
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 修改姓名
- (IBAction)NameBtnAction:(id)sender {
    ChangeViewController *changeVC = [ChangeViewController new];
    changeVC.ViewIdentify = @"修改姓名";
    [self.navigationController pushViewController:changeVC animated:YES];
    
}
#pragma mark --- 修改手机号
- (IBAction)phoneBtnAction:(id)sender {
    ChangeViewController *changeVC = [ChangeViewController new];
    changeVC.ViewIdentify = @"修改手机号";
    [self.navigationController pushViewController:changeVC animated:YES];
}
#pragma mark --- 修改密码
- (IBAction)passwordBtnAction:(id)sender {
    ChangeViewController *changeVC = [ChangeViewController new];
    changeVC.ViewIdentify = @"修改密码";
    [self.navigationController pushViewController:changeVC animated:YES];
}
#pragma mark --- 退出登录
- (IBAction)exitBtnAction:(id)sender {
    
    [self requestExitLoginData];
    
}

#pragma mark ---- 数据退出登录请求
-(void)requestExitLoginData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    NSDictionary *parameters = nil;
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kExitLogin];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
//        NSLog(@"进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@" responseObject:%@",responseObject);
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            
          
            LoginViewController *loginVC = [LoginViewController new];
            [self.navigationController pushViewController:loginVC animated:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
           
         
        }else if ([responseObject[@"errorCode"]isEqualToString:@"40003"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:responseObject[@"errorMessage"] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//               
//            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
            }];
//            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"退出登录error%@",error);
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
