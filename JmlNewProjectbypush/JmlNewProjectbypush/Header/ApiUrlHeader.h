//
//  ApiUrlHeader.h
//  ceshi
//
//  Created by 闫继祥 on 2018/1/31.
//  Copyright © 2018年 闫继祥. All rights reserved.
//

#ifndef ApiUrlHeader_h
#define ApiUrlHeader_h

//定义一个API
#define APIURL                @"http://m.jzjn369.com/api.php"
#define APIURLIMG                @"http://m.jzjn369.com"

#define API(x)  [NSString stringWithFormat:@"%@%@",APIURL,(x)]
//登录
#define APILogin @"/user/do_login"
//发送验证码
#define APISendYzm @"/index/send_sms"
//绑定邀请码
#define APIYqm @"/user/set_ask"


#endif /* ApiUrlHeader_h */
