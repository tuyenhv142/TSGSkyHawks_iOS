#import "EGOrderCell.h"

#import "EGUserOrdersModel.h"

@interface EGOrderCell()

@property (nonatomic, strong) UILabel *orderIdLabel;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation EGOrderCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    static NSString *ID = @"EGOrderCell";
    EGOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 白色背景视图
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = ScaleW(8);
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    
    // 订单编号
    self.orderIdLabel = [[UILabel alloc] init];
    self.orderIdLabel.text =@"訂單編號";
    self.orderIdLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    self.orderIdLabel.textColor = rgba(115, 115, 115, 1);
    [containerView addSubview:self.orderIdLabel];
    
    // 查看详情按钮
    self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.detailButton setTitle:@"查看訂單詳情" forState:UIControlStateNormal];
    [self.detailButton setTitleColor:rgba(0, 122, 96, 1) forState:UIControlStateNormal];
    self.detailButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    // 修改按钮的用户交互，使点击事件可以穿透
    self.detailButton.userInteractionEnabled = NO;
    [self.detailButton setImage:[UIImage imageNamed:@"chevron-right_Green"] forState:UIControlStateNormal];
    self.detailButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//    self.detailButton.imageEdgeInsets = UIEdgeInsetsMake(0, ScaleW(8), 0, -ScaleW(8));
    
    [containerView addSubview:self.detailButton];
    
    // 分隔线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = rgba(229, 229, 229, 1);
    [containerView addSubview:self.lineView];
    
    // 商品标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text =@"商品标题";
    self.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    self.titleLabel.textColor = rgba(23, 23, 23, 1);
    self.titleLabel.numberOfLines = 0;
    [containerView addSubview:self.titleLabel];
    
    // 价格
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.text =@"1111";
    self.priceLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    self.priceLabel.textColor = rgba(214, 159, 0, 1);
    [containerView addSubview:self.priceLabel];
    
    // 日期
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.text =@"2025/1/25";
    self.dateLabel.font = [UIFont systemFontOfSize:FontSize(14)];
    self.dateLabel.textColor = rgba(115, 115, 115, 1);
    [containerView addSubview:self.dateLabel];
    
    // 布局
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, ScaleW(16), ScaleW(16), ScaleW(16)));
    }];
    
    
    [self.orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(ScaleW(16));
        make.top.equalTo(containerView).offset(ScaleW(12));
        make.right.equalTo(containerView.mas_centerX).offset(ScaleW(16));
    }];
    
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView).offset(-ScaleW(16));
        make.centerY.equalTo(self.orderIdLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containerView).inset(ScaleW(16));
        make.top.equalTo(self.orderIdLabel.mas_bottom).offset(ScaleW(12));
        make.height.mas_equalTo(ScaleW(1));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containerView).inset(ScaleW(16));
        make.top.equalTo(self.lineView.mas_bottom).offset(ScaleW(14));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(ScaleW(16));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleW(8));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(ScaleW(16));
        make.top.equalTo(self.priceLabel.mas_bottom).offset(ScaleW(8));
        make.bottom.equalTo(containerView).offset(-ScaleW(14));
    }];
}

- (void)setupWithOrder:(NSDictionary *)order {
    self.orderIdLabel.text = [NSString stringWithFormat:@"訂單編號：%@", order[@"orderId"]];
    self.titleLabel.text = order[@"title"];
    
    // 格式化价格
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.groupingSeparator = @",";
    formatter.groupingSize = 3;
    
    NSString *priceString = [order[@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber *price = @([priceString doubleValue]);
    NSString *formattedPrice = [formatter stringFromNumber:price];
    self.priceLabel.text = [NSString stringWithFormat:@"NT $%@", formattedPrice];
    
    self.dateLabel.text = order[@"date"];
}


- (void)setHistoryModel:(OrderHistoryModel *)historyModel
{
    
    self.orderIdLabel.text = [NSString stringWithFormat:@"訂單編號：%@",historyModel.OrderId];
    self.titleLabel.text = historyModel.PurchasedItem;
    // 格式化价格
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.groupingSeparator = @",";
    formatter.groupingSize = 3;
    NSNumber *price = @(historyModel.TotalPrice);
    NSString *formattedPrice = [formatter stringFromNumber:price];
    self.priceLabel.text = [NSString stringWithFormat:@"NT $%@", formattedPrice];
    
    NSString *CheckoutTime = historyModel.CheckoutTime;
    NSString *time = [CheckoutTime substringWithRange:NSMakeRange(0, 10)];
    time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.dateLabel.text = time;
    
}
@end
