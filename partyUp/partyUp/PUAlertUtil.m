
#import "PUAlertUtil.h"

@implementation PUAlertUtil

+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString*) message andCancelButtonTitle:(NSString*) cancelButtonTitle andOtherButtonTitles:(NSString*)otherButtonTitle andDelegate:(id<UIAlertViewDelegate>)delegate{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles: otherButtonTitle, nil];
    [alert show];
}


+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString*) message andCancelButtonTitle:(NSString*) cancelButtonTitle{
    [self showAlertWithTitle:title andMessage:message andCancelButtonTitle:cancelButtonTitle andOtherButtonTitles:nil andDelegate:nil];
}

+(void) showAlertWithMessage:(NSString*)message{
    if(message && message.length > 0)
        [self showAlertWithTitle:@"Atenção" andMessage:message andCancelButtonTitle:@"OK"];
}



@end
