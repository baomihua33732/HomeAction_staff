//
//  LoginViewController.m
//  HomeAction_staff
//
//  Created by 郭同明 on 16/9/13.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "LoginViewController.h"
#import "DetailViewController.h"
#import "HomeViewController.h"
#import "RegistViewController.h"
#import "ChangeViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *accountTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UIView *accountView;
@property (strong, nonatomic) IBOutlet UIView *passWordView;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (nonatomic, strong) NSString *remberAccountStr;
@property (nonatomic,strong) NSString *isFixPass;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
   
//    if ([[kStanderUserDefaults objectForKey:@"remberAccount"] length] != 0) {
        _accountTF.text = [kStanderUserDefaults objectForKey:@"remberAccount"];
//    }else{
//        _accountTF.text = @"";
//    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    [_accountTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_accountTF setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [_passWordTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _accountView.layer.masksToBounds = YES;
    _accountView.layer.cornerRadius = 3;
    _passWordView.layer.masksToBounds = YES;
    _passWordView.layer.cornerRadius = 3;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 3;
    _remberAccountStr = @"记住";

    if (_accountStrs.length != 0) {
        _accountTF.text = _accountStrs;
    }
    _accountTF.delegate = self;
    _passWordTF.delegate = self;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- 显示密码
- (IBAction)showPassWordBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        
        _passWordTF.secureTextEntry = YES;
    }else if (sender.selected){
        _passWordTF.secureTextEntry = NO;
      
    }
}
#pragma mark --- 记住账号
- (IBAction)remberAccountBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        _remberAccountStr = @"记住";
        [kStanderUserDefaults setObject:_accountTF.text forKey:@"remberAccount"];
    }else if (sender.selected){
        _remberAccountStr = @"不记住";
        [kStanderUserDefaults removeObjectForKey:@"remberAccount"];
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)goBack:(id)sender {
    RegistViewController *regist = [RegistViewController new];
    [self.navigationController pushViewController:regist animated:YES];
}
#pragma mark --- 登录
- (IBAction)loginBtnAction:(id)sender {
    if (_passWordTF.text.length >=6 && _passWordTF.text.length <=12) {
         [self requestLoginData];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"密码长度必须大于6位小于12位" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        //            }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        //            [alert addAction:cancelAction];
        [alert addAction:defaultAction];
    }
   

   
}


#pragma mark ---- 登录数据请求
-(void)requestLoginData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
       manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil]; 
    NSDictionary *parameters = @{@"developerStaffCode":_accountTF.text,@"staffPasswd":_passWordTF.text.MD5};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kLoginIn];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
//         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"*********** %@",responseObject);
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            if ([_remberAccountStr isEqualToString:@"记住"]) {
                 [kStanderUserDefaults setObject:_accountTF.text forKey:@"remberAccount"];
            }
            [kStanderUserDefaults setObject:responseObject[@"developerStaffCode"] forKey:@"developerStaffCode"]; //存用户名
            [JPUSHService setTags:nil alias:responseObject[@"developerStaffCode"] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            }];
            if (responseObject[@"staffName"]!= [NSNull null]) {
                kShareManager.staffName = responseObject[@"staffName"];
            }else{
                kShareManager.staffName = @"";
            }
            if (responseObject[@"staffPhone"]!= [NSNull null]) {
                kShareManager.staffPhone = responseObject[@"staffPhone"];
            }else{
                kShareManager.staffPhone = @"";
            }
            if (responseObject[@"orgName"]!= [NSNull null]) {
                kShareManager.orgNameStr = responseObject[@"orgName"];
            }else{
                kShareManager.orgNameStr = @"";
            }
            _isFixPass = [responseObject[@"isFixPass"] stringValue];
            if ([_isFixPass isEqualToString:@"1"]) {
                ChangeViewController *changeVC = [ChangeViewController new];
                changeVC.ViewIdentify = @"重置密码";
                changeVC.beginPW = responseObject[@"developerStaffCode"];
                [self.navigationController pushViewController:changeVC animated:YES];
            }else{
                HomeViewController *homeVC = [HomeViewController new];
                [self.navigationController pushViewController:homeVC animated:YES];
            }


        }else if([responseObject[@"errorCode"]isEqualToString:@"10200"]||[responseObject[@"errorCode"]isEqualToString:@"10198"]){
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
