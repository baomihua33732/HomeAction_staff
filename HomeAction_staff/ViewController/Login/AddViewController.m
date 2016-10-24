//
//  AddViewController.m
//  HomeAction_staff
//
//  Created by 郭同明 on 16/9/23.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "AddViewController.h"
#import "LoginViewController.h"
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _accountLabel.text = _staffCodeStr;
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)makeSureBtnAction:(id)sender {
    if (_nameTF.text.length !=0 &&_phoneTF.text.length !=0&&_passwordTF.text.length != 0&&[_passwordTF.text rangeOfString:@" "].location ==NSNotFound) {
        [self requestSureData];
    }else if (_nameTF.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if (_phoneTF.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if (_passwordTF.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if ([_passwordTF.text rangeOfString:@" "].location !=NSNotFound){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码中不能含有空格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- 显示密码
- (IBAction)showPWBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        
        _passwordTF.secureTextEntry = YES;
    }else if (sender.selected){
        _passwordTF.secureTextEntry = NO;
        
    }
}
#pragma mark ---- 请求完善个人资料
-(void)requestSureData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"developerStaffCode":_staffCodeStr,@"registerCode":_registerCodeStr,@"staffName":_nameTF.text,@"staffPasswd":[_passwordTF.text MD5],@"staffPhone":_phoneTF.text};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kCreateInfoDeveloperStaff];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            LoginViewController *loginVC = [LoginViewController new];
            loginVC.accountStrs = _staffCodeStr;
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }else if([responseObject[@"errorCode"]isEqualToString:@"10233"]||[responseObject[@"errorCode"]isEqualToString:@"10209"]||[responseObject[@"errorCode"]isEqualToString:@"10003"]||[responseObject[@"erroeCode"]isEqualToString:@"10208"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:responseObject[@"errorMessage"] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
            //            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            //            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:[NSString stringWithFormat:@"错误码:%@",responseObject[@"errorCode"]] preferredStyle:UIAlertControllerStyleAlert];
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
        NSLog(@"登录error %@",error);
    }];
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
