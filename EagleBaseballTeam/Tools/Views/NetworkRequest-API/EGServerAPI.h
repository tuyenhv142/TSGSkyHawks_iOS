//
//  EGServerAPI.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define showTestApi
NS_ASSUME_NONNULL_BEGIN

@interface EGServerAPI : NSObject

//MARK:  雄鹰API
+ (NSString *)getUserInfobyEmail:(NSString *)email;
//查询用户累计消费
//+ (NSString *)getUserOrders:(NSString *)ID;
+ (NSString *)getUserOrders:(NSString *)ID pagesize:(NSString *)pagesize;
//球队全年战绩
+ (NSString *)getTeamStanding;
//球队上下半年战绩
+ (NSString *)getTeamHalfStanding:(NSString*)half_year;
//投手排行榜
+ (NSString *)getPitcherStats;
//打者排行榜
+ (NSString *)getBatterStats;
// 获取球员list
+ (NSString *)getTeamMembers:(NSString*)year;
//获取个人球员数据
+ (NSString *)getPersonnelAcnt:(NSString *)strAcnt;
//获取教练list
+ (NSString *)getCoachMembers:(NSString*)year;

// 获取勋章信息
+ (NSString*)getMetelInfo:(NSString*)encryptedIdentity;
//获取球员异动list
+(NSString *)getMemberchange:(NSString*)year;

#pragma mark --- 赛程 xiangguan
/**
 * 赛程表 取得
 */
+ (NSString *)getSchedule_api;

+ (NSString *)getSchedule_api_test;

//MARK:  CRM
#pragma mark 登录 注册 密码 验证码 api
/**
 * 客户端验证
 */
+ (NSString*)oauthVerify_api;
/**
 * 刷新jwt令牌
 */
+ (NSString*)refreshToken_api;
/**
 * 会员登入
 */
+ (NSString*)signIn_api;
/**
 * Ticket登入
 */
+ (NSString*)signInTicket_api;
/**
 * getOnetimeToken
 */
+ (NSString*)getOneTimeToken;
/**
 * 注册检验
 */
+ (NSString*)checkPhone_api:(NSString *)phone;
/**
 * 会员register
 */
+ (NSString*)signUp_api;
/**
 * 会员register
 */
+ (NSString*)forgotPassword_api;
/**
 * 注册检验
 */
+ (NSString*)checkPhoneRegister_api:(NSString *)phone;
/**
 * 会员register
 */
+ (NSString*)otpSms_api;
/**
 *  查询会员详细资料GET
 */
+ (NSString*)basicMember_api:(NSString *)memberID;
/**
 *  更新会员联络资料PUT  查询会员详细资料GET
 */
+ (NSString*)basicMemberContact_api:(NSString *)memberID;
/**
 *  更新密碼 PUT
 */
+ (NSString*)basicMemberResetpassword_api:(NSString *)memberID;

//MARK: QR Code
/*
 产生会员QRCode
 /basic/member/{id}/gen-qrcode
 */
+ (NSString*)basicMemberGenqrcode:(NSString *)memberID;

#pragma mark --- 通知讯息
/**
 *  查询通知
 */
+ (NSString*)messageList_api:(NSString *)memberID page:(NSString *)page type:(NSString *)category;
/**
 *  通知 批次设置为已读
 */
+ (NSString*)messageMarkRead_api:(NSString *)memberID;
/**
 *   將通知全部設為已读
 */
+ (NSString*)allMessageMarkRead_api:(NSString *)memberID  type:(NSString *)category;
/**
 *   . 查詢是否有未讀通知
 */
+ (NSString*)messageUnRead_api:(NSString *)memberID  type:(NSString *)category;

#pragma mark ---累计消费
/**
 *  查询现场消费-总金额
 */
+ (NSString*)totalSpent_api:(NSString *)memberID;
/**
 *  查询 现场消费
 */
+ (NSString*)orderHistory_api:(NSString *)memberID;
/**
 *  查询 现场消费 - 详情
 */
+ (NSString*)orderHistoryDeatil_api:(NSString *)memberID orderId:(NSString *)orderID;


//MARK: Task Events
+ (NSString*)getEventtasks;
+ (NSString*)getEventcheckins;
+ (NSString*)getEventmembertasks:(NSString *)qrCode;
/**
 *任务详情api
 */
+ (NSString*)taskDetailInfo_api:(NSString*)task_id QRCode:(NSString *)qrCode;


//MARK: 点数
/*
  扣除 赠送 兑换
 */
+ (NSString*)pointDeduct;
+ (NSString*)pointGrant;
+ (NSString*)pointRedeem;
+ (NSString*)pointHistoryBy:(NSString *)memberID Page:(NSInteger) page andSize:(NSInteger) size;
+ (NSString*)pointHistory:(NSString *)memberID andJournalId :(NSString *)journalId;
//2025-05-08
/**
 *赠品兑换 list
 */
+ (NSString*)couponsList_api:(NSString*)user_id getType:(NSInteger)type;

+ (NSString*)couponsList_api:(NSString*)user_id getStuatus:(NSInteger)status;

+ (NSString*)couponsInfo_api:(NSString*)goods_id;
/*
 查询兑换门市
 */
+ (NSString*)searchstores:(NSString*)stores_id;

/*
 用於核銷贈品券的 QR Code
 */
+ (NSString*)getGiftQRCode:(NSString*)user_id;

/*兑换赠品劵*/
+ (NSString*)redeem_coupon:(NSString*)user_id;
#pragma mark --- newsoft api
/**
 * 当使用游客登录时调用。
 */
+ (NSString*)mobile_crm_API;
/**
 * 獲取token 中继服务器 appid 6f068756f301480e946fa4138d4320fd   appsecret d2f786df293e402ea1911eccb82d0de0
 */
+ (NSString*)getTokenForAppId_api;
/**
  * get 请求APP需要的信标设备列表
  */
+ (NSString*)mobile_beaconList;
/**
 * 存储有效蓝牙信标设备交互
 */
+ (NSString*)mobile_beaconSave;
/**
 * 返回youtube信息列表
 */
+ (NSString*)get_YouTubeInfo;
/**
 * youtube live信息列表
 */
+ (NSString*)get_YouTubeLive:(NSString*)eventType;

+ (NSString*)get_Questions;

/*
 应援班表 api
 */
+(NSString*)get_FansClass;

/*
 获取体育场餐饮数据api
 */
+(NSString*)get_CateringClass;



@end

NS_ASSUME_NONNULL_END
