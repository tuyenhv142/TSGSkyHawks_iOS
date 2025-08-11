//
//  EGSocialLinksCellTableViewCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/26/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGSocialLinksCell2.h"

@interface EGSocialLinksCell2()

@property (nonatomic, strong) NSArray<UIView *> *containerViews;
@end

@implementation EGSocialLinksCell2

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGSocialLinksCell2";
    EGSocialLinksCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[EGSocialLinksCell2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
        
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
    NSArray *titles = @[@"YouTube",@"Spotify", @"Instagram"];
    NSArray *images = @[@"youtube",@"Spotify", @"instagram"];
    
    NSMutableArray *containers = [NSMutableArray array];
    CGFloat spacing =  ScaleW(24);
    CGFloat buttonWidth =  (self.contentView.frame.size.width -spacing*3)/4;
    
//    CGFloat buttonWidth = ScaleW(60);
//
//    NSLog(@"width:%f",self.frame.size.width);
//    NSLog(@"width:%f",self.contentView.frame.size.width);
//    NSLog(@"width:%f",Device_Width);
//    NSLog(@"buttonWidth:%f",buttonWidth);
//    NSLog(@"%f",spacing);
//    
//    CGFloat yPosition = ScaleW(20);
    
    UIView *lastContainer = nil;
    for (NSInteger i = 0; i < titles.count; i++) {
//        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0 + (buttonWidth + spacing) * i, yPosition, buttonWidth, ScaleW(70))];
        
        UIView *container = [UIView new];
       // [container setBackgroundColor:[UIColor yellowColor]];
        container.tag = i;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
        button.backgroundColor = [UIColor colorWithRed:0 green:0.478 blue:0.376 alpha:1.0];
        button.layer.cornerRadius = ScaleW(8);
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(socialButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonWidth + ScaleW(8), buttonWidth, ScaleW(16))];
        UILabel *label = [[UILabel alloc] init];
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
                make.left.mas_equalTo(lastContainer.mas_right).offset(ScaleW(20));
//                make.width.mas_equalTo(lastContainer);
            } else {
                make.left.mas_equalTo(ScaleW(10));
            }
//            if (i == titles.count - 1) {
//                make.right.mas_equalTo(0);
//            }
            make.width.mas_equalTo(buttonWidth);
            make.top.mas_equalTo(ScaleW(10));
            make.bottom.mas_equalTo(-ScaleW(10));
        }];
        lastContainer = container;
        
        // 设置按钮约束
       // button.backgroundColor = [UIColor greenColor];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container);
            make.centerX.mas_equalTo(container);
            make.width.height.mas_equalTo(buttonWidth-10);
        }];
        
        // 设置标签约束
        //label.backgroundColor = [UIColor redColor];
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
            [self openURL:@"https://music.youtube.com/channel/UCbXwnOO4m6LWDEjoR_dOJ5g"
                fallback:@"https://music.youtube.com/channel/UCbXwnOO4m6LWDEjoR_dOJ5g"];
            break;
           
        case 1:
            //https://open.spotify.com/artist/6mrJ0N4ITNsJBP8FRLQMHj
            [self openURL:@"spotify://artist/6mrJ0N4ITNsJBP8FRLQMHj"
                fallback:@"https://open.spotify.com/artist/6mrJ0N4ITNsJBP8FRLQMHj"];
            break;
            
        case 2:
            [self openURL:@"instagram://user?username=tsg_hawks"
                fallback:@"https://www.instagram.com/tsg_hawks/"];
            break;
           
        case 3:
            [self openURL:@"YOUR_APP_SCHEME://shop"
                fallback:@"https://www.tsghawks.com/shop/"];
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
