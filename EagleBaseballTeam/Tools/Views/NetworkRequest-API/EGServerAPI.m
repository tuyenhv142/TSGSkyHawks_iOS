//
//  EGServerAPI.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//


#import "EGServerAPI.h"


#ifdef showTestApi

//新零售
#define SERVER_URL @"https://dev-hawk-crm.tsgb2c.net/api/v1"
//獲取任務相關
#define CRMEvent_URL @"https://hawk-event.tsgb2c.net/api/v1/public"
//雄鹰 中继
#define SERVERXiongYing_URL  @"https://tsg-hawks-akaqhvfyb7euhdh7.a03.azurefd.net" /*@"https://www.tsghawks.com"*/
//中继
#define NewSfotAPI @"http://20.189.240.127:8765"
// @"http://relay.tsghawks.com:8765"
//@"http://20.189.240.127:8765"
#else

//新零售 用戶點數
#define SERVER_URL @"https://hawk-crm.newretail.app/api/v1"
//獲取任務相關
#define CRMEvent_URL @"https://hawk-event.newretail.app/api/v1/public"
//雄鹰 中继
#define SERVERXiongYing_URL @"https://tsg-hawks-akaqhvfyb7euhdh7.a03.azurefd.net"
//中继 服务器
#define NewSfotAPI @"https://relay.tsghawks.com:8765"

#endif


#define SERVERXiongYing @"https://www.tsghawks.com"
#define SERVERXiongYingTest @"http://20.189.240.127"
#define SERVER_URL_TICKET @"https://ticket-platform.tsgb2c.net/api/v1"


@implementation EGServerAPI

+ (NSString *)getIPURLString:(NSString *)api
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", SERVER_URL, api];
//    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)getIPTicketURLString:(NSString *)api
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", SERVER_URL_TICKET, api];
//    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//newsoft server
+ (NSString *)getNewsoftIPURLString:(NSString *)api
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", NewSfotAPI, api];
//    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//MARK:  雄鹰API
+ (NSString *)getXiongYingURLString:(NSString *)api
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", SERVERXiongYing_URL, api];
    return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//查询用户信息
+ (NSString *)getUserInfobyEmail:(NSString *)email
{
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/wc/v3/customers?email=%@&consumer_key=ck_0de8be632e78d179c2ebcd1215c301198a75944a&consumer_secret=cs_87db163ae5d871a3913ee961261a37152fd14fe1", SERVERXiongYing, email];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//查询用户累计消费
+ (NSString *)getUserOrders:(NSString *)ID pagesize:(NSString *)pagesize
{
//    NSString *url = [NSString stringWithFormat:@"%@/wp-json/wc/v3/orders?customer=%@&status=completed&page=1&per_page=%@", SERVERXiongYing_URL, ID,pagesize];
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/wc/v3/orders?customer=%@&status=completed", SERVERXiongYing, ID];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//球队全年战绩
+ (NSString *)getTeamStanding
{
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/stats?type=team_standing_d", SERVERXiongYing_URL];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//球队上下半年战绩
+ (NSString *)getTeamHalfStanding:(NSString*)half_year
{
   // _%@
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/stats?type=team_standing_d%@", SERVERXiongYing,half_year];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//投手排行榜
+ (NSString *)getPitcherStats
{
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/stats?type=pitcher_stats_d", SERVERXiongYing];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//打者排行榜
+ (NSString *)getBatterStats
{
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/stats?type=batter_stats_d", SERVERXiongYing];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

// 获取球员list
+ (NSString *)getTeamMembers:(NSString*)year
{
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/GetTeamMembers?year=%@&kindCode=A&teamNo=AKP011", SERVERXiongYing_URL,year];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//获取个人球员数据
+ (NSString *)getPersonnelAcnt:(NSString *)strAcnt
{
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/GetPersonnel?acnt=%@", SERVERXiongYing_URL,strAcnt];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


// 获取教练list
+ (NSString *)getCoachMembers:(NSString*)year
{
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/GetTeamCoach?year=%@&kindCode=A&teamNo=AKP011",SERVERXiongYing_URL,year];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//获取球员移动数据
+(NSString *)getMemberchange:(NSString*)year
{
    NSString* url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/GetTeamTrans?year=%@&clubNo=AKP",SERVERXiongYing_URL,year];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


// 获取勋章信息
+ (NSString*)getMetelInfo:(NSString*)encryptedIdentity
{
    NSString *encodedString = RFC3986EncodeString(encryptedIdentity);
    
    NSString *url = [NSString stringWithFormat:@"%@/member/badges?encryptedIdentity=%@", CRMEvent_URL,encodedString];
    return  url;//[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark --- 赛程 xiangguan
/**
 * 赛程表 取得
 */
+ (NSString *)getSchedule_api
{
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/GetSchedule", SERVERXiongYing];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
+ (NSString *)getSchedule_api_test
{
    NSString *url = [NSString stringWithFormat:@"%@/wp-json/th_game/v1/GetSchedule", SERVERXiongYingTest];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//MARK:  新零售
#pragma mark 登录 注册 密码 验证码 api

/**
 * 客户端验证
 */
+ (NSString*)oauthVerify_api
{
    return [self getIPURLString:@"oauth/verify"];
}
/**
 * 刷新jwt令牌
 */
+ (NSString*)refreshToken_api
{
    return [self getIPURLString:@"oauth/refresh-token"];
}
/**
 * 会员登入
 */
+ (NSString*)signIn_api
{
    return [self getIPURLString:@"client/sign-in"];
}
/**
 * Ticket登入
 */
+ (NSString*)signInTicket_api
{
    return [self getIPTicketURLString:@"members/sign-in"];
}

/**
 * getTokenForWeb
 */
+ (NSString*)getOneTimeToken
{
    return [self getIPTicketURLString:@"members/one-time-token"];
}
/**
 * 注册检验
 */
+ (NSString*)checkPhone_api:(NSString *)phone
{
    return [self getIPURLString:[NSString stringWithFormat:@"client/sign-up/check?phone=%@",phone]];
}
/**
 * 会员register
 */
+ (NSString*)signUp_api
{
    return [self getIPURLString:@"client/sign-up"];
}
/**
 * 会员register
 */
+ (NSString*)forgotPassword_api
{
    return [self getIPURLString:@"client/forgot-password"];
}
/**
 * 注册检验
 */
+ (NSString*)checkPhoneRegister_api:(NSString *)phone
{
    return [self getIPURLString:[NSString stringWithFormat:@"client/sign-in/check?phone=%@",phone]];
}
/**
 * 会员register
 */
+ (NSString*)otpSms_api
{
    return [self getIPURLString:@"client/otp/sms"];
}
/**
 *  查询会员详细资料GET
 */
+ (NSString*)basicMember_api:(NSString *)memberID
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@",memberID]];
}
/**
 *  更新会员联络资料PUT  查询会员详细资料GET
 */
+ (NSString*)basicMemberContact_api:(NSString *)memberID
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/contact",memberID]];
}
/**
 *  更新密碼 PUT
 */
+ (NSString*)basicMemberResetpassword_api:(NSString *)memberID
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/reset-password",memberID]];
}
//MARK: QRCode
/*
/basic/member/{id}/gen-qrcode
*/

+ (NSString*)basicMemberGenqrcode:(NSString *)memberID{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/gen-qrcode",memberID]];
}

#pragma mark --- 通知讯息
/**
 *  查询通知
 */
+ (NSString*)messageList_api:(NSString *)memberID page:(NSString *)page type:(NSString *)category
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/message/inapp?page=%@&size=100&category=%@",memberID,page,category]];
}
/**
 *  通知 批次设置为已读
 */
+ (NSString*)messageMarkRead_api:(NSString *)memberID
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/message/inapp/read",memberID]];
}
/**
 *   將通知全部設為已读
 */
+ (NSString*)allMessageMarkRead_api:(NSString *)memberID type:(NSString *)category
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/message/inapp/read-all?category=%@",memberID,category]];
}
/**
 *   . 查詢是否有未讀通知
 */
+ (NSString*)messageUnRead_api:(NSString *)memberID  type:(NSString *)category
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/message/inapp/unread?category=%@",memberID,category]];
}
#pragma mark --- 累计消费
/**
 *  查询现场消费-总金额
 */
+ (NSString*)totalSpent_api:(NSString *)memberID
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/total-spent",memberID]];
}
/**
 *  查询 现场消费
 */
+ (NSString*)orderHistory_api:(NSString *)memberID
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/order-history",memberID]];
}
/**
 *  查询 现场消费 - 详情
 */
+ (NSString*)orderHistoryDeatil_api:(NSString *)memberID orderId:(NSString *)orderID
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/order-detail/%@",memberID,orderID]];
}

//MARK: Task Events
+ (NSString*)getEventtasks{
    
    NSString *url = [NSString stringWithFormat:@"%@/events/tasks", CRMEvent_URL];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString*)getEventcheckins{
    NSString *url = [NSString stringWithFormat:@"%@/events/reward", CRMEvent_URL];
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
/**
 *任务详情api
 */
+ (NSString*)taskDetailInfo_api:(NSString*)task_id QRCode:(NSString *)qrCode
{
    NSString *encodedString = RFC3986EncodeString(qrCode);
    NSString *url = [NSString stringWithFormat:@"%@/event-tasks/%@?encryptedIdentity=%@", CRMEvent_URL,task_id,encodedString];
    return  url;//[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
}


NSString* RFC3986EncodeString(NSString *string) {
    NSMutableCharacterSet *allowed = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowed addCharactersInString:@"-._~"]; // RFC 3986 允许的未编码字符
    return [string stringByAddingPercentEncodingWithAllowedCharacters:allowed];
}

+ (NSString*)getEventmembertasks:(NSString *)qrCode{

    NSString *encodedString = RFC3986EncodeString(qrCode);
//    ELog(@"encodedString:%@",encodedString);
    NSString *url = [NSString stringWithFormat:@"%@/members/tasks?encryptedIdentity=%@", CRMEvent_URL,encodedString];
//    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}

#pragma mark ---点数
/**
 *  扣除点数 需要client Access token post 方法
 *  {
 "HashKey": "9c217a52584ff8bb9d3ea8ecf494a3d24f2302ad6937a3a521aa0f8de4fb3ecc",
 "Phone": "string",
 "Points": 0,
 "Reason": "string",
 "UUID": "string"
}
 */
+ (NSString*)pointDeduct
{
    return [self getIPURLString:@"client/point/deduct"];
}
//赠送点数
+ (NSString*)pointGrant
{
    return [self getIPURLString:@"client/point/grant"];
}
//兑换点数
+ (NSString*)pointRedeem
{
    return [self getIPURLString:@"client/point/redeem"];
}
//查询点数历史记录  /basic/member/{id}/journal-history?points_sign=negative (positive)
+ (NSString*)pointHistoryBy:(NSString *)memberID Page:(NSInteger) page andSize:(NSInteger) size
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/journal-history?page=%ld&size=%ld",memberID,page,size]];
}
//查询点数记录明细  basic/member/{id}/journal-detail/{journalId}
+ (NSString*)pointHistory:(NSString *)memberID andJournalId :(NSString *)journalId
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/journal-detail/%@",memberID,journalId]];
}
//2025-05-08
/**
 *按照 1.贈品券 2. 活動憑證 获取赠品兑换 list
 */
+ (NSString*)couponsList_api:(NSString*)user_id getType:(NSInteger)type
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/coupons/available?coupon_type=%d&size=100",user_id,(int)type]];
}

/**
 *按照 0. 未使用 1. 已鎖定 2. 已使用 3.已過期 获取赠品兑换 list
 */
+ (NSString*)couponsList_api:(NSString*)user_id getStuatus:(NSInteger)status
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/coupons?usage_status=%d&size=100",user_id,(int)status]];
}

/**
 *按照 0. 未使用 1. 已鎖定 2. 已使用 3.已過期 获取赠品兑换 list
 */
+ (NSString*)couponsInfo_api:(NSString*)goods_id
{
    return [self getIPURLString:[NSString stringWithFormat:@"client/coupons/%@",goods_id]];
}

/*
 查询兑换门市
 */
+ (NSString*)searchstores:(NSArray*)stores_id
{
    NSMutableString *url = [NSMutableString new];
    [url appendString:@"client/coupons/redeem-stores/search?codes="];
    for(int i=0;i<stores_id.count;i++)
    {
        if(i==0)
            [url appendString:[stores_id objectAtIndex:i]];
        else
            [url appendFormat:@",%@",[stores_id objectAtIndex:i]];
    }
    
    return [self getIPURLString:url];
}

/*
 用於核銷贈品券的 QR Code
 */
+ (NSString*)getGiftQRCode:(NSString*)user_id
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/coupons/qrcode/generate",user_id]];
}

/*
 兌換赠品劵
 */
+ (NSString*)redeem_coupon:(NSString*)user_id
{
    return [self getIPURLString:[NSString stringWithFormat:@"basic/member/%@/points/redeem-coupon",user_id]];
}

#pragma mark --- 应援班表 api
+(NSString*)get_FansClass
{
    return [self getNewsoftIPURLString:[NSString stringWithFormat:@"api/v1/app/jsondata/wingstarsschedule"]];
    
}

+(NSString*)get_CateringClass
{
    return [self getNewsoftIPURLString:[NSString stringWithFormat:@"api/v1/app/jsondata/catering"]];
}



#pragma mark --- newsoft api
/**
 * 当使用游客登录时调用。
 */
+ (NSString*)mobile_crm_API
{
    return [self getNewsoftIPURLString:@"api/v1/app/mobile_crm/info"];
}
/**
 * 獲取token 中继服务器
 */
+ (NSString*)getTokenForAppId_api
{
    return [self getNewsoftIPURLString:[NSString stringWithFormat:@"api/v1/com/token/new/%@",[[EGCredentialManager sharedManager] getZjApiIdKey]]];
}
/**
 * 刷新token 中继服务器
 */
+ (NSString*)refreshTokenForAppId_api
{
    return [self getNewsoftIPURLString:[NSString stringWithFormat:@"api/v1/com/token/refresh/%@",[[EGCredentialManager sharedManager] getZjApiIdKey]]];
}
/**
  * get 请求APP需要的信标设备列表
  */
+ (NSString*)mobile_beaconList
{
    return [self getNewsoftIPURLString:[NSString stringWithFormat:@"api/v1/app/beacon/list?pageSize=%d",500]];
}

/**
 * 存储有效蓝牙信标设备交互
 */
+ (NSString*)mobile_beaconSave
{
    return [self getNewsoftIPURLString:@"api/v1/app/device-bluetooth/interaction"];
}

/**
 * 返回youtube信息列表
 */
+ (NSString*)get_YouTubeInfo
{
    return [self getNewsoftIPURLString:@"api/v1/app/youtube/vlist"];
}

/**
 * youtube live信息列表
 */
+ (NSString*)get_YouTubeLive:(NSString*)eventType
{
    return [self getNewsoftIPURLString:[NSString stringWithFormat:@"api/v1/app/youtube/vlist?eventType=%@",eventType]];
}

/**
 * 返回问题列表
 */
+ (NSString*)get_Questions
{
    return [self getXiongYingURLString:@"api/v1/app/questions"];
}

@end
