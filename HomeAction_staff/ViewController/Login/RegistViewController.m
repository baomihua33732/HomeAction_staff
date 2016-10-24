//
//  RegistViewController.m
//  HomeAction_staff
//
//  Created by 郭同明 on 16/9/23.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginViewController.h"
#import "AddViewController.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UIView *zhucemaView;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;
@property (weak, nonatomic) IBOutlet UITextField *registTF;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
       self.navigationController.navigationBarHidden = YES;
    _zhucemaView.layer.masksToBounds = YES;
    _zhucemaView.layer.cornerRadius = 3;
    _makeSureBtn.layer.masksToBounds = YES;
    _makeSureBtn.layer.cornerRadius = 3;
    _registTF.delegate = self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
#pragma mark --- 注册按钮
- (IBAction)registBtnAction:(id)sender {
    
    [self requestRegistData];

    
  
}
#pragma mark --- 切换到登陆
- (IBAction)GoLoginBtnAction:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstOpen"]) {
        LoginViewController *loginVC = [LoginViewController new];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
       [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark ---- 请求注册码
-(void)requestRegistData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"inputRegisterCode":_registTF.text};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kValidRegisterCode];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            
            AddViewController *addVC = [AddViewController new];
            addVC.staffCodeStr = responseObject[@"developerStaffCode"];
            addVC.registerCodeStr = _registTF.text;
            [self.navigationController pushViewController:addVC animated:YES];
            
        }else if([responseObject[@"errorCode"]isEqualToString:@"10221"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:responseObject[@"errorMessage"] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
            //            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            //            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            
        }else if([responseObject[@"errorCode"]isEqualToString:@"10222"]){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"注册码失效或错误" preferredStyle:UIAlertControllerStyleAlert];
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
        NSLog(@"验证注册码接口error %@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
