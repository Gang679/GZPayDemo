//
//  ViewController.m
//  GZPayDemo
//
//  Created by xinshijie on 2017/4/6.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//

#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"


#define GZWidth [UIScreen mainScreen].bounds].size.width ;
#define GZHeight [UIScreen mainScreen].bounds].size.height;
@interface ViewController ()
{
    NSString *order_sn ;
}

//.strong
@property (nonatomic,strong) UIButton *AliPayButton;
//.strong
@property (nonatomic,strong) UIButton *WeiXinPayButton;

@property (nonatomic, strong)GZURLSessionTask *TPTask ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GangZiPayDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    self.AliPayButton.backgroundColor = [UIColor orangeColor];
    self.WeiXinPayButton.backgroundColor = [UIColor redColor];
    
    UIBarButtonItem *RightBar = [[UIBarButtonItem alloc]initWithTitle:@"刚子分享" style:UIBarButtonItemStylePlain target:self action:@selector(GZPay:)];
    RightBar.tag = 113 ;
    
    self.navigationItem.rightBarButtonItem = RightBar ;
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(UIButton *)AliPayButton{
    if (_AliPayButton == nil) {
        _AliPayButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, self.view.bounds.size.width - 100, 50)];
        [_AliPayButton setTitle:@"支付宝支付" forState:UIControlStateNormal];
        [_AliPayButton addTarget:self action:@selector(GZPay:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_AliPayButton];
        _AliPayButton.tag = 111;
    }
    return _AliPayButton ;
}

-(UIButton *)WeiXinPayButton{
    if (_WeiXinPayButton == nil) {
        _WeiXinPayButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, self.view.bounds.size.width - 100, 50)];
        [_WeiXinPayButton setTitle:@"微信支付" forState:UIControlStateNormal];
        [_WeiXinPayButton addTarget:self action:@selector(GZPay:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_WeiXinPayButton];
        _WeiXinPayButton.tag = 112 ;
    }
    return _WeiXinPayButton ;
}

-(void)GZPay:(UIButton *)sender{
    if (sender.tag == 111) {
        NSDictionary *parma = @{@"user_id":@"209",
                                @"amount":@"1",
                                @"money":@"0.1",
                                @"payment":@"支付宝支付"
                                };
        NSString *url = @"http://www.88meichou.com/api/alipay/getPayment.php";
        
        self.TPTask = [ImageTask Only_uploadImageWithUrlString:url parameters:parma withImageArray:nil withSuccessBlock:^(id response) {
            order_sn = [response objectForKey:@"order_sn"];
            
            [self buyproduct];
            
        } withFailurBlock:^(NSError *error) {
            
        } withUpLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            
        }];

    }else if (sender.tag == 112) {
        NSDictionary *parma1 = @{@"user_id":@"209",
                                 @"amount":@"1",
                                 @"money":@"0.1",
                                 @"payment":@"支付宝支付"
                                 };
        NSString *url = @"http://www.88meichou.com/api/alipay/getPayment.php";
        self.TPTask = [ImageTask Only_uploadImageWithUrlString:url parameters:parma1 withImageArray:nil withSuccessBlock:^(id response) {
            
            //            NSLog(@"~~~~~!!@@~~~~~%@",response);
            order_sn = [response objectForKey:@"order_sn"];
            
            [self ByWeiXinBuy];
            
        } withFailurBlock:^(NSError *error) {
            
        } withUpLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            
        }];
    }else{
        NSString *str =  [NSString stringWithFormat:@"http://www.88meichou.com/share.php?id=%@",@"836"];
        NSString *shareText = [NSString stringWithFormat:@"%@ 我为自己代言",@"刚子"];
        NSString  *ShareTitle = [NSString stringWithFormat:@"%@,%@",@"刚子",@"友盟分享功能实现"];
        NSString *urlSrt = [NSString stringWithFormat:@"%@",str];
        GZShareManage *manger = [GZShareManage shareManage];
        
        manger.shareTitle = ShareTitle ;
        manger.shareText = shareText ;
        manger.shareImageUrl = @"http://tupian.enterdesk.com/2012/0606/gha/10/11285966_1334673509285.jpg" ;
        manger.shareWebpageUrl = urlSrt ;
        
        [manger gz_shareListWithShareType:GZUM_SHARE_TYPE_WEB_LINK viewController:self];
    }

}


-(void)buyproduct{
    //四美坊app商户ID 用户ID 私钥
    NSString *pid = @"2088421263479877";
    NSString *appID = @"2016092201949956";
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALhNuoy6DrIF27wxQXT1JarZIhCleLbGZIKi/xLGb0KMP6m9xP17GJ0asqhDqIPQOos2vmwmeA8ast2gQQWzbtaKMyqsrxQgrlTvYomwo3579JwOS29wgpjAWn2YQ9t3YGlECpFtoX3KtyJ7JPhtTcfJqPpHiNFjujmPCU83s9qJAgMBAAECgYAw4y1gttm/Dx7CRK6AP6bGMuJ+V+Y1VVrD7EiMymYo2NrqQ5RFSKm2wqYxTAEfNdTRqKvKNEoUd5iKgT++K2JywugECubbv/2hSzUqsr1VhQ/buzIwSTTPFJHrG2WSL+c8hqgsxk3Fn79vKarRnPdYj7r+7xZ43uwfxx/mzaXnoQJBANtyF6P8vjJLazCwrX+bg7CS447c/38Nsai6CTOr4GyvEzd+sIUkFahTGzk83qBdU4ksMGfGrv7Bwvk5X2c4AcMCQQDXAQ9067qOtGsWXiDgNqDe2+CgNotXwhBOKGlbv3t9xYi89K2u9hqIz3yUWBbbxOaolCJvpFREJV4mmtXQiEHDAkEAr1tijMZg7ivaQhRM8FXDTAx1DyqGeG7m8t+GjuXf9rmIb6YrRJlrPRD8Bicf96HcKRdIrwTTvfvz49f25rKYpQJBAK+OvRlCdlWZ+isMdxm9YYQ30+XeQ89Htdqr4sO4ydQ73Fg2Di/j4my9x0K13wxabeFO/ANfEjOGs6cgHOCmsdMCQQCNyYE6MloO1xaHkFIRuzMjUJB94Wkaip/DzZE5a/vIsm6mk6JcaPDCGAm2yf2xd6f/1y0WViaSLv6jLcdwZCZ8";
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||
        [appID length] == 0 ||
        [privateKey length] == 0)
    {
        [self.view gz_showAlertView:@"提示" message:@"缺少pid或者appID或者私钥。"];
        return ;
    }
    /*
     *生成订单信息及签名
     */
    Order* order = [Order new];
    //将商品信息赋予AlixPayOrder的成员变liang
    // NOTE: app_id设置
    order.app_id = appID;
    order.notify_url  = @"http://www.88meichou.com/api/alipay/alipay.php";
    order.biz_content.seller_id = pid ;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"刚子支付Demo";
    order.biz_content.subject = [NSString stringWithFormat:@"购买%@美豆",@"1"];
    order.biz_content.out_trade_no = order_sn ;
    //    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    //    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f",0.01];
    
    order.biz_content.total_amount = [NSString stringWithFormat:@"%@", @"0.1"]; //商品价格
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    //    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"ap2016092201949956";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        //          NSLog(@"~~~~~~~~~~~!!~~~~~~~~~~%@",orderString);签名
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            // NSLog(@"reslut = %@",resultDic);
            NSString * str = resultDic[@"memo"];
            // NSLog(@"~~~~~!!~~%@",str);
            NSString *result = resultDic[@"resultStatus"];
            if ([result isEqualToString:@"9000"]) {
                #pragma 回掉函数
            }
        }];

        
    }
}


-(void)ByWeiXinBuy{
    
    [self weXinAplyPayOrderName:@"刚子支付Demo" PayPrice:@"1"];
    
}

#pragma mark--微信支付
-(void)weXinAplyPayOrderName:(NSString *)OrderName PayPrice:(NSString *)PayPrice{
    
    if (![WXApi isWXAppInstalled]) {
        [self.view gz_showAlertView:@"温馨提示" message:@"未检测到客户端，请安装"];
    }else{
        //创建支付签名对象
        payRequsestHandler *req = [payRequsestHandler alloc];
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];
        //获取到实际调起微信支付的参数后，在app端调起支付
        NSMutableDictionary *dict = [req sendPay_OrderName:OrderName PayPrice:PayPrice];
        if(dict == nil){
            //错误提示
            NSString *debug = [req getDebugifo];
            [self.view gz_showAlertView:@"提示信息" message:debug];
        }else{
            [self sendRepweixin:dict];//提交支付
        }
    }
}
-(void)sendRepweixin:(NSDictionary *)dict{
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
