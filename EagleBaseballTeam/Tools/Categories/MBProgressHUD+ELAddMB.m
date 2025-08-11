//
//  MBProgressHUD+ELAddMB.m
//  MobileCaptureDemo
//
//  Created by dragon_zheng on 2023/12/5.
//

#import "MBProgressHUD+ELAddMB.h"

@implementation MBProgressHUD (ELAddMB)

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    [self hideHUDForView:view animated:NO];
    [self show:error icon:@"error.png" view:view];
}
+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    [self hideHUDForView:view animated:NO];
    [self show:success icon:@"success.png" view:view];
}
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    [MBProgressHUD showMessag:text toView:view afterDelay:0];
}


+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay{
//    if(afterDelay == 0){
//        afterDelay = message.length > 15 ? 2.5 : 1.5;
//    }
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundView.color = rgba(105, 105, 105, 0.75);
    hud.detailsLabel.text = message;
//    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = NO;
    hud.mode = MBProgressHUDModeText;
//    [hud hide:YES afterDelay:afterDelay];
    return hud;
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view isDelayHiden:(BOOL)hiden {
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.bezelView.color = rgba(105, 105, 105, 0.75);
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = NO;
    if (hiden) {
        [hud hideAnimated:YES afterDelay:30.0];
    }
    return hud;
}



//lnn
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}
#pragma mark lnn 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    //style
//    hud.mode = 1;
    return hud;
}
/** lnn 消失 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil){
        view = [UIApplication sharedApplication].windows.firstObject;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
              //执行耗时的异步操作..
              dispatch_async(dispatch_get_main_queue(), ^{
                  //回到主线程，执行UI刷新操作
              });
          });
    }
    [self hideHUDForView:view animated:YES];
    
}
//
//+ (MBProgressHUD *)showDelayHidenMessage:(NSString *)message
//{
//    UIView *view = [UIApplication sharedApplication].keyWindow;
//    // 快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.label.text = message;
////    hud.bezelView.color = rgba(105, 105, 105, 0.75);
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    // YES代表需要蒙版效果
//   // hud.dimBackground = YES;
//    hud.mode = MBProgressHUDModeText;
//    [hud hideAnimated:YES afterDelay:1.5];
//    return hud;
//}
+ (MBProgressHUD *)showDelayHidenMessageNoImage:(NSString *)message
{
    UIView *view = [UIApplication sharedApplication].windows.firstObject;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    //hud.margin = 1.f; // 根据需要调整边距
    hud.label.numberOfLines = 0;
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
    return  hud;
}

+ (MBProgressHUD *)showDelayHidenMessage:(NSString *)message
{
    UIView *view = [UIApplication sharedApplication].windows.firstObject;
    UIImage *image = [UIImage imageNamed:@"台鋼雄鷹Logo"];

//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-40, 0, 30, 30)];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.layer.cornerRadius = 5.f;
//    imageView.layer.masksToBounds = YES;
//    [imageView setImage:image];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

   // hud.customView = imageView;  // 设置图片
    hud.mode = MBProgressHUDModeText;
    //hud.margin = 1.f; // 根据需要调整边距
    hud.label.numberOfLines = 0;
//    hud.label.text = message;
//    [hud.bezelView addSubview:imageView];
//    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(10);
//        make.centerY.mas_equalTo(0);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(30);
//    }];
    //初始化
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    //空格间隙
    NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@"  "];
    //图片
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage image:image withRoundCorner:150.0];
   // attachment.image =image ;
    attachment.bounds = CGRectMake(0, -10, 35, 35);
    
    NSAttributedString *imageAttachment = [NSAttributedString attributedStringWithAttachment:attachment];
    //图片
    [attributedString appendAttributedString:imageAttachment];
    //空格间隙
    [attributedString appendAttributedString:spaceString];
    //文字
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange textRange = NSMakeRange(0, message.length);
//    //行间距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.lineSpacing = 5;
    style.headIndent = 45;  // 设置第二行开始的缩进值，与图片宽度相近
    style.firstLineHeadIndent = 45;  // 第一行缩进为0
        style.alignment = NSTextAlignmentLeft;  // 文本左对齐
    [textString addAttribute:NSParagraphStyleAttributeName value:style range:textRange]; // 都没用
    //文字颜色
  //  [textString addAttribute:NSForegroundColorAttributeName value:textColor range:textRange];
    //字体
   // [textString addAttribute:NSFontAttributeName value:textFont range:textRange];
    //空格间隙
    [attributedString appendAttributedString:textString];
    //用label的attributedText属性来使用富文本

    hud.label.attributedText= attributedString ;

//    hud.label.textAlignment = NSTextAlignmentLeft; //有用但不需要
    
    
//    [hud.label mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(50);
////        make.trailing.mas_equalTo(self).offset(-5);
//    }];
//    [hud.bezelView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(hud.label).with.offset(10);
//    }];
    hud.bezelView.color = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
    return hud;
}


+ (MBProgressHUD *)showIndeterminateDelayHidenMessage:(NSString *)message
{
    UIView *view = [UIApplication sharedApplication].windows.firstObject;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.bezelView.color = rgba(105, 105, 105, 0.75);
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = NO;
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud hideAnimated:YES afterDelay:3.5];
    return hud;
}
@end
