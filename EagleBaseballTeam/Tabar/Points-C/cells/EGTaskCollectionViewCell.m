#import "EGTaskCollectionViewCell.h"
#import "EGPaddingLabel.h"

@interface EGTaskCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageViewMark;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *pointsIcon;
@property (nonatomic, strong) UILabel *pointsLabel;
@property (nonatomic, strong) EGPaddingLabel *statusLabel;
@property (nonatomic,strong) UIButton *statesBtn;
@property (nonatomic,strong) UIButton *bluetoothBtn;

@end

@implementation EGTaskCollectionViewCell

- (UIButton *)bluetoothBtn
{
    if (!_bluetoothBtn) {
        _bluetoothBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bluetoothBtn setImage:[UIImage imageNamed:@"icon_bluetooth"] forState:UIControlStateNormal];
        [_bluetoothBtn setImage:[UIImage imageNamed:@"bluetooth"] forState:UIControlStateDisabled];
        _bluetoothBtn.backgroundColor = rgba(245, 245, 245, 1);
        [_bluetoothBtn setEnabled:NO];
    }
    return _bluetoothBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 8;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.imageViewMark = [UIImageView new];
    self.imageViewMark.image = [UIImage imageNamed:@"3x_TAKAO"];
    self.imageViewMark.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageViewMark];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    self.titleLabel.textColor = rgba(0, 122, 96, 1);
    self.titleLabel.text = @"捕捉 TAKAO";
    [self.contentView addSubview:self.titleLabel];
    
//    [self.contentView addSubview:self.bluetoothBtn];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    self.dateLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.dateLabel];
    
    self.pointsIcon = [[UIImageView alloc] init];
//    self.pointsIcon.backgroundColor = rgba(0, 122, 96, 1);
//    self.pointsIcon.layer.cornerRadius = ScaleW(12);
//    self.pointsIcon.layer.masksToBounds = true;
    self.pointsIcon.image = [UIImage imageNamed:@"TSG_Dark"];
    self.pointsIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:self.pointsIcon];
    
    self.pointsLabel = [[UILabel alloc] init];
    self.pointsLabel.text = @"5 點";
    self.pointsLabel.textColor = UIColor.blackColor;
    self.pointsLabel.font =  [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightMedium];
    [self.contentView addSubview:self.pointsLabel];
    
    self.statesBtn = [[UIButton alloc] init];
    [_statesBtn setTitle:@"任務詳情" forState:UIControlStateNormal];
    [_statesBtn setBackgroundImage:[UIImage imageWithColor:rgba(208, 159, 41, 1)] forState:UIControlStateNormal];  // UIControlStateNormal状态背景色
    [_statesBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _statesBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
  
    _statesBtn.backgroundColor = rgba(208, 159, 41, 1);
    
    [_statesBtn setTitleColor:rgba(163, 163, 163, 1) forState:UIControlStateDisabled];  // 禁用状态文字颜色
    [_statesBtn setTitle:@"即將開放" forState: UIControlStateDisabled];
    [_statesBtn setBackgroundImage:[UIImage imageWithColor:rgba(245, 245, 245, 1)] forState:UIControlStateDisabled];  // 禁用状态背景色
    _statesBtn.userInteractionEnabled = NO;
    [_statesBtn setEnabled:NO];
    
    _statesBtn.layer.cornerRadius = ScaleW(12);
    _statesBtn.layer.masksToBounds = true;
    _statesBtn.contentEdgeInsets = UIEdgeInsetsMake(0, ScaleW(8), 0, ScaleW(8));
    [self.statesBtn addTarget:self action:@selector(statusButtonClicked) forControlEvents:UIControlEventTouchUpInside ];
    self.statusLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:_statesBtn];
    
    
    
    self.bluetoothBtn.layer.cornerRadius = ScaleW(12.5);
    self.bluetoothBtn.layer.masksToBounds = YES;
 
//    [self.bluetoothBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.titleLabel);
//        make.right.mas_equalTo(-ScaleW(20));
//        make.height.width.mas_equalTo(ScaleW(25));
////            make.width.mas_equalTo(ScaleW(62));
////            make.bottom.mas_equalTo(-ScaleW(16));
//    }];
    
//    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleW(4));
//        make.left.equalTo(self.titleLabel);
//    }];
    
    [self.imageViewMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(10));
        make.left.mas_equalTo(ScaleW(10));
        make.right.mas_equalTo(-ScaleW(10));
        make.height.mas_equalTo(ScaleW(130));
    }];
    
    [self.pointsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.bottom.equalTo(self.contentView).offset(-ScaleW(15));
        make.size.mas_equalTo(CGSizeMake(ScaleW(24), ScaleW(24)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageViewMark.mas_bottom).offset(ScaleW(10));
        make.left.equalTo(self.contentView).offset(ScaleW(10));
        make.right.equalTo(self.contentView).offset(-ScaleW(10));
    }];
    
    [self.pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointsIcon);
        make.left.equalTo(self.pointsIcon.mas_right).offset(ScaleW(5));
    }];
    
    [self.statesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScaleW(15));
        make.height.mas_equalTo(ScaleW(24));
        make.bottom.mas_equalTo(-ScaleW(15));
    }];
}

- (void)setupWithTask:(NSDictionary *)task {
    
    self.titleLabel.text = task[@"title"];
    self.dateLabel.text = task[@"dateRange"];
    self.pointsLabel.text = [NSString stringWithFormat:@"%@ 點", task[@"points"]];
    NSDictionary *taskDetail = [task objectOrNilForKey:@"taskDetail"];
    BOOL  isBluetooth = [[taskDetail objectOrNilForKey:@"isBluetooth"] boolValue];
    
    [self.bluetoothBtn setHidden:!isBluetooth];

    NSString *status = task[@"status"];
//    ELog(@"status :%@",status);
    [_statesBtn setTitle:status forState:UIControlStateDisabled];
//    if ([status isEqualToString:@"已完成"]) {
//        _statesBtn.enabled = NO;
//        [_statesBtn setTitle:status forState:UIControlStateDisabled];
////        _statesBtn.backgroundColor = rgba(229, 229, 229, 1);
////        [_statesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    } else if ([status isEqualToString:@"敬請期待"]) {
////        [_statesBtn setTitleColor:rgba(82, 82, 82, 1) forState:UIControlStateNormal];
////        _statesBtn.backgroundColor = [UIColor clearColor];
//    } else {
//        [_statesBtn setTitle:status forState:UIControlStateNormal];
//        _statesBtn.enabled = YES;
////        _statesBtn.backgroundColor = rgba(208, 159, 41, 1);
////        [_statesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }
}

- (void)statusButtonClicked {
    NSLog(@"click");
    if ([self.delegate respondsToSelector:@selector(taskCell:didClickStateButtonAtIndexPath:)]) {
        [self.delegate taskCell:self didClickStateButtonAtIndexPath:self.indexPath];
    }
}

@end
