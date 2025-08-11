//
//  EGSocialLinksCellTableViewCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/26/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGSocialLinksCell.h"

@interface EGSocialLinksCell()

@property (nonatomic, strong) NSArray<UIView *> *containerViews;
@end

@implementation EGSocialLinksCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGSocialLinksCell";
    EGSocialLinksCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[EGSocialLinksCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
        
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
    self.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
//    self.contentView.backgroundColor = [UIColor redColor];
    NSArray *titles = @[@"Facebook", @"Instagram", @"YouTube", @"購物商城"];
    NSArray *images = @[@"facebook", @"instagram", @"youtube", @"shopping"];
    
    NSMutableArray *containers = [NSMutableArray array];
    CGFloat spacing =  ScaleW(24);
    CGFloat buttonWidth =  (self.contentView.frame.size.width -spacing*3)/4;

    NSLog(@"width:%f",self.frame.size.width);
    NSLog(@"width:%f",self.contentView.frame.size.width);
    NSLog(@"width:%f",Device_Width);
    NSLog(@"buttonWidth:%f",buttonWidth);
    NSLog(@"%f",spacing);
    
    CGFloat yPosition = ScaleW(20);
    
    UIView *lastContainer = nil;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0 + (buttonWidth + spacing) * i, yPosition, buttonWidth, ScaleW(70))];
//        [container setBackgroundColor:[UIColor yellowColor]];
        container.tag = i;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
        button.backgroundColor = [UIColor colorWithRed:0.0 green:0.475 blue:0.753 alpha:1.0];
        button.layer.cornerRadius = ScaleW(8);
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(socialButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonWidth + ScaleW(8), buttonWidth, ScaleW(16))];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
//        [label sizeToFit];
        [container addSubview:button];
        [container addSubview:label];
        [self.contentView addSubview:container];
        
        // 设置容器约束
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastContainer) {
                make.left.mas_equalTo(lastContainer.mas_right);
                make.width.mas_equalTo(lastContainer);
            } else {
                make.left.mas_equalTo(0);
            }
            if (i == titles.count - 1) {
                make.right.mas_equalTo(0);
            }
            make.top.bottom.mas_equalTo(0);
        }];
        lastContainer = container;
        
        // 设置按钮约束
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container);
            make.centerX.mas_equalTo(container);
            make.width.height.mas_equalTo(buttonWidth);
        }];
        
        // 设置标签约束
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(button.mas_bottom).offset(8);
            make.centerX.mas_equalTo(button);
//            make.width.mas_equalTo(button);
            make.bottom.mas_equalTo(-ScaleW(10));
        }];
                
        
        [containers addObject:container];
    }
    self.containerViews = containers;
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    NSLog(@"width:%f",self.frame.size.width);
//    NSLog(@"width:%f",self.contentView.frame.size.width);
//    CGFloat spacing =  ScaleW(24);
//    CGFloat buttonWidth =  (self.contentView.frame.size.width -spacing*3)/4;
//    CGFloat yPosition = ScaleW(20);
//    [self.containerViews enumerateObjectsUsingBlock:^(UIView *container, NSUInteger idx, BOOL *stop) {
//            container.frame = CGRectMake(0 + (buttonWidth + spacing) * idx, yPosition, buttonWidth, ScaleW(70));
//        }];
//}

- (void)socialButtonTapped:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self openURL:@"fb://profile/100083409097537" fallback:@"https://www.facebook.com/profile.php?id=61572830384548"];
            break;
        case 1:
            [self openURL:@"instagram://user?username=tsg_hawks"
                fallback:@"https://www.instagram.com/tsg_skyhawks/"];
            break;
        case 2:
            [self openURL:@"youtube://www.youtube.com/channel/UCVBlrH9PZRWtgrfcrjmXZMA"
                fallback:@"https://www.youtube.com/@%E5%8F%B0%E9%8B%BC%E5%A4%A9%E9%B7%B9%E8%81%B7%E6%A5%AD%E6%8E%92%E7%90%83%E9%9A%8A"];
            break;
        case 3:
            [self openURL:@"YOUR_APP_SCHEME://shop"
                fallback:@"https://www.tsgskyhawks.com/categories/%E5%AE%98%E6%96%B9%E5%95%86%E5%9F%8E"];
            break;
    }
}

- (void)openURL:(NSString *)appURL fallback:(NSString *)webURL {
    NSURL *appSchemeURL = [NSURL URLWithString:appURL];
    NSURL *webFallbackURL = [NSURL URLWithString:webURL];
    
    [[UIApplication sharedApplication] openURL:appSchemeURL
                                     options:@{}
                           completionHandler:^(BOOL success) {
        if (!success) {
            [[UIApplication sharedApplication] openURL:webFallbackURL
                                            options:@{}
                                  completionHandler:nil];
        }
    }];
}

@end
