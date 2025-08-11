//
//  ELAlertController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "ELAlertController.h"

@interface ELAlertController ()

@end

@implementation ELAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+ (void)alertControllerWithTitleName:(NSString*)titleName andMessage:(NSString*)message
                   cancelButtonTitle:(NSString * _Nullable)cancelTitle confirmButtonTitle:(NSString*)confirmTitle showViewController:(UIViewController*)currentVC addCancelClickBlock:(CancelButtonBlock)cancelBlock addConfirmClickBlock:(SureButtonBlock)SureBlock{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleName message:message preferredStyle:UIAlertControllerStyleAlert];
    //改变title的大小和颜色
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:titleName];
    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:NSMakeRange(0, titleName.length)];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"#171717"] range:NSMakeRange(0, titleName.length)];
    [alertController setValue:titleAtt forKey:@"attributedTitle"];
    
    //改变message的大小和颜色
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
    [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, message.length)];
    [messageAtt addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"#404040"] range:NSMakeRange(0, message.length)];
    [alertController setValue:messageAtt forKey:@"attributedMessage"];
  
    if (confirmTitle) {
        /*确认按钮*/
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SureBlock(action);
        }];
        [alertAction setValue:[UIColor hexStringToColor:@"#007A60"] forKey:@"_titleTextColor"];
        
        [alertController addAction:alertAction];
    }
    if (cancelTitle) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //        exit(0);
            cancelBlock(action);
        }];
        /*取消按钮的颜色*/
        [cancel setValue:[UIColor hexStringToColor:@"#737373"] forKey:@"_titleTextColor"];
        [alertController addAction:cancel];
        
    }
    [currentVC presentViewController:alertController animated:YES completion:nil];
}


@end
