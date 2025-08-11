#import "EGOrderDetailCell.h"

@interface EGOrderDetailCell()

@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *quantityLabel;

@end

@implementation EGOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.productImageView = [[UIImageView alloc] init];
    self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.productImageView.layer.cornerRadius = ScaleW(8);
    self.productImageView.clipsToBounds = YES;
    self.productImageView.backgroundColor = rgba(245, 245, 245, 1);
    [self.contentView addSubview:self.productImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    self.titleLabel.textColor = rgba(23, 23, 23, 1);
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    self.priceLabel.textColor = rgba(23, 23, 23, 1);
    [self.contentView addSubview:self.priceLabel];
    
    self.quantityLabel = [[UILabel alloc] init];
    self.quantityLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    self.quantityLabel.textColor = rgba(163, 163, 163, 1);
    [self.contentView addSubview:self.quantityLabel];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(16));
        make.top.equalTo(self.contentView).offset(ScaleW(16));
//        make.height.mas_equalTo(ScaleW(80));
//        make.width.mas_equalTo(ScaleW(80));
//        make.bottom.equalTo(self.contentView).offset(-ScaleW(16));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(ScaleW(12));
        make.top.equalTo(self.productImageView).offset(ScaleW(5));
        make.right.equalTo(self.contentView).offset(-ScaleW(16));
    }];
    
//    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel);
//        make.bottom.equalTo(self.productImageView);
//    }];
    
//    [self.quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.priceLabel.mas_right).offset(ScaleW(5));
//        make.bottom.equalTo(self.productImageView);
//    }];
}

- (void)setupWithImage:(NSString *)imageName title:(NSString *)title price:(NSString *)price andQuantity:(NSString *)quantity{
  

    if (imageName.length > 0) {
        [self.productImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ScaleW(80));
            make.height.mas_equalTo(ScaleW(80));
            make.bottom.equalTo(self.contentView).offset(-ScaleW(16));
        }];
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
        
        [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.productImageView);
        }];
        [self.quantityLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel.mas_right).offset(ScaleW(5));
            make.bottom.equalTo(self.productImageView);
        }];
        
        self.titleLabel.numberOfLines = 0;
        
    }else{
        
        [self.productImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(ScaleW(45));
        }];
        
        [self.quantityLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleW(16));
            make.bottom.mas_equalTo(-ScaleW(16));
            make.right.equalTo(self.contentView).offset(-ScaleW(16));
        }];
        [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.quantityLabel.mas_left).offset(-ScaleW(5));
            make.centerY.equalTo(self.quantityLabel);
        }];
        
        self.titleLabel.numberOfLines = 1;
    }

    self.titleLabel.text = title;
    
    // 格式化价格
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.groupingSeparator = @",";
    formatter.groupingSize = 3;
    NSString *priceString = [price stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber *priceNum = @([priceString doubleValue]);
    NSString *formattedPrice = [formatter stringFromNumber:priceNum];
    
    self.priceLabel.text = [NSString stringWithFormat:@"NT $%@", formattedPrice];
    if (!quantity) {
        quantity = @"1";
    }
    self.quantityLabel.text = [NSString stringWithFormat:@"x%@", quantity];
}

@end
