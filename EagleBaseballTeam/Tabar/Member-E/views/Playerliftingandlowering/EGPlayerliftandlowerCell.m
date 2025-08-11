//
//  EGMemberCardCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPlayerliftandlowerCell.h"
@interface EGPlayerliftandlowerCell()

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UILabel *winLabel;//胜利
@property (nonatomic, strong) UILabel *failLabel;//失败
@property (nonatomic, strong) UILabel *sameLabel;//和


@end

@implementation EGPlayerliftandlowerCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGPlayerliftandlowerCell";
    EGPlayerliftandlowerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGPlayerliftandlowerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 5;//这里间距为10，可以根据自己的情况调整
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * frame.origin.x;
    [super setFrame:frame];
}


- (void)setupUI {
    
    [self setFrame:self.contentView.frame];
    self.baseView = self.contentView;//[[UIView alloc] init];
    self.baseView.layer.masksToBounds = YES;
    self.baseView.backgroundColor = UIColor.whiteColor;//rgba(229, 229, 229, 1);
    
    self.winLabel = [[UILabel alloc] init];
    self.winLabel.text = @"日期";
    self.winLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.winLabel.textAlignment = NSTextAlignmentLeft;
    [self.baseView addSubview:self.winLabel];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.centerY.mas_equalTo(self.baseView);
        make.width.mas_equalTo(ScaleW(100));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.failLabel =  [[UILabel alloc] init];
    self.failLabel.text = @"球员";
    self.failLabel.textAlignment = NSTextAlignmentCenter;
    self.failLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.failLabel];
    [self.failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winLabel.mas_right).offset(ScaleW(30));
        make.centerY.mas_equalTo((self.baseView));
        make.width.mas_equalTo(ScaleW(80));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
    self.sameLabel =  [[UILabel alloc] init];
    self.sameLabel.text = @"异动原因";
    self.sameLabel.textAlignment = NSTextAlignmentCenter;
    self.sameLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.sameLabel];
    [self.sameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.failLabel.mas_right).offset(ScaleW(30));
        make.centerY.mas_equalTo((self.baseView));
        make.width.mas_equalTo(ScaleW(100));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
   
}

- (void)setupWithInfo:(NSDictionary *)info {
    self.winLabel.text = [self convertDate:[[info objectForKey:@"ChgDate"] stringValue]];
    self.failLabel.text = [[info objectForKey:@"Acnt"] stringValue];
    self.sameLabel.text = [self getreason:[[info objectForKey:@"ChgReason"] stringValue]];
}


-(NSString*)convertDate:(NSString*)inDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:inDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:@"yyyy/MM/dd"];
    // 格式化日期
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
    
}

-(NSString*)getreason:(NSString*)type
{
    NSString*string = @"";
    NSInteger reason = type.intValue;
    switch (reason) {
        case 1:
            string = @"升一军";
            break;
        case 2:
            string = @"降二军";
            break;
        case 3:
            string = @"转会";
            break;
        case 4:
            string = @"退休";
            break;
        case 5:
            string = @"受伤";
            break;
        case 6:
            string = @"降三军";
            break;
        case 7:
            string = @"升教练";
            break;
        case 8:
            string = @"開除";
            break;
        case 9:
            string = @"违规開除";
            break;
        case 10:
            string = @"奖励升级";
            break;
        case 11:
            string = @"開心就好";
            break;
        case 12:
            string = @"大家看到单独";
            break;
        case 13:
            string = @"额外热沃尔沃额外";
            break;
        case 14:
            string = @"两节课发动机";
            break;
    }
    
    return string;
}

@end
