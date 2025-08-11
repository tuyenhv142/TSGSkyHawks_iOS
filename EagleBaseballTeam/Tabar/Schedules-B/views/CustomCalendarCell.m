//
//  CustomCalendarCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/6.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "CustomCalendarCell.h"

#import "EGScheduleModel.h"

@implementation CustomCalendarCell

//- (void)drawRect:(CGRect)rect {
//    // 自定义绘制代码
//    [super drawRect:rect]; // 确保调用父类的 drawRect 方法以保持原有功能
//    
//    // 示例：改变背景颜色和文字颜色
////    self.backgroundColor = [UIColor lightGrayColor]; // 设置背景颜色
////    self.titleLabel.textColor = [UIColor whiteColor]; // 设置文字颜色
//    
//    
//    self.contentView.backgroundColor =rgba(243, 243, 243, 1);
//    self.contentView.layer.borderWidth = 0.5;
//    self.contentView.layer.borderColor = rgba(222, 222, 222, 1).CGColor;
//}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (UIView *)selectedBackgroundView
{
    return nil;
}

- (void)commonInit
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(11)];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(3));
        make.right.mas_equalTo(-ScaleW(6));
        make.width.mas_equalTo(ScaleW(17));
        make.height.mas_equalTo(ScaleW(15));
    }];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    shapeLayer.borderColor = [UIColor clearColor].CGColor;
    shapeLayer.opacity = 1;
    [self.contentView.layer insertSublayer:shapeLayer below:titleLabel.layer];
    self.shapeLayer = shapeLayer;
    
    
    self.clipsToBounds = NO;
    self.contentView.clipsToBounds = NO;//裁切圆角
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(ScaleW(35));
        make.height.mas_equalTo(ScaleW(35));
    }];
//    self.imageView.image = [UIImage imageNamed:@"樂天桃猿3x_S"];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    subtitleLabel.textColor = rgba(115, 115, 115, 1);
    subtitleLabel.font = [UIFont boldSystemFontOfSize:FontSize(12)];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.centerX.mas_equalTo(0);
    }];
    
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = rgba(222, 222, 222, 1).CGColor;
//    self.subtitleLabel.text = @"延賽";
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat diameter = self.bounds.size.width * 0.45;//23;// MIN(self.bounds.size.height/3,self.bounds.size.width);
//    diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter)*0.5) : diameter;
    
    self.shapeLayer.frame = CGRectMake(self.bounds.size.width - ScaleW(23),ScaleW(3),ScaleW(17),ScaleW(15));
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:self.shapeLayer.bounds
                                                cornerRadius:ScaleW(7)].CGPath;
    if (!CGPathEqualToPath(self.shapeLayer.path,path)) {
        self.shapeLayer.path = path;
    }
}

- (void)setCanlenderData:(NSString *)index
{
    if ([index isEqualToString:@"HomeTeam"]) {
        self.contentView.backgroundColor = rgba(226, 247, 243, 1);
    }else{
        self.contentView.backgroundColor = UIColor.whiteColor;
    }
}

- (void)setSchedulesModel:(EGScheduleModel *)model
{
    
}
@end
