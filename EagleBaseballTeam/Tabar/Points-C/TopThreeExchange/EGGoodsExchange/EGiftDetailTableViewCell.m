//
//  EGiftDetailTableViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/29.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGiftDetailTableViewCell.h"
#import "ELBannerView.h"

@interface EGiftDetailTableViewCell ()

@property (nonatomic,strong) UIImageView *picture;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *goodsName;

@property (nonatomic,strong) UIImageView *yellow_picture;
@property (nonatomic,strong) UILabel *yellow_title;

@property (nonatomic,strong)ELBannerView *bannerView;
@property (nonatomic,strong) UIButton* left_bt;
@property (nonatomic,strong) UIButton* right_bt;

@end


@implementation EGiftDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.currentIndex = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGiftDetailTableViewCell";
    EGiftDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[EGiftDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor whiteColor];
        
        UIView *baseView = self.contentView;//[UIView new];
//        baseView.layer.masksToBounds = true;
//        baseView.layer.cornerRadius = ScaleW(8);
//        baseView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:baseView];
//        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(ScaleW(20));
//            make.left.mas_equalTo(ScaleW(20));
//            make.right.mas_equalTo(-ScaleW(20));
//            make.bottom.mas_equalTo(0);
//        }];
//        self.picture = [UIImageView new];
//        self.picture.image = [UIImage imageNamed:@"FamilyCard2"];
//        self.picture.layer.masksToBounds = true;
//        self.picture.layer.cornerRadius = ScaleW(8);
//        self.picture.layer.borderColor = ColorRGB(0xD4D4D4).CGColor;
//        self.picture.layer.borderWidth = 1.0;
//        self.picture.backgroundColor = [UIColor whiteColor];
//        [baseView addSubview:self.picture];
//        [self.picture mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(ScaleW(20));
//            make.centerX.mas_equalTo(0);
//            make.width.mas_equalTo(ScaleW(121));
//            make.height.mas_equalTo(ScaleW(121));
//        }];
          if (!_bannerView) {
                _bannerView = [[ELBannerView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(121), ScaleW(121))];
            }
        [baseView addSubview:_bannerView];
        [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(20));
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(ScaleW(121));
            make.height.mas_equalTo(ScaleW(121));
        }];
        
        self.left_bt = [UIButton new];
        self.left_bt.tag = 101;
        [self.left_bt addTarget:self action:@selector(changeImageleft) forControlEvents:UIControlEventTouchUpInside];
        [self.left_bt setImage:[UIImage imageNamed:@"chevron-left"]  forState:UIControlStateNormal];
        [baseView addSubview:self.left_bt];
        [self.left_bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bannerView.mas_left).offset(-ScaleW(10));
            make.centerY.mas_equalTo(_bannerView.mas_centerY);
            make.width.mas_equalTo(ScaleW(15));
            make.height.mas_equalTo(ScaleW(15));
        }];
        
        self.right_bt = [UIButton new];
        self.right_bt.tag = 102;
        [self.right_bt addTarget:self action:@selector(changeImageright) forControlEvents:UIControlEventTouchUpInside];
        [self.right_bt setImage:[UIImage imageNamed:@"chevron-right-2"] forState:UIControlStateNormal];
        [baseView addSubview:self.right_bt];
        [self.right_bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bannerView.mas_right).offset(ScaleW(10));
            make.centerY.mas_equalTo(_bannerView.mas_centerY);
            make.width.mas_equalTo(ScaleW(15));
            make.height.mas_equalTo(ScaleW(15));
        }];
        
        self.yellow_picture = [UIImageView new];
        self.yellow_picture.image = [UIImage imageNamed:@"Vector 1"];
//        self.yellow_picture.layer.masksToBounds = true;
//        self.yellow_picture.layer.cornerRadius = ScaleW(8);
        self.yellow_picture.layer.borderColor = ColorRGB(0xD4D4D4).CGColor;
        self.yellow_picture.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:self.yellow_picture];
        [self.yellow_picture mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(5));
            make.right.mas_equalTo(-ScaleW(5));
            make.width.mas_equalTo(ScaleW(80));
            make.height.mas_equalTo(ScaleW(17));
        }];
        
        self.yellow_title = [UILabel new];
        self.yellow_title.textAlignment = NSTextAlignmentCenter;
        self.yellow_title.text = @"鷹國皇家限定";
        self.yellow_title.numberOfLines = 0;
        self.yellow_title.textColor = UIColor.whiteColor;
        self.yellow_title.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightSemibold];
        [baseView addSubview:self.yellow_title];
        [self.yellow_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.yellow_picture.mas_top);
            //make.right.mas_equalTo(ScaleW(0));
            make.centerX.mas_equalTo(self.yellow_picture.mas_centerX);
            make.width.mas_equalTo(ScaleW(100));
            make.height.mas_equalTo(ScaleW(17));
        }];
        
        
        
        self.title = [UILabel new];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.text = @"特別優惠";
        self.title.numberOfLines = 0;
        self.title.textColor = rgba(0, 122, 96, 1);
        self.title.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        [baseView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bannerView.mas_bottom).offset(ScaleW(10));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
        
        self.goodsName = [UILabel new];
        self.goodsName.textAlignment = NSTextAlignmentCenter;
        self.goodsName.text = @"王柏融【2024鷹勇戰士主題實戰球衣】";
        self.goodsName.numberOfLines = 0;
        self.goodsName.textColor = rgba(64, 64, 64, 1);
        self.goodsName.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [baseView addSubview:self.goodsName];
        [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(ScaleW(10));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.bottom.mas_equalTo(-ScaleW(10));
        }];
    }
    return self;
}

-(void)controllImage:(NSArray*)imagearray
{
    [self.bannerView setImages:imagearray showTitle:NO width:ScaleW(121) border:YES];
    
    if(imagearray.count<=1)
    {
        self.left_bt.hidden = YES;
        self.right_bt.hidden = YES;
    }
    else
    {
        self.left_bt.hidden = NO;
        self.right_bt.hidden = NO;
    }
}

-(void)changeImageright
{
    self.currentIndex = [self.bannerView getCurrentImageIndex];
    
    self.currentIndex++;
    if(self.currentIndex>self.image_array.count-1)
        self.currentIndex=self.image_array.count-1;
    
    [self.bannerView setCurrentImage:self.currentIndex];
}

-(void)changeImageleft
{
    self.currentIndex = [self.bannerView getCurrentImageIndex];
    self.currentIndex--;
    if(self.currentIndex<0)
        self.currentIndex = 0;
    [self.bannerView setCurrentImage:self.currentIndex];
}

-(void)updateUI
{
    self.image_array = [self.info objectForKey:@"galleryImages"];//[NSArray arrayWithObjects:@"renxiang", @"XTAIWOLF",@"jinianqiu",@"yingyuanshoudeng",nil];
    [self controllImage:self.image_array];
    
    self.goodsName.text = [self.info objectForKey:@"couponName"];
    self.title.text = @"特別優惠";
    
    if(self.from_type==1){
        //设置会员黄色标签
        NSMutableString *strng = [NSMutableString new];
        NSString* criter = [self.info objectForKey:@"eligibilityCriteria"];
        if([criter isKindOfClass:[NSString class]])
        {
            if([criter isEqualToString:@"memberCard"])
            {
                NSArray* criter_mem = [self.info objectForKey:@"eligibleMembers"];
                if([criter_mem isKindOfClass:[NSArray class]]){
                    if(criter_mem.count==1){
                        strng = [NSMutableString stringWithString:[criter_mem objectAtIndex:0]];
                        if([strng isEqualToString:@"A001"])
                            strng = [NSMutableString stringWithString:@"鷹國皇家"];
                        if([strng isEqualToString:@"A002"])
                            strng = [NSMutableString stringWithString:@"鷹國尊爵"];
                        if([strng isEqualToString:@"A003"])
                            strng = [NSMutableString stringWithString:@"Takao 親子卡"];
                        if([strng isEqualToString:@"A004"])
                            strng = [NSMutableString stringWithString:@"鷹國人"];
                        self.yellow_title.hidden = NO;
                        self.yellow_title.text = strng;
                        [self.yellow_picture setHidden:NO];
                    }
                    else if(criter_mem.count>1){
                        strng = [NSMutableString stringWithString:@"鷹國會員"];
                        self.yellow_title.hidden = NO;
                        self.yellow_title.text = strng;
                        [self.yellow_picture setHidden:NO];
                    }
                    else
                    {
                        strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
                        self.yellow_title.hidden = YES;
                        [self.yellow_picture setHidden:YES];
                    }
                }
                else
                {
                    strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
                    self.yellow_title.hidden = YES;
                    [self.yellow_picture setHidden:YES];
                }
            }
            else
            {
                strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
                self.yellow_title.hidden = YES;
                [self.yellow_picture setHidden:YES];
            }
            
        }
        else
        {
            strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
            self.yellow_title.hidden = YES;
            [self.yellow_picture setHidden:YES];
        }
    }
    else
    {
        self.yellow_title.hidden = YES;
        [self.yellow_picture setHidden:YES];
    }
    
}
@end




@implementation LeftRightLBTableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"LeftRightLBTableViewCell";
    LeftRightLBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[LeftRightLBTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor whiteColor];
        
        UIView *baseView = self.contentView;//[UIView new];
//        baseView.layer.masksToBounds = true;
//        baseView.layer.cornerRadius = ScaleW(8);
//        baseView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:baseView];
//        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(ScaleW(20));
//            make.left.mas_equalTo(ScaleW(20));
//            make.right.mas_equalTo(-ScaleW(20));
//            make.bottom.mas_equalTo(0);
//        }];
        
        self.leftLb = [UILabel new];
        self.leftLb.textAlignment = NSTextAlignmentLeft;
        self.leftLb.text = @"兌換點數";
        self.leftLb.numberOfLines = 0;
        self.leftLb.textColor = rgba(115, 115, 115, 1);
        self.leftLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [baseView addSubview:self.leftLb];
        [self.leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(20));
            make.centerY.mas_equalTo(0);
        }];
        
        self.rightLb = [UILabel new];
        self.rightLb.textAlignment = NSTextAlignmentRight;
        self.rightLb.text = @"2499 點";
        self.rightLb.textColor = rgba(64, 64, 64, 1);
        self.rightLb.numberOfLines = 0;
        self.rightLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        [baseView addSubview:self.rightLb];
        [self.rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ScaleW(30));
            make.right.mas_equalTo(-ScaleW(20));
            make.centerY.mas_equalTo(0);
        }];
    }
    return self;
}
@end
