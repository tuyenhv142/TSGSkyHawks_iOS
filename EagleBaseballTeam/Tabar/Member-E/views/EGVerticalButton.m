//
//  EGVerticalButton.m
//  EagleBaseballTeam
//
//  Created by rick on 1/26/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGVerticalButton.h"

@implementation EGVerticalButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 获取标题和图片的大小
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    CGSize imageSize = self.imageView.frame.size;
    
    // 设置图片位置
    CGFloat totalHeight = titleSize.height + imageSize.height + 8.0; // 8.0是标题和图片之间的间距
    CGFloat imageY = (self.frame.size.height - totalHeight) / 2 + titleSize.height + 8.0;
    self.imageView.frame = CGRectMake((self.frame.size.width - imageSize.width) / 2,
                                    imageY,
                                    imageSize.width,
                                    imageSize.height);
    
    // 设置标题位置
    CGFloat titleY = (self.frame.size.height - totalHeight) / 2;
    self.titleLabel.frame = CGRectMake((self.frame.size.width - titleSize.width) / 2,
                                     titleY,
                                     titleSize.width,
                                     titleSize.height);
}


@end
