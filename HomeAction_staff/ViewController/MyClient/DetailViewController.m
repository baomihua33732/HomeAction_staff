//
//  DetailViewController.m
//  HomeAction_staff
//
//  Created by 郭同明 on 16/9/20.
//  Copyright © 2016年 陈宝祥. All rights reserved.
//

#import "DetailViewController.h"
#define Start_X 20.0f           // 第一个按钮的X坐标
#define Start_Y 35.0f           // 第一个按钮的Y坐标
#define Width_Space 5.0f        // 2个按钮之间的横间距
#define Height_Space 20.0f      // 竖间距

@interface DetailViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;    //备注View
@property (strong, nonatomic) IBOutlet UIView *typeView;              //户型View
@property (strong, nonatomic) IBOutlet UIView *ageView;                //年龄view
@property (strong, nonatomic) IBOutlet UIView *genderView;             //性别view
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;              //标题view

@property (strong, nonatomic) IBOutlet UIButton *maketureBtn;
@property(nonatomic,strong)UIButton *chooseTypeBtn;       //户型
@property(nonatomic,strong)UIButton *chooseAgeBtn;       //年龄
@property(nonatomic,strong)UIButton *chooseGenderBtn;    //性别

@property (nonatomic) NSInteger isChooseNum;  //户型是否为选中状态

@property (nonatomic, strong) NSMutableArray *typeDataArr;
@property (nonatomic, strong) NSMutableArray *typeTempArr;
@property (nonatomic, strong) NSMutableArray *typeNameArr;
@property (nonnull, strong) NSString *typeNameStr;//之前选择的户型
@property (nonnull, strong) NSString *changeNum;//判断用户是否修改过户型
@property (nonatomic, strong) NSMutableArray *typeChooseEndArr;//选择户型之后的数组
@end

@implementation DetailViewController

-(void)viewWillAppear:(BOOL)animated{
    _typeChooseEndArr = [NSMutableArray new];
    if ([_ViewIdentify isEqualToString:@"webView"]){
        _scrollView.hidden = YES;
        _titleLabel.text = _ViewIdentify;
    }else if ([_ViewIdentify isEqualToString:@"添加足迹"]){
        _titleLabel.text = @"添加足迹";
        [self requestTypeListData];//获取户型列表
    }else if ([_ViewIdentify isEqualToString:@"修改客户信息"]){
        
        _titleLabel.text = _ViewIdentify;

        _nameTF.text = _changeNameStr;
        _phoneTF.text = _changePhoneStr;
        _detailTextView.text = _changeRemarkStr;
        
          [self requestTypeListData];//获取户型列表
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (ScreenHeight == 480) {
        self.scrollView.contentSize = CGSizeMake(0, 568);
    }
    self.scrollView.scrollEnabled = YES;
    _detailTextView.layer.masksToBounds = YES;
    _detailTextView.layer.cornerRadius = 3;
    _maketureBtn.layer.masksToBounds = YES;
    _maketureBtn.layer.cornerRadius = 3;

    _phoneTF.delegate =self;
    _nameTF.delegate = self;
    _detailTextView.delegate = self;
  
   
}
#pragma mark --- 点击回车键收键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
#pragma mark ---设置选择栏
-(void)setChoose{
    //关注类型
//    NSMutableArray *arry = [[NSMutableArray alloc]initWithObjects:@"AAAA",@"B",@"C",@"D",@"E",nil];
    
    for (int i = 0 ; i < _typeDataArr.count; i++) {
        ClassModel *model = _typeDataArr[i];
        NSInteger index = i % _typeDataArr.count;
        NSInteger page = i / _typeDataArr.count;
        
        // 圆角按钮
      UIButton *  aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aBt.layer.borderWidth = 1.0f;
        aBt.layer.borderColor = [[UIColor grayColor]CGColor];
        aBt.layer.masksToBounds = YES;
        aBt.layer.cornerRadius = 3;
        aBt.frame = CGRectMake(index * (60 + Width_Space) + Start_X, page  * (25 + Height_Space)+Start_Y, 60, 25);
    
        //tag标记值
        aBt.tag = i;
        //文字
        [aBt setTitle:model.typeName forState:UIControlStateNormal];
        aBt.backgroundColor = [UIColor whiteColor];
        [aBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        aBt.titleLabel.font = [UIFont systemFontOfSize:12];
        [aBt addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeView addSubview:aBt];
    }
   
    
    //————————————————————————————————————  年龄 ----------------------
    NSMutableArray *ageArry = [[NSMutableArray alloc]initWithObjects:@"20-30",@"30-40",@"40-50",@"50-60",@"60以上",nil];
    for (int i = 0 ; i < ageArry.count; i++) {
        NSInteger index = i % 5;
        NSInteger page = i / 5;
        
        // 圆角按钮
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aBt.layer.borderWidth = 1.0f;
        aBt.layer.borderColor = [[UIColor grayColor]CGColor];
        aBt.layer.masksToBounds = YES;
        aBt.layer.cornerRadius = 3;
        aBt.frame = CGRectMake(index * (55 + Width_Space) + Start_X, page  * (25 + Height_Space)+Start_Y, 55, 25);
        //tag标记值
        aBt.tag = i;
        //文字
        [aBt setTitle:ageArry[i] forState:UIControlStateNormal];
        
  
   
            aBt.backgroundColor = [UIColor whiteColor];
            [aBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      aBt.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [aBt addTarget:self action:@selector(ageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.ageView addSubview:aBt];
    }
    //————————————————————————————————————  性别 ----------------------
    NSMutableArray *genderArry = [[NSMutableArray alloc]initWithObjects:@"男",@"女",nil];
    for (int i = 0 ; i < genderArry.count; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        
        // 圆角按钮
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aBt.layer.borderWidth = 1.0f;
        aBt.layer.borderColor = [[UIColor grayColor]CGColor];
        aBt.layer.masksToBounds = YES;
        aBt.layer.cornerRadius = 3;
        aBt.frame = CGRectMake(index * (55 + Width_Space) + Start_X, page  * (25 + Height_Space)+Start_Y, 55, 25);
        //tag标记值
        aBt.tag = i;
        //文字
        [aBt setTitle:genderArry[i] forState:UIControlStateNormal];
            aBt.backgroundColor = [UIColor whiteColor];
            [aBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        aBt.titleLabel.font = [UIFont systemFontOfSize:12];
        [aBt addTarget:self action:@selector(genderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.genderView addSubview:aBt];
    }

    
}
#pragma mark ---- 客户管理确定按钮
- (IBAction)makeTrueBtnAction:(id)sender {

        _typeTempArr = [NSMutableArray new];
        for (int i =0 ; i <_typeDataArr.count; i++) {
            ClassModel * model = _typeDataArr[i];
            for (int j = 0; j < _typeNameArr.count; j++) {
                if ([model.typeName isEqualToString:_typeNameArr[j]]) {
                    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:model.typeID,@"houseTypeId",model.typeName,@"houseTypeName", nil];
                    
                    [_typeTempArr addObject:aDic];
                }
            }
        }
    if (_typeTempArr.count != 0 && _ageStr.length != 0 && _sexStr.length != 0) {
        [self requestMakeSureData];
    }else if(_typeTempArr.count == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"请选择户型" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        //            }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        //            [alert addAction:cancelAction];
        [alert addAction:defaultAction];
    }else if (_ageStr.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"请选择年龄" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        //            }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        //            [alert addAction:cancelAction];
        [alert addAction:defaultAction];
    }else if (_sexStr.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"请选择性别" preferredStyle:UIAlertControllerStyleAlert];
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
#pragma mark --- 选择的点击事件
//-----------------------------------  类型-------------------------------
-(void)typeBtnAction:(UIButton *)sender{
    
    _changeNum = @"修改过户型";
    if (sender.selected == NO) {
        sender.backgroundColor = kBlueColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.selected = YES;
        [_typeNameArr addObject:sender.titleLabel.text];
    }else if(sender.selected == YES){
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        sender.selected = NO;
        [_typeNameArr removeObject:sender.titleLabel.text];
        
    }
    
    
    
    
    
    
}
//-----------------------------------  年龄-------------------------------
-(void)ageBtnAction:(UIButton *)sender{
    
    
    //点击的和上次是一样的
    if(_chooseAgeBtn == sender) {
        
        //        //不做处理
        
        
    } else{
        
        sender.backgroundColor = [UIColor colorWithRed:6/255.0 green:158/255.0 blue:255/255.0 alpha:1.0];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _chooseAgeBtn.backgroundColor = [UIColor whiteColor];
        [_chooseAgeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    _chooseAgeBtn = sender;
    _ageStr = [sender.titleLabel.text substringToIndex:2];
  
    
}
//-----------------------------------  性别-------------------------------
-(void)genderBtnAction:(UIButton *)sender{
    

    
    //点击的和上次是一样的
    if(_chooseGenderBtn == sender) {
        
        //        //不做处理
        
        
    } else{
        
        sender.backgroundColor = [UIColor colorWithRed:6/255.0 green:158/255.0 blue:255/255.0 alpha:1.0];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _chooseGenderBtn.backgroundColor = [UIColor whiteColor];
        [_chooseGenderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    _chooseGenderBtn = sender;
    
    if ([sender.titleLabel.text isEqualToString:@"男"]) {
        _sexStr = @"1";
    }else if ([sender.titleLabel.text isEqualToString:@"女"]){
        _sexStr = @"2";
    }
   
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ---- 获取户型
-(void)requestTypeListData{
     _typeDataArr = [NSMutableArray new];
    _typeNameArr = [NSMutableArray new];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = nil;
    
    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kHouseTypeList];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
  
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            NSArray *array = responseObject[@"houseTypeList"];
            for (NSDictionary *dic in array) {
                ClassModel *model = [ClassModel new];
                model.typeID = dic[@"houseTypeId"];
                model.typeName = dic[@"houseTypeName"];
                [_typeDataArr addObject:model];
           
            }
        }else {
            
        }
         [self setChoose];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取户型列表error ");
    }];
}
#pragma mark ---- 客户资料录入
-(void)requestMakeSureData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"recId":_staffID,@"custName":_nameTF.text,@"phoneNumber":_phoneTF.text,@"sex":_sexStr,@"ageGroup":_ageStr,@"HouseTypeList":_typeTempArr,@"remark":_detailTextView.text};

    NSString *url=[NSString stringWithFormat:@"%@%@",KURL,kCustomerDataEntry];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        //         NSLog(@"上传进度:%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
        if ([responseObject[@"status"]isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if ([responseObject[@"errorCode"]isEqualToString:@"10003"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:responseObject[@"errorMessage"] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
            //            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            //            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
        }else {
            NSLog(@"%@  %@",responseObject[@"errorCode"],responseObject[@"errorMessage"]);
        }
        [self setChoose];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"客户资料录入error ");
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
