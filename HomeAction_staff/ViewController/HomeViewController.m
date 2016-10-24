//
//  HomeViewController.m
//  HomeAction_staff
//
//  Created by 郭同明 on 16/9/13.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "HomeViewController.h"
#import "MyClientViewController.h"  //我的客户
#import "PersonViewController.h"   //个人中心

@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *twoCodeImageView; //二维码

@property (nonatomic, strong) NSString *app_Version;                      //版本号
@property (nonatomic, strong) NSString *versionNum;                      //版本号
@property (nonatomic, strong) NSString *versionUrl;                      //版本升级下载地址
@property (nonatomic, strong) NSString *versionDesc;                  //版本升级描述
@property (weak, nonatomic) IBOutlet UIView *teoCodeBackView;
@property (weak, nonatomic) IBOutlet UIView *twosView;

@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [self requestrTwoNumData];
    [self requestrVersionData];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setOther];
}
#pragma mark --- 设置其他
-(void)setOther{
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    if (ScreenHeight == 480) {
        self.scrollView.contentSize = CGSizeMake(0, 665);
    }
    self.scrollView.scrollEnabled = YES;

  
    
   

    
   
    
}



#pragma mark --- 我的服务
- (IBAction)MyClientBtnAction:(id)sender {
    MyClientViewController *clientTVC = [MyClientViewController new];
    [self.navigationController pushViewController:clientTVC animated:YES];
   

    
}

#pragma mark --- 个人中心
- (IBAction)PersonalBtnAction:(id)sender {
    PersonViewController *personalVC = [PersonViewController new];
    [self.navigationController pushViewController:personalVC animated:YES];
    
    
 
}
#pragma mark --- 检查版本更新
-(void)requestrVersionData{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    _app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = nil;
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kAppVersionCheck];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            NSArray *array = responseObject[@"systemInfoDtoList"];
            for (NSDictionary *dic in array) {
                if ([dic[@"paraName"]isEqualToString:kVersionNum]) {
                    _versionNum = dic[@"paraChar1"];
                }
                if ([dic[@"paraName"]isEqualToString:kVersionUrl]) {
                    _versionUrl = dic[@"paraChar1"];
                }
                if ([dic[@"paraName"]isEqualToString:kVersionDesc]) {
                    _versionDesc = dic[@"paraChar1"];
                }
            }
            
            NSArray * versionNumArr = [_versionNum componentsSeparatedByString:@","];//用,号截成数组
            if ([versionNumArr[0] isEqualToString:_app_Version]) {
                
            }else if (![versionNumArr[0] isEqualToString:_app_Version]&&[versionNumArr[1] isEqualToString:@"0"]){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:_versionDesc preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_versionUrl]];
                    [[UIApplication sharedApplication]openURL:url];
                    
                }];
                [alert addAction:cancelAction];
                [alert addAction:defaultAction];
            }else if (![versionNumArr[0] isEqualToString:_app_Version]&&[versionNumArr[1] isEqualToString:@"1"]){
               
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_versionUrl]];
                [[UIApplication sharedApplication]openURL:url];
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"检查版本error %@",error);
    }];
    
}
#pragma mark --- 生成二维码
-(void)requestrTwoNumData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = nil;
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kHouseProjectQr];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject%@ ",responseObject);
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
           _twoCodeStr = responseObject[@"qrCdoe"];
            CGSize QRSize = CGSizeMake(150.0f, 150.0f);
            _twoCodeImageView.image=[UIImage generateQRCode:_twoCodeStr size:QRSize ];
            
            CGSize LogoSize = CGSizeMake(40.0f, 40.0f);
            _twoCodeImageView.image= [_twoCodeImageView.image  mergeImage:[UIImage imageNamed:@"home_icon"] size:LogoSize];
        }else {
            _twosView.hidden = YES;
            _twoCodeImageView.hidden = YES;
            _teoCodeBackView.hidden = YES;
            NSLog(@"二维码 errorCode %@,errorMessage %@",responseObject[@"errorCode"],responseObject[@"errorMessage"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取二维码接口失败error %@",error);
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
