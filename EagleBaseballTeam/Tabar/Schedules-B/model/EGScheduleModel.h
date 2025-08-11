//
//  EGScheduleModel.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGScheduleModel : NSObject

//"HomeTeamName" : "味全龍",
//"VisitingTeamName" : "統一7-ELEVEn獅",
//"HomeTeamName" : "富邦悍將",
//"VisitingTeamName" : "台鋼雄鷹",
//"HomeTeamName" : "中華隊", 中信兄弟
//"VisitingTeamName" : "Lotte Giants", 樂天桃猿

//{
//  "CloserAcnt" : "0000000779",
//  "IsGameStop" : "0",//是否比赛暂停

//  "GameResultName" : "正常結束比賽",
//    
//  "PreExeDate" : "2025-02-12T18:35:00",//预执行日期
//  
//  "UpdateTime" : "2025-02-12T21:31:46",
//  "GameResult" : "0",
//  "MultyGame" : "N",//双重赛
//  "Seq" : null,
//  
//  
//  "GameSno" : 1,//场次编号
//  "GameDuringTime" : "025500",
//  
//  "MvpCount" : null,
//  "AudienceCnt" : 20099,//观众人数
//    
//  "WinningPitcherName" : "王柏傑",
//  "WinningPitcherAcnt" : "0000007065",//胜投账号
//  "HomePitcherAcnt" : "0000005372",
//  "VisitingPitcherAcnt" : "0000004942",
//    
//  "MvpName" : "",
//  
//  "Year" : "2025",
//  "GameDateMonth" : "2",
//  "GameDateDay" : "12",
//  
//
//  "MvpAcnt" : "",//MVP账号
//  "CloserName" : "陳柏豪",
//    
//  "LoserPitcherName" : "羅畇雁",
//  "LoserPitcherAcnt" : "0000007490"
//    
//    
//    "PresentStatus" : 1, // 1目前 0过去
//    
//    "FieldNo" : "F29", //球场编号
//    "FieldAbbe" : "大巨蛋",//球场简介 "FieldAbbe" : "嘉義市",
//    
//    "GameDateTimeS" : "2025-02-12T18:35:00",
//    "GameDateTimeE" : "2025-02-12T21:30:00",
//    "GameDate" : "2025-02-12T00:00:00",
//    
//    "HomeScore" : 4,
//    "HomeTeamName" : "中華隊",
//    "HomeClubSmallImgPath" : "\/files\/atts\/0M175491350762541131\/2024十二強_自辦熱身賽_中華隊logo-06_0.png",
//    "HomeTeamCode" : "ZZZ018",
//    "HomeTeamDesc" : null,
//    
//    "VisitingTeamName" : "Lotte Giants",
//    "VisitingScore" : 3,
//    "VisitingClubSmallImgPath" : "\/files\/atts\/0P036528635521431301\/樂天巨人.png",
//    "VisitingTeamDesc" : null,
//    "VisitingTeamCode" : "ZZZ030",

//  "KindCode" : "X",//种类代码
//  "GameSno" : 1,//场次编号
//
//}
@property (nonatomic,assign) NSInteger PresentStatus;

@property (nonatomic,copy) NSString *FieldNo;
@property (nonatomic,copy) NSString *FieldAbbe;

@property (nonatomic,copy) NSString *GameDate;
@property (nonatomic,copy) NSString *GameDateTimeS;
//@property (nonatomic,copy) NSString *GameDateTimeE;

//@property (nonatomic,assign) NSInteger HomeScore ;
@property (nonatomic,assign) NSInteger HomeSetsWon ;
@property (nonatomic,copy) NSString *HomeTeamName;
//@property (nonatomic,copy) NSString *HomeTeamCode;

//@property (nonatomic,assign) NSInteger VisitingScore;
@property (nonatomic,assign) NSInteger VisitingSetsWon;
@property (nonatomic,copy) NSString *VisitingTeamName;
//@property (nonatomic,copy) NSString *VisitingTeamCode;

//@property (nonatomic,copy) NSString *KindCode ;
//@property (nonatomic,assign) NSInteger GameSno ;
//@property (nonatomic,assign) NSString *GameSno ;
@property (nonatomic,assign) NSInteger Seq ;

//@property (nonatomic,copy) NSString *GameResult;// 1yansai 2baoliu
@end

NS_ASSUME_NONNULL_END
