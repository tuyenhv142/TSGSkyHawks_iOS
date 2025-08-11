//
//  EGMemberInfoTbViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/17.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGMemberInfoTbViewCell.h"

@interface EGMemberInfoTbViewCell ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *calendarBtn;
@end


@implementation EGMemberInfoTbViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGMemberInfoTbViewCell";
    EGMemberInfoTbViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[EGMemberInfoTbViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = rgba(243, 243, 243, 1);
        UIView *baseView = self.contentView;
        
        UILabel *titleLb = [UILabel new];
        titleLb.textColor = rgba(23, 23, 23, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [baseView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(15));
            make.left.mas_equalTo(ScaleW(24));
            make.right.mas_equalTo(-ScaleW(24));
        }];
        self.titleLb = titleLb;
        
        UITextField *contentTextField = [UITextField new];
        contentTextField.borderStyle = UITextBorderStyleRoundedRect;
        contentTextField.font = [UIFont systemFontOfSize:FontSize(14)];
        contentTextField.returnKeyType = UIReturnKeyNext;
        [contentTextField addTarget:self action:@selector(textFieldTextChangeString:) forControlEvents:(UIControlEventEditingChanged)];
        contentTextField.delegate = self;
        contentTextField.placeholder = @"請輸入";
        [baseView addSubview:contentTextField];
        [contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(24));
            make.top.mas_equalTo(titleLb.mas_bottom).offset(ScaleW(8));
            make.height.mas_equalTo(ScaleW(45));
            make.right.mas_equalTo(-ScaleW(24));
            make.bottom.mas_equalTo(0);
        }];
        self.contentTextField = contentTextField;
        
        UIButton *calendarBtn = [[UIButton alloc] init];
        calendarBtn.layer.cornerRadius = ScaleW(14);
        calendarBtn.layer.masksToBounds = true;
        [calendarBtn setImage:[UIImage imageNamed:@"calendar-green"] forState:UIControlStateNormal];
        [calendarBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:calendarBtn];
        [calendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentTextField);
            make.height.mas_equalTo(ScaleW(28));
            make.right.mas_equalTo(-ScaleW(40));
        }];
        calendarBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -10, -20);
        calendarBtn.hidden = true;
        self.calendarBtn = calendarBtn;
        
    }
    return self;
}
-(void)textFieldTextChangeString:(UITextField *)textField
{
    if (_textStringBlock) {
        _textStringBlock(textField.text,false);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(void)rightButtonAction:(UIButton *)btn
{
    if (_textStringBlock) {
        _textStringBlock(@"",true);
    }
}
- (void)setDataDict:(NSDictionary *)dataDict
{
    NSString *titleStr = dataDict[@"title"];
    self.titleLb.text = titleStr;
    
    NSString *enabled_TextF = dataDict[@"enabled_TextF"];
    self.contentTextField.placeholder = dataDict[@"placeholder"];
    
    if ([enabled_TextF intValue]) {
        self.contentTextField.backgroundColor = UIColor.whiteColor;
    }else{
        self.contentTextField.backgroundColor = rgba(222, 222, 222, 1);
    }
    self.contentTextField.enabled = [enabled_TextF intValue];
    self.contentTextField.text = dataDict[@"value"];
    
    self.contentTextField.secureTextEntry = false;
    self.contentTextField.keyboardType = UIKeyboardTypeDefault;
    
    if ([titleStr isEqualToString:@"生日"]) {
        self.contentTextField.userInteractionEnabled = false;
        if (![enabled_TextF intValue]) {
            self.calendarBtn.hidden = true;
        }else{
            self.calendarBtn.hidden = false;
        }
    }else{
        self.calendarBtn.hidden = true;
        self.contentTextField.userInteractionEnabled = true;
    }
}

@end





@interface MemberInfoTextFieldTbViewCell ()<UITextFieldDelegate>

@end
@implementation MemberInfoTextFieldTbViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"MemberInfoTextFieldTbViewCell";
    MemberInfoTextFieldTbViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[MemberInfoTextFieldTbViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = rgba(243, 243, 243, 1);
        UIView *baseView = self.contentView;
        
        UITextField *contentTextField = [UITextField new];
        contentTextField.borderStyle = UITextBorderStyleRoundedRect;
        contentTextField.font = [UIFont systemFontOfSize:FontSize(14)];
        contentTextField.returnKeyType = UIReturnKeyNext;
        [contentTextField addTarget:self action:@selector(textFieldSingleTextChangeString:) forControlEvents:(UIControlEventEditingChanged)];
        contentTextField.delegate = self;
        contentTextField.placeholder = @"請輸入";
        [baseView addSubview:contentTextField];
        [contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(24));
            make.top.mas_equalTo(ScaleW(5));
            make.height.mas_equalTo(ScaleW(45));
            make.right.mas_equalTo(-ScaleW(24));
        }];
        self.contentTextField = contentTextField;
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setImage:[UIImage imageNamed:@"chevron-down"] forState:UIControlStateNormal];
        rightBtn.userInteractionEnabled = false;
        [baseView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentTextField);
            make.height.mas_equalTo(ScaleW(28));
            make.right.mas_equalTo(-ScaleW(40));
        }];
        rightBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -10, -20);
        self.rightBtn = rightBtn;
        
        UILabel *alterLb = [UILabel new];
        alterLb.textColor = rgba(115, 115, 115, 1);//限 2025 台鋼雄鷹現役球員/教練團
        alterLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [baseView addSubview:alterLb];
        [alterLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentTextField.mas_bottom).offset(ScaleW(8));
            make.left.mas_equalTo(ScaleW(24));
            make.right.mas_equalTo(-ScaleW(24));
            make.bottom.mas_equalTo(0);
        }];
        self.alterLb = alterLb;
        
    }
    return self;
}

- (void)setTextFieldTextAndPlaceholder:(NSDictionary *)dataDict
{
    self.contentTextField.placeholder = [dataDict objectOrNilForKey:@"placeholder"];
    self.contentTextField.text = [dataDict objectOrNilForKey:@"value"];
    BOOL hidbtn = [dataDict[@"BtnHidden"] intValue];
    self.rightBtn.hidden = hidbtn;
    self.contentTextField.enabled = hidbtn;
    if ([[dataDict objectOrNilForKey:@"placeholder"] isEqualToString:@"第三順位"]) {
        self.alterLb.text = @"限 2025 台鋼天鷹現役球員/教練團";
    }else{
        self.alterLb.text = @"";
    }
}
-(void)textFieldSingleTextChangeString:(UITextField *)textField
{    
    if (_textFSingleBlock) {
        _textFSingleBlock(textField.text,false);
    }
}

@end





@interface MemberInfoTwoBtnTbViewCell ()<UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *btnMArray;
//@property (nonatomic,strong) UITextField *contentTextField;
@end

@implementation MemberInfoTwoBtnTbViewCell
- (NSMutableArray *)btnMArray
{
    if (_btnMArray == nil) {
        _btnMArray = [NSMutableArray array];
    }
    return _btnMArray;
}
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"MemberInfoTwoBtnTbViewCell";
    MemberInfoTwoBtnTbViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[MemberInfoTwoBtnTbViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = rgba(243, 243, 243, 1);
        UIView *baseView = self.contentView;
        
        UILabel *titleLb = [UILabel new];
        titleLb.text = @"性別";
        titleLb.textColor = rgba(23, 23, 23, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [baseView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(15));
            make.left.mas_equalTo(ScaleW(24));
            make.right.mas_equalTo(-ScaleW(24));
        }];
        self.titleLb = titleLb;
        
        UIView *btnViews = [[UIView alloc] init];
        [baseView addSubview:btnViews];
        [btnViews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(24));
            make.top.mas_equalTo(titleLb.mas_bottom).offset(ScaleW(8));
            make.right.mas_equalTo(-ScaleW(24));
            make.bottom.mas_equalTo(-ScaleW(15));
        }];
        NSArray *btnArray = @[@"   ",@"   ",@"   "];
        for (int i = 0; i < btnArray.count; i++ ) {
            UIButton *detailBtn = [[UIButton alloc] init];
            [detailBtn setTitle:btnArray[i] forState:UIControlStateNormal];
            [detailBtn setTitleColor:rgba(64, 64, 64, 1) forState:UIControlStateNormal];
            detailBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
            [detailBtn setImage:[UIImage imageNamed:@"tuoYuanHui"] forState:UIControlStateNormal];
            [detailBtn setImage:[UIImage imageNamed:@"Checkboxes-1"] forState:UIControlStateSelected];
            [detailBtn setImage:[UIImage imageNamed:@"Checkboxes_Disabled"] forState:UIControlStateDisabled];
            detailBtn.tag = i;
            [detailBtn addTarget:self action:@selector(sexButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
            [btnViews addSubview:detailBtn];
            [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.height.mas_equalTo(ScaleW(24));
                make.left.mas_equalTo(ScaleW(1) + i * ScaleW(60));
            }];
            detailBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -20);
            [self.btnMArray addObject:detailBtn];
        }
        
    }
    return self;
}
#pragma mark - 复选框点击事件
-(void)sexButtonMethod:(UIButton *)sender
{
    for (UIButton *button in self.btnMArray) {
        if ([sender isEqual:button]) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    if (_buttonSelectBlock) {
        _buttonSelectBlock([NSString stringWithFormat:@"%ld",sender.tag],true);
    }
}

- (void)setTitleAndButtonText:(NSDictionary *)dataDict
{
    NSString *sexStr = dataDict[@"title"];
    self.titleLb.text = sexStr;
    
    NSArray *array = dataDict[@"array"];
    if (array.count == 3) {
        
        BOOL isEnabled = false;
        for (int i = 0; i < self.btnMArray.count; i++ ) {
            
            UIButton *button = self.btnMArray[i];
            NSDictionary *dict = array[i];
            BOOL hidbtn = [dict[@"state"] intValue];
            button.selected = !hidbtn;
            [button setTitle:dict[@"titleType"] forState:UIControlStateNormal];
            [button layoutButtonWithEdgeInsetsStyle:1 imageTitleSpace:5];
            if (i == 2 && hidbtn) {
                isEnabled = true;
            }else{
                isEnabled = false;
            }
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ScaleW(1) + i * ScaleW(60) );
            }];
        }
        for (UIButton *button in self.btnMArray) {
            button.enabled = isEnabled;
        }
        
    }else{
        
        for (int i = 0; i < self.btnMArray.count; i++ ) {
            
            UIButton *button = self.btnMArray[i];
            button.enabled = true;
            if (i < array.count) {
                NSDictionary *dict = array[i];
                button.hidden = false;
                BOOL hidbtn = [dict[@"state"] intValue];
                button.selected = hidbtn;
                [button setTitle:dict[@"titleType"] forState:UIControlStateNormal];
                [button layoutButtonWithEdgeInsetsStyle:1 imageTitleSpace:5];
            }else{
                button.hidden = true;
                [button setTitle:@"" forState:UIControlStateNormal];
                [button layoutButtonWithEdgeInsetsStyle:1 imageTitleSpace:5];
            }
            if (array.count == 2) {
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(ScaleW(1) + i * ScaleW(150) );
                }];
            }else{
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(ScaleW(1) + i * ScaleW(60) );
                }];
            }
        }
        
    }
    
    
    
   
}
@end
