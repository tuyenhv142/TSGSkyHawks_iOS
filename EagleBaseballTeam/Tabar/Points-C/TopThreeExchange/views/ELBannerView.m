//
//  ELBannerView.m
//  BurgerKing
//
//  Created by elvin on 2025/4/27.
//

#import "ELBannerView.h"

@interface ELBannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong)UIView *top_View;

@end

@implementation ELBannerView

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 0)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;  // 禁用垂直滚动条
        _scrollView.bounces = NO;  // 禁用弹性效果 为了禁止上下滑动 必须添加
    }
    return _scrollView;
}
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}
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
        self.current_index = 0;
        [self createUI:frame];
    }
    return self;
}

-(void)createUI:(CGRect)frame
{
    self.scrollView.frame = frame;
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.contentView];
    
    UIView *topView = [UIView new];
    topView.layer.cornerRadius = ScaleW(10);
    topView.layer.masksToBounds = true;
    topView.backgroundColor = rgba(0, 0, 0, 0.6);
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(ScaleW(62));
        make.right.mas_equalTo(-ScaleW(10));
        make.bottom.mas_equalTo(-ScaleW(10));
    }];
    self.top_View = topView;
    UILabel *titleLb = [UILabel new];
//    titleLb.text = @"1/5";
    titleLb.textColor = rgba(255, 255, 255, 1);
    titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    [topView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(ScaleW(5));
    }];
    self.titleLb = titleLb;
    UIButton *iconBtn = [[UIButton alloc] init];
    [iconBtn setImage:[UIImage imageNamed:@"sFrame"] forState:UIControlStateNormal];
    [topView addSubview:iconBtn];
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-ScaleW(5));
        make.height.mas_equalTo(ScaleW(16));
        make.width.mas_equalTo(ScaleW(16));
    }];
    
    
}

- (void)setImages:(NSArray *)images showTitle:(BOOL)show width:(NSInteger)width border:(BOOL)showborder
{
    self.scroller_width = width;
    
    if(!show)
      self.top_View.hidden = YES;
    else
      self.top_View.hidden = NO;
    
    _images = images;
    
    if(_images.count==0)
        self.titleLb.text = [NSString stringWithFormat:@"0/%ld",_images.count];
    else
    self.titleLb.text = [NSString stringWithFormat:@"1/%ld",_images.count];
    
    self.contentView.frame = CGRectMake(0, 0, width * images.count, self.scrollView.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(width * images.count, 0);
    
    // 添加图片
    for (int i = 0; i < images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, self.contentView.frame.size.height)];
        NSString *imgurl = images[i];
        if ([imgurl containsString:@"http"]) {
            NSURL *imageURL =  [NSURL URLWithString:imgurl];
            [imageView sd_setImageWithURL:imageURL];
        }else{
            imageView.image = [UIImage imageNamed:images[i]];
        }
        if(showborder){
            imageView.layer.borderWidth = 1.0;
            imageView.layer.borderColor = ColorRGB(0xD4D4D4).CGColor;
            imageView.layer.cornerRadius = 8.0;
            imageView.layer.masksToBounds = YES;
        }
       
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentPage = offsetX / scrollView.bounds.size.width;
//    self.scrollView.contentOffset = CGPointMake(currentPage * Device_Width, 0);
    self.current_index = currentPage+1;
    self.titleLb.text = [NSString stringWithFormat:@"%ld/%ld",currentPage+1,_images.count];
}

- (NSInteger)getCurrentImageIndex
{
    return self.current_index;
}

- (void)setCurrentImage:(NSInteger)currentIndex 
{
    self.current_index = currentIndex;
    [self.scrollView setContentOffset:CGPointMake(self.scroller_width*self.current_index, 0) animated:YES];
}

@end
