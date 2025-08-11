//
//  EGRegisterTBViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGRegisterTBViewCell.h"

@interface EGRegisterTBViewCell ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *titleLb;
@end


@implementation EGRegisterTBViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGRegisterTBViewCell";
    EGRegisterTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[EGRegisterTBViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor whiteColor];
        UIView *baseView = self.contentView;
        
        UILabel *titleLb = [UILabel new];
        titleLb.textColor = rgba(23, 23, 23, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [baseView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(15));
            make.left.mas_equalTo(ScaleW(24));
        }];
        self.titleLb = titleLb;
        self.policyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.policyBtn setImage:[UIImage imageNamed:@"information-circle"] forState:UIControlStateNormal];
        [self.policyBtn addTarget:self action:@selector(lookPolicyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:self.policyBtn];
        [self.policyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLb);
            make.left.equalTo(titleLb.mas_right).offset(ScaleW(5));
            make.height.mas_equalTo(ScaleW(16));
            make.width.mas_equalTo(ScaleW(16));
        }];
        self.policyBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -20, -15, -40);
        
        
        UITextField *contentTextField = [UITextField new];
        contentTextField.borderStyle = UITextBorderStyleRoundedRect;
        contentTextField.font = [UIFont systemFontOfSize:FontSize(14)];
        contentTextField.returnKeyType = UIReturnKeyNext;
        [contentTextField addTarget:self action:@selector(textFieldTextChangeString:) forControlEvents:(UIControlEventEditingChanged)];
        contentTextField.delegate = self;
//        contentTextField.placeholder = @"請輸入";
        [baseView addSubview:contentTextField];
        [contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(24));
            make.top.mas_equalTo(titleLb.mas_bottom).offset(ScaleW(8));
            make.height.mas_equalTo(ScaleW(45));
            make.right.mas_equalTo(-ScaleW(24));
        }];
        self.contentTextField = contentTextField;
        
        UILabel *subtitleLabel = [UILabel new];
        subtitleLabel.textAlignment = NSTextAlignmentLeft;
        subtitleLabel.textColor = rgba(115, 115, 115, 1);
        subtitleLabel.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
        subtitleLabel.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:subtitleLabel];
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentTextField.mas_bottom).offset(ScaleW(5));
            make.left.mas_equalTo(ScaleW(24));
            make.right.mas_equalTo(-ScaleW(24));
            make.bottom.mas_equalTo(-ScaleW(5));
        }];
        self.subtitleLabel = subtitleLabel;
        
        UIButton *rightBtn = [[UIButton alloc] init];
        rightBtn.layer.cornerRadius = ScaleW(14);
        rightBtn.layer.masksToBounds = true;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
//        [rightBtn setTitle:@"發送驗證碼" forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [rightBtn setTitleColor:rgba(163, 163, 163, 1) forState:UIControlStateDisabled];
        [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentTextField);
            make.height.mas_equalTo(ScaleW(28));
            make.right.mas_equalTo(-ScaleW(40));
        }];
        rightBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -10, -20);
        self.rightBtn = rightBtn;
        
    }
    return self;
}

-(void)lookPolicyButtonAction
{
    if (_textStringBlock) {
        _textStringBlock(@"policy",true);
    }
}

-(void)rightButtonAction:(UIButton *)btn
{
    if (_textStringBlock) {
        _textStringBlock(@"",true);
    }
}

-(void)textFieldTextChangeString:(UITextField *)textField
{
    if ([self.titleLb.text isEqualToString:@"手機號碼"] && textField.text.length >= 10) {
        
        textField.text = [textField.text substringToIndex:10];
        [textField resignFirstResponder];
        
    }else if ([self.titleLb.text isEqualToString:@"密碼"] || [self.titleLb.text isEqualToString:@"密碼確認"]) {
        if (textField.text.length >= 20) {
            textField.text = [textField.text substringToIndex:20];
            [textField resignFirstResponder];
        }
    }
    
    if (_textStringBlock) {
        _textStringBlock(textField.text,false);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}



-(void)setRightButtonStatue
{
    self.contentTextField.secureTextEntry = !self.rightBtn.selected;
    
}
- (void)setDataDict:(NSDictionary *)dataDict
{
    NSString *titleStr = dataDict[@"title"];
    self.titleLb.text = titleStr;
    
    self.contentTextField.placeholder = dataDict[@"placeholder"];
    self.contentTextField.enabled = true;
    self.contentTextField.text = dataDict[@"value"];
    self.contentTextField.secureTextEntry = false;
    self.contentTextField.keyboardType = UIKeyboardTypeDefault;
    
    self.subtitleLabel.text = dataDict[@"subTitle"];
    self.subtitleLabel.textColor = rgba(115, 115, 115, 1);
    
    if ([titleStr isEqualToString:@"手機號碼"]) {
        
        self.rightBtn.hidden = false;
        [self.rightBtn setTitle:@" 發送驗證碼 " forState:UIControlStateNormal];
        [self.rightBtn setImage:nil forState:UIControlStateNormal];
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:rgba(243, 243, 243, 1)] forState:UIControlStateDisabled];
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:rgba(0, 78, 162, 1)] forState:UIControlStateNormal];
        
        self.contentTextField.keyboardType = UIKeyboardTypePhonePad;
        
    }else if ([titleStr isEqualToString:@"密碼"] || [titleStr isEqualToString:@"密碼確認"]) {
        
        self.rightBtn.hidden = false;
        [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"eye-slash"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"showPswd"] forState:UIControlStateSelected];
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        self.contentTextField.secureTextEntry = true;
        
    }else if ([titleStr isEqualToString:@"生日"]) {
        
        self.contentTextField.enabled = false;
        self.rightBtn.hidden = false;
        [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"calendar-green"] forState:UIControlStateNormal];
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:UIColor.clearColor] forState:UIControlStateNormal];
        self.subtitleLabel.textColor = rgba(0, 78, 162, 1);
        
    }else{
        self.rightBtn.hidden = true;
    }
    
    if ([titleStr isEqualToString:@"生日"] || [titleStr isEqualToString:@"身分證字號"]) {
        self.policyBtn.hidden = false;
    }else{
        self.policyBtn.hidden = true;
    }
}

- (void)setSubtitleLabelString:(NSString *)subtitleLabel
{
    self.subtitleLabel.text = subtitleLabel;
    self.subtitleLabel.textColor = UIColor.redColor;
}
@end
