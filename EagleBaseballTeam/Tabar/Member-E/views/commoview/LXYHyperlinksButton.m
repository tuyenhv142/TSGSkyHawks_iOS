//
//  LXYHyperlinksButton.m
//  music
//
//  Created by Dragon_Zheng on 2/7/25.
//
#import <Foundation/Foundation.h>
#import "LXYHyperlinksButton.h"

@implementation LXYHyperlinksButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
 
-(void)setColor:(UIColor *)color{
    lineColor = [color copy];
    [self setNeedsDisplay];
}
 
 
- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    CGRect aaa = self.bounds;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat descender = self.titleLabel.font.descender;
    if([lineColor isKindOfClass:[UIColor class]]){
        CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor);
    }
    /*
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender+8);
    CGContextSetLineWidth(contextRef, 5);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender+8);
     */
    CGContextMoveToPoint(contextRef, aaa.origin.x, textRect.origin.y + textRect.size.height + descender+18);
    CGContextSetLineWidth(contextRef, 5);
    CGContextAddLineToPoint(contextRef, aaa.origin.x + aaa.size.width, textRect.origin.y + textRect.size.height + descender+18);
     
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}
 
@end
