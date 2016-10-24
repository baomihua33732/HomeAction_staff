//
//  ChangeViewController.m
//  HomeAction_staff
//
//  Created by 郭同明 on 16/9/19.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "ChangeViewController.h"
#import "HomeViewController.h"
@interface ChangeViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet JKCountDownButton *sendBtn; //发送验证码按钮
@property (strong, nonatomic) IBOutlet UIButton *makeSureBtn; //确认按钮
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;  //标题
@property (strong, nonatomic) IBOutlet UIView *nickNameView;//名字View
@property (strong, nonatomic) IBOutlet UIView *phoneView;//手机号View
@property (strong, nonatomic) IBOutlet UIView *passWordView;//密码View
@property (strong, nonatomic) IBOutlet UITextField *nickNameTF;//姓名
@property (strong, nonatomic) IBOutlet UITextField *checkTF;//验证码

@property (strong, nonatomic) IBOutlet UITextField *phoneTF;//手机号

@property (strong, nonatomic) IBOutlet UITextField *oldPWTF;//原密码

@property (strong, nonatomic) IBOutlet UITextField *newpwTF;//新密码

@end

@implementation ChangeViewController

-(void)viewWillAppear:(BOOL)animated{
    if ([self.ViewIdentify isEqualToString:@"修改姓名"]) {
        _titleLabel.text = @"姓名修改";
        _phoneView.hidden = YES;
        _passWordView.hidden = YES;
    }else if([self.ViewIdentify isEqualToString:@"修改手机号"]){
          _titleLabel.text = @"联系方式";
        _nickNameView.hidden = YES;
        _passWordView.hidden = YES;
    }else if([self.ViewIdentify isEqualToString:@"修改密码"]){
          _titleLabel.text = @"修改密码";
        _nickNameView.hidden = YES;
        _phoneView.hidden = YES;
    }else if ([_ViewIdentify isEqualToString:@"重置密码"]){
        _titleLabel.text = @"重置密码";
        _nickNameView.hidden = YES;
        _passWordView.hidden = YES;
        _phoneTF.placeholder = @"请输入新密码";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 3;
    _makeSureBtn.layer.masksToBounds = YES;
    _makeSureBtn.layer.cornerRadius = 3;
    _nickNameTF.text = @"";
    _phoneTF.text = @"";
    _nickNameTF.delegate = self;
    _phoneTF.delegate = self;
    _oldPWTF.delegate = self;
    _newpwTF.delegate = self;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
#pragma mark --- 返回上一界面
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 发送验证码
- (IBAction)sendBtnAction:(id)sender {
}
#pragma mark --- 确认
- (IBAction)makeSureBtnAction:(id)sender {
  
    
    if ([self.ViewIdentify isEqualToString:@"修改姓名"]) {
         [self requestPersonMessageData];
    }else if([self.ViewIdentify isEqualToString:@"修改手机号"]){
         [self requestPersonMessageData];
    }else if([self.ViewIdentify isEqualToString:@"修改密码"]){
        
        if (_newpwTF.text.length >=6 && _newpwTF.text.length <=12&&_oldPWTF.text.length != 0 &&[_newpwTF.text rangeOfString:@" "].location ==NSNotFound) {
             [self requestPassWordData];
        }else if(_oldPWTF.text.length == 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"旧密码不正确" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
            //            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            //            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
        }else if ([_newpwTF.text rangeOfString:@" "].location !=NSNotFound){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码中不能含有空格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
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
       
    }else if ([_ViewIdentify isEqualToString:@"重置密码"]){
        _phoneTF.secureTextEntry = YES;
        _newpwTF.text = _phoneTF.text;
        _oldPWTF.text = _beginPW;
        [self requestPassWordData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- 请求修改昵称和手机号
-(void)requestPersonMessageData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"staffName":_nickNameTF.text,@"staffPhone":_phoneTF.text};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kUpdateInfoDeveloperStaff];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            
            if (_phoneTF.text.length !=0) {
                kShareManager.staffPhone = _phoneTF.text;
            }
            
            if (_nickNameTF.text.length != 0) {
                kShareManager.staffName = _nickNameTF.text;
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
               [self.navigationController popViewControllerAnimated:YES];
        }else if([responseObject[@"errorCode"]isEqualToString:@"10003"]||[responseObject[@"errorCode"]isEqualToString:@"10233"]){
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
        NSLog(@"修改个人信息error %@",error);
    }];
}

#pragma mark ---- 请求修改密码
-(void)requestPassWordData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    
    NSDictionary *parameters = @{@"staffPasswd":_newpwTF.text.MD5,@"oldStaffPasswd":_oldPWTF.text.MD5,@"developerStaffCode":[kStanderUserDefaults objectForKey:@"developerStaffCode"]};
    NSLog(@"  %@   %@   %@",_newpwTF.text,_oldPWTF.text,[kStanderUserDefaults objectForKey:@"developerStaffCode"]);
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kUpdateInfoDeveloperStaffPassword];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            if ([_ViewIdentify isEqualToString:@"重置密码"]){
                HomeViewController *homeVC = [HomeViewController new];
                [self.navigationController pushViewController:homeVC animated:YES];
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else if([responseObject[@"errorMessage"] isEqualToString:@"用户名或旧密码不正确"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"原始密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"errorMessage"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"修改密码error %@",error);
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
