//
//  EGActivityNotifcationDetailViewController.m
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/23.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGActivityNotifcationDetailViewController.h"

#import "EGMessageModel.h"

@interface EGActivityNotifcationDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation EGActivityNotifcationDetailViewController

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 0)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;  // 禁用垂直滚动条
        _scrollView.layer.cornerRadius = 8;
        _scrollView.layer.masksToBounds = true;
        _scrollView.bounces = NO;  // 禁用弹性效果 为了禁止上下滑动 必须添加
    }
    return _scrollView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
//        _titleLabel.text = @"雄鷹起飛倒數!今晚18：35主場迎戰味全龍！";
        _titleLabel.textColor = rgba(80, 35, 20, 1);
        _titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        
    }
    return _titleLabel;
}
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
//        _dateLabel.text = @"2025/09/09";
        _dateLabel.textColor = rgba(0, 0, 0, 0.4);
        _dateLabel.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightMedium];
    }
    return _dateLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = rgba(0, 0, 0, 0.1);
    }
    return _lineView;
}
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = rgba(0, 0, 0, 0.75);
        _contentLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    }
    return _contentLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活動通知";
    self.view.backgroundColor = UIColor.whiteColor;
    
    CGFloat width = Device_Width-ScaleW(30);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(width);
        make.left.mas_equalTo(ScaleW(15));
        make.right.mas_equalTo(-ScaleW(15));
        make.top.mas_equalTo(ScaleW(15) + [UIDevice de_navigationFullHeight]);
    }];
    NSArray *images = self.dataModel.images;
    self.scrollView.contentSize = CGSizeMake(width * images.count, 0);
//    ELog(@"%@\n%@",self.dataModel.coverImage,self.dataModel.images[0]);
    if (images.count > 0) {
        
        // 添加图片
        for (int i = 0; i < images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, width)];
            NSString *imgurl = images[i];
            if ([imgurl containsString:@"http"]) {
                NSURL *imageURL =  [NSURL URLWithString:imgurl];
                [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"notification"]];
            }else{
                imageView.image = [UIImage imageNamed:images[i]];
            }
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.scrollView addSubview:imageView];
        }
        
    }else{
//        if (self.dataModel.coverImage) {
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataModel.coverImage] placeholderImage:[UIImage imageNamed:@"3x_TAKAO"]];
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [self.scrollView addSubview:imageView];
//        }else{
            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
//        }
    }
    
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.right.mas_equalTo(-ScaleW(15));
        make.top.equalTo(self.scrollView.mas_bottom).offset(ScaleW(15));
    }];
    self.titleLabel.text = self.dataModel.title;
    
    [self.view addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.right.mas_equalTo(-ScaleW(15));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleW(15));
    }];
    NSString *timeString = self.dataModel.CreatedAt;
    self.dateLabel.text = [timeString substringToIndex:10];
    
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ScaleW(1));
        make.left.mas_equalTo(ScaleW(15));
        make.right.mas_equalTo(-ScaleW(15));
        make.top.equalTo(self.dateLabel.mas_bottom).offset(ScaleW(15));
    }];
    
    [self.view addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.right.mas_equalTo(-ScaleW(15));
        make.top.equalTo(self.lineView.mas_bottom).offset(ScaleW(15));
    }];
    self.contentLabel.text = self.dataModel.content;
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
