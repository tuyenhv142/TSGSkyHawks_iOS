#import "UILabel+Padding.h"
#import <objc/runtime.h>

@implementation UILabel (Padding)

// 关联对象的 Key
static char kContentInsetsKey;

// 重写方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 交换 drawTextInRect: 方法
        Method originalDrawTextInRect = class_getInstanceMethod([self class], @selector(drawTextInRect:));
        Method swizzledDrawTextInRect = class_getInstanceMethod([self class], @selector(paddedDrawTextInRect:));
        method_exchangeImplementations(originalDrawTextInRect, swizzledDrawTextInRect);

        // 交换 intrinsicContentSize 方法
        Method originalIntrinsicContentSize = class_getInstanceMethod([self class], @selector(intrinsicContentSize));
        Method swizzledIntrinsicContentSize = class_getInstanceMethod([self class], @selector(paddedIntrinsicContentSize));
        method_exchangeImplementations(originalIntrinsicContentSize, swizzledIntrinsicContentSize);
    });
}

// 自定义 drawTextInRect: 方法
- (void)paddedDrawTextInRect:(CGRect)rect {
    // 应用内边距
    UIEdgeInsets insets = self.contentInsets;
    [self paddedDrawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

// 自定义 intrinsicContentSize 方法
- (CGSize)paddedIntrinsicContentSize {
    // 计算原始尺寸并添加内边距
    CGSize originalSize = [self paddedIntrinsicContentSize];
    UIEdgeInsets insets = self.contentInsets;
    CGSize paddedSize = CGSizeMake(
        originalSize.width + insets.left + insets.right,
        originalSize.height + insets.top + insets.bottom
    );
    return paddedSize;
}

// 设置内边距
- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:contentInsets];
    objc_setAssociatedObject(self, &kContentInsetsKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay]; // 标记需要重绘
}

// 获取内边距
- (UIEdgeInsets)contentInsets {
    NSValue *value = objc_getAssociatedObject(self, &kContentInsetsKey);
    return value ? [value UIEdgeInsetsValue] : UIEdgeInsetsZero;
}

@end
