//
//  EGBeaconInfoView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/15.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGBeaconInfoView.h"

@interface EGBeaconInfoView ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *rssiLabel;
@property (nonatomic, strong) UILabel *majorLabel;
@property (nonatomic, strong) UILabel *minorLabel;
@property (nonatomic, strong) UILabel *batteryLabel;
@property (nonatomic, strong) UILabel *uuidLabel;
@end

@implementation EGBeaconInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 创建标签
    self.timeLabel = [self createLabelWithFrame:CGRectMake(20, 100, 300, 20)];
    self.rssiLabel = [self createLabelWithFrame:CGRectMake(20, 130, 300, 20)];
    self.majorLabel = [self createLabelWithFrame:CGRectMake(20, 160, 300, 20)];
    self.minorLabel = [self createLabelWithFrame:CGRectMake(20, 190, 300, 20)];
    self.batteryLabel = [self createLabelWithFrame:CGRectMake(20, 220, 300, 20)];
    self.uuidLabel = [self createLabelWithFrame:CGRectMake(20, 250, 300, 40)];
    
    // 添加到视图
    [self addSubview:self.timeLabel];
    [self addSubview:self.rssiLabel];
    [self addSubview:self.majorLabel];
    [self addSubview:self.minorLabel];
    [self addSubview:self.batteryLabel];
    [self addSubview:self.uuidLabel];
}

- (UILabel *)createLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:FontSize(14)];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    return label;
}

- (void)updateBeaconInfo
{
    // 设置时间
    self.timeLabel.text = @"時間：2025/03/14 16:00";
    
    // 设置信号强度
    self.rssiLabel.text = @"訊號強度：-59dBm";
    
    // 设置 Major
    self.majorLabel.text = @"Major：0";
    
    // 设置 Minor
    self.minorLabel.text = @"Minor：1";
    
    // 设置电池
    self.batteryLabel.text = @"電池：100%";
    
    // 设置 UUID
    self.uuidLabel.text = @"UUID：FDA50693-A4E2-4FB1-AFCF-C6EB07647825";
    self.uuidLabel.numberOfLines = 2;
}

@end
